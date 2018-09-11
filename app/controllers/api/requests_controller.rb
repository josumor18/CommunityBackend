module Api
    class RequestsController < ApplicationController
      protect_from_forgery with: :null_session

        #GET community resquests
        def get
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                reqs = Request.where(id_community: params[:id_community])
                users_req = []

                reqs.each do |req|
                    user = User.where(id: req.id_user).first

                    if(user)
                        users_req.push(user)
                    end
                end

                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------
                render json: { status: 'SUCCESS', message: 'Solicitudes obtenidas', users: users_req, auth_token: user.auth_token }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        #POST create request
        def create
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                req = Request.new(id_community: params[:id_community], id_user: user.id, seen: false)

                if(req.save)
                    #---------- Cambiar authentication token ----------
                    user.auth_token = nil
                    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                    user.auth_token = (0...20).map { o[rand(o.length)] }.join
                    user.save
                    #--------------------------------------------------
                    render json: { status: 'SUCCESS', message: 'Solicitud creada', auth_token: user.auth_token }, status: :created
                else
                    render json: { status: 'INVALID', message: 'Error al guardar solicitud'}, status: :unauthorized
                end
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        #DELETE community request
        def delete
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                Request.where(id_community: params[:id_community]).where(id_user: params[:id_user]).destroy_all

                render json: { status: 'SUCCESS', message: 'Solicitud eliminada', auth_token: user.auth_token }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end





        #########################
        #POST create community
        def create_com
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                com = Community.new(name:params[:name], description: params[:description], rules: params[:rules], isSubcommunity:params[:isSubcommunity], photo:params[:photo], photo_thumbnail:params[:photo_thumbnail])#community_params)
    
                if(com.save)
                    #---------- Cambiar authentication token ----------
                    user.auth_token = nil
                    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                    user.auth_token = (0...20).map { o[rand(o.length)] }.join
                    user.save
                    #--------------------------------------------------
                    render json: { status: 'SUCCESS', message: 'Comunidad creada', auth_token: user.auth_token }, status: :created
                else
                    render json: { status: 'INVALID', message: 'Error al crear comunidad'}, status: :unauthorized
                end
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
            
        end

    end
end