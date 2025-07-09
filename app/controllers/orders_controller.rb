class OrdersController < ApplicationController
  include ErrorHandler

  before_action :validate_create_params, only: [:create]

  def index
    orders_json = OrderFetcherService.new(@current_user).paid_orders_with_assets_json
    render json: orders_json, status: :ok
  end

  def create
    result = OrderCreationService.new(
      @current_user,
      order_params[:asset_ids],
      order_params[:payment_method]
    ).call

    if result[:success]
      render json: {
        message: OrderMessages::SUCCESS,
        order_id: result[:order].id
      }, status: :created
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def download
    result = OrderDownloadService.new(@current_user, params[:id]).generate_downloadable_json

    if result[:success]
      send_data result[:data],
                type: 'application/json; header=present',
                disposition: "attachment; filename=#{result[:filename]}"
    else
      render json: { error: result[:error] }, status: :not_found
    end
  end

  def show
    order = @current_user.orders
                         .includes(order_items: :asset)
                         .find(params[:id])

    render json: order.as_json(include: {
      order_items: {
        include: :asset,
        except: [:created_at, :updated_at]
      }
    }), status: :ok
  end

  private

  def order_params
    params.permit(:payment_method, asset_ids: [])
  end

  def validate_create_params
    unless order_params[:asset_ids].is_a?(Array) && order_params[:asset_ids].any?
      render json: { error: OrderMessages::ERROR_ASSET_IDS_ARRAY }, status: :bad_request and return
    end

    unless order_params[:payment_method].present?
      render json: { error: OrderMessages::ERROR_PAYMENT_METHOD_REQUIRED }, status: :bad_request and return
    end
  end
end
