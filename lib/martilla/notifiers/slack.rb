module Martilla
  class Slack < Notifier
    def success(data)
      puts "SUCCESSFULLY BACKUP UP"
    end

    def error(msg, data)
      puts "ERROR WHILE PERFORMING THE BACKUP: #{msg}"
    end
  end
end
