module Api
    class ChatsController < ApplicationController
      protect_from_forgery with: :null_session
        
        #POST send_message
        def send_message
            user = User.where(id: params[:id]).first
            token = params[:auth_token]

            if (user && user.auth_token==token)
                id_chat = params[:id_chat]
                if(id_chat)
                    mess = Message.new(id_chat: id_chat, id_user: user.id, message: params[:message], seen: false)
                    if(mess.save)
                        #---------- Cambiar authentication token ----------
                        #user.auth_token = nil
                        #o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                        #user.auth_token = (0...20).map { o[rand(o.length)] }.join
                        #user.save
                        #--------------------------------------------------
                        #render json: { status: 'SUCCESS', message: 'MENSAJE ENVIADO', auth_token:user.auth_token}, status: :ok
                        render json: { status: 'SUCCESS', message: 'MENSAJE ENVIADO'}, status: :ok
                    else
                        render json: { status: 'ERROR', message: 'Mensaje no enviado'}, status: :unauthorized
                    end
                end
            else
                render json: { status: 'INVALID TOKEN', message: 'Token inválido'}, status: :unauthorized
            end
        end

        #GET get_chats
        def get_chats
            user = User.where(id: params[:id]).first
            token = params[:auth_token]

            if (user && user.auth_token==token)
                comm_mem = CommunityMember.where(id_user: user.id).where(id_community: params[:id_community]).first

                chats = []
                last_msg = []
                chat_grupal = Chat.where(id_community: params[:id_community]).where(is_group: true).first
                chats.push(chat_grupal)
                last_msg.push(Message.where(id_chat: chat_grupal.id).last)

                if(comm_mem && comm_mem.isAdmin)
                    comm_mems = CommunityMember.where(id_community: params[:id_community]).where(isAdmin: false)

                    comm_mems.each do |m|
                        chat_temp = Chat.where(id_community: m.id_community).where(id_user: m.id_user).where(is_group: false).first
                        chats.push(chat_temp)
                        last_msg.push(Message.where(id_chat: chat_temp.id).last)
                    end
                else
                    chat_temp = Chat.where(id_community: params[:id_community]).where(is_group: false).where(id_user: user.id).first
                    chats.push(chat_temp)
                    last_msg.push(Message.where(id_chat: chat_temp.id).last)
                end

                #---------- Cambiar authentication token ----------
                #user.auth_token = nil
                #o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                #user.auth_token = (0...20).map { o[rand(o.length)] }.join
                #user.save
                #--------------------------------------------------
                render json: { status: 'SUCCESS', message: 'Mensajes Obtenidos', chats: chats, last_msg: last_msg, auth_token:user.auth_token}, status: :ok
            else
                render json: { status: 'INVALID TOKEN', message: 'Token inválido'}, status: :unauthorized
            end
        end

        #GET get_messages
        def get_messages
            user = User.where(id: params[:id]).first
            token = params[:auth_token]
            if (user && user.auth_token==token)
                messages_list = Message.where(id_chat: params[:id_chat]).order('created_at ASC')

                last_id = params[:last_id].to_i
                mess_list = []
                count_my_messages = 0

                if(last_id == -1)
                    messages_list.each do |mess|
                        if(mess.id_user != user.id)
                            mess.update(:seen=>true)
                        else
                            count_my_messages = count_my_messages + 1
                        end
                        mess_list.push(mess)
                    end
                else
                    last_id_passed = false
                    messages_list.each do |mess|
                        if(last_id_passed)
                            if(mess.id_user != user.id)
                                mess.update(:seen=>true)
                            else
                                count_my_messages = count_my_messages + 1
                            end
                            mess_list.push(mess)
                        else
                            if(mess.id == last_id)
                                last_id_passed = true
                            end
                        end
                        
                    end
                end
                

                #---------- Cambiar authentication token ----------
                #user.auth_token = nil
                #o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
                #user.auth_token = (0...20).map { o[rand(o.length)] }.join
                #user.save
                #--------------------------------------------------
                render json: { status: 'SUCCESS', message: 'Mensajes Obtenidos', messages_list:mess_list, count_my_messages:count_my_messages}, status: :ok
            else
                render json: { status: 'INVALID TOKEN', message: 'Token inválido'}, status: :unauthorized
            end
        end
    end
end