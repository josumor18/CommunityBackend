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
                events = Event.where(id_community: params[:id_community])
    
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

                communities.each do |comm|
                    ev = Event.where(id_community: comm.id_community)
                    events.push(ev)
                end
    
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


        private
        def event_params
            params.permit(:id_community, :title, :description, :dateEvent, :start, :end, :photo, :approved)
        end
    end
end