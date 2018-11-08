module Api
    class CommunitiesController < ApplicationController
      protect_from_forgery with: :null_session

        #POST create
        def create
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                com = Community.new(community_params)
                com.sub_communities = []
    
                if(com.save)
                    CommunityMember.new(id_community: com.id, id_user: user.id, isAdmin: true).save
                    Chat.new(id_community: com.id, is_group: true).save
                    #---------- Cambiar authentication token ----------
                    user.auth_token = nil
                    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                    user.auth_token = (0...20).map { o[rand(o.length)] }.join
                    user.save
                    #--------------------------------------------------
                    render json: { status: 'SUCCESS', message: 'Comunidad creada', id_community: com.id, auth_token: user.auth_token }, status: :created
                else
                    render json: { status: 'INVALID', message: 'Error al crear comunidad'}, status: :unauthorized
                end
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
            
        end

        #PUT
        def edit
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            
            if(user.auth_token == token)
                  com = Community.where(id: params[:idCommunity]).first
                  if(com)
                    if(user.id != 5)
                      #---------- Cambiar authentication token ----------
                      user.auth_token = nil
                      o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                      user.auth_token = (0...20).map { o[rand(o.length)] }.join
                      user.save
                      #--------------------------------------------------
                    end
                      
                      com.update(:name=>params[:name])
                      com.update(:description=>params[:description])
                      com.update(:rules=>params[:rules])
                      com.update(:isSubcommunity=>params[:isSubcommunity])
                      com.update(:photo=>params[:photo])
                      com.update(:photo_thumbnail=>params[:photo_thumbnail])
                      render json: { status: 'SUCCESS', message: 'CAMBIO EXITOSO',auth_token:user.auth_token}, status: :ok
                  else
                      render json: { status: 'INVALID', message: 'No existe esa comunidad'}, status: :unauthorized
                  end

            else
              render json: { status: 'INVALID TOKEN', message: 'Token inválido'}, status: :unauthorized
              
            end
        end
        
        #GET communities
        def get_communities

            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                communities_user = CommunityMember.where(id_user: user.id)

                communities = []
                comms = Community.where(isSubcommunity: false)
                subcomms = Community.where(isSubcommunity: true)


                communities_user.each do |item|
                    comm = Community.where(isSubcommunity: false).where(id: item.id_community).first
                    if(comm)
                        communities.push(comm)
                        if(comm.sub_communities != nil)
                            subcomunidades = comm.sub_communities
                            subcomunidades.each do |item_sub|
                                sub_com = communities_user.where(id_community: item_sub).first

                                if(sub_com)
                                    subcomm = Community.where(isSubcommunity: true).where(id: item_sub).first
                                    communities.push(subcomm)
                                end
                            end
                        end
                    end
                end
                
                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------
                render json: { status: 'SUCCESS', message: 'Comunidades obtenidas', communities: communities, auth_token: user.auth_token }, status: :ok

            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end



        end

        #GET communities
        def get_all_communities

            communities = Community.all
            render json: { status: 'SUCCESS', message: 'Comunidades obtenidas', communities: communities }, status: :ok


        end

        #GET search_community
        def search_community
            user = User.where(id: params[:id]).first
            pass = params[:auth_token]
            busqueda = params[:busqueda]
            if (user && user.auth_token == pass)
                communities = Community.where(isSubcommunity:false)
                communities_user = CommunityMember.where(id_user: user.id)

                resultados = []
                solicitudes = []
              
                communities.each do |community|
                    if(((community.name).downcase).include? busqueda.downcase)
                        isMember = false
                        communities_user.each do |comm|
                            if(community.id == comm.id_community)
                                isMember = true
                            end
                        end
                        if(!isMember)
                            resultados.push(community)

                            req = Request.where(id_community:community.id).where(id_user:user.id).first
                            if(req)
                                solicitudes.push(true)
                            else
                                solicitudes.push(false)
                            end
                        end
                    end
                end

                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------

                render json: { status: 'SUCCESS', message: 'Comunidades obtenidas', resultados: resultados, solicitudes: solicitudes, auth_token: user.auth_token }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        #GET members
        def get_members
            user = User.where(id: params[:id]).first
            pass = params[:auth_token]
            if (user && user.auth_token == pass)
                community_members = CommunityMember.where(id_community: params[:id_community])

                user_ids = []
                user_names = []
                id_members.each do |id_member|
                    user_ids.push(id_member.id_user)
                    member = User.where(id: id_member.id_user).first
                    if(member)
                        user_names.push(member.name)
                    else
                        user_names.push("(Sin nombre)")
                    end
                end

                 #---------- Cambiar authentication token ----------
                 user.auth_token = nil
                 o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                 user.auth_token = (0...20).map { o[rand(o.length)] }.join
                 user.save
                 #--------------------------------------------------
 
                 render json: { status: 'SUCCESS', message: 'Miembros obtenidos', id_members: user_ids, name_members: user_names, auth_token: user.auth_token }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end


        private
        def community_params
            params.permit(:name, :description, :rules, :isSubcommunity, :photo, :photo_thumbnail)
        end

    end
end