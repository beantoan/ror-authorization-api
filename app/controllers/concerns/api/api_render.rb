module Api::ApiRender
  extend ActiveSupport::Concern

  def render_success_json(data, msg)
    render json: { data: data, msg: msg }, status: :ok
  end

  def render_error_json(msg)
    render json: { msg: msg }, status: :unprocessable_entity
  end

  def render_access_denied_json(data, msg)
    render json: { data: data, msg: msg }, status: :forbidden
  end
end