class OrderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :status, :reason, :payment_method_id, :address_id,
             :created_at, :updated_at, :total_invoice_cents,
             :total_invoice_currency
end
