
require 'net/smtp'

class SmtpNotifier

  def initialize(host, port, username, password, email)
    @host = host
    @port = port
    @username = username
    @password = password
    @email = email
  end

  def notify(title, message)
    Net::SMTP.start(@host, @port, 'localhost', @username, @password, :plain) do |smtp|
      smtp.send_message format_message(title, message), @email, @email
    end

  end

  def format_message(title, message)
    <<MESSAGE_END
From: #{@email}
To: #{@email}
MIME-Version: 1.0
Content-type: text/html
Subject: #{title}

#{message}
MESSAGE_END
  end

end
