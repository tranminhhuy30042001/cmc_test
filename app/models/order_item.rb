class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :asset
end
