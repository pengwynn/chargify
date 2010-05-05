module Chargify
  class UnexpectedResponseError < RuntimeError
  end
  
  class Parser < HTTParty::Parser
    def parse
      begin
        Crack::JSON.parse(body)
      rescue => e
        raise UnexpectedResponseError, "Crack could not parse JSON. It said: #{e.message}. Chargify's raw response: #{body}"
      end
    end
  end
  
  class Client
    include HTTParty
    
    parser Chargify::Parser
    headers 'Content-Type' => 'application/json' 
    
    attr_reader :api_key, :subdomain
    
    # Your API key can be generated on the settings screen.
    def initialize(api_key, subdomain)
      @api_key = api_key
      @subdomain = subdomain
      
      self.class.base_uri "https://#{@subdomain}.chargify.com"
      self.class.basic_auth @api_key, 'x'
      
    end
    
    # options: page
    def list_customers(options={})
      customers = self.class.get("/customers.json", :query => options)
      customers.map{|c| Hashie::Mash.new c['customer']}
    end
    
    def customer(chargify_id)
      Hashie::Mash.new(self.class.get("/customers/lookup.json?reference=#{chargify_id}")).customer
    end
    
    #
    # * first_name (Required)
    # * last_name (Required)
    # * email (Required)
    # * organization (Optional) Company/Organization name
    # * reference (Optional, but encouraged) The unique identifier used within your own application for this customer
    # 
    def create_customer(info={})
      response = Hashie::Mash.new(self.class.post("/customers.json", :body => {:customer => info}.to_json))
      return response.customer if response.customer
      response
    end
    
    #
    # * first_name (Required)
    # * last_name (Required)
    # * email (Required)
    # * organization (Optional) Company/Organization name
    # * reference (Optional, but encouraged) The unique identifier used within your own application for this customer
    # 
    def update_customer(info={})
      info.stringify_keys!
      chargify_id = info.delete('id')
      response = Hashie::Mash.new(self.class.put("/customers/#{chargify_id}.json", :body => {:customer => info}))
      return response.customer unless response.customer.to_a.empty?
      response
    end
    
    def customer_subscriptions(chargify_id)
      subscriptions = self.class.get("/customers/#{chargify_id}/subscriptions.json")
      subscriptions.map{|s| Hashie::Mash.new s['subscription']}
    end
    
    def subscription(subscription_id)
      raw_response = self.class.get("/subscriptions/#{subscription_id}.json")
      return nil if raw_response.code != 200
      Hashie::Mash.new(raw_response).subscription
    end
    
    # Returns all elements outputted by Chargify plus:
    # response.success? -> true if response code is 201, false otherwise
    def create_subscription(subscription_attributes={})
      raw_response = self.class.post("/subscriptions.json", :body => {:subscription => subscription_attributes}.to_json)
      created  = true if raw_response.code == 201
      response = Hashie::Mash.new(raw_response)
      (response.subscription || response).update(:success? => created)
    end

    # Returns all elements outputted by Chargify plus:
    # response.success? -> true if response code is 200, false otherwise
    def update_subscription(sub_id, subscription_attributes = {})
      raw_response = self.class.put("/subscriptions/#{sub_id}.json", :body => {:subscription => subscription_attributes}.to_json)
      updated      = true if raw_response.code == 200
      response     = Hashie::Mash.new(raw_response)
      (response.subscription || response).update(:success? => updated)
    end

    # Returns all elements outputted by Chargify plus:
    # response.success? -> true if response code is 200, false otherwise
    def cancel_subscription(sub_id, message="")
      raw_response = self.class.delete("/subscriptions/#{sub_id}.json", :body => {:subscription => {:cancellation_message => message} }.to_json)
      deleted      = true if raw_response.code == 200
      response     = Hashie::Mash.new(raw_response)
      (response.subscription || response).update(:success? => deleted)
    end

    def charge_subscription(sub_id, subscription_attributes={})
      raw_response = self.class.post("/subscriptions/#{sub_id}/charges.json", :body => { :charge => subscription_attributes })
      success      = raw_response.code == 201
      if raw_response.code == 404
        raw_response = {}
      end

      response = Hashie::Mash.new(raw_response)
      (response.charge || response).update(:success? => success)
    end

    def list_products
      products = self.class.get("/products.json")
      products.map{|p| Hashie::Mash.new p['product']}
    end
    
    def product(product_id)
      Hashie::Mash.new( self.class.get("/products/#{product_id}.json")).product
    end
    
    def product_by_handle(handle)
      Hashie::Mash.new(self.class.get("/products/handle/#{handle}.json")).product
    end
    
  end
end
