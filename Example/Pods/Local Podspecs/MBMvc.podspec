
Pod::Spec.new do |s|
  s.name         = "MBMvc"
  s.version      = "1.3.0"
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
  s.source       = { :git => "https://github.com/alibaba/MBMvc.git", :tag => s.version.to_s }


  s.platform     = :ios, '6.1'

  s.ios.deployment_target = '6.0'


  s.subspec 'Default' do |bs|
    bs.source_files = 'Pod/Classes/Default/**/*' ,'Pod/Classes/Facade/**/*'
    bs.public_header_files = 'Pod/Classes/Default/**/*.h' ,'Pod/Classes/Facade/**/*.h'
    bs.dependency 'MBMvc/Protocol'
    bs.dependency 'MBMvc/Util'
  end

  s.subspec 'Protocol' do |bs|
    bs.source_files = 'Pod/Classes/Protocol/**/*'
    bs.public_header_files = 'Pod/Classes/Protocol/**/*.h'
  end

  s.subspec 'Proxy' do |bs|
    bs.source_files = 'Pod/Classes/Proxy/**/*'
    bs.public_header_files = 'Pod/Classes/Proxy/**/*.h'
    bs.dependency 'MBMvc/Default'
    bs.dependency 'MBMvc/Util'
  end

  s.subspec 'Rx' do |bs|
    bs.source_files = 'Pod/Classes/Rx/**/*'
    bs.public_header_files = 'Pod/Classes/Rx/**/*.h'
    bs.dependency 'ReactiveCocoa'
  end

  s.subspec 'Util' do |bs|
    bs.source_files = 'Pod/Classes/Util/**/*','Pod/Classes/Bindable/**/*'
    bs.public_header_files = 'Pod/Classes/Util/**/*.h','Pod/Classes/Bindable/**/*.h'
    bs.dependency 'MBMvc/Protocol'
  end
 # s.resource_bundles = {
 #   'MBMvc' => ['Pod/Assets/*.png']
 # }

  s.requires_arc = true

  s.prefix_header_contents = <<-EOS

#ifdef DEBUG
#define TBMB_DEBUG
#endif

EOS

end
