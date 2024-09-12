require "rails_helper"
RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  describe "Associations" do
    it "belongs to a user" do
      expect(subject).to belong_to(:user)
    end

    it "belongs to a payment method" do
      expect(subject).to belong_to(:payment_method)
    end

    it "belongs to an address" do
      expect(subject).to belong_to(:address)
    end

    it "has many order items and destroys them when the order is destroyed" do
      expect(subject).to have_many(:order_items).dependent(:destroy)
    end
  end

  describe "nested attributes" do
    it "accepts nested attributes for order_items" do
      expect(subject).to accept_nested_attributes_for(:order_items)
    end
  
    it "accepts nested attributes for address" do
      expect(subject).to accept_nested_attributes_for(:address)
    end
  
    it "accepts nested attributes for payment_method" do
      expect(subject).to accept_nested_attributes_for(:payment_method)
    end
  end
  

  describe "enums"  do
    it "defines enum for status with the correct values" do
      expect(subject).to define_enum_for(:status).with_values(
        failed: 0,
        succeeded: 1,
        confirming: 2,
        rejected: 3
      )
    end
  end

  describe "monetize" do
    it "monetizes total_invoice_cents with the correct model currency" do
      expect(subject).to monetize(:total_invoice_cents).with_model_currency(:total_invoice_currency)
    end
  end

  describe ".with_status" do
    let(:payment_method) { create(:payment_method) }
    let(:address) { create(:address, user: user) }
    let(:order1) { create :order, user: user, status: :succeeded, created_at: Time.current}
    let(:order2) { create :order, user: user, status: :failed, created_at: Time.current}
    it "returns orders with the succeeded status" do
      expect(Order.with_status(:succeeded)).to include(order1)
    end
    
    it "returns orders with the failed status" do
      expect(Order.with_status(:failed)).to include(order2)
    end
  end

  describe ".for_user" do
    let(:order1) { create(:order, user: user, status: :succeeded, created_at: Time.current) }
    let(:order2) { create(:order, user: user, status: :failed, created_at: 1.month.ago) }
    it "returns orders for the given user" do
      expect(Order.for_user(user.id)).to include(order1, order2)
    end
  end

  describe ".payment_method_enum" do
    let(:payment_method1) { create(:payment_method, payment_method: :bank_transfer) }
    let(:payment_method2) { create(:payment_method, payment_method: :credit_card) }
    let(:payment_method3) { create(:payment_method, payment_method: :paypal) }
  
    let(:order1) { create(:order, user: user, payment_method: payment_method1, created_at: Time.current) }
    let(:order2) { create(:order, user: user, payment_method: payment_method2, created_at: Time.current.beginning_of_month + 1.day) }
    let(:order3) { create(:order, user: user, payment_method: payment_method3, created_at: Time.current.last_month.beginning_of_month + 1.day) }
 
    it "returns orders with the correct payment method for bank_transfer" do
      expect(Order.ransack(payment_method_enum_eq: payment_method1.id).result).to include(order1)
    end
  
    it "returns orders with the correct payment method for credit_card" do
      expect(Order.ransack(payment_method_enum_eq: payment_method2.id).result).to include(order2)
    end
  
    it "returns orders with the correct payment method for paypal" do
      expect(Order.ransack(payment_method_enum_eq: payment_method3.id).result).to include(order3)
    end
  
    it "does not include orders with payment method bank_transfer when filtering for paypal" do
      expect(Order.ransack(payment_method_enum_eq: payment_method3.id).result).not_to include(order1)
    end
  
    it "does not include orders with payment method credit_card when filtering for paypal" do
      expect(Order.ransack(payment_method_enum_eq: payment_method3.id).result).not_to include(order2)
    end
  end

  describe ".current_month" do
    let(:order1) { create(:order, user: user, status: :succeeded, created_at: Time.current) }
    let(:order2) { create(:order, user: user, status: :succeeded, created_at: 2.months.ago) }
    it "returns orders created in the current month" do
      expect(Order.current_month).to include(order1)
      expect(Order.current_month).not_to include(order2)
    end
  end

  describe ".previous_month" do
    let(:order2) { create(:order, user: user, status: :succeeded, created_at: Time.current.last_month) }
    let(:order1) { create(:order, user: user, status: :succeeded, created_at: Time.current) }

    it "returns orders created in the previous month" do
      expect(Order.previous_month).to include(order2)
      expect(Order.previous_month).not_to include(order1)
    end
  end


  describe ".ransacker" do
    it "creates a ransackable alias for search" do
      expect(Order.ransackable_attributes(nil)).to include("search")
    end
  end

  describe "class methods" do
    let(:succeeded_order1) { create(:order, status: :succeeded, total_invoice_cents: 10000, created_at: Time.current) }
    let(:succeeded_order2) { create(:order, status: :succeeded, total_invoice_cents: 5000, created_at: 1.month.ago) }

    describe ".revenue_percentage_change" do
      let(:succeeded_order1) { create(:order, user: user, status: :succeeded, total_invoice_cents: 10000, created_at: Time.current) }
      it "calculates the percentage change in revenue between current and previous month" do
        expect(Order.revenue_percentage_change).to eq(100.0)
      end
    end

    describe ".order_count_percentage_change" do
      let(:succeeded_order1) { create(:order, user: user, status: :succeeded, total_invoice_cents: 10000, created_at: Time.current) }
      it "calculates the percentage change in order count between current and previous month" do
        expect(Order.order_count_percentage_change).to eq(100.0)
      end
    end
  end
end
