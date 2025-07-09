class OrderFetcherService
  include OrdersQueryable

  def initialize(user)
    @user = user
  end

  def paid_orders_with_assets_json
    orders_with_status_json('paid')
  end
end