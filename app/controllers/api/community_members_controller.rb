module Api
    class CommunityMembersController < ApplicationController
      protect_from_forgery with: :null_session
      
     def delete
         
        cm = CommunityMember.where(id_community: params[:id_community]).where(id_user: params[:id_user]).first
        if (cm)
            
            CommunityMember.where(id_community: params[:id_community]).where(id_user: params[:id_user]).destroy_all
            render json: { status: 'SUCCESS', message: 'ELIMINACION EXITOSA'}, status: :ok
        else
            render json: { status: 'INVALID', message: 'NO ENCONTRADA'}, status: :unauthorized
            
        end
        
      end

    end
end