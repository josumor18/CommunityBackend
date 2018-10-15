module Api
    class PushNotification < ApplicationController
        protect_from_forgery with: :null_session

        #tipo: 1-Evento; 2-Difusion
        def createNotification(tipo, object)
            require 'fcm'

            fcm = FCM.new("AAAAUQHhwp4:APA91bGFhhqTIvUGRGkq3gahuv4GQyRqiOEO4T92tMCz6bXSIki-zqLTFMexXV5I-qaF2eSSqz0iP3z3i997T1XAxXH6uJciLl6gp6H1PmXPOSYGLroOD1uGcKcNLM_aa_I5rcvfDf7X") # Find server_key on: your firebase console on web > tab general > web api key

            #registration_ids= [device_token] # Array of keys generated by firebase for devices 
            registration_ids = get_tokens(object.id_community, object.approved)

            options = {
                    priority: "high",
                    collapse_key: "updated_score", 
                    notification: {
                        title: "Message Title", 
                        body: "Hi, Worked perfectly",
                        icon: "myicon"
                    },
                    data: {
                        tipo: 231,
                        message: "Este es mi mensaje para tí",
                        titulo: "Titulito"
                    }
                    }

            response = fcm.send(registration_ids, options)
        end

        def get_tokens(id_community, approved)
            registration_ids = []
            if(approved == true)
                members = CommunityMember.where(id_community: id_community)

                members.each do |member|
                    if(member.isAdmin == false)
                        device = DeviceToken.where(id_user: member.id_user).first
                        registration_ids.push(device.token)
                    end
                end
            else
                member = CommunityMember.where(id_community: id_community).where(isAdmin: true).first
                device = DeviceToken.where(id_user: member.id_user).first
                registration_ids.push(device.token)
            end
            registration_ids
        end

        #def printSomething
            #puts "Hola"
        #end
    end
end