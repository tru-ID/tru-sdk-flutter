#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint trusdkflutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'trusdkflutter'
  s.version          = '0.0.1'
  s.summary          = 'tru.ID Flutter Plugin.'
  s.description      = <<-DESC
Tru.ID Flutter Plugin 
                       DESC
  s.homepage         = 'https://github.com/tru-id/tru-sdk-flutter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'author' => 'Eric@tru.id' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'tru-sdk-ios', '0.2.4'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.3'
end
