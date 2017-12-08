Pod::Spec.new do |s|

  s.name         = "FaveButton"
  s.version      = "3.0.3"
  s.summary      = "Twitter's heart like animated button written in Swift"
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/subdiox/fave-button'
  s.author       = { 'subdiox' => 'subdiox@gmail.com' }
  s.ios.deployment_target = '8.0'
  s.source       = { :git => 'https://github.com/subdiox/fave-button.git', :tag => s.version.to_s }
  s.source_files  = 'Source/**/*.swift'
  s.requires_arc = true
  end

