class CanoeMailer < ApplicationMailer
  helper :application

  def invite(canoe, coller, to_email)
    @canoe = canoe
    @coller = coller
    mail(from: @coller.email,
      to: to_email,
      subject: "'#{@canoe.title}' 카누를 소개합니다.")
  end
end
