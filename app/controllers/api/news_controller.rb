module Api
    class NewsController < ApplicationController
      protect_from_forgery with: :null_session

      def create
          
          post = New.new(idCommunity: params[:idCommunity], title: params[:title], description: params[:description], date: params[:date], photo: params[:photo], approved: params[:approved])
          if (post.save)
            
            #amigos = Amigo.where(id_user1: user.id)

            #amigos.each do |amigo|
              #notif = Notification.new(id_user: amigo.id_user2, id_friend: user.id, id_post: post.id, visto: false)
              #notif.save
            #end

            #---------- Cambiar authentication token ----------
            #user.auth_token = nil
            #o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
            #user.auth_token = (0...20).map { o[rand(o.length)] }.join
            #user.save
            #--------------------------------------------------
            render json: { status: 'SUCCESS', message: 'Difusion creada'}, status: :created
          else
            render json: { status: 'INVALID', message: 'Error al guardar difusion'}, status: :unauthorized
          end
      
    end

    def get_news
      com = Community.where(id: params[:id]).first
      
      publicaciones = []
      posts = New.all
      posts.each do |item|
        if(com.id == item.idCommunity)
          publicaciones.push(item)
        end

      end
      
      render json: { status: 'SUCCESS', message: 'Difusiones obtenidas', news: publicaciones}, status: :ok
    end

        

    end
end