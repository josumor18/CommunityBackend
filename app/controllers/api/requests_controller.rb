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
                seens = []

                reqs.order("created_at ASC")

                reqs.each do |req|
                    user_req = User.where(id: req.id_user).first

                    if(user_req)
                        users_req.push(user_req)
                    end
                    
                    seens.push(req.seen)

                    req.update(:seen=>true)
                end

                #---------- Cambiar authentication token ----------
                user.auth_token = nil
                o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                user.auth_token = (0...20).map { o[rand(o.length)] }.join
                user.save
                #--------------------------------------------------
                render json: { status: 'SUCCESS', message: 'Solicitudes obtenidas', users: users_req, seens: seens, auth_token: user.auth_token }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        #POST accept request
        def accept
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                mem = CommunityMember.new(id_community: params[:id_community], id_user: params[:id_user], isAdmin: false)

                if(mem.save)
                    Request.where(id_community: params[:id_community]).where(id_user: params[:id_user]).destroy_all

                    Chat.new(id_community: params[:id_community], id_user: params[:id_user], is_group: false).save
                    #---------- Cambiar authentication token ----------
                    user.auth_token = nil
                    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                    user.auth_token = (0...20).map { o[rand(o.length)] }.join
                    user.save
                    #--------------------------------------------------
                    render json: { status: 'SUCCESS', message: 'Usuario agregado', auth_token: user.auth_token }, status: :ok
                else
                    render json: { status: 'SUCCESS', message: 'Usuario NO agregado', auth_token: user.auth_token }, status: :unauthorized
                end
                
                
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

        #PUT seen request
        def put_seen
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                reqs = Request.where(id_community: params[:id_community])

                reqs.each do |req|
                    req.update(:seen=>true)
                end

                render json: { status: 'SUCCESS', message: 'Solicitudes actualizadas' }, status: :ok
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

        #GET community resquests
        def count_new_requests
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if(user.auth_token == token)
                cant = Request.where(id_community: params[:id_community]).where(seen: false).count

                render json: { status: 'SUCCESS', message: 'Cantidad de solicitudes obtenidas', cantidad: cant }, status: :ok
            else
                render json: { status: 'INVALID', message: 'Token invalido'}, status: :unauthorized
            end
        end

    end
end