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
          render json: { status: 'SUCCESS', message: 'SESION INICIADA', data:user }, status: :ok
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

      private
      def user_params
        params.permit(:name, :email, :password, :tel, :cel, :address)
      end

    end
end