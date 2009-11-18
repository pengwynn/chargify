require 'helper'

class TestChargify < Test::Unit::TestCase
  context "When hitting the Chargify API" do
    setup do
      @client = Chargify::Client.new('OU812', 'pengwynn')
    end
    
    should "return a list of customers" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers.json", "customers.json"
      customers = @client.list_customers
      customers.size.should == 1
      customers.first.reference.should == 'bradleyjoyce'
      customers.first.organization.should == 'Squeejee'
    end
    
    
    should "return info for a customer" do
      stub_get "https://OU812:x@pengwynn.chargify.com/customers/16.json", "customer.json"
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
    
    should "create a customer subscription" do
      stub_post "https://OU812:x@pengwynn.chargify.com/subscriptions.json", "subscription.json"
      options = {
        :product_handle     => 'monthly',
        :customer_reference => 'bradleyjoyce'
      }
      customer_attributes = {
        :first_name   => "Wynn",
        :last_name    => "Netherland",
        :email        => "wynn@example.com"
      }
      subscription = @client.create_subscription(options, customer_attributes)
      subscription.customer.organization.should == 'Squeejee'
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