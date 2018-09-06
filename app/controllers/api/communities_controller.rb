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



    end
end