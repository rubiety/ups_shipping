require 'uri'
require 'net/http'
require 'net/https'
require 'benchmark'

module UpsShipping
  class ResponseError < StandardError # :nodoc:
    attr_reader :response

    def initialize(response, message = nil)
      @response = response
      @message  = message
    end

    def to_s
      "Failed with #{response.code} #{response.message if response.respond_to?(:message)}"
    end
  end
  
  class Connection
    attr_accessor :logger
    
    def initialize
      self.logger = Logger.new(Rails.root.join('log/ups_shipping.log').to_s)
    end
    
    def confirm_shipment(shipment, production_override = false)
      request = ShipmentConfirmRequest.new(shipment, production_override)
      http_response = http_request(:post, request.request_uri, request.body, request.headers)
      ShipmentConfirmResponse.new(http_response, request)
    end
    
    def accept_shipment(shipment_digest, production_override = false)
      request = ShipmentAcceptRequest.new(shipment_digest, production_override)
      http_response = http_request(:post, request.request_uri, request.body, request.headers)
      ShipmentAcceptResponse.new(http_response, request)
    end
    
    def void_shipment(tracking_number, production_override = false)
      request = VoidShipmentRequest.new(tracking_number, production_override)
      http_response = http_request(:post, request.request_uri, request.body, request.headers)
      VoidShipmentResponse.new(http_response, request)
    end
    
    
    private
    
    def http_request(method, url, body, headers = {})
      begin
        info "#{method.to_s.upcase} #{url}"
        
        result = nil
        
        realtime = Benchmark.realtime do
          result = case method
          when :get
            raise ArgumentError, "GET requests do not support a request body" if body
            http.get(url.request_uri, headers)
          when :post
            debug body
            http.post(url.request_uri, body, headers)
          else
            raise ArgumentError, "Unsupported request method #{method.to_s.upcase}"
          end
        end
        
        info "--> %d %s (%d %.4fs)" % [result.code, result.message, result.body ? result.body.length : 0, realtime]
        response = handle_response(result)
        debug response
        response
      rescue EOFError => e
        raise ConnectionError, "The remote server dropped the connection"
      rescue Errno::ECONNRESET => e
        raise ConnectionError, "The remote server reset the connection"
      rescue Errno::ECONNREFUSED => e
        raise RetriableConnectionError, "The remote server refused the connection"
      rescue Timeout::Error, Errno::ETIMEDOUT => e
        raise ConnectionError, "The connection to the remote server timed out"
      end
    end
    
    def endpoint
      Configuration.base_url
    end
    
    def http
      http = Net::HTTP.new(endpoint.host, endpoint.port)
      configure_debugging(http)
      configure_timeouts(http)
      configure_ssl(http)
      http
    end
    
    def configure_debugging(http)
      # TODO: http.set_debug_output(wiredump_device)
    end
    
    def configure_timeouts(http)
      http.open_timeout = 60
      http.read_timeout = 60
    end
    
    def configure_ssl(http)
      return unless endpoint.scheme == "https"

      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    
    def handle_response(response)
      case response.code.to_i
      when 200...300
        response.body
      else
        raise ResponseError.new(response)
      end
    end
    
    def debug(message, tag = nil)
      log(:debug, message, tag)
    end
    
    def info(message, tag = nil)
      log(:info, message, tag)
    end
    
    def log(level, message, tag)
      message = "[#{tag}] #{message}" if tag
      logger.send(level, message) if logger
    end
  end
end
