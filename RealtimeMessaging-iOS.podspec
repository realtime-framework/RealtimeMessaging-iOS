#
# Be sure to run `pod lib lint OrtcClientLib.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RealtimeMessaging-iOS"
  s.version          = "2.1.52"
  s.summary          = "Realtime Cloud Messaging (ORTC) SDK for iOS"
  s.description      = <<-DESC
Part of the The Realtime® Framework, Realtime Cloud Messaging (aka ORTC) is a secure, fast and highly scalable cloud-hosted Pub/Sub real-time message broker for web and mobile apps.

If your website or mobile app has data that needs to be updated in the user’s interface as it changes (e.g. real-time stock quotes or ever changing social news feed) Realtime Cloud Messaging is the reliable, easy, unbelievably fast, “works everywhere” solution.
DESC
  s.homepage         = "http://framework.realtime.co/messaging"
  s.license          = 'MIT'
  s.author           = { "Realtime.co" => "framework@realtime.co" }
  s.source           = { :git => "https://github.com/realtime-framework/RealtimeMessaging-iOS.git", :tag => s.version}
  s.social_media_url = 'https://twitter.com/RTWworld'

  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'

  s.requires_arc = true

  s.source_files = 'Pod/Classes/OrtcClient/*.{h,m}'
  s.public_header_files = 'Pod/Classes/OrtcClient/*.h'
  s.library  = 'icucore'
  s.dependency 'SocketRocket', '0.5.1'

end
