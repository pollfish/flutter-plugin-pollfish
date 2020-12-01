Pod::Spec.new do |s|

  s.name             = 'flutter_pollfish'
  s.version          = '1.2.1'
  s.summary          = 'A Flutter plugin for rendering Pollfish surveys within an app'
  s.description      = <<-DESC
A  Flutter plugin for rendering Pollfish surveys within an app
                       DESC
  s.homepage         = 'https://www.pollfish.com/publisher'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pollfish, Inc.' => 'support@pollfish.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'Pollfish', '~> 5.5.0'
  s.ios.deployment_target = '9.0'
  s.static_framework = true
end


