module Api
    class UsersController < ApplicationController
      protect_from_forgery with: :null_session
      
      # POST
      def login
        user = User.where(email: params[:email]).first
        pass = params[:password]
        token = params[:auth_token]
        device_token = params[:device_token]
        if (user && (user.password == pass || user.auth_token == token))
          dev_tok = DeviceToken.where(id_user: user.id).first
          if(dev_tok)
            dev_tok.update(:token=>device_token)
          end
            #---------- Cambiar authentication token ----------
            user.auth_token = nil
            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
            user.auth_token = (0...20).map { o[rand(o.length)] }.join
            user.save
            #--------------------------------------------------

            comm_admin = CommunityMember.where(id_user: user.id).where(isAdmin: true)
            list_com_admin = []
            comm_admin.each do |item|
                list_com_admin.push(item.id_community)
            end

            render json: { status: 'SUCCESS', message: 'SESION INICIADA', data:user, list_com_admin: list_com_admin }, status: :ok
        else
            render json: { status: 'INVALID', message: 'Error al iniciar sesion'}, status: :unauthorized
        end
      end

      # POST
      def register
        user = User.where(email: params[:email]).first
        if user
            render json: { status: 'ERROR', message: 'USUARIO EXISTENTE' }, status: :unauthorized
        else
            user = User.new(user_params)
            user.isPrivate = false
            #---------- Cambiar authentication token ----------
            user.auth_token = nil
            o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
            user.auth_token = (0...20).map { o[rand(o.length)] }.join
            #--------------------------------------------------

            if user.save
              DeviceToken.new(id_user: user.id, token: "").save
              render json: { status: 'SUCCESS', message: 'USUARIO REGISTRADO', data:user }, status: :created
            else
                render json: { status: 'ERROR', message: 'USUARIO NO CREADO' }, status: :bad
            end
        end
      end

      #PUT
      def logout
        user = User.where(id: params[:id]).first
        token = params[:auth_token]

        if (user && user.auth_token==token)
          dev_tok = DeviceToken.where(id_user: user.id).first
          dev_tok.update(:token=>"")
        end
      end

      #PUT
      def edit
        user = User.where(id: params[:id]).first
        token = params[:auth_token]

        if (user && user.auth_token==token)
          #---------- Cambiar authentication token ----------
          user.auth_token = nil
          o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
          user.auth_token = (0...20).map { o[rand(o.length)] }.join
          user.save
          #--------------------------------------------------
          user.update(:name=>params[:name])
          user.update(:cel=>params[:cel])
          user.update(:tel=>params[:tel])
          user.update(:address=>params[:address])
          user.update(:isPrivate=>params[:isPrivate])
          render json: { status: 'SUCCESS', message: 'CAMBIO EXITOSO',auth_token:user.auth_token}, status: :ok
        else
          render json: { status: 'INVALID TOKEN', message: 'Token inválido'}, status: :unauthorized
          
        end
      end

      def update_image
        user = User.where(id: params[:id]).first
        if(user)
          user.photo = params[:photo]
          user.photo_thumbnail = params[:photo_thumbnail]
          user.save
          render json: { status: 'SUCCESS', message: 'USUARIO MODIFICADO (fotos)' }, status: :ok
        else
          render json: { status: 'SUCCESS', message: 'USUARIO NO MODIFICADO'}, status: :unauthorized
        end
      end

      def get_users
        com = CommunityMember.where(id_community: params[:id_community])
        
        usuarios = []
        users = User.all
        com.each do |item1|
          users.each do |item|
            if(item1.id_user == item.id)
              usuarios.push(item)
            end

          end
        end
        
        render json: { status: 'SUCCESS', message: 'Usuarios obtenidos', usuarios: usuarios}, status: :ok
      end

      private
      def user_params
        params.permit(:name, :email, :password, :tel, :cel, :address)
      end

    end
end