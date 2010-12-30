module UpsShipping
  
  # = Shipment Confirm Request
  # Initializes a shipment in UPS.  Constructor accepts a large options hash which is expected to contain 
  # details necessary for a shipment.  Example hash structure:
  #    
  #   {
  #     :description => "My Products",
  #     :service_code => "02",
  #     :ship_to => {
  #       :company_name => "Company",
  #       :attention_name => "Ben Hughes",
  #       :phone_number => "123-123-1234",
  #       :address1 => "123 Address",
  #       :address2 => "Apartment 2",
  #       :address3 => "Other",
  #       :city => "Rochester",
  #       :state => "NY",
  #       :postal_code => "14623"
  #       :country => "US"
  #     }
  #     :packages => [
  #       {
  #         :description => "Package One",
  #         :packing_type_code => '02',
  #         :insured_value => 1500.00,
  #         :weight => 14.1,
  #         :weight_unit => 'IN',
  #         :dimensions => {
  #           :unit => 'IN',
  #           :length => 2,
  #           :width => 3,
  #           :height => 4
  #         }
  #       }
  #     ]
  #   }
  # 
  class ShipmentConfirmRequest < Request
    attr_accessor :description
    attr_accessor :ship_to
    attr_accessor :service_code
    attr_accessor :packages
    attr_accessor :return_service_code
    attr_accessor :label_format
    attr_accessor :production_override
    
    def initialize(data = {}, production_override = false)
      self.description = data[:description]
      self.ship_to = data[:ship_to]
      self.service_code = data[:service_code]
      self.packages = data[:packages] || []
      self.return_service_code = data[:return_service_code]
      self.label_format = data[:label_format] || 'gif'
      self.production_override = production_override
    end
    
    def request_uri
      production_override ? URI.parse("https://www.ups.com/ups.app/xml/" + path_suffix) : super
    end
    
    def path_suffix
      "ShipConfirm"
    end
    
    def body
      xml = Builder::XmlMarkup.new(:indent => 2)
      
      build_credentials(xml)
      
      xml.instruct!(:xml, :encoding => "UTF-8")
      xml.ShipmentConfirmRequest do
        xml.Request do
          xml.TransactionReference do
            xml.CustomerContext
            xml.XpciVersion 1.0001
          end
          
          xml.RequestAction "ShipConfirm"
          xml.RequestOption "nonvalidate"
        end
        
        xml.Shipment do
          xml.Description description unless description
          
          if return_service_code
            xml.ReturnService do
              xml.Code return_service_code
            end
          end
          
          xml.Shipper do
            xml.Name Configuration.shipper['name']
            xml.AttentionName Configuration.shipper['attention_name']
            xml.PhoneNumber Configuration.shipper['phone_number']
            xml.ShipperNumber Configuration.shipper['shipper_number'] unless Configuration.shipper['shipper_number'].blank?
            xml.Address do
              xml.AddressLine1 Configuration.shipper['address1']
              xml.City Configuration.shipper['city']
              xml.StateProvinceCode Configuration.shipper['state']
              xml.CountryCode Configuration.shipper['country']
              xml.PostalCode Configuration.shipper['postal_code']
            end
          end
          
          # Reverse ShipFrom and ShipTo if this is return service:
          if return_service_code
            
            xml.ShipFrom do
              xml.CompanyName ship_to[:company_name]
              xml.AttentionName ship_to[:attention_name]
              xml.PhoneNumber ship_to[:phone_number]
              xml.Address do
                xml.AddressLine1 ship_to[:address1]
                xml.AddressLine2 ship_to[:address2]
                xml.AddressLine3 ship_to[:address3]
                xml.City ship_to[:city]
                xml.StateProvinceCode ship_to[:state]
                xml.CountryCode ship_to[:country]
                xml.PostalCode ship_to[:postal_code]
              end
            end
            
            xml.ShipTo do
              xml.CompanyName Configuration.ship_from['company_name']
              xml.AttentionName Configuration.ship_from['attention_name']
              xml.PhoneNumber Configuration.ship_from['phone_number']
              xml.Address do
                xml.AddressLine1 Configuration.ship_from['address1']
                xml.AddressLine2 Configuration.ship_from['address2']
                xml.AddressLine3 Configuration.ship_from['address3']
                xml.City Configuration.ship_from['city']
                xml.StateProvinceCode Configuration.ship_from['state']
                xml.CountryCode Configuration.ship_from['country']
                xml.PostalCode Configuration.ship_from['postal_code']
              end
            end
            
          else
            
            xml.ShipFrom do
              xml.CompanyName Configuration.ship_from['company_name']
              xml.AttentionName Configuration.ship_from['attention_name']
              xml.PhoneNumber Configuration.ship_from['phone_number']
              xml.Address do
                xml.AddressLine1 Configuration.ship_from['address1']
                xml.AddressLine2 Configuration.ship_from['address2']
                xml.AddressLine3 Configuration.ship_from['address3']
                xml.City Configuration.ship_from['city']
                xml.StateProvinceCode Configuration.ship_from['state']
                xml.CountryCode Configuration.ship_from['country']
                xml.PostalCode Configuration.ship_from['postal_code']
              end
            end
            
            xml.ShipTo do
              xml.CompanyName ship_to[:company_name]
              xml.AttentionName ship_to[:attention_name]
              xml.PhoneNumber ship_to[:phone_number]
              xml.Address do
                xml.AddressLine1 ship_to[:address1]
                xml.AddressLine2 ship_to[:address2]
                xml.AddressLine3 ship_to[:address3]
                xml.City ship_to[:city]
                xml.StateProvinceCode ship_to[:state]
                xml.CountryCode ship_to[:country]
                xml.PostalCode ship_to[:postal_code]
              end
            end
          
          end
          
          xml.Service do
            xml.Code service_code
            xml.Description Carrier::DEFAULT_SERVICES[service_code]
          end
          
          xml.PaymentInformation do
            xml.Prepaid do
              xml.BillShipper do
                xml.AccountNumber Configuration.account_number
              end
            end
          end
          
          # xml.ShipmentServiceOptions do
          #   xml.OnCallAir do
          #     xml.PickupDetails do
          #       xml.PickupDate
          #       xml.EarlyTimeReady
          #       xml.LatestTimeReady
          #       xml.ContactInfo do
          #         xml.Name
          #         xml.PhoneNumber
          #       end
          #     end
          #   end
          # end
          
          packages.each do |package|
            xml.Package do
              if package[:description]
                xml.Description package[:description]
              elsif return_service_code  # Description is required for return service code
                xml.Description "Video Phone Merchandise"
              end
              
              if package[:packing_type_code]
                xml.PackagingType do
                  xml.Code package[:packing_type_code]
                end
              end
              
              if package[:dimensions]
                xml.Dimensions do
                  if package[:dimensions][:unit]
                    xml.UnitOfMeasurement do
                      xml.Code package[:dimensions][:unit]
                    end
                  end
                  
                  xml.Length package[:dimensions][:length]
                  xml.Width package[:dimensions][:width]
                  xml.Height package[:dimensions][:height]
                end
              end
              
              if package[:weight]
                xml.PackageWeight do
                  if package[:weight_unit]
                    xml.UnitOfMeasurement package[:weight_unit]
                  end
                  
                  xml.Weight package[:weight]
                end
              end
              
              # xml.ReferenceNumber do
              #   xml.Code
              #   xml.Value
              # end
              
              if package[:insured_value]
                xml.PackageServiceOptions do
                  xml.InsuredValue do
                    xml.CurrencyCode 'USD'
                    xml.MonetaryValue package[:insured_value]
                  end
                
                  # xml.VerbalConfirmation do
                  #   xml.Name
                  #   xml.PhoneNumber
                  # end
                end
              end
            end
          end
          
        end
        
        
        # FYI:
        # "Label print method code that the labels are to
        # be generated for EPL2 formatted labels use
        # ‘EPL’, for SPL formatted labels use ‘SPL’, for
        # ZPL formatted labels use ‘ZPL’, for STAR
        # printer formatted labels use ‘STARPL’ and for
        # image formats use ‘GIF’."
        # 
        xml.LabelSpecification do
          
          if self.label_format.downcase == 'gif'
            xml.LabelPrintMethod do
              xml.Code "GIF"
            end
          
            xml.HTTPUserAgent "Mozilla/5.0"
          
            xml.LabelImageFormat do
              xml.Code "GIF"
            end
          
          elsif self.label_format.downcase == 'epl'
            xml.LabelPrintMethod do
              xml.Code "EPL"
            end
            
            xml.LabelStockSize do
              xml.Width 6.25
              xml.Height 4
            end
          end
          
        end
        
      end
    end
  end
end