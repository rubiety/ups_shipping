module UpsShipping
  class Location
    attr_accessor :country,
    attr_accessor :postal_code,
    attr_accessor :province,
    attr_accessor :city,
    attr_accessor :address1,
    attr_accessor :address2,
    attr_accessor :address3,
    attr_accessor :phone,
    attr_accessor :fax,
    attr_accessor :address_type
    
    alias_method :zip, :postal_code
    alias_method :postal, :postal_code
    alias_method :state, :province
    alias_method :territory, :province
    alias_method :region, :province
    
    def initialize(options = {})
      @country = options[:country]
      @postal_code = options[:postal_code] || options[:postal] || options[:zip]
      @province = options[:province] || options[:state] || options[:territory] || options[:region]
      @city = options[:city]
      @address1 = options[:address1]
      @address2 = options[:address2]
      @address3 = options[:address3]
      @phone = options[:phone]
      @fax = options[:fax]
      
      raise ArgumentError.new('address_type must be either "residential" or "commercial"') if options[:address_type] and not (["residential", "commercial", ""]).include?(options[:address_type].to_s)
      @address_type = options[:address_type].nil? ? nil : options[:address_type].to_s
    end
    
    def residential?; (@address_type == 'residential') end
    def commercial?; (@address_type == 'commercial') end
    
    def to_s
      prettyprint.gsub(/\n/, ' ')
    end
    
    def prettyprint
      chunks = []
      chunks << [@address1,@address2,@address3].reject {|e| e.blank?}.join("\n")
      chunks << [@city,@province,@postal_code].reject {|e| e.blank?}.join(', ')
      chunks << @country
      chunks.reject {|e| e.blank?}.join("\n")
    end
    
    def inspect
      string = prettyprint
      string << "\nPhone: #{@phone}" unless @phone.blank?
      string << "\nFax: #{@fax}" unless @fax.blank?
      string
    end
  end
end