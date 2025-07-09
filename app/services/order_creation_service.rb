class OrderCreationService
  include OrdersQueryable

  def initialize(user, asset_ids = nil, payment_method = nil)
    @user = user
    @asset_ids = asset_ids
    @payment_method = payment_method
  end

  def call
    return error_response(OrderMessages::ERROR_ASSET_IDS_ARRAY) unless valid_asset_ids?

    assets = Asset.where(id: @asset_ids)
    return error_response(OrderMessages::ERROR_ASSETS_NOT_FOUND) if assets.size != @asset_ids.size

    order = nil

    ActiveRecord::Base.transaction do
      order = create_order!(assets)
      create_order_items!(order, assets)
      order.status_paid!
    end

    { success: true, order: order }

  rescue ActiveRecord::RecordInvalid => e
    error_response(e.record.errors.full_messages)
  rescue StandardError => e
    error_response("Unexpected error: #{e.message}")
  end

  private

  def valid_asset_ids?
    @asset_ids.is_a?(Array) && @asset_ids.any?
  end

  def create_order!(assets)
    @user.orders.create!(
      total_price: assets.sum(&:price),
      status: :pending,
      payment_method: @payment_method,
      payment_info: {}
    )
  end

  def create_order_items!(order, assets)
    assets.each do |asset|
      order.order_items.create!(
        asset: asset,
        price_at_purchase: asset.price,
        quantity: 1
      )
    end
  end

  def error_response(message)
    { success: false, error: message }
  end
end
