lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "subdomains_brute"
require "awesome_print"


domain = "ruby-lang.org"
#domain = "nyist.edu.cn"
b = SubdomainsBrute::Brute.new(domain, {ns: ["114.114.114.114"]})


b.run
puts b.get_domains_count
ap b.ret