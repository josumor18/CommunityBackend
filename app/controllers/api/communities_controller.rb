module Api
    class CommunitiesController < ApplicationController
      protect_from_forgery with: :null_session

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

        #GET search_community
        def search_community
            user = User.where(id: params[:id]).first
            pass = params[:auth_token]
            busqueda = params[:busqueda]
            if (user && user.auth_token == pass)
                communities = Community.all
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

                render json: { status: 'SUCCESS', message: 'Comunidades obtenidas', resultados: resultados, solicitudes: solicitudes, auth_token: user.auth_token }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end



    end
end