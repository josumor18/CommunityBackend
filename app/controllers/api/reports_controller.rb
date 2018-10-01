module Api
    class ReportsController < ApplicationController
      protect_from_forgery with: :null_session

      def create
          
          report = Report.new(id_user: params[:idUser], id_comment: params[:idComment], reason: params[:reason])
          if (report.save)  

            #---------- Cambiar authentication token ----------
            #user.auth_token = nil
            #o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map(&:to_a).flatten
            #user.auth_token = (0...20).map { o[rand(o.length)] }.join
            #user.save
            #--------------------------------------------------

            #Notifications
            comment = Comment.where(id: params[:idComment]).first
            news = New.where(id: comment.id_news).first
            idCom = news.idCommunity
        
            members = CommunityMember.where(id_community: idCom)
            members.each do |item|
              notif = Notification.new(idUser: item.id_user, idContent: news.id, isNews: false, isReports: true, isEvents: false, titleContent:  params[:idComment], seen: false, photo: "")
              notif.save
            end

            render json: { status: 'SUCCESS', message: 'Reporte creado'}, status: :created
          else
            render json: { status: 'INVALID', message: 'Error al crear reporte'}, status: :unauthorized
          end
      
      end  

      

    end
end