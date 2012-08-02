maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures transcode_consumer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{ubuntu centos}.each do |os|
  supports os
end

%w{rightscale rvm}.each do |dep|
  depends dep
end

recipe "transcode_consumer::default", "Sets some prerequisite info for RVM"
recipe "transcode_consumer::install", "Installs the transcode consumer gem and any required libs"
recipe "transcode_consumer::do_start_consumers", "Starts the specified number of transcoding consumers"
recipe "transcode_consumer::do_stop_consumers", "Stops all running transcoding consumers"
recipe "transcode_consumer::do_disable_consumers_reconverge", ""

#attribute "cloud/google/store/key",
#  :display_name => "Google Storage API Key",
#  :required => "required",
#  :recipes => ["transcode_consumer::install"]
#
#attribute "cloud/google/store/secret",
#  :display_name => "Google Storage API Secret",
#  :required => "required",
#  :recipes => ["transcode_consumer::install"]

attribute "transcode/amqp/host",
  :display_name => "Transcode AMQP Hostname",
  :required => "required",
  :recipes => ["transcode_consumer::do_start_consumers"]

#attribute "transcode/gstore_bucket",
#  :display_name => "Transcoding Destination Google Storage Bucket",
#  :required => "required",
#  :recipes => ["transcode_consumer::do_start_consumers"]

attribute "transcode/consumer/count",
  :display_name => "Transcode Consumer Count",
  :required => "optional",
  :default => "1",
  :recipes => ["transcode_consumer::do_start_consumers"]

attribute "transcode/consumer/log_level",
  :display_name => "Transcode Consumer Log Level",
  :required => "optional",
  :choice => ["info", "error", "debug", "fatal", "warn"],
  :default => "info",
  :recipes => ["transcode_consumer::do_start_consumers"]

attribute "transcode/consumer/ruby",
  :display_name => "Transcode Consumer Ruby Version (Installed by RVM)",
  :required => "optional",
  :default => "ruby-1.8.7-p370",
  :recipes => ["transcode_consumer::default", "transcode_consumer::install"]
