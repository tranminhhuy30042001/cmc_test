module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_unprocessable_entity
    rescue_from StandardError, with: :handle_internal_error
    rescue_from OrderDownloadService::OrderNotFoundError, with: :handle_not_found
  end

  private

  def handle_not_found(e)
    render json: { error: e.message }, status: :not_found
  end

  def handle_unprocessable_entity(exception)
    message = if exception.respond_to?(:record) && exception.record.present?
                exception.record.errors.full_messages.join(", ")
              else
                exception.message
              end

    render_error(message, :unprocessable_entity)
  end

  def handle_internal_error(exception)
    Rails.logger.error("[#{self.class.name}] Unexpected error: #{exception.message}")

    render_error("Internal server error. Please try again later", :internal_server_error)
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
