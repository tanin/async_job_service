class RunJobsController < ApplicationController
  include Rack::Utils
  include Commands::Execute

  # not the best place
  # should be POST :create
  def show
    uid = Digest::MD5.hexdigest(job_params[:id])

    cmd = Commands::RunJob.new(
      uid: uid,
      queue_name: job_params[:queue_name],
      state: job_params[:state],
      data: data&.merge(id: job_params[:id]).deep_symbolize_keys
    )

    execute(cmd)

    render json: { uid: uid, message: 'Job enqueued successfully' }, status: 204
  end

  protected

  def job_params
    params.permit(:queue_name, :id, :state)
  end

  def data
    parse_nested_query(request.query_string)
  end
end
