Pod::Spec.new do |s|
  s.name             = "ios-UMSocialHelper"
  s.version          = "0.1.0"
  s.summary          = "umeng message for ios development"

  s.description      = <<-DESC
                       DESC
  s.homepage         = "https://github.com/brivio/ios-UMMessageHelper"
  s.license          = 'MIT'
  s.author           = { "brivio" => "brivio@qq.com" }
  s.source           = { :git => "https://github.com/brivio/ios-UMMessageHelper.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'source/**/*.{h,m,c}'
  s.vendored_libraries  = 'source/**/*.a'
  s.vendored_frameworks  = 'source/**/*.framework'
  s.resources='source/**/*.bundle'
  s.frameworks='Security','SystemConfiguration','CoreGraphics','CoreTelephony'
  s.libraries='iconv','sqlite3','stdc++','z'
end
