CarrierWave.configure do |config|
  config.fog_directory = ENV['AWS_BUCKET']
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.s3_access_policy = :public_read

  config.fog_credentials = {
    :provider =>              'AWS',
    :aws_access_key_id =>     ENV['AWS_ACCESS_KEY'],
    :aws_secret_access_key => ENV['AWS_SECRET_KEY'],
    :region =>                ENV['AWS_REGION']
  }
end
