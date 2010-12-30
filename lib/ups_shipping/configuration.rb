module UpsShipping
  class Configuration
    cattr_accessor :account_number
    cattr_accessor :base_url
    cattr_accessor :developer_key
    cattr_accessor :access_license_number
    cattr_accessor :user_id
    cattr_accessor :password
    cattr_accessor :shipper
    cattr_accessor :ship_from
    
    def self.load_from(filename, rails_env = Rails.env.to_s)
      data = YAML.load_file(filename)[rails_env]
      
      if data
        self.account_number = data['account_number']
        self.base_url = URI.parse(data['base_url'])
        self.developer_key = data['developer_key']
        self.access_license_number = data['access_license_number']
        self.user_id = data['user_id']
        self.password = data['password']
        self.shipper = data['shipper']
        self.ship_from = data['ship_from']
      end
    end
    
    self.load_from(Rails.root.join('config/ups_shipping.yml'))
  end
end
