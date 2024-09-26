# config/initializers/elasticsearch.rb
Elasticsearch::Model.client = Elasticsearch::Client.new(
  url: 'http://elasticsearch:9200',
  log: true,
  user: 'elastic',
  password: '123456'
)
