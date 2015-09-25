class AdminMailer < ActionMailer::Base
  default from: "developer@skurun.com"

  def uberadmin_creation_notification(admin)
    @new_uberadmin = admin
    mail(to: "manhattan@skurun.com", subject: 'UberAdmin creation notification')
  end
end
