require 'judge'

class FileController < ApplicationController
  before_action :authenticate_request!

  def create_submit
    return head :unauthorized unless @current_user
    return head :forbidden unless User.can_submit_to?(@current_user['id'], params[:id])

    submit = Submit.create!(contest_problem_id: params[:id],
                            author_id: @current_user['id'],
                            status: :que, submit_files: uploaded_files)
    Judge.create_task(submit)
  end

  private

  def uploaded_files
    params.select { |i, _| i.to_s.start_with? 'file' }.values.map { |f| SubmitFile.new file: f }
  end
end
