task reset_all: :environment do

  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['db:migrate'].invoke


  article = Article.create!(name: 'Article 1', body: 'This is the body', published: true)
  article.comments.create!(name: 'What a comment')
  article.comments.create!(name: 'What a comment2')
  article.comments.create!(name: 'What good job')

  article = Article.create!(name: 'Article 2', body: 'This is  body', published: false)
  article.comments.create!(name: 'What  job')

  article = Article.create!(name: 'Article 3', body: 'This the body', published: false)
  article.comments.create!(name: 'What gosdfsfod job')
  article.comments.create!(name: 'Wsdfsdfhat good job')

  article = Article.create!(name: 'Article 4', body: 'is the bodyasdsads', published: true)
  article.comments.create!(name: 'What good job')
  article.comments.create!(name: 'Whatsdfsdf good job')
  article.comments.create!(name: 'What good josdfsdfb')

end
