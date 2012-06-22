maintainer       "Ryan J. Geyer"
maintainer_email "me@ryangeyer.com"
license          "All rights reserved"
description      "Installs/Configures transcode_controller"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.1"

supports "ubuntu"

depends "rs_utils"

recipe "transcode_controller::install", "Installs the transcode controller gem and any required libs"

attribute "cloud/google/store/key",
  :display_name => "Google Storage API Key",
  :required => "required",
  :recipes => ["transcode_controller::install"]

attribute "cloud/google/store/secret",
  :display_name => "Google Storage API Secret",
  :required => "required",
  :recipes => ["transcode_controller::install"]