Pod::Spec.new do |s|

  s.version        = "3.1.2.3"
  s.name         = "AVOSCloud"
  s.summary      = "LeanCloud iOS SDK for mobile backend."
  s.homepage     = "https://leancloud.cn"
  s.license      = { :type => "Commercial", :text => "© Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html" }
  s.author       = { "LeanCloud" => "support@leancloud.cn" }
  s.documentation_url = "https://leancloud.cn/docs/api/iOS/index.html"
  s.platform     = :ios, "5.1.1"
  s.source       = { :http => "https://download.leancloud.cn/sdk/iOS/release-v#{s.version}/#{s.name}.framework.zip"}
  s.source_files        = "iOS/release-v#{s.version}/#{s.name}.framework/**/*.h", 'LCDummy.m'
  s.public_header_files = "iOS/release-v#{s.version}/#{s.name}.framework/**/*.h"
  s.resources           = "iOS/release-v#{s.version}/#{s.name}.framework/#{s.name}.bundle"
  s.preserve_paths      = "iOS/release-v#{s.version}/#{s.name}.framework/#{s.name}"
  s.frameworks = "CFNetwork", "SystemConfiguration", "MobileCoreServices", "CoreTelephony", "CoreLocation",  "CoreGraphics", "Security", "QuartzCore"
  s.libraries  = "icucore", "sqlite3"
  s.vendored_libraries = "lib#{s.name}.a"
  s.prepare_command = <<-CMD
    touch LCDummy.m && cp "iOS/release-v#{s.version}/#{s.name}.framework/#{s.name}" "lib#{s.name}.a"
  CMD

end
