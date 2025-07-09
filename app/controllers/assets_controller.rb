class AssetsController < ApplicationController
  include ErrorHandler

  def index
    assets = Asset.all
    render json: assets, status: :ok
  end

  def catalog_import
    result = AssetImportService.import(params[:assets], @current_user)

    if result[:success]
      render json: { message: result[:message], count: result[:count] }, status: :created
    else
      render json: { error: result[:errors] }, status: :unprocessable_entity
    end
  end
end
