require_relative 'dsl'
class BaseApi
  include DSL

  def ids
    ids = {all_ids: driver.ids}
    scopes.each do |name, block|
      ids["#{name}_ids"] = model.instance_exec(&block).ids
    end
    ids
  end

  def get options={}
    records = driver.all
    records = records.where(id: options[:ids]) if (options[:ids].present?)

    if (options[:attributes].present?)
      allowed_attributes = white_list_attributes(options[:attributes])
      records_json = []
      records.each do |record|
        record_json = record.as_json
        allowed_attributes.each do |attr_name|
          record_json[attr_name] = attributes[attr_name].call(record)
        end
        records_json.append(record_json)
      end
    else
      records_json = records.as_json
    end

    return {model.table_name => records_json}
  end

  def trigger action_name, params
    if ids = params[:ids]
      action = member_actions[action_name]
      driver.where(id: ids).find_each do |record|
        instance_exec(record, &action)
      end
    else
      action = collection_actions[action_name]
      action.call()
    end
  end

  def error msg
    throw new NotImplementedError
  end

  private

  def white_list_attributes(attrs)
    blacklist = attrs - attribute_names
    error("Unknown attributes: #{blacklist.join(', ')}") if blacklist.any?
    attrs
  end

end
