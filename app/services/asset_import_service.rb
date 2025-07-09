class AssetImportService
  SUCCESS_MESSAGE = 'Assets imported successfully'.freeze

  def self.import(asset_params_array, user)
    assets = asset_params_array.map do |a|
      user.assets.build(a.permit(:title, :description, :file_url, :price))
    end

    if assets.all?(&:valid?)
      assets.each(&:save!)
      {
        success: true,
        message: SUCCESS_MESSAGE,
        count: assets.size
      }
    else
      errors = assets.map(&:errors).map(&:full_messages).flatten.uniq
      {
        success: false,
        errors: errors
      }
    end
  end
end
