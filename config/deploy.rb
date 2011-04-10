set :application, "adempiere"
set :repository,  "git@github.com:itbakery/adempiere.git"
set :user, "admin"
set :scm, :git
set  :run_method, :run
set  :ssh_options, {:forward_agent => true }
set :deploy_to, "/home/#{application}"

default_run_options[:pty] = true
ssh_options[:port] = 8022
role :web, "www.adempiere.asia"
role :app, "www.adempiere.asia"
role :db,  "www.adempiere.asia", :primary => true


# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

task :after_update_code, :roles => :app do
  %w{uploads  avatars swfs ckeditor_assets map icons}.each do |share|
    run "rm -rf #{release_path}/public/#{share} "
    run "mkdir -p #{shared_path}/purple/#{share} "
    run "ln -nfs #{shared_path}/purple/#{share} #{release_path}/public/#{share} "
  end
end
end