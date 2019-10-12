module Martilla
  class Backup
    module Utilities
      def duration_format(seconds)
        case seconds
        when 0..59
          # 22s
          "#{seconds}s"
        when 60..3599
          # 18m 19s
          "#{s_to_m(seconds)}m #{seconds % 60}s"
        else
          # 7h 9m 51s
          "#{s_to_h(seconds)}h #{s_to_m(seconds)}m #{seconds % 60}s"
        end
      end

      def s_to_m(seconds)
        (seconds / 60) % 60
      end

      def s_to_h(seconds)
        (seconds / 3600) % 3600
      end

      def self.sample_config
        {
          db: {
            type: 'postgres',
            options: {
              host: 'ec2-00-00-100-100.eu-west-1.compute.amazonaws.com',
              port: 5432,
              user: 'username',
              password: 'password',
              db: 'databasename'
            }
          },
          storage: {
            type: 's3',
            options: {
              bucket: 'db-backups',
              access_key_id: 'asdf',
              secret_access_key: '1234',
              region: 'us-east-1',
              path: 'path/to/backups'
            }
          },
          notifiers: [
            {
              type: 'email',
              options: {
                from: 'backups@example.com',
                to: 'dba@example.com',
                cc: 'ops@example.com',
                address: 'smtp.yourserver.com',
                port: 25,
                user_name: 'user',
                password: 'password',
                authentication: 'plain'
              }
            },
            {
              type: 'slack',
              options: {
                url: 'https://slack.com/alksmdlakmsla'
              }
            }
          ]
        }
      end
    end
  end
end
