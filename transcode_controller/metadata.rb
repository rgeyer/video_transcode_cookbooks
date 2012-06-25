maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures transcode_controller"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

supports "ubuntu"

depends "rs_utils"

recipe "transcode_controller::install", "Installs the transcode controller gem and any required libs"
recipe "transcode_controller::do_create_jobs_from_rss", "Executes gio_2012_controller once for each RSS feed that's supplied"

attribute "cloud/google/store/key",
  :display_name => "Google Storage API Key",
  :required => "required",
  :recipes => ["transcode_controller::install"]

attribute "cloud/google/store/secret",
  :display_name => "Google Storage API Secret",
  :required => "required",
  :recipes => ["transcode_controller::install"]

attribute "transcode/amqp/host",
  :display_name => "Transcode AMQP Hostname",
  :required => "required",
  :recipes => ["transcode_controller::do_create_jobs_from_rss"]

attribute "transcode/rss_sources",
  :display_name => "Transcoding RSS Sources",
  :required => "required",
  :type => "array",
  :recipes => ["transcode_controller::do_create_jobs_from_rss"]

attribute "transcode/handbrake_presets",
  :display_name => "Transcoding HandBrake Presets",
  :required => "required",
  :type => "array",
  :recipes => ["transcode_controller::do_create_jobs_from_rss"]