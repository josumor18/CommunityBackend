module Api
    class CommunitiesController < ApplicationController
      protect_from_forgery with: :null_session

        #GET communities
        def get_communities

            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                communities_user = Community_member.where(id_user: user.id)

                communities = []
                comms = Community.where(isSubcomunity: false)
                subcomms = Community.where(isSubcomunity: true)

                comms.each do |item|
                    if(communities_user.id_community == item && communities_user.isAdmin == true)
                        communities.push(item)
                        if(item.sub_communities != nil)
                            subcomunidades = item.sub_communities
                            subcomunidades.each do |item_sub|
                                subcomms.each do |item_subcomm|
                                    if(item_subcomm.id == item_sub)
                                        communities.push(item_subcomm)
                                    end
                                end
                            end
                        end
                    end

                    if(communities_user.id_community == item && communities_user.isAdmin == false)
                        communities.push(item)
                        if(item.sub_communities != nil)
                            subcomunidades = item.sub_communities
                            subcomunidades.each do |item_sub|
                                subcomms.each do |item_subcomm|
                                    if(item_subcomm.id == item_sub)
                                        communities.push(item_subcomm)
                                    end
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



    end
end