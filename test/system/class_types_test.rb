require "application_system_test_case"

class ClassTypesTest < ApplicationSystemTestCase
  setup do
    @class_type = class_types(:one)
  end

  test "visiting the index" do
    visit class_types_url
    assert_selector "h1", text: "Class types"
  end

  test "should create class type" do
    visit class_types_url
    click_on "New class type"

    fill_in "Description", with: @class_type.description
    check "Is archived" if @class_type.is_archived
    fill_in "Name", with: @class_type.name
    click_on "Create Class type"

    assert_text "Class type was successfully created"
    click_on "Back"
  end

  test "should update Class type" do
    visit class_type_url(@class_type)
    click_on "Edit this class type", match: :first

    fill_in "Description", with: @class_type.description
    check "Is archived" if @class_type.is_archived
    fill_in "Name", with: @class_type.name
    click_on "Update Class type"

    assert_text "Class type was successfully updated"
    click_on "Back"
  end

  test "should destroy Class type" do
    visit class_type_url(@class_type)
    click_on "Destroy this class type", match: :first

    assert_text "Class type was successfully destroyed"
  end
end
