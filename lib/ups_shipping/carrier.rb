module UpsShipping
  module Carrier
    DEFAULT_SERVICES = {
      "01" => "UPS Next Day Air",
      "02" => "UPS Second Day Air",
      "03" => "UPS Ground",
      "07" => "UPS Worldwide Express",
      "08" => "UPS Worldwide Expedited",
      "11" => "UPS Standard",
      "12" => "UPS Three-Day Select",
      "13" => "UPS Next Day Air Saver",
      "14" => "UPS Next Day Air Early A.M.",
      "54" => "UPS Worldwide Express Plus",
      "59" => "UPS Second Day Air A.M.",
      "65" => "UPS Saver",
      "82" => "UPS Today Standard",
      "83" => "UPS Today Dedicated Courier",
      "84" => "UPS Today Intercity",
      "85" => "UPS Today Express",
      "86" => "UPS Today Express Saver"
    }
    
    CANADA_ORIGIN_SERVICES = {
      "01" => "UPS Express",
      "02" => "UPS Expedited",
      "14" => "UPS Express Early A.M."
    }
    
    MEXICO_ORIGIN_SERVICES = {
      "07" => "UPS Express",
      "08" => "UPS Expedited",
      "54" => "UPS Express Plus"
    }
    
    EU_ORIGIN_SERVICES = {
      "07" => "UPS Express",
      "08" => "UPS Expedited"
    }
    
    OTHER_NON_US_ORIGIN_SERVICES = {
      "07" => "UPS Express"
    }
    
    RETURN_SERVICE_TYPES = {
      "2" => "UPS Print and Mail (PNM)",
      "3" => "UPS Return Service 1-Attempt (RS1)",
      "5" => "UPS Return Service 3-Attempt (RS3)",
      "8" => "UPS Electronic Return Label (ERL)",
      "9" => "UPS Print Return Label (PRL)"
    }
  end
end