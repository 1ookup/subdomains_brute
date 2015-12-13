module SubdomainsBrute
  class Brute
  	# root_domain 根域名
  	# option
  	# => :thread_name
  	# => 
  	attr_accessor :root_domain, :option, :max_level, :ret
  	def initialize(root_domain, option = {})
  		@root_domain = root_domain
  		@option = option
  		@option[:thread_num] ||= 200
  		@option[:sub_names] ||= SubdomainsBrute::get_subname
  		@option[:next_names] ||= SubdomainsBrute::get_nextname
  		@option[:ns] ||= get_root_domain_ns
  		@max_level = 5					#最大爆破域名级别
  		@init_level = 2
  		@current_level = 2			#当前爆破域名级别
  		@ret = {}
  		@ret[1] = []
  		get_root_domain_ip
  		@progressbar = nil
  	end

  	def get_root_domain_ns
  		ns = []
  		dns = Resolv::DNS.new
  		domain = @root_domain
  		dns.each_resource(domain, Resolv::DNS::Resource::IN::NS) do |nameserver| 
				ns += get_ip_by_name(nameserver.name)
			end
			ns.uniq!
			if ns.empty?
				ns += SubdomainsBrute::get_ns
			end
			ns
  	end

  	def get_root_domain_ip
  		get_ip_by_name(@root_domain).each do |ip|
  			@ret[1] << {name: @root_domain, host: ip}
  		end
  		@ret[1] << {name: @root_domain, host: "unknown host"} if @ret[1].empty?			
  	end


  	def get_ip_by_name(name, ns = [])
  		ip = []
  		if ns.empty?
  			dns = Resolv::DNS.new
  		else
  			dns = Resolv::DNS.new(:nameserver => ns)
  		end
      error_count = 0
      begin
        dns.each_address(name) do |addr| 
          ip << addr.to_s
        end
      rescue 
        error_count += 1
        sleep 1
        retry if error_count >= 5
      end
  		
  		ip
  	end

  	def run
  		queue = Queue.new
  		threads = []
  		progress_thread = nil
  		mutex = Mutex.new
  		
  		@init_level.upto(@max_level) do |level|	
  			@current_level = level 			#当前域名级别
  			exist_domains = [] 					# 域名是否存在， 存在不在添加进入queue， 防止一个域名对应多个ip
  			@ret[level] = [] 						# 存在的域名
  			names = []									# 爆破用的names字典
  			
  			@ret[level-1].each do |domain|
  				next if exist_domains.include?(domain[:name])
  				exist_domains << domain[:name]
  				if level == 2
  					names = @option[:sub_names]
  				else
  					names = @option[:next_names]
  				end
  				names.each do |name|
  					queue << "#{name}.#{domain[:name]}"
  				end
  			end
  			next if queue.empty?
  			
  			queue_size = queue.size
  			@progressbar = ProgressBar.create(:title => "Level: #{@current_level}", :format => '%a |%b>>%i| %p%% %t')
  			@progressbar.progress = 0

  			progress_thread = Thread.new do
  				while true
  					sleep 1
  					break if @progressbar.progress == 100
  					@progressbar.progress = (queue_size.to_f - queue.size.to_f)/queue_size * 100
  				end
  			end
  			
  			@option[:thread_num].times do |i|
  				threads << Thread.new do 
  					Thread.current.abort_on_exception = true
  					until queue.empty?
  						name = queue.pop
  						get_ip_by_name(name, @option[:ns]).each do |ip|
  							next if ip == "0.0.0.0"
  							mutex.lock
  							if @ret[level].select { |domain| domain[:host] == ip }.size < 10
  								@ret[level] << {name: name, host: ip}
  								@progressbar.log("#{name}: #{ip}")
  							end
  							mutex.unlock
  						end
  					end
  				end
  			end

  			threads.each { |t| t.join }
  			@progressbar.progress = 100 unless @progressbar.progress ==100
  			progress_thread.kill
  		end
  	end

  	def get_domains_count
  		@domains_count = 0 
  		@init_level.upto(@max_level) do |level|
  			@ret[level].each do |domain|
  				@domains_count += 1
  			end
  		end
  		@domains_count
  	end

  end
end

