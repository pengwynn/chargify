require 'helper'

class TestChargify < Test::Unit::TestCase
  context "When hitting the Chargify API" do
    setup do
      @client = Chargify::Client.new('OU812', 'pengwynn')
    end

    should "raise UnexpectedResponseError when reponse is invalid JSON" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "invalid_subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      assert_raise Chargify::UnexpectedResponseError do
        @client.create_subscription(options)
      end
    end
    
    should "return a list of customers" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers.json", "customers.json"
      customers = @client.list_customers
      customers.size.should == 1
      customers.first.reference.should == 'bradleyjoyce'
      customers.first.organization.should == 'Squeejee'
    end
    
    
    should "return info for a customer" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/lookup.json?reference=16", "customer.json"
      customer = @client.customer(16)
      customer.reference.should == 'bradleyjoyce'
      customer.organization.should == 'Squeejee'
    end
    
    should "create a new customer" do
      stub_post "https://OU812:x@pengwynn.chargify.com/customers.json", "new_customer.json"
      info = {
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com"
      }
      customer = @client.create_customer(info)
      customer.first_name.should == "Wynn"
    end
    
    should "update a customer" do
      stub_put "https://OU812:x@pengwynn.chargify.com/customers/16.json", "new_customer.json"
      info = {
        :id           => 16,
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com"
      }
      customer = @client.update_customer(info)
      customer.first_name.should == "Wynn"
    end
    
    should_eventually "raise an exception if a customer is not found" do
      
    end
    
    should_eventually "delete a customer" do
      
    end

    should "return a list of customer subscriptions" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/16/subscriptions.json", "subscriptions.json"
      subscriptions = @client.customer_subscriptions(16)
      subscriptions.size.should == 1
      subscriptions.first.customer.reference.should == "bradleyjoyce"
    end
    
    
    should "return info for a subscription" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/13.json", "subscription.json"
      subscription = @client.subscription(13)
      subscription.customer.reference.should == 'bradleyjoyce'
    end

    should "return nil if a subscription is not found" do
      stub_get "https://OU812:x@pengwynn.chargify.com/subscriptions/18.json", "subscription_not_found.json", 404
      subscription = @client.subscription(18)
      subscription.should == nil
    end
    
    should "update a customer subscription" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = @client.update_subscription(123, options)
      subscription.customer.organization.should == 'Squeejee'
    end

    should "set success? to true when subscription is updated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "subscription.json", 200
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = @client.update_subscription(123, options)
      subscription.success?.should == true
    end

    should "set success? to false when subscription is not updated successfully" do
      stub_put "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "subscription.json", 500
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = @client.update_subscription(123, options)
      subscription.success?.should == nil
    end
    
    should "create a customer subscription" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = @client.create_subscription(options)
      subscription.customer.organization.should == 'Squeejee'
    end

    should "set success? to true when subscription is created successfully" do 
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json", 201
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = @client.create_subscription(options)
      subscription.success?.should == true
    end

    should "set success? to nil when subscription is not created successfully" do 
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json", 400
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce',
        :customer_attributes => {
          :first_name   => "Wynn",
          :last_name    => "Netherland",
          :email        => "wynn@example.com"
        }
      }
      subscription = @client.create_subscription(options)
      subscription.success?.should == nil
    end

    should "cancel subscription" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 200
      subscription = @client.cancel_subscription(123)

      subscription.state.should == "canceled"
    end

    should "set success? to nil when subscription is not cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 500
      subscription = @client.cancel_subscription(123)

      subscription.success?.should == nil
    end

    should "set success? to true when subscription is cancelled successfully" do
      stub_delete "https://OU812:x@pengwynn.chargify.com/subscriptions/123.json", "deleted_subscription.json", 200
      subscription = @client.cancel_subscription(123)

      subscription.success?.should == true
    end
    
    should_eventually "create a one-off charge for a subscription" do
      
    end
    
    should_eventually "list metered usage for a subscription" do
      
    end
    
    should_eventually "record metered usage for a subscription" do
      
    end
    
    should_eventually "migrate a subscription to a new product" do
      
    end
    
    should_eventually "create one-time coupons" do
      
    end
    
    should "return a list of products" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products.json", "products.json"
      products = @client.list_products
      products.first.accounting_code.should == 'TSMO'
    end
    
    should "return info for a product" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products/8.json", "product.json"
      product = @client.product(8)
      product.accounting_code.should == 'TSMO'
    end
    
    should "return info for a product by its handle" do
      stub_get "https://OU812:x@pengwynn.chargify.com/products/handle/tweetsaver.json", "product.json"
      product = @client.product_by_handle('tweetsaver')
      product.accounting_code.should == 'TSMO'
    end

    
  end
end
