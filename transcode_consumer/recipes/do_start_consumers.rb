#
# Cookbook Name:: transcode_consumer
# Recipe:: do_start_consumers
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

include_recipe 'transcode_consumer::install'

amqp_host = node['transcode']['amqp']['host']
log_level = node['transcode']['consumer']['log_level']
tot_procs = node['transcode']['consumer']['count'].to_i
num_procs = `pgrep -f '^/usr/local/rvm/gems/.*/bin/transcode_consumer ' | wc -l`.to_i

num_procs.upto( tot_procs - 1 ) do |idx|
  rvm_shell "Start consumer process ##{idx}" do
    ruby_string "#{node['transcode']['consumer']['ruby']}@transcode_consumer"
    code <<-EOF
      nohup transcode_consumer \
        --amqp-host #{amqp_host} \
        --log-level #{log_level} \
        &>>/var/log/transcode_parent_#{idx}.log \
        </dev/null &
    EOF
  end
end

rightscale_marker :end
