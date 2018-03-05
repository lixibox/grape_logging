module GrapeLogging
  module Formatters
    class Lograge

      def call(severity, datetime, _, data)
        time = data.delete :time
        attributes = {
          method: data[:method],
          path: data[:path],
          format: 'json',
          controller: get_api_name(data[:path]),
          action: get_action_name(data[:path]),
          status: data[:status],
          duration: time[:total],
          view: time[:view],
          db: time[:db],
          '@timestamp': datetime.iso8601,
          parameters: data[:params]
        }
        ::Lograge.formatter.call(attributes) + "\n"
      end

      def get_api_name(path)
        arr = path.split('/')
        case arr[1]
        when 'web'
          return 'web_api'
        when 'api'
          return 'mobile_api_' + arr[2]
        else
          return arr[1] + '_api_' + arr[2]
        end
      end

      def get_action_name(path)
        path.split('/').last.gsub('.json', '')
      end

    end
  end
end
