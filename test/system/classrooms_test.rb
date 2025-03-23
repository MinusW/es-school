require "application_system_test_case"

class ClassroomsTest < ApplicationSystemTestCase
  setup do
    @classroom = classrooms(:one)
  end

  test "visiting the index" do
    visit classrooms_url
    assert_selector "h1", text: "Classrooms"
  end

  test "should create classroom" do
    visit classrooms_url
    click_on "New classroom"

    fill_in "Class type", with: @classroom.class_type_id
    check "Is archived" if @classroom.is_archived
    fill_in "Name", with: @classroom.name
    fill_in "Room", with: @classroom.room_id
    fill_in "Teacher", with: @classroom.teacher_id
    click_on "Create Classroom"

    assert_text "Classroom was successfully created"
    click_on "Back"
  end

  test "should update Classroom" do
    visit classroom_url(@classroom)
    click_on "Edit this classroom", match: :first

    fill_in "Class type", with: @classroom.class_type_id
    check "Is archived" if @classroom.is_archived
    fill_in "Name", with: @classroom.name
    fill_in "Room", with: @classroom.room_id
    fill_in "Teacher", with: @classroom.teacher_id
    click_on "Update Classroom"

    assert_text "Classroom was successfully updated"
    click_on "Back"
  end

  test "should destroy Classroom" do
    visit classroom_url(@classroom)
    click_on "Destroy this classroom", match: :first

    assert_text "Classroom was successfully destroyed"
  end
end
