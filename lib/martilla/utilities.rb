module Martilla
  class Backup
    module Utilities
      def duration_format(seconds)
        case seconds.to_i
        when 0..59
          # 22s
          "#{seconds.to_i}s"
        when 60..3599
          # 18m 19s
          "#{s_to_m(seconds).to_i}m #{(seconds % 60).to_i}s"
        else
          # 7h 9m 51s
          "#{s_to_h(seconds).to_i}h #{s_to_m(seconds).to_i}m #{(seconds % 60).to_i}s"
        end
      end

      def s_to_m(seconds)
        (seconds / 60) % 60
      end

      def s_to_h(seconds)
        (seconds / 3600) % 3600
      end

      def formatted_file_size
        return if @file_size.nil?

        if @file_size <= 799_999
          compressed_file_size = @file_size / 2**10
          formatted_size = '%.2f' % compressed_file_size
          "#{formatted_size} KB"
        elsif @file_size <= 799_999_999
          compressed_file_size = @file_size / 2**20
          formatted_size = '%.2f' % compressed_file_size
          "#{formatted_size} MB"
        else
          compressed_file_size = @file_size / 2**30
          formatted_size = '%.2f' % compressed_file_size
          "#{formatted_size} GB"
        end
      end
    end
  end
end
