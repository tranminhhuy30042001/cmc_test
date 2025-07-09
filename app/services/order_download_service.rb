class OrderDownloadService
  class OrderNotFoundError < StandardError; end
 
  def initialize(user, order_id)
    @user = user
    @order_id = order_id
  end

  def generate_downloadable_json
    order = find_paid_order || raise(OrderNotFoundError, "Order not found or not paid")

    data = build_order_data(order)
    filename = "order_#{order.id}_assets.json"

    { success: true, filename: filename, data: JSON.pretty_generate(data) }
  end

  private

  def find_paid_order
    @user.orders
         .status_paid
         .includes(order_items: :asset)
         .find_by(id: @order_id)
  end

  def build_order_data(order)
    {
      order_id: order.id,
      total_price: order.total_price,
      assets: order.order_items.map { |item| build_asset_data(item) }
    }
  end

  def build_asset_data(item)
    asset = item.asset
    {
      id: asset.id,
      title: asset.title,
      description: asset.description,
      file_url: asset.file_url,
      price: item.price_at_purchase
    }
  end

  def error_response(message)
    { success: false, error: message }
  end
end
