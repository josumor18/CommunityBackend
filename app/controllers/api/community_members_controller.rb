module Api
    class CommunityMembersController < ApplicationController
      protect_from_forgery with: :null_session
      
     def delete
        user = User.where(id: params[:id]).first
        token = params[:auth_token]
        if(user.auth_token == token)
            
            cm = CommunityMember.where(id_community: params[:id_community]).where(id_user: params[:id_user]).first
            if (cm)
                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------
                CommunityMember.where(id_community: params[:id_community]).where(id_user: params[:id_user]).destroy_all
                render json: { status: 'SUCCESS', message: 'ELIMINACION EXITOSA', auth_token: user.auth_token}, status: :ok
            else
                render json: { status: 'INVALID', message: 'NO ENCONTRADA'}, status: :unauthorized
                
            end
        else
            render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
        end
      end

    end
end