maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures transcode_producer"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

%w{ubuntu centos}.each do |os|
  supports os
end

%w{rightscale rvm}.each do |dep|
  depends dep
end

recipe "transcode_producer::default", "Sets some prerequisite info for RVM"
recipe "transcode_producer::install", "Installs the transcode controller gem and any required libs"
recipe "transcode_producer::do_create_jobs_from_rss", "Executes transcode_producer once for each RSS feed that's supplied"

#attribute "cloud/google/store/key",
#  :display_name => "Google Storage API Key",
#  :required => "required",
#  :recipes => ["transcode_producer::install"]
#
#attribute "cloud/google/store/secret",
#  :display_name => "Google Storage API Secret",
#  :required => "required",
#  :recipes => ["transcode_producer::install"]

attribute "transcode/amqp/host",
  :display_name => "Transcode AMQP Hostname",
  :required => "required",
  :recipes => ["transcode_producer::do_create_jobs_from_rss"]

attribute "transcode/rss_sources",
  :display_name => "Transcoding RSS Sources",
  :required => "required",
  :type => "array",
  :recipes => ["transcode_producer::do_create_jobs_from_rss"]

#attribute "transcode/output_bucket",
#  :display_name => "Output Bucket Name",
#  :description => "The name of the Google Storage bucket where the transcoded files will be uploaded",
#  :required => "optional",
#  :recipes => ["transcode_producer::do_create_jobs_from_rss"]

attribute "transcode/output_path",
  :display_name => "Transcoding Destination local filesystem path",
  :required => "optional",
  :default => "/mnt/ephemeral/transcode",
  :recipes => ["transcode_producer::do_create_jobs_from_rss"]

attribute "transcode/handbrake_presets",
  :display_name => "Transcoding HandBrake Presets",
  :required => "required",
  :type => "array",
  :recipes => ["transcode_producer::do_create_jobs_from_rss"]

attribute "transcode/producer/ruby",
  :display_name => "Transcode Consumer Ruby Version (Installed by RVM)",
  :required => "optional",
  :default => "ruby-1.8.7-p370",
  :recipes => ["transcode_producer::default", "transcode_producer::install"]
