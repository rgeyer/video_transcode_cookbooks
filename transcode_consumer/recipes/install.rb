#
# Cookbook Name:: transcode_consumer
# Recipe:: install
#
# Copyright (c) 2012 Ryan J. Geyer
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

rightscale_marker :begin

include_recipe "transcode_consumer::default"

rvm_environment "#{node['transcode']['consumer']['ruby']}@transcode_consumer" do
  action :create
end

# This is a RightScale CentOS 6.2 - RightLink 5.8 (Beta) concession.  Without doing this
# thunker loses it's mind and you can't SSH in even though the environment seems sane.
#
#RightScale-Administrators-MacBook-Pro-2:~ ryangeyer$ ssh rightscale@50.112.211.192
#/opt/rightscale/sandbox/lib/ruby/site_ruby/1.8/rubygems.rb:779:in `report_activate_error': Could not find RubyGem eventmachine (>= 0) (Gem::LoadError)
#	from /opt/rightscale/sandbox/lib/ruby/site_ruby/1.8/rubygems.rb:214:in `activate'
#	from /opt/rightscale/sandbox/lib/ruby/site_ruby/1.8/rubygems.rb:1082:in `gem'
#	from /opt/rightscale/right_link/lib/gem_dependencies.rb:39
#	from /opt/rightscale/right_link/bin/rs_thunk.rb:26:in `require'
#	from /opt/rightscale/right_link/bin/rs_thunk.rb:26
#Connection to 50.112.211.192 closed.
rvm_default_ruby "system"

gemfile = ::File.join(::File.dirname(__FILE__), '..', 'files', 'default', 'transcode_consumer-0.0.1.gem')

rvm_gem 'transcode_consumer' do
  ruby_string "#{node['transcode']['consumer']['ruby']}@transcode_consumer"
  source gemfile
  action :install
end

# Temporarily disable the use of the gstore creds (note action :nothing)
template ::File.join('/root', '.fog') do
  owner 'root'
  mode 00600
  source 'dot_fog.erb'
  action :nothing
end

# Make sure the worker is running by re-running the recipe every 2 minutes

# TODO: Note that the action is :nothing, this is intentional cause it can DDoS RightNet, probably need to think of a better
# approach to make sure the consumer process(es) are running.
cron "Re-run transcode_consumer::do_start_workers" do
  minute "*/2"
  user "root"
  command "rs_run_recipe -n transcode_consumer::do_start_workers 2>&1 > /var/log/rs_sys_reconverge.log"
  action :nothing
end

rightscale_marker :end
