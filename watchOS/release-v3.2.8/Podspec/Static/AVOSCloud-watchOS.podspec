Pod::Spec.new do |s|
  platform   = 'AVOSCloud'

  s.name     = "AVOSCloud-watchOS"
  s.version  = "3.2.8"
  s.platform = :watchos, "2.0"
  s.watchos.deployment_target = "2.0"
  s.summary  = "LeanCloud watchOS SDK for mobile backend."
  s.homepage = "https://leancloud.cn"
  s.documentation_url = "https://leancloud.cn/api-docs/iOS/index.html"
  s.license  = {
    :type => "Commercial",
    :text => "Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html"
  }
  s.author   = { "LeanCloud" => "support@leancloud.cn" }

  s.source   = { :http => "https://download.leancloud.cn/sdk/watchOS/release-v#{s.version}/Static/#{platform}.framework.zip" }

  framework_path = "watchOS/release-v#{s.version}/Static/#{platform}.framework"

  s.source_files        = "*.h"
  s.public_header_files = "*.h"
  s.preserve_paths      = "#{framework_path}/#{platform}"
  s.vendored_libraries  = "lib#{platform}.a"

  s.frameworks = "MobileCoreServices", "CoreLocation",  "CoreGraphics", "Security", "QuartzCore"
  s.libraries  = "icucore", "sqlite3"

  s.xcconfig = { 'OTHER_LDFLAGS' => '$(inherited) -ObjC -lz' }

  s.prepare_command = <<-CMD.gsub(/^[ \t]+/, '')
    cp #{framework_path}/#{platform} lib#{platform}.a
    cp #{framework_path}/Headers/* .
  CMD

end
