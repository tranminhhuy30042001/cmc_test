# app/messages/order_messages.rb
module OrderMessages  
  SUCCESS = 'Order completed successfully'.freeze
  ERROR_ASSET_IDS_ARRAY = 'asset_ids must be a non-empty array'.freeze
  ERROR_ASSETS_NOT_FOUND = 'One or more assets not found'.freeze
  ERROR_ORDER_NOT_FOUND = 'Order not found'.freeze
  ERROR_PAYMENT_METHOD_REQUIRED = 'payment_method is required'.freeze
end
