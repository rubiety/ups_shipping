module UpsShipping
  class ShipmentAcceptResponse < Response
    attr_accessor :transportation_charges
    attr_accessor :service_options_charges
    attr_accessor :total_charges
    attr_accessor :billing_weight
    attr_accessor :billing_weight_unit
    attr_accessor :high_value_report
    attr_accessor :high_value_report_format
    
    attr_accessor :packages
    
    def initialize(body, request = nil)
      self.packages = []
      super
    end
    
    def parse_response
      data = Hash.from_xml(body)["shipment_accept_response"]
      
      self.status_code = data['response']['response_status_code']
      self.status_description = data['response']['response_status_description']
      
      if success?
        self.transportation_charges = data['shipment_results']['shipment_charges']['transportation_charges']['monetary_value']
        self.service_options_charges = data['shipment_results']['shipment_charges']['service_options_charges']['monetary_value']
        self.total_charges = data['shipment_results']['shipment_charges']['total_charges']['monetary_value']
        
        self.billing_weight = data['shipment_results']['billing_weight']['weight']
        self.billing_weight_unit = data['shipment_results']['billing_weight']['unit_of_measurement']['code']
        
        if data['shipment_results']['control_log_receipt']
          self.high_value_report = data['shipment_results']['control_log_receipt']['graphic_image']
          self.high_value_report_format = data['shipment_results']['control_log_receipt']['image_format']['code']
        end
        
        data['shipment_results']['package_results'] = [data['shipment_results']['package_results']] unless data['shipment_results']['package_results'].is_a?(Array)
        data['shipment_results']['package_results'].each do |package_result|
          self.packages << {
            :tracking_number => package_result['tracking_number'],
            :label_format => package_result['label_image']['label_image_format']['code'],
            :label => package_result['label_image']['graphic_image'],
            :html => package_result['label_image']['html_image'],
            :service_options_charges => package_result['service_options_charges']['monetary_value']
          }
        end
        
      else
        self.error_severity = data['response']['error']['error_severity']
        self.error_code = data['response']['error']['error_code']
        self.error_description = data['response']['error']['error_description']
      end
      
    end
    
  end
end