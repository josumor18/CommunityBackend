module Api
    class NotificationsController < ApplicationController
      protect_from_forgery with: :null_session

        
        #PUT seen notification 
        #params auth_token, idNotification, idUser
        def put_seenNotification
            user = User.where(id: params[:idUser]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                req = Notification.where(id: params[:idNotification]).first
                req.update(:seen=>true)


                render json: { status: 'SUCCESS', message: 'Notificacion actualizada' }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end
        
        
        #GET notifications by user
        #params auth_token, idUser
        def get_newsNotifications
            user = User.where(id: params[:idUser]).first
            token = params[:auth_token]
            if (user && user.auth_token == token)
              notifs = Notification.where(idUser: params[:idUser])
   
              #---------- Change authentication token ----------
              user.auth_token = nil
              o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
              user.auth_token = (0...20).map { o[rand(o.length)] }.join
              user.save
              #--------------------------------------------------
      
              render json: { status: 'SUCCESS', message: 'Notificaciones obtenidas', auth_token: user.auth_token, notifications: notifs}, status: :ok
            else
              render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end
        
        
        #DELETE notifications by id
        #params auth_token, idUser, idNotification 
        def delete_Notification
            user = User.where(id: params[:idUser]).first
            pass = params[:auth_token]
            if (user && user.auth_token == pass)
      

                dest = Notification.where(id: params[:idNotification]).first
                if (dest)   
                    Notification.where(id: params[:idNotification]).destroy_all
                    render json: { status: 'SUCCESS', message: 'ELIMINACION EXITOSA'}, status: :ok
                else
                    render json: { status: 'INVALID', message: 'NOTIFICACION NO ENCONTRADA'}, status: :unauthorized
                end
            else
              render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end
        
        
    end
end