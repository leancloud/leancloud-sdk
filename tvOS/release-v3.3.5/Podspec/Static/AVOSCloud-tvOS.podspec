Pod::Spec.new do |s|
  platform   = 'AVOSCloud'

  s.name     = "AVOSCloud-tvOS"
  s.version  = "3.3.5"
  s.platform = :tvos, "9.0"
  s.tvos.deployment_target = "9.0"
  s.summary  = "LeanCloud tvOS SDK for mobile backend."
  s.homepage = "https://leancloud.cn"
  s.documentation_url = "https://leancloud.cn/api-docs/iOS/index.html"
  s.license  = {
    :type => "Commercial",
    :text => "Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html"
  }
  s.author   = { "LeanCloud" => "support@leancloud.cn" }

  s.source   = { :http => "https://download.leancloud.cn/sdk/tvOS/release-v#{s.version}/Static/#{platform}.framework.zip" }

  framework_path = "tvOS/release-v#{s.version}/Static/#{platform}.framework"

  s.source_files        = "*.h"
  s.public_header_files = "*.h"
  s.preserve_paths      = "#{framework_path}/#{platform}"
  s.vendored_libraries  = "lib#{platform}.a"

  s.frameworks = "CFNetwork", "MobileCoreServices", "CoreLocation",  "CoreGraphics", "Security", "QuartzCore"
  s.libraries  = "icucore", "sqlite3"

  s.xcconfig = { 'OTHER_LDFLAGS' => '$(inherited) -ObjC -lz' }

  s.prepare_command = <<-CMD.gsub(/^[ \t]+/, '')
    cp #{framework_path}/#{platform} lib#{platform}.a
    cp #{framework_path}/Headers/* .
  CMD

end
