Pod::Spec.new do |s|

  s.version        = "131213.1139"
  s.source         = { :http => "https://download.avoscloud.com/sdk/iOS/release-beta/AVOSCloudSNS.framework.zip"}


  s.platform       = :ios, '5.0'
  s.name           = "AVOSCloudSNS"
  s.summary        = "AVOS Cloud SNS SDK for iOS"
  s.homepage       = "http://avoscloud.com"
  s.license        = { :type => 'Commercial', :text => '© Copyright 2013 AVOS Systems, Inc. See http://avoscloud.com' }
  s.author         = { "Travis" => "travis@avos.com" }
  s.requires_arc   = true

  
  s.preserve_paths      = "iOS/release-beta/*"
  s.vendored_frameworks = "iOS/release-beta/AVOSCloudSNS.framework"
  s.public_header_files = "iOS/release-beta/**/*.h"
  
  s.frameworks = 'CFNetwork', 'SystemConfiguration', 'MobileCoreServices', 'Security'
  s.dependency 'AVOSCloud'
end
