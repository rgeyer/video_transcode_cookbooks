#
# Cookbook Name:: transcode_producer
# Recipe:: do_create_jobs_from_rss
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

# This not only ensures that the gem is installed, but that the RVM recipes and environment are included
include_recipe "transcode_producer::install"

presets = ""

node['transcode']['handbrake_presets'].each do |preset|
  presets += "--handbrake-preset \"#{preset}\" "
end

output_path = node['transcode']['output_path']

node['transcode']['rss_sources'].each do |source|
  rvm_shell "Execute transcode_producer for #{source}" do
    ruby_string "#{node['transcode']['producer']['ruby']}@transcode_producer"
    code "transcode_producer --amqp-host \"#{node['transcode']['amqp']['host']}\" --input-url \"#{source}\" --output-path #{output_path} #{presets}"
  end
end

rightscale_marker :end
