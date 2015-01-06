
Pod::Spec.new do |s|
  s.name         = "MBMvc"
  s.version      = "1.1.3.2"
  s.summary      = "MBMvc is a Message Based MVC framework."
  s.homepage     = "https://github.com/alibaba/MBMvc"

  s.license      = { :type => 'GPL2' , :text => <<-LICENSE
             (C) 2007-2013 Alibaba Group Holding Limited
             This program is free software; you can redistribute it and/or modify
             it under the terms of the GNU General Public License version 2 as
             published by the Free Software Foundation.
 LICENSE
                    }

  s.author       = { "文通" => "wentong@taobao.com" }
  s.source       = { :git => "https://github.com/alibaba/MBMvc.git", :tag => "1.1.3.2" }


  s.platform     = :ios, '6.1'

  s.ios.deployment_target = '5.0'

  s.source_files = 'MBMvc/**/*.{h,m}'

  s.public_header_files = 'MBMvc/**/*.h'

  s.requires_arc = true
  
  #'OMPromises/Core', '~>0.3.0'
  s.dependency 'OMPromises/Core'

  s.prefix_header_contents = <<-EOS
  
#ifdef DEBUG
#define TBMB_DEBUG
#endif

EOS

end
