require 'net/http'

uri = URI 'https://graph.facebook.com/me'

Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
  req = Net::HTTP::Get.new uri
  puts http.request(req).body
end
