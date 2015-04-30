Pod::Spec.new do |s|

  s.version        = "3.1.0"
  s.source         = { :http => "https://download.leancloud.cn/sdk/iOS/release-v#{s.version}/AVOSCloudCrashReporting.framework.zip"}


  s.platform       = :ios, '5.1.1'
  s.name           = "AVOSCloudCrashReporting"
  s.summary        = "LeanCloud Crash Report SDK for iOS"
  s.homepage       = "https://leancloud.cn"
  s.license        = { :type => 'Commercial', :text => '© Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html' }
  s.author         = { "LeanCloud" => "support@leancloud.cn" }
  s.documentation_url = 'https://leancloud.cn/docs/api/iOS/index.html'
  s.requires_arc   = true

  
  s.preserve_paths      = "iOS/release-v#{s.version}/*"
  s.vendored_frameworks = "iOS/release-v#{s.version}/AVOSCloudCrashReporting.framework"
  s.public_header_files = "iOS/release-v#{s.version}/**/*.h"
  
  s.dependency 'AVOSCloud'
end
