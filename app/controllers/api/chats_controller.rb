module Api
    class ChatsController < ApplicationController
      protect_from_forgery with: :null_session
        
        def send_message
            user = User.where(id: params[:id]).first
            token = params[:auth_token]

            if (user && user.auth_token==token)
                id_chat = params[:id_chat]
                if(id_chat)
                    mess = Message.new(id_chat: id_chat, )
                end
            end
        end
    end
end