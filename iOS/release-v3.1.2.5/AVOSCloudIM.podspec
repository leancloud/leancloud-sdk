Pod::Spec.new do |s|

  s.name     = "AVOSCloudIM"
  s.version        = "3.1.2.5"
  s.platform = :ios, "5.1.1"
  s.summary  = "LeanCloud iOS Instant Message SDK for mobile backend."
  s.homepage = "https://leancloud.cn"
  s.documentation_url = "https://leancloud.cn/docs/api/iOS/index.html"
  s.license  = {
    :type => "Commercial",
    :text => "Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html"
  }
  s.author   = { "LeanCloud" => "support@leancloud.cn" }
  s.source   = { :http => "https://download.leancloud.cn/sdk/iOS/release-v#{s.version}/#{s.name}.framework.zip" }

  s.source_files        = "iOS/release-v#{s.version}/#{s.name}.framework/**/*.h", "LCDummy.m"
  s.public_header_files = "iOS/release-v#{s.version}/#{s.name}.framework/**/*.h"
  s.preserve_paths      = "iOS/release-v#{s.version}/#{s.name}.framework/#{s.name}"

  s.dependency "AVOSCloud"

  s.xcconfig = { 'OTHER_LDFLAGS' => '$(inherited) -undefined dynamic_lookup' }

  s.prepare_command = <<-CMD
    cp "iOS/release-v#{s.version}/#{s.name}.framework/#{s.name}" "lib#{s.name}.a"
    touch LCDummy.m
  CMD
  
end
