module UpsShipping
  class VoidShipmentRequest < Request
    attr_accessor :tracking_number
    attr_accessor :production_override
    
    def initialize(tracking_number, production_override = false)
      self.tracking_number = tracking_number
      self.production_override = production_override
    end
    
    def request_uri
      production_override ? URI.parse("https://www.ups.com/ups.app/xml/" + path_suffix) : super
    end
    
    def path_suffix
      "Void"
    end
    
    def body
      xml = Builder::XmlMarkup.new(:indent => 2)
      
      build_credentials(xml)
      
      xml.instruct!(:xml, :encoding => "UTF-8")
      xml.VoidShipmentRequest do
        xml.Request do
          xml.TransactionReference do
            xml.CustomerContext
            xml.XpciVersion
          end
          
          xml.RequestAction 1
          xml.RequestOption 1
        end
        
        xml.ShipmentIdentificationNumber tracking_number
      end
    end
    
  end
end
