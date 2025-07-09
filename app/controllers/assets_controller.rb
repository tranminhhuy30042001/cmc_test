class AssetsController < ApplicationController

  ASSETS_IMPORTED_SUCCESSFULLY = 'Assets imported successfully'.freeze
  def index
    assets = Asset.all
    render json: assets, status: :ok
  end

  def catalog_import
    assets = params[:assets].map do |a|
      @current_user.assets.build(a.permit(:title, :description, :file_url, :price))
    end

    if assets.all?(&:valid?)
      assets.each(&:save!)
      render json: { message: ASSETS_IMPORTED_SUCCESSFULLY, count: assets.size }, status: :created
    else
      errors = assets.map(&:errors).map(&:full_messages).flatten.uniq
      render json: { error: errors }, status: :unprocessable_entity
    end
  end
end
