#!/usr/bin/env ruby

# This is a script provided to the users for painless migrate to new keywords.
# To be extra careful, we explicitly replace each exact keyword.

keywords = [
  /\bParse\b/,
  /\bParseACL\b/,
  /\bParseAnalytics\b/,
  /\bParseAnonymousUtils\b/,
  /\bParseBroadcastReceiver\b/,
  /\bParseCallback\b/,
  /\bParseClassName\b/,
  /\bParseCloud\b/,
  /\bParseErrorUtils\b/,
  /\bParseException\b/,
  /\bParseFile\b/,
  /\bParseGeoPoint\b/,
  /\bParseInstallation\b/,
  /\bParseObject\b/,
  /\bParseObjects\b/,
  /\bParsePush\b/,
  /\bParseQuery\b/,
  /\bParseQuerys\b/,
  /\bParseRelation\b/,
  /\bParseResponse\b/,
  /\bParseResponseArray\b/,
  /\bParseRole\b/,
  /\bParseRoles\b/,
  /\bParseRuntimeException\b/,
  /\bParseUploader\b/,
  /\bParseUser\b/,
  /\bParseUsers\b/,
  /\bParseUtils\b/,
  /\bStorageTypeParse\b/,
  /\bcopyPropertiesFromJsonStringToParseObject\b/,
  /\bcopyPropertiesFromMapToParseObject\b/,
  /\bcreateFileFromParseObject\b/,
  /\bcurrParseUser\b/,
  /\bgetEndpointByParseClassName\b/,
  /\bgetParseClassEndpoint\b/,
  /\bgetParseClassName\b/,
  /\bgetParseFile\b/,
  /\bgetParseGeoPoint\b/,
  /\bgetParseInstallationEndpoint\b/,
  /\bgetParseObject\b/,
  /\bgetParseRoleEndpoint\b/,
  /\bgetParseUser\b/,
  /\bgetParseUserEndpoint\b/,
  /\bnewParseObjectByClassName\b/,
  /\bnewParseUser\b/,
  /\bparseFileWithParseObject\b/
]

targets = [
  'AVOSCloud',
  'AVACL',
  'AVAnalytics',
  'AVAnonymousUtils',
  'AVBroadcastReceiver',
  'AVCallback',
  'AVClassName',
  'AVCloud',
  'AVErrorUtils',
  'AVException',
  'AVFile',
  'AVGeoPoint',
  'AVInstallation',
  'AVObject',
  'AVObjects',
  'AVPush',
  'AVQuery',
  'AVQueries',
  'AVRelation',
  'AVResponse',
  'AVResponseArray',
  'AVRole',
  'AVRoles',
  'AVRuntimeException',
  'AVUploader',
  'AVUser',
  'AVUsers',
  'AVUtils',
  'StorageTypeAV',
  'copyPropertiesFromJsonStringToAVObject',
  'copyPropertiesFromMapToAVObject',
  'createFileFromAVObject',
  'currAVUser',
  'getEndpointByAVClassName',
  'getAVClassEndpoint',
  'getAVClassName',
  'getAVFile',
  'getAVGeoPoint',
  'getAVInstallationEndpoint',
  'getAVObject',
  'getAVRoleEndpoint',
  'getAVUser',
  'getAVUserEndpoint',
  'newAVObjectByClassName',
  'newAVUser',
  'parseFileWithAVObject'
]

kw_map = Hash[keywords.zip(targets)]

Dir.glob('**/*.java') do |java_file|
  puts "Processing #{java_file}..."
  text = File.read(java_file)
  kw_map.each do |from, to|
    text = text.gsub(from, to)
  end
  File.write(java_file, text)
end