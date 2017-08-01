class ApiBaseController < ActionController::API

  def ids
    render json: api.ids
  end

  def index
    ids = params[:ids]
    attributes = params[:attributes]
    render json: api.need_a_name(ids: ids, attributes: attributes)
  end

  private

  def api
    ArticlesApi.new
  end

end
