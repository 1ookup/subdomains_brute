require "ipaddr"
require "resolv"
require "ruby-progressbar"

require "subdomains_brute/version"
require "subdomains_brute/config"
require "subdomains_brute/brute"

module SubdomainsBrute
  # Your code goes here...
  def self.hello
  	print_hello
  end
end



=begin
require "resolv"

Resolv::DNS.new(:nameserver => ['210.251.121.21'],
                :search => ['ruby-lang.org'],
                :ndots => 1)



需要解决问题
##一个域名对应多个IP.
```ruby
Resolv.getaddresses("www.ruby-lang.org")   # return array
```

##解决多dns
```ruby
	Resolv::DNS.new(:nameserver => ['210.251.121.21']).getaddresses("www.ruby-lang.org")

	resolv_ipv4 = Resolv::DNS.new(:nameserver => ['210.251.121.21']).getaddresses("www.ruby-lang.org").resolv_ipv4.address.unpack('CCCC')
```

Resolv::DNS.new.each_address("oreilly.com") { |addr| puts addr }

dns = Resolv::DNS.new domain = "oreilly.com" dns.each_resource(domain, Resolv::DNS::Resource::IN::MX) do |mail_server| puts mail_server.exchange end # smtp1.oreilly.com # smtp2.oreilly.com 
dns.each_resource(domain, Resolv::DNS::Resource::IN::NS) do |nameserver| 
	puts nameserver.ip
end # a.auth-ns.sonic.net ...



=end