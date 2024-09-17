require "rails_helper"

shared_examples "a not found Order" do
  it "redirects to the confirming orders path" do
    expect(response).to redirect_to(root_path)
  end

  it "sets a flash alert message" do
    expect(flash[:warning]).to eq I18n.t("orders.not_found")  
  end
end

RSpec.describe Admin::OrdersController, type: :controller do
  let!(:order) { create(:order, status: :confirming) }
  let(:admin) { create(:user, role: 0) }
  let(:mock_pagy) { instance_double("Pagy") }

  before do
    sign_in admin
  end

  describe "GET #index" do
    before do
      allow(controller).to receive(:pagy).and_return([mock_pagy, Order.all])
      get :index
    end

    it "renders the index template" do
      expect(response).to render_template(:index)
    end

    it "assigns @orders to the list of orders" do
      expect(assigns(:orders)).to eq(Order.all)
    end

    it "assigns @pagy" do
      expect(assigns(:pagy)).to eq(mock_pagy)
    end
  end

  describe "PUT #update" do
    context "when order is confirming and accept action is called" do
      before { patch :update, params: { id: order.id, type: "accept" } }

      it "processes the order items and updates the order status to succeeded" do
        order.reload
        expect(order.succeeded?).to be_truthy
      end

      it "sets a flash success message" do
        expect(flash[:notice]).to eq(I18n.t("orders.acept_notice"))
      end

      it "redirects to the succeeded orders path" do
        expect(response).to redirect_to(admin_order_path(status: :succeeded))
      end
    end

    context "when order is confirming and cancel action is called" do
      before { patch :update, params: { id: order.id, type: "cancel" } }

      it "processes the order items and updates the order status to failed" do
        order.reload
        expect(order.failed?).to be_truthy
      end

      it "sets a flash success message" do
        expect(flash[:notice]).to eq(I18n.t("orders.destroy_notice"))
      end

      it "redirects to the failed orders path" do
        expect(response).to redirect_to(admin_order_path(status: :failed))
      end
    end

    context "when the order does not exist" do
      before { patch :update, params: { id: 999, type: "accept" } }

      it_behaves_like "a not found Order"
    end

    context "when the order update fails" do
      before do
        allow_any_instance_of(Order).to receive(:succeeded!).and_raise(ActiveRecord::RecordInvalid)
        patch :update, params: { id: order.id, type: "accept" }
      end

      it "does not update the order" do
        order.reload
        expect(order.confirming?).to be_truthy
      end

      it "sets a flash alert message" do
        expect(flash[:alert]).to eq(I18n.t("orders.cannot_accept_notice"))
      end

      it "redirects to the confirming orders path" do
        expect(response).to redirect_to(admin_order_path(status: :confirming))
      end
    end
  end
end
