
Pod::Spec.new do |s|
  s.name         = "MBMvc"
  s.version      = "1.0.0"
  s.summary      = "MBMvc"
  s.homepage     = "https://github.com/alibaba/MBMvc"

  s.license      = 'GPL2'

  s.author       = { "文通" => "wentong@taobao.com" }
  s.source       = { :git => "git@github.com:alibaba/MBMvc.git", :tag => "1.0.0" }


  s.platform     = :ios, '6.1'

  s.ios.deployment_target = '4.3'

  s.source_files = 'MBMvc/**/*.{h,m}'

  s.public_header_files = 'MBMvc/**/*.h'

  s.requires_arc = true

end
