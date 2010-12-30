module UpsShipping
  class Response
    attr_accessor :body
    attr_accessor :headers
    attr_accessor :request
    
    attr_accessor :status_code
    attr_accessor :status_description
    attr_accessor :error_severity
    attr_accessor :error_code
    attr_accessor :error_description
    
    def initialize(body, request = nil)
      self.body = body
      self.request = request
      parse_response
    end
    
    def success?
      status_code == '1'
    end
    
    
    protected
    
    def parse_response
      raise "Must Implement"
    end
  end
end
