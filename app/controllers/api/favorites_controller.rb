module Api
    class FavoritesController < ApplicationController
      protect_from_forgery with: :null_session

      def create
          
          post = New.new(id_user: params[:id_user], id_news: params[:id_news])
          if (post.save)

            render json: { status: 'SUCCESS', message: 'Difusion agregada a favoritos '}, status: :created
          else
            render json: { status: 'INVALID', message: 'Error al guardar difusion a favoritos'}, status: :unauthorized
          end
      
    end

    def get_newsFavorites
      usr = User.where(id: params[:id]).first

      
      publicaciones = []
      postsFav = Favorite.all
      postsFav.each do |item|
        if(usr.id == item.id_news)
          publicaciones.push(item)
        end

      end
      
      render json: { status: 'SUCCESS', message: 'Difusiones obtenidas de favoritos', news: publicaciones}, status: :ok
    end

 


    def delete_Favorites
      fav = Favorite.where(id: params[:id]).first
      if (n)
        
        Favorite.where(id: params[:id]).destroy_all
        
        render json: { status: 'SUCCESS', message: 'ELIMINACION EXITOSA'}, status: :ok
      else
        render json: { status: 'INVALID', message: 'NO ENCONTRADA'}, status: :unauthorized
        
      end
    end

        

    end
end