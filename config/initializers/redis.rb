# $redis = Redis.new(:host => 'uri.host', :port => uri.port, :password => uri.password)
# if ENV["REDISCLOUD_URL"]
uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/" )
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
# else
# $redis = Redis.new(:host => 'localhost', :port => 6379)
#
# end