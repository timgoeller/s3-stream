require 'active_record'
require_relative './models/user'
require_relative './postgres_csv_exporter'
require 'aws-sdk-s3'

def db_configuration
  db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
  YAML.load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration["development"])

s3_client = Aws::S3::Client.new(
  endpoint: 'http://localhost:9000',
  force_path_style: true,
  region: 'us-east-1',
  access_key_id: 'minioadmin',
  secret_access_key: 'minioadmin',
  
)

p s3_client.put_object(
  bucket: 's3-export',
  key: 'result.csv',
  metadata: { author: 'test'},
  body: 'sdsdsdfsdf',
)

bucket = 's3-export'

csv_object = Aws::S3::Object.new(bucket, 'result.csv', client: s3_client)

csv_object.upload_stream do |upload_stream|
  upload_stream.binmode

  PostgresCSVExporter.new('(SELECT * FROM users)').each do |row|
    upload_stream.write row
  end
end


