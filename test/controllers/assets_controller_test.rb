require "test_helper"

class AssetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get assets_index_url
    assert_response :success
  end

  test "should get catalog_import" do
    get assets_catalog_import_url
    assert_response :success
  end
end
