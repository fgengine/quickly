Pod::Spec.new do |s|
  s.name = 'Quickly'
  s.version = '0.0.82'
  s.homepage = 'https://github.com/fgengine/quickly'
  s.summary = 'Quickly'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = {
    'Alexander Trifonov' => 'fgengine@gmail.com'
  }
  s.source = {
    :git => 'https://github.com/fgengine/quickly.git',
    :tag => s.version.to_s
  }
  s.osx.deployment_target = '10.10'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = 'Quickly/**/*.{h,m,swift}'
  s.module_map = 'Quickly/Quickly.modulemap'
  s.osx.frameworks = 'Foundation'
  s.osx.frameworks = 'AppKit'
  s.ios.frameworks = 'Foundation'
  s.ios.frameworks = 'UIKit'
end
