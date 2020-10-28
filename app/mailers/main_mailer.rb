class MainMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.main_mailer.report_email.subject
  #
  default :from => "titomer_ap@surgu.ru" # укажите свой адрес!
  def report_email(pdf_output, to)
    report_filename = Time.zone.now.strftime('Report %d-%m-%Y')
    attachments[report_filename] = {
        :mime_type => 'application/pdf',
        :content => pdf_output
    }
    mail(:to => to, :subject => report_filename.titleize)
  end
end
