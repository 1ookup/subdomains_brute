lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "subdomains_brute"
require "awesome_print"



domain = "nyist.edu.cn"
ns = ["114.114.114.114", "8.8.8.8"]
baidu = SubdomainsBrute::Brute.new(domain, {ns: ns, thread_num: 200})
baidu.run
2.upto(5) do |level|
	puts "#{level}级域名: " if baidu.ret[level].size > 0
	baidu.ret[level].each do |domain|
		puts "#{domain[:name]}\t----\t#{domain[:host]}"
	end
end


exit
domain = "ruby-lang.org"
#domain = "nyist.edu.cn"
b = SubdomainsBrute::Brute.new(domain, {ns: ["114.114.114.114"]})


b.run
puts b.get_domains_count
ap b.ret