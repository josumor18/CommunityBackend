module Api
    class UsersController < ApplicationController
      protect_from_forgery with: :null_session
      
      # POST
      def login
        user = User.where(email: params[:email]).first
        pass = params[:password]
        if (user && user.password == pass)
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
            user.isPrivate = true
            if user.save
                render json: { status: 'SUCCESS', message: 'USUARIO REGISTRADO', data:user }, status: :created
            else
                render json: { status: 'ERROR', message: 'USUARIO NO CREADO' }, status: :bad
            end
        end
      end

      def edit
        user = User.where(id: params[:id]).first
        token = params[:authentication_token]

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
          render json: { status: 'SUCCESS', message: 'CAMBIO EXITOSO',authentication_token:user.auth_token}, status: :ok
        else
          render json: { status: 'INVALID TOKEN', message: 'Token inválido'}, status: :unauthorized
          
        end
      end

      private
      def user_params
        params.permit(:name, :email, :password, :tel, :cel, :address)
      end

    end
end