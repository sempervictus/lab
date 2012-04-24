require 'sinatra'
require 'lab'
 
before do
  ## Basic blacklisting of metacharacters
  redirect to "/exception" if request.path_info =~ /\;|\|/
  @controller = Lab::Controllers::VmController.new
  @controller.from_file("/home/jcran/qa/lib/lab_pro/config/metasploit_lab_config.yml")
end
 
get '/' do
 redirect to "/list"
end

get '/exception' do
  "sorry, that's not allowed, request contains bad data"
end

get '/list' do
  erb :list
end

get '/list' do
  redirect to '/list'
end

get '/show/:hostname' do
  # Get the watcher
  hostname = params[:hostname]
  @vm = @controller[hostname]
  erb :show
end

get '/start/:hostname' do
  hostname = params[:hostname]
  @vm = @controller[hostname]
  @vm.start
  redirect to "/show/#{hostname}"
end

get '/stop/:hostname' do
  hostname = params[:hostname]
  @vm = @controller[hostname]
  @vm.stop
  redirect to "/show/#{hostname}"
end

get '/revert_snapshot/:hostname/:snapshot' do
  hostname = params[:hostname]
  snapshot = params[:snapshot] || "clean"
  @vm = @controller[hostname]
  @vm.revert_snapshot snapshot
  redirect to "/show/#{hostname}"
end
