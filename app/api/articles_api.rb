class ArticlesApi < BaseApi

  # optional | autoloads all assocations and scopes (maybe methods?)
	# api_for Article

	driver Article.published  # limit all results to a subset of the model

	scope :ordered   #Use a scope defined on the model
	scope :published { where(published: false) } # custom scope which isnt on the model, required as cant chain scopes

	has_many :comments # adds methods: for answers, answer_ids, answer_count
	belongs_to :author  # adds methods: author, author_id
	# has_one :page # adds methods: forum


	attribute :view_count # adds attribute called view_count which calls same named model method
	attribute :score do |article| # attribute with block, block is passed the current record
		article.id * 10
	end

  # mutations

  permitted_params :name, :body, :created_at #blobvious
  # before_create do |record| # callbacks
  # after_create
  # before_update
  # after_update
  # before_destroy
  # after_destroy

  ########## ACTIONS

  action :vote_up do # collection method
    driver.vote_up!
  end

  action_for :update_x do |question| # member method (all members our found by id)
    question.update(x: params[:x])
  end

  action :vote_down do
    error('cant vote down')    # returns error
    error_for(Question.first, 'cant vote down')    # returns error for a specific record
  end

end
