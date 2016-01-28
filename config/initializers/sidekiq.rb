# check if the redis.yml file exists - if you are running your staging env as
# a solo instance without a redis utility instance, it won't
if File.exists?(Rails.root + 'config/redis.yml')
  # Load the redis.yml configuration file
  redis_config = YAML.load_file(Rails.root + 'config/redis.yml')[Rails.env]

  if redis_config
    Sidekiq.configure_server do |config|
      config.redis = {
         namespace: "spider:#{Rails.env}",
         url: "redis://#{redis_config['host']}:#{redis_config['port']}"
      }
    end
    Sidekiq.configure_client do |config|
      config.redis = {
         namespace: "spider:#{Rails.env}",
         url: "redis://#{redis_config['host']}:#{redis_config['port']}"
      }
    end
  end

else
  Sidekiq.configure_server do |config|
    config.redis = {namespace: "spider:#{Rails.env}"}
  end
  Sidekiq.configure_client do |config|
    config.redis = {namespace: "spider:#{Rails.env}"}
  end
end
