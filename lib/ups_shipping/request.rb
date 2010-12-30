module UpsShipping
  class Request
    def path_suffix
      raise "Must Implement"
    end
    
    def request_uri
      URI.parse(Configuration.base_url.to_s + "/" + path_suffix)
    end
    
    def headers
      { "Content-Type" => "application/x-www-form-urlencoded" }
    end
    
    
    private
    
    def build_credentials(xml)
      xml.instruct!(:xml)
      
      xml.AccessRequest do
        xml.AccessLicenseNumber UpsShipping::Configuration.access_license_number
        xml.UserId UpsShipping::Configuration.user_id
        xml.Password UpsShipping::Configuration.password
      end
    end
  end
end
