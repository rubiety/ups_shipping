module UpsShipping
  class ShipmentConfirmResponse < Response
    attr_accessor :transportation_charges
    attr_accessor :service_options_charges
    attr_accessor :total_charges
    attr_accessor :billing_weight
    attr_accessor :billing_weight_unit
    
    attr_accessor :shipment_identification_number
    attr_accessor :shipment_digest
    
    def parse_response
      data = Hash.from_xml(body)["shipment_confirm_response"]

      if data.nil? or data['response'].nil?
        self.error_code = "NIL"
        self.error_description = "Response from shipment confirm response was nil."
        return
      end
      
      self.status_code = data['response']['response_status_code']
      self.status_description = data['response']['response_status_description']
      
      if success?
        self.transportation_charges = data['shipment_charges']['transportation_charges']['monetary_value']
        self.service_options_charges = data['shipment_charges']['service_options_charges']['monetary_value']
        self.total_charges = data['shipment_charges']['total_charges']['monetary_value']
      
        self.billing_weight = data['billing_weight']['weight']
        self.billing_weight_unit = data['billing_weight']['unit_of_measurement']['code']
      
        self.shipment_identification_number = data['shipment_identification_number']
        self.shipment_digest = data['shipment_digest']
      else
        self.error_severity = data['response']['error']['error_severity'] rescue nil
        self.error_code = data['response']['error']['error_code'] rescue nil
        self.error_description = data['response']['error']['error_description'] rescue nil
      end
      
    end
  end
end
