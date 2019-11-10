require 'aws-sdk-ses'

module Martilla
  class Ses < EmailNotifier
    def success(data)
      begin
        ses_client.send_email(
          destination: {
            to_addresses: to_email.split(',')
          },
          message: {
            body: {
              html: {
                charset: 'UTF-8',
                data: success_html(data)
              },
              text: {
                charset: 'UTF-8',
                data: success_txt(data)
              }
            },
            subject: {
              charset: 'UTF-8',
              data: success_subject
            }
          },
          source: from_email
        )
      rescue Aws::SES::Errors::ServiceError => error
        puts "Email not sent. Error message: #{error}"
      end
    end

    def error(msg, data)
      begin
        ses_client.send_email(
          destination: {
            to_addresses: to_email.split(',')
          },
          message: {
            body: {
              html: {
                charset: 'UTF-8',
                data: error_html(msg, data)
              },
              text: {
                charset: 'UTF-8',
                data: error_txt(msg, data)
              }
            },
            subject: {
              charset: 'UTF-8',
              data: failure_subject
            }
          },
          source: from_email
        )
      rescue Aws::SES::Errors::ServiceError => error
        puts "Email not sent. Error message: #{error}"
      end
    end

    private

    def ses_client
      options = {}
      options[:region] = aws_region unless aws_region.nil?
      options[:access_key_id] = aws_access_key unless aws_access_key.nil?
      options[:secret_access_key] = aws_secret_key unless aws_secret_key.nil?
      Aws::SES::Client.new(options)
    end

    def aws_region
      aws_region = @options['region']
      raise config_error('region') if aws_region.nil?
      aws_region
    end

    def aws_access_key
      @options['access_key_id']
    end

    def aws_secret_key
      @options['secret_access_key']
    end
  end
end
