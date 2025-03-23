require "test_helper"

class CoursesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    assert_difference("Course.count") do
      post courses_url, params: { course: { classroom_id: @course.classroom_id, end_time: @course.end_time, is_archived: @course.is_archived, module_id: @course.module_id, quarter_id: @course.quarter_id, start_time: @course.start_time, teacher_id: @course.teacher_id, weekday: @course.weekday } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { classroom_id: @course.classroom_id, end_time: @course.end_time, is_archived: @course.is_archived, module_id: @course.module_id, quarter_id: @course.quarter_id, start_time: @course.start_time, teacher_id: @course.teacher_id, weekday: @course.weekday } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference("Course.count", -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end
end
