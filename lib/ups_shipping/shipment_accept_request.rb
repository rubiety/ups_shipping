module UpsShipping
  
  # = Shipment Accept Request
  # Finalizes shipment in UPS given a previously-existing shipping digest, which is the sole argument
  # to the constructor method.
  # 
  class ShipmentAcceptRequest < Request
    attr_accessor :shipment_digest
    attr_accessor :production_override
    
    def initialize(shipment_digest, production_override = false)
      self.shipment_digest = shipment_digest
      self.production_override = production_override
    end
    
    def request_uri
      production_override ? URI.parse("https://www.ups.com/ups.app/xml/" + path_suffix) : super
    end
    
    def path_suffix
      "ShipAccept"
    end
    
    def body
      xml = Builder::XmlMarkup.new(:indent => 2)
      
      build_credentials(xml)
      
      xml.instruct!(:xml, :encoding => "UTF-8")
      xml.ShipmentAcceptRequest do
        xml.Request do
          xml.TransactionReference do
            xml.CustomerContext
            xml.XpciVersion 1.0001
          end
          
          xml.RequestAction "ShipAccept"
        end
        
        xml.ShipmentDigest shipment_digest
      end
    end
  end
end