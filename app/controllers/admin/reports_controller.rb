class Admin::ReportsController < ApplicationController
  before_action :authorize_admin!

  def creators_earnings
    creators = User.where(role: 'customer')
                   .select(:id, :email)
                   .map do |creator|
      total_earnings = OrderItem.joins(order: :user)
                                .where(orders: { status: 'paid' })
                                .where(asset_id: creator.assets.select(:id))
                                .sum('order_items.price_at_purchase * order_items.quantity')

      {
        id: creator.id,
        email: creator.email,
        total_earnings: total_earnings.to_f
      }
    end

    render json: { creators: creators }, status: :ok
  end

  private

  def authorize_admin!
    unless @current_user&.role == 'admin'
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
