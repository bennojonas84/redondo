app_dir = File.expand_path(File.dirname(__FILE__))
pid File.join(app_dir, 'tmp/pids/unicorn.pid')
stderr_path File.join(app_dir, 'log/unicorn.log')

worker_processes 4
listen 8081

preload_app true
GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)
before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base) 
end
