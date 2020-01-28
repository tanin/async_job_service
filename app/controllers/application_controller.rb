class ApplicationController < ActionController::API
  rescue_from ActionController::UnpermittedParameters do |error|
    message = "Invalid parameter: #{error.params.to_sentence}"
    message << 'Please verify that the parameter name is valid and the values are the correct type.'
    render json: { exception: error, message: message }, status: :bad_request
  end

  rescue_from Commands::ValidationError, NotImplementedError do |error|
    render json: { error: error.message }, status: :bad_request
  end

  rescue_from Domain::RunJob::JobAlreadyExists do |error|
    render json: { error: error.message }, status: :unprocessable_entity
  end
end
