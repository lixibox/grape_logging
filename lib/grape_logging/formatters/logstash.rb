module GrapeLogging
  module Formatters
    class Logstash
      def call(severity, datetime, _, data)
        load_dependencies
        event = LogStash::Event.new(data)

        event['message'] = "[#{data[:status]}] #{data[:method]} #{data[:path]} (#{data[:controller]}##{data[:action]})"
        event.to_json
      end

      private

      def load_dependencies
        require 'logstash-event'
      rescue LoadError
        puts 'You need to install the logstash-event gem to use the logstash output.'
        raise
      end

      def format(data)
        if data.is_a?(Hash)
          data
        elsif data.is_a?(String)
          { message: data }
        elsif data.is_a?(Exception)
          format_exception(data)
        else
          { message: data.inspect }
        end
      end

      def format_exception(exception)
        {
          exception: {
            message: exception.message
          }
        }
      end
    end
  end
end
