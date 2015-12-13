module SubdomainsBrute
  # Your code goes here...

  # 获取预定的 nameserver
  def self.get_ns
  	ns = []
  	ns_file = File.expand_path('../../../vendor', __FILE__) + "/dns_servers.txt"
  	File.read(ns_file).split("\n").each do |line|
  		line.strip!
  		begin
  			ns << IPAddr.new(line).to_s
  		rescue 
  		end
  	end
  	ns
  end

  # 获取预定的 sub domains
  def self.get_subname
  	subnames = []
  	ns_file = File.expand_path('../../../vendor', __FILE__) + "/subnames.txt"
    puts ns_file
  	File.read(ns_file).split("\n").each do |line|
  		line.strip!
  		if not line.nil? or not line == ""
  			subnames << line
  		end
  	end
  	subnames
  end

  # 获取域名的 next_name
  def self.get_nextname
  	nextnames = []
  	ns_file = File.expand_path('../../../vendor', __FILE__) + "/next_sub.txt"
  	File.read(ns_file).split("\n").each do |line|
  		line.strip!
  		if not line.nil? or not line == ""
  			nextnames << line
  		end
  	end
  	nextnames
	end
end