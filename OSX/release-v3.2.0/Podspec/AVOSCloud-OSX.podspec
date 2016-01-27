Pod::Spec.new do |s|

  component  = "AVOSCloud"

  s.name     = "AVOSCloud-OSX"
  s.version  = "3.2.0"
  s.summary  = "LeanCloud OS X SDK for Mac platform."
  s.homepage = "https://leancloud.cn"
  s.documentation_url = "https://leancloud.cn/api-docs/iOS/index.html"
  s.license  = {
    :type => "Commercial",
    :text => "Copyright 2015 LeanCloud, Inc. See https://leancloud.cn/terms.html"
  }
  s.author   = { "LeanCloud" => "support@leancloud.cn" }
  
  s.platform = :osx, 10.8
  s.requires_arc = true

  s.source   = { :http => "http://download.leancloud.cn/sdk/OSX/release-v#{s.version}/#{component}.framework.zip" }

  framework_path = "OSX/release-v#{s.version}/#{component}.framework"

  s.preserve_paths       = "#{framework_path}"
  s.public_header_files  = "#{framework_path}/**/*.h"
  s.vendored_frameworks  = "#{framework_path}"
  s.resources            = "#{framework_path}"

  s.frameworks = "CoreServices", "SystemConfiguration", "CoreLocation"
  s.libraries  = "icucore", "sqlite3", "z", "curl"

  s.xcconfig = {
      "OTHER_LDFLAGS" => "$(inherited) -ObjC",
      "FRAMEWORK_SEARCH_PATHS" => "\"${PODS_ROOT}/#{s.name}/**\"",
      "LD_RUNPATH_SEARCH_PATHS" => "@loader_path/../Frameworks"
  }

end
