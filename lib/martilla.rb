require 'martilla/version'
require 'martilla/cli'

require 'martilla/backup'

require 'martilla/database'
require 'martilla/databases/mysql'
require 'martilla/databases/postgres'

require 'martilla/notifier'
require 'martilla/notifiers/email_notifier'
require 'martilla/notifiers/smtp'
require 'martilla/notifiers/sendmail'
require 'martilla/notifiers/ses'
require 'martilla/notifiers/slack'

require 'martilla/storage'
require 'martilla/storages/local'
require 'martilla/storages/s3'
require 'martilla/storages/scp'

module Martilla
  class Error < StandardError; end
end
