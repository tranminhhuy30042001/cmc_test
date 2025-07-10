class AssetsController < ApplicationController
  include ErrorHandler

  def index
    assets = Asset.all
    render json: assets, status: :ok
  end

  def catalog_import
    asset_params_array = catalog_import_params
    result = AssetImportService.import(asset_params_array, @current_user)
  
    if result[:success]
      render json: { message: result[:message], count: result[:count] }, status: :created
    else
      render json: { error: result[:errors] }, status: :unprocessable_entity
    end
  end

  private

  def catalog_import_params
    raise ActionController::ParameterMissing, 'assets' unless params[:assets]  
    params.permit(assets: [:title, :description, :file_url, :price])[:assets]
  end
  
end
