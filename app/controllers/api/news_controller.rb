module Api
    class NewsController < ApplicationController
      protect_from_forgery with: :null_session

      def create
          
          post = New.new(idCommunity: params[:idCommunity], title: params[:title], description: params[:description], date: params[:date], photo: params[:photo], approved: params[:approved])
          if (post.save)
            
            #notifications
            isApproved = params[:approved]
            if(isApproved)
              members = CommunityMember.where(id_community: params[idCommunity])
              members.each do |item|
                Notification.new(idUser: item.id_user, idContent: post.id, created_at: params[:date], isNews: true, isReports: false, isEvents: false, titleContent:  params[:title], seen: false)
              end
            end

            #amigos = Amigo.where(id_user1:  = user.id)

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

      favs = Favorite.where(id_user: params[:idUser])
      
      render json: { status: 'SUCCESS', message: 'Difusiones obtenidas', news: publicaciones, favorites: favs}, status: :ok
    end

    def get_news_status
      com = Community.where(id: params[:id]).first
      
      publicaciones = []
      posts = New.where(approved: params[:isApproved])
      posts.each do |item|
        if(com.id == item.idCommunity)
          publicaciones.push(item)
        end

      end
      favs = Favorite.where(id_user: params[:idUser])
      render json: { status: 'SUCCESS', message: 'Difusiones obtenidas', news: publicaciones, favorites: favs}, status: :ok

    end

    def approve_news
      n = New.where(id: params[:id]).first
      if (n)
        
        n.update(:approved=>true)
        #notifications
        idCom = n.idCommunity
        members = CommunityMember.where(id_community: idCom)
        members.each do |item|
          #FALTAAAAAAAAAAA
          Notification.new(idUser: item.id_user, idContent: n.id, created_at: params[:date], isNews: true, isReports: false, isEvents: false, titleContent:  params[:title], seen: false)
        end

        
        render json: { status: 'SUCCESS', message: 'APROBACION EXITOSA'}, status: :ok
      else
        render json: { status: 'INVALID', message: 'NO ENCONTRADA'}, status: :unauthorized
        
      end
    end

    def delete_news
      n = New.where(id: params[:id]).first
      if (n)
        
        New.where(id: params[:id]).destroy_all


        comments = Comment.where(id_news: params[:id])
        comments.each do |item|
          r = Report.where(id_comment: item.id).first
          if(r)
            Report.where(id_comment: item.id).destroy_all
          end

        end

        comments.destroy_all
        

        Favorite.where(id_news: params[:id]).destroy_all


        render json: { status: 'SUCCESS', message: 'ELIMINACION EXITOSA'}, status: :ok
      else
        render json: { status: 'INVALID', message: 'NO ENCONTRADA'}, status: :unauthorized
        
      end
    end

        

    end
end