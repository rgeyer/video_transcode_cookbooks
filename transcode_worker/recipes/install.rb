#
# Cookbook Name:: transcode_worker
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

rs_utils_marker :begin

gemfile = ::File.join(::File.dirname(__FILE__), '..', 'files', 'default', 'worker-0.0.1.gem')

%w{libopenssl-ruby1.8 libreadline-ruby1.8 libruby1.8 libshadow-ruby1.8 ruby ruby1.8 ruby1.8-dev}.each do |p|
  package p do
    action :install
  end
end

bash "Reset RubyGem sources to include only http://rubygems.org/ and install worker gem" do
  code <<EOF
for i in `gem sources | awk '{if (NR > 2) {print}}'`; do gem sources -r $i; done
gem install #{gemfile} --no-ri --no-rdoc
EOF
end

template ::File.join('/root', '.fog') do
  owner 'root'
  mode 00600
  source 'dot_fog.erb'
end

rs_utils_marker :end
