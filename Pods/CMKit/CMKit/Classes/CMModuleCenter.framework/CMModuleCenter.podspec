Pod::Spec.new do |s|
  s.name             = 'CMModuleCenter'
  s.version          = '0.5.0'
  s.summary          = '模块管理中心'

  s.homepage         = 'http://git.dev.cmrh.com/FrontEnd/Architecture/iOS/CMModuleCenter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sys_mobile_adm' => 'sys_mobile_adm@cmrh.com' }
  s.source           = { :git => 'http://git.dev.cmrh.com/FrontEnd/Architecture/iOS/CMModuleCenter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.requires_arc          = true

  s.source_files         = 'CMModuleCenter/*.{h,m}'
  s.public_header_files  = 'CMModuleCenter/*.h'

end
