require "prawn"
require "prawn/table"

class GradePdfGenerator
  def initialize(student)
    @student = student
  end

  def generate
    Prawn::Document.new do |pdf|
      # Header
      pdf.text "ES School", size: 20, style: :bold, align: :center
      pdf.move_down 10
      pdf.text "Grade Report", size: 16, align: :center
      pdf.move_down 20

      # Student Information
      pdf.text "Student Information", size: 14, style: :bold
      pdf.move_down 5
      pdf.text "Name: #{@student.user.full_name}"
      pdf.text "Email: #{@student.user.email}"
      pdf.text "Class: #{@student.classroom.name}"
      pdf.move_down 20

      # Grades by Subject
      @student.grades.not_archived.includes(:course).group_by { |g| g.course.theme }.each do |theme, grades|
        pdf.text theme.module_name, size: 14, style: :bold
        pdf.move_down 5

        # Create table for grades
        data = [ [ "Date", "Grade", "Teacher" ] ]
        grades.sort_by(&:grading_date).reverse.each do |grade|
          data << [
            grade.grading_date.strftime("%b %d, %Y"),
            grade.grade.to_s,
            grade.teacher.user.full_name
          ]
        end

        # Add average row
        avg = grades.sum(&:grade) / grades.size
        data << [ "Average", avg.round(1).to_s, "" ]

        pdf.table(data, header: true) do |t|
          t.row(0).style(background_color: "CCCCCC", text_color: "000000", font_style: :bold)
          t.cells.style(padding: 5)
          t.cells.style(borders: [ :bottom, :left, :right, :top ])
          t.column_widths = [ 100, 60, 150 ]
        end
        pdf.move_down 20
      end

      # Overall Summary
      pdf.text "Overall Summary", size: 14, style: :bold
      pdf.move_down 5
      all_grades = @student.grades.not_archived
      overall_average = all_grades.any? ? (all_grades.sum(&:grade) / all_grades.size).round(1) : "N/A"
      pdf.text "Total Grades: #{all_grades.count}"
      pdf.text "Overall Average: #{overall_average}"
      pdf.text "Number of Subjects: #{@student.grades.not_archived.includes(:course).map { |g| g.course.theme }.uniq.count}"

      # Footer
      pdf.move_down 30
      pdf.text "Generated on: #{Time.current.strftime("%B %d, %Y %H:%M")}", size: 10, align: :center
    end
  end
end
