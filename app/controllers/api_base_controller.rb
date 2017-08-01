class ApiBaseController < ActionController::API

  def ids
    render json: api.ids
  end

  def index
    if action = params[:action_name]
      result = api.trigger(action, params)
    else
      ids = params[:ids]
      attributes = params[:attributes]
      result = api.get(ids: ids, attributes: attributes)
    end
    render json: result
  end

  private

  def api
    @api ||= "#{params[:api].camelize}Api".constantize.new
  end

end
