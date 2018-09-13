class ApplicantNotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.applicant_notifications_mailer.new_email.subject
  #
  def new_email(email_id)
    @email = Email.find email_id
    @job_application = @email.job_application
    @job_offer = @job_application.job_offer
    @user = @job_application.user

    to = @user.email
    subject = @email.subject
    @body = @email.body
    @answer_url = [:account, @job_application, :emails]

    mail to: to, subject: subject
  end
end
