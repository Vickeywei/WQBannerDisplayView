
Pod::Spec.new do |s|
    s.name         = "WQBannerDisplayView"   #名称
    s.version      = "0.0.1"          #版本号
    s.summary      = "仿淘宝用三个Button实现无缝无限轮播视图OC版本"  #描述
    s.homepage     = "https://github.com/Vickeywei/WQBannerDisplayView" #描述页面
    s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
    © 2016-2016 Vicky. All rights reserved.
    LICENSE
    }
    s.author       = { "vicky" => "weiqi@hzdracom.com" }  #作者
    s.platform     = :ios, '7.0'    #支持的系统
    s.source       = { :git => "https://github.com/Vickeywei/WQBannerDisplayView.git",:tag => "0.0.1"  }   #源码地址
    s.source_files  = 'WQImageDisplayView/*.{h,m}'    #源码
    s.requires_arc = true       #是否需要arc

end
