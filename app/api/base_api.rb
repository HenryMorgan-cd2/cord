
class BaseApi

  class <<self

    @permitted_params = []
    @attributes = {}
    @collection_actions = {}
    @member_actions = {}

    def driver driver=nil
      return @driver if driver.nil?
      @driver ||= driver
    end

    def scopes
      @scopes ||= {}
    end

    def scope name, &block
      block ||= ->{ send(name) }
      scopes[name] = block
    end

    # has_many :books
    # book_ids, books, book_count
    def has_many association_name
      self.attribute association_name
      single = association_name.to_s.singularize
      self.attribute "#{single}_ids"
      self.attribute "#{single}_count" do |record|
        record.send(association_name).count
      end
    end

    # has_one :token
    # adds token
    def has_one association_name
      self.attribute association_name
    end

    def belongs_to association_name
      self.attribute association_name
    end

    def association association_name
      reflection = @driver.reflect_on_association association_name
      case reflection&.macro
      when :belongs_to
        self.belongs_to name
      when :has_one
        self.has_one name
      when :has_many
        self.has_many name
      else
        raise "Driver has no assocation named: #{association_name}"
      end
    end

    def attributes
      @attributes ||= HashWithIndifferentAccess.new
    end

    def attribute name, &block
      block ||= ->(record){ record.send(name) }
      attributes[name] = block
    end


    def permitted_params *args
      return @permitted_params || [] if args.empty?
      @permitted_params = args
    end


    def collection_actions
      @collection_actions ||= {}
    end

    def action name, &block
      collection_actions[name] = block
    end


    def member_actions
      @member_actions ||= {}
    end

    def action_for name, &block
      member_actions[name] = block
    end

  end



  def ids
    ids = {all_ids: driver.ids}
    scopes.each do |name, block|
      ids["#{name}_ids"] = model.instance_exec(&block).ids
    end
    ids
  end

  def need_a_name options={}
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

  def error msg
    throw new NotImplementedError
  end

  private

  def driver
    self.class.driver
  end

  def model
    driver.model
  end

  def scopes
    self.class.scopes
  end

  def attributes
    self.class.attributes
  end

  def attribute_names
    attributes.keys
  end

  def white_list_attributes(attrs)
    blacklist = attrs - attribute_names
    error("Unknown attributes: #{blacklist.join(', ')}") if blacklist.any?
    attrs
  end

end
