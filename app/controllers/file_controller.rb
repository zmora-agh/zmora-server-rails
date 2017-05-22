class FileController < ApplicationController
  before_action :authenticate_request!

  def create_submit
    return head :forbidden unless @current_user
    return head :unauthorized unless User.can_submit_to?(@current_user['id'], params[:id])

    Submit.create!(contest_problem_id: params[:id],
                   author_id: @current_user['id'],
                   status: :que, submit_files: uploaded_files)
  end

  private

  def uploaded_files
    params.select { |i, _| i.to_s.start_with? 'file' }.values.map { |f| SubmitFile.new file: f }
  end
end
