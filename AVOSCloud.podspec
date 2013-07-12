Pod::Spec.new do |s|
  s.platform  	 = :ios, '5.0'
  s.name           = "AVOS Cloud"
  s.version        = "1.0"
  s.summary        = "AVOS Cloud iOS SDK for mobile backend."
  s.homepage       = "https://github.com/avos/avoscloud-sdk"
  s.license        = 'AVOS Inc. License'
  s.author         = { "Zeng Zhu" => "zzhu@avos.com" }
  s.source         = { :git => "git@github.com:avos/avoscloud-sdk.git" }
  s.source_files   = "iOS/beta/AVOSCloud.framework/Headers/*.{h}'
  s.library        = "AVOSCloud"
  s.requires_arc   = true
  s.frameworks     = 'Foundation'
end
