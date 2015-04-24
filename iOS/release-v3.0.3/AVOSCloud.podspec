Pod::Spec.new do |s|

  s.version        = "3.0.3"
  s.source         = { :http => "https://download.leancloud.cn/sdk/iOS/release-v#{s.version}/AVOSCloud.framework.zip"}


  s.platform       = :ios, '5.1.1'
  s.name           = "AVOSCloud"
  s.summary        = "LeanCloud iOS SDK for mobile backend."
  s.homepage       = "https://leancloud.cn"
  s.license        = { :type => 'Commercial', :text => '© Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html' }
  s.author         = { "LeanCloud" => "support@leancloud.cn" }
  s.documentation_url = 'https://leancloud.cn/docs/api/iOS/index.html'
  s.requires_arc   = true

  
  s.preserve_paths      = "iOS/release-v#{s.version}/*"
  s.vendored_frameworks = "iOS/release-v#{s.version}/AVOSCloud.framework"
  s.public_header_files = "iOS/release-v#{s.version}/**/*.h"
  
  s.frameworks = 'CFNetwork', 'SystemConfiguration', 'MobileCoreServices', 'CoreTelephony', 'CoreLocation',  'CoreGraphics', 'Security', 'QuartzCore'
  s.libraries = 'icucore' 
end
