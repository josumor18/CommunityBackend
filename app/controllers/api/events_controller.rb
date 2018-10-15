module Api
    class EventsController < ApplicationController
      protect_from_forgery with: :null_session
        
        #POST create
        def create
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                eve = Event.new(event_params)
    
                if(eve.save)
                    #---------- Cambiar authentication token ----------
                    user.auth_token = nil
                    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                    user.auth_token = (0...20).map { o[rand(o.length)] }.join
                    user.save
                    #--------------------------------------------------

                    #notifications
                    push_notif = PushNotification.new
                    push_notif.createNotification(1, eve)

                    isApproved = params[:approved]
                    if(isApproved == "true")
                        members = CommunityMember.where(id_community: params[:id_community])
                        members.each do |item|
                            if(user.id != item.id_user)
                                notif = Notification.new(idUser: item.id_user, idContent: eve.id, isNews: false, isReports: false, isEvents: true, titleContent:  params[:title], seen: false, photo: params[:photo])
                                notif.save
                            end
                        end
                    else
                        members = CommunityMember.where(id_community: params[:id_community])
                        members.each do |item|
                            if(user.id != item.id_user)
                                if(item.isAdmin == true)
                                    notif = Notification.new(idUser: item.id_user, idContent: eve.id, isNews: false, isReports: false, isEvents: true, titleContent:  params[:title], seen: false, photo: params[:photo])
                                    notif.save
                                end
                            end
                        end
                    end


                    render json: { status: 'SUCCESS', message: 'Evento creado', auth_token: user.auth_token }, status: :created
                else
                    render json: { status: 'INVALID', message: 'Error al crear comunidad'}, status: :unauthorized
                end
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        #GET community_events
        def get_comm_events
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                community = CommunityMember.where(id_user: user.id).where(id_community: params[:id_community]).first
                events = []
                if(community.isAdmin == true)
                    events = Event.where(id_community: params[:id_community])
                else
                    events = Event.where(id_community: params[:id_community]).where(approved: true)
                end
                
                #events = events.order('start ASC')
                events = events.sort_by { |h| [h.dateEvent, h.start] }
                
                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------
                render json: { status: 'SUCCESS', message: 'Eventos obtenidos', events: events, auth_token: user.auth_token }, status: :ok
                
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        #GET user_events
        def get_user_events
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                communities = CommunityMember.where(id_user: user.id)
                events = []
                comm_names = []

                communities.each do |comm|
                    ev = Event.where(id_community: comm.id_community)
                    ev.each do |e|
                        if(e.approved == true)
                            events.push(e)
                        end
                    end
                end

                #events = events.order('start ASC')
                events = events.sort_by { |h| [h.dateEvent, h.start] }

                events.each do |e|
                    com = Community.where(id: e.id_community).first
                    comm_names.push(com.name)
                end
                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------
                render json: { status: 'SUCCESS', message: 'Eventos obtenidos', events: events, comm_names: comm_names, auth_token: user.auth_token }, status: :ok

            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        def approve
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                event = Event.where(id: params[:id_event]).first
                event.update(:approved=>true)
                
                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------
                

                #notifications
                push_notif = PushNotification.new
                push_notif.createNotification(1, eve)

                idCom = event.id_community
                members = CommunityMember.where(id_community: idCom)
                members.each do |item|
                    if(user.id != item.id_user)
                        notif = Notification.new(idUser: item.id_user, idContent: event.id, isNews: false, isReports: false, isEvents: true, titleContent:  event.title, seen: false, photo: event.photo)
                        notif.save
                    end
                end



                render json: { status: 'SUCCESS', message: 'Evento actualizado', auth_token: user.auth_token }, status: :ok

            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        def delete
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                e = Event.where(id: params[:id_event]).first
                if (e)
                    n = Notification.where(idContent: params[:id_event]).where(isEvents: true).first
                    if (n)
                        Notification.where(idContent: params[:id_event]).where(isEvents: true).destroy_all
                    end
                    Event.where(id: params[:id_event]).destroy_all
                    render json: { status: 'SUCCESS', message: 'ELIMINACION EXITOSA'}, status: :ok
                else
                    render json: { status: 'INVALID', message: 'NO ENCONTRADA'}, status: :unauthorized
                    
                end
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end



        #GET Event by id
        #params auth_token, idUser, idEvent
        def getSingleEvent_by_id
            user = User.where(id: params[:idUser]).first
            token = params[:auth_token]
            if (user && user.auth_token == token)
            e = Event.where(id: params[:idEvent]).first
            comm = Community.where(id: e.id_community).first
            #---------- Change authentication token ----------
            user.auth_token = nil
            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
            user.auth_token = (0...20).map { o[rand(o.length)] }.join
            user.save
            #--------------------------------------------------
        
            render json: { status: 'SUCCESS', message: 'difusión obtenida', auth_token: user.auth_token, event: e, nameCommunity: comm.name}, status: :ok
            else
            render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end    


        private
        def event_params
            params.permit(:id_community, :title, :description, :dateEvent, :start, :end, :photo, :approved)
        end


    end
end