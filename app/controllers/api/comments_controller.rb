module Api
    class CommentsController < ApplicationController
      protect_from_forgery with: :null_session

      def create
          
          comment = Comment.new(id_news: params[:id_news], id_user: params[:id_user], description: params[:description])
          if (comment.save)
            
            
            render json: { status: 'SUCCESS', message: 'Comentario creado'}, status: :created
          else
            render json: { status: 'INVALID', message: 'Error al guardar comentario'}, status: :unauthorized
          end
      
    end

    def get_comments
      news = New.where(id: params[:id]).first
      
      comentarios = []
      coms = Comment.all
      coms.each do |item|
        if(news.id == item.id_news)
          comentarios.push(item)
        end

      end
      
      render json: { status: 'SUCCESS', message: 'Comentarios obtenidos', comentarios: comentarios}, status: :ok
    end


    def delete_comments
      c = Comment.where(id: params[:id]).first
      if (c)
        
        Comment.where(id: params[:id]).destroy_all
        reps = Report.where(id_comment: params[:id])
        reps.each do |item|
          Notification.where(idContent: item.id).where(isReports: true).destroy_all
        end

        Report.where(id_comment: params[:id]).destroy_all



        render json: { status: 'SUCCESS', message: 'ELIMINACION EXITOSA'}, status: :ok
      else
        render json: { status: 'INVALID', message: 'NO ENCONTRADA'}, status: :unauthorized
        
      end
    end

        

    end
end