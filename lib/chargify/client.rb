module Chargify
  class Client
    include HTTParty
    format :json
    
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
      Hashie::Mash.new(self.class.get("/customers/#{chargify_id}.json")).customer
    end
    
    #
    # * first_name (Required)
    # * last_name (Required)
    # * email (Required)
    # * organization (Optional) Company/Organization name
    # * reference (Optional, but encouraged) The unique identifier used within your own application for this customer
    # 
    def create_customer(info={})
      response = Hashie::Mash.new(self.class.post("/customers.json", :body => {:customer => info}))
      return response.customer unless response.customer.blank?
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
      return response.customer unless response.customer.blank?
      response
    end
    
    def customer_subscriptions(chargify_id)
      subscriptions = self.class.get("/customers/#{chargify_id}/subscriptions.json")
      subscriptions.map{|s| Hashie::Mash.new s['subscription']}
    end
    
    def subscription(subscription_id)
      Hashie::Mash.new(self.class.get("/subscriptions/#{subscription_id}.json")).subscription
    end
    
    # When creating a subscription, you must specify a product, a customer, and payment (credit card) details.
    # 
    # The product may be specified by product_id or by product_handle (API Handle).
    # 
    # An existing customer may be specified by a customer_id (ID within Chargify) or a customer_reference (unique value within your app that you have shared with Chargify via the reference attribute on a customer). A new customer may be created by providing customer_attributes.
    # 
    #     * product_handle The API Handle of the product for which you are creating a subscription. Required, unless a product_id is given instead.
    #     * product_id The Product ID of the product for which you are creating a subscription. The product ID is not currently published, so we recommend using the API Handle instead.
    #     * customer_id The ID of an existing customer within Chargify. Required, unless a customer_reference or a set of customer_attributes is given.
    #     * customer_reference The reference value (provided by your app) of an existing customer within Chargify. Required, unless a customer_id or a set of customer_attributes is given.
    #     * customer_attributes
    #           o first_name The first name of the customer. Required when creating a customer via attributes.
    #           o last_name The last name of the customer. Required when creating a customer via attributes.
    #           o email The email address of the customer. Required when creating a customer via attributes.
    #           o organization The organization/company of the customer. Optional.
    #           o reference A customer "reference", or unique identifier from your app, stored in Chargify. Can be used so that you may reference your customers within Chargify using the same unique value you use in your application. Optional.
    # 
    def create_subscription(options, customer_attributes={})
      options.merge({:customer_attributes => customer_attributes}) unless customer_attributes.blank?
      response = Hashie::Mash.new(self.class.post("/subscriptions.json", :body => options))
      return response.subscription unless response.subscription.blank?
      response
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