module OrdersQueryable
  PAID_STATUS = 'paid'.freeze

  def orders_with_status_json(status = PAID_STATUS)
    @user.orders
         .where(status: status)
         .includes(order_items: :asset)
         .as_json(include: {
           order_items: {
             include: :asset,
             except: [:created_at, :updated_at]
           }
         })
  end

end
