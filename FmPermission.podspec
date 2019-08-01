Pod::Spec.new do |s|
  s.name = "FmPermission"
  s.version = "0.0.7"
  s.summary = "ios FmPermission."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"sunxiubo"=>"952055647@qq.com"}
  s.homepage = "https://github.com/952055647/fmpermission-ios"
  s.description = "TODO: Add long description of the pod here."
  s.source = { :git => 'https://github.com/952055647/fmpermission-ios.git', :tag => s.version.to_s }
  s.platform     = :ios
  s.requires_arc = true
  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'FmPermission.framework'
  s.static_framework  =  true
  s.xcconfig = {'OTHER_LDFLAGS' => '-ObjC'}
end
