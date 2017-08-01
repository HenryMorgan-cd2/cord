module DSL
  def self.included(base)
    base.extend ClassMethods
  end

  def driver
    self.class.driver || raise('No api driver set')
  end

  def model
    return driver if driver <= ActiveRecord::Base
    driver.model
  end

  def scopes
    self.class.scopes
  end

  def attributes
    self.class.attributes
  end

  def member_actions
    self.class.member_actions
  end

  def collection_actions
    self.class.collection_actions
  end

  def attribute_names
    attributes.keys
  end

  module ClassMethods

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
      self.attribute "#{association_name}_id" do |record|
        record.send(association_name).id
      end
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
      @collection_actions ||= HashWithIndifferentAccess.new
    end

    def action name, &block
      collection_actions[name] = block
    end


    def member_actions
      @member_actions ||= HashWithIndifferentAccess.new
    end

    def action_for name, &block
      member_actions[name] = block
    end

  end
end
