class Order < ApplicationRecord
  belongs_to :user

  has_many :order_items, dependent: :destroy
  has_many :assets, through: :order_items

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_method, presence: true

  enum :status, {
    pending: 'pending',
    paid: 'paid',
    completed: 'completed',
    canceled: 'canceled'
  }, prefix: true
end
