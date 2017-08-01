class Forum::QuestionsApi < BaseApi

  driver ::Comment

  scope :top { where('id < 10') }

end
