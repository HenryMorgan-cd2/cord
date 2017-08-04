class ApiBaseController < ActionController::API

  def schema
    render json: {
      table_name: api.model.table_name,
      model_name: api.model.name,
      columns: api.model.column_names,
      attributes: api.attribute_names,
      scopes: api.scopes.keys,
      actions: {
        member: api.member_actions.keys,
        collection: api.collection_actions.keys,
      },
    }
  end

  def ids
    render json: api.ids
  end

  def index
    ids = params[:ids]
    attributes = params[:attributes]
    result = api.get(ids: ids, attributes: attributes)
    render json: result
  end

  def perform
    result = api.perform(params[:action_name])
    render json: result
  end

  private

  def api
    @api ||= "#{params[:api].camelize}Api".constantize.new params
  end

end

# /api/articles/ids
# /api/articles/perform/:action_name


# {
#   ids: {
#     all: [1,2,3,4],
#     published: [2,3,4],
#     complete: [2,3,4],
#   }
#   records: [{id: 1, name: 'asda', body: 'asd'}...]
#   response: {
#     status: :success # :redirect, :error
#     redirect: '/redirect_to_address'
#     flash: [
#       {type: :success, message: 'This is my flash message!'},
#       {type: :error, message: 'This is my flash message!'},
#       {type: :info, message: 'This is my flash message!'},
#     ]
#     error: 'there was an error'
#     record_errors: [{id: 1, errors: {name: 'is invalid', body: 'is required'}}]
#     nullify: :all # [1,2,3,4,5]
# }
