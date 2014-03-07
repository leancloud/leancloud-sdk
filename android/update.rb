#!/usr/bin/env ruby

# This script is provided for users for painless migrate to 2.4.0
# To be extraly careful, we explicitly replace each exact import

keywords = [
            /com\.avos\.avoscloud\.AVInstallation/,
            /com\.avos\.avoscloud\.PushService/,
            /com\.avos\.avoscloud\.AVAnalytics/,
            /com\.avos\.avoscloud\.AVDuration/,
            /com\.avos\.avoscloud\.AVOnlineConfigureListener/,
            /com\.avos\.avoscloud\.AVUncaughtExceptionHandler/,
            /com\.avos\.avoscloud\.AnalyticsActivity/,
            /com\.avos\.avoscloud\.AnalyticsEvent/,
            /com\.avos\.avoscloud\.AnalyticsImpl/,
            /com\.avos\.avoscloud\.AnalyticsOnlineConfig/,
            /com\.avos\.avoscloud\.AnalyticsSession/,
            /com\.avos\.avoscloud\.AnalyticsUtils/,
            /com\.avos\.avoscloud\.ReportPolicy/,
            /com\.avos\.avoscloud\.AVBroadcastReceiver/,
            /com\.avos\.avoscloud\.AVDefaultNotificationReceiver/,
            /com\.avos\.avoscloud\.AVPush/
            ]

targets = [
           'com.avos.avospush.AVInstallation',
           'com.avos.avospush.PushService',
           'com.avos.avosstatistics.AVAnalytics',
           'com.avos.avosstatistics.AVDuration',
           'com.avos.avosstatistics.AVOnlineConfigureListener',
           'com.avos.avosstatistics.AVUncaughtExceptionHandler',
           'com.avos.avosstatistics.AnalyticsActivity',
           'com.avos.avosstatistics.AnalyticsEvent',
           'com.avos.avosstatistics.AnalyticsImpl',
           'com.avos.avosstatistics.AnalyticsOnlineConfig',
           'com.avos.avosstatistics.AnalyticsSession',
           'com.avos.avosstatistics.AnalyticsUtils',
           'com.avos.avosstatistics.ReportPolicy',
           'com.avos.avospush.AVBroadcastReceiver',
           'com.avos.avospush.AVDefaultNotificationReceiver',
           'com.avos.avospush.AVPush'
           ]

kw_map = Hash[keywords.zip(targets)]

Dir.glob('AndroidManifest.xml') do | android_file|
  puts "processing #{android_file}..."
  text = File.read(android_file)
  kw_map.each do |from, to|
    text = text.gsub(from,to)
  end
  File.write(android_file,text)
end

Dir.glob('**/*.java') do |java_file|
  puts "Processing #{java_file}..."
  text = File.read(java_file)
  kw_map.each do |from, to|
    text = text.gsub(from, to)
  end
  File.write(java_file, text)
end
            
