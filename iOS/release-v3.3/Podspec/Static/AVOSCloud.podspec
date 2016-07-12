Pod::Spec.new do |s|

  s.name     = "AVOSCloud"
  s.version  = "3.3"
  s.platform = :ios, "6.0"
  s.summary  = "LeanCloud iOS SDK for mobile backend."
  s.homepage = "https://leancloud.cn"
  s.documentation_url = "https://leancloud.cn/api-docs/iOS/index.html"
  s.license  = {
    :type => "Commercial",
    :text => "Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html"
  }
  s.author   = { "LeanCloud" => "support@leancloud.cn" }
  
  s.source   = { :http => "https://download.leancloud.cn/sdk/iOS/release-v#{s.version}/Static/#{s.name}.framework.zip" }

  framework_path = "iOS/release-v#{s.version}/Static/#{s.name}.framework"

  s.source_files        = "*.h"
  s.public_header_files = "*.h"
  s.preserve_paths      = "#{framework_path}/#{s.name}"
  s.vendored_libraries  = "lib#{s.name}.a"

  s.frameworks = "CFNetwork", "SystemConfiguration", "MobileCoreServices", "CoreTelephony", "CoreLocation",  "CoreGraphics", "Security", "QuartzCore"
  s.libraries  = "icucore", "sqlite3"

  s.xcconfig = { 'OTHER_LDFLAGS' => '$(inherited) -ObjC -lz' }

  s.prepare_command = <<-CMD.gsub(/^[ \t]+/, '')
    cp #{framework_path}/#{s.name} lib#{s.name}.a
    cp #{framework_path}/Headers/* .
  CMD

end
