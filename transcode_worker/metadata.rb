maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures transcode_worker"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

supports "ubuntu"

depends "rs_utils"

recipe "transcode_worker::install", "Installs the transcode worker gem and any required libs"
recipe "transcode_worker::do_start_workers", "Starts the specified number of transcoding workers"
recipe "transcode_worker::do_stop_workers", "Stops all running transcoding workers"
recipe "transcode_worker::do_disable_workers_recoverge", ""

attribute "cloud/google/store/key",
  :display_name => "Google Storage API Key",
  :required => "required",
  :recipes => ["transcode_worker::install"]

attribute "cloud/google/store/secret",
  :display_name => "Google Storage API Secret",
  :required => "required",
  :recipes => ["transcode_worker::install"]

attribute "transcode/amqp/host",
  :display_name => "Transcode AMQP Hostname",
  :required => "required",
  :recipes => ["transcode_worker::do_start_workers"]

attribute "transcode/gstore_bucket",
  :display_name => "Transcoding Destination Google Storage Bucket",
  :required => "required",
  :recipes => ["transcode_worker::do_start_workers"]

attribute "transcode/worker/count",
  :display_name => "Transcode Worker Count",
  :required => "optional",
  :default => "1",
  :recipes => ["transcode_worker::do_start_workers"]

attribute "transcode/worker/log_level",
  :display_name => "Transcode Worker Log Level",
  :required => "optional",
  :choice => ["info", "error", "debug", "fatal", "warn"],
  :default => "info",
  :recipes => ["transcode_worker::do_start_workers"]