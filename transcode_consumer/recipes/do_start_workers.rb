#
# Cookbook Name:: transcode_consumer
# Recipe:: do_start_workers
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

include_recipe 'transcode_consumer::install'

rightscale_marker :begin

running_workers = `pgrep -f transcode_consumer | wc -l`.to_i - 1
worker_count = node[:transcode][:consumer][:count].to_i

qty = worker_count - running_workers

qty.times do |idx|
  bash "Start the #{idx}th worker" do
    code "transcode_consumer --amqp-host #{node[:transcode][:amqp][:host]} --gstorage-bucket #{node[:transcode][:gstore_bucket]} --log-level #{node[:transcode][:worker][:log_level]} &"
  end
end

rightscale_marker :end