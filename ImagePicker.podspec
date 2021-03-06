Pod::Spec.new do |s|
  s.name             = "ImagePicker"
  s.summary          = "Reinventing the way ImagePicker works."
  s.version          = "3.1.99"
  s.homepage         = "https://github.com/hyperoslo/ImagePicker"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = { :git => "https://github.com/yudinm/ImagePicker.git" }
  s.social_media_url = 'https://twitter.com/hyperoslo'
  s.platform     = :ios, '9.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'
  s.resource_bundles = { 'ImagePicker' => ['Images/*.{png}','Resources/*.{png}','Resources/*.{storyboard}'] }
  s.frameworks = 'AVFoundation'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
end
