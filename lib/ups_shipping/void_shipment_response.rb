module UpsShipping
  class VoidShipmentResponse < Response
    def parse_response
      data = Hash.from_xml(body)["void_shipment_response"]
      
      self.status_code = data['response']['response_status_code']
      self.status_description = data['response']['response_status_description']
      
      unless success?
        self.error_severity = data['response']['error']['error_severity']
        self.error_code = data['response']['error']['error_code']
        self.error_description = data['response']['error']['error_description']
      end
    end
  end
end
