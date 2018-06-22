Pod::Spec.new do |s|
  s.name                    = "DaylightUtils"
  s.version                 = "1.0"
  s.summary                 = "A collection of commonly used utility code shared across most projects"
  s.homepage                = "https://github.com/DaylightLtd/ios-utils"
  s.license                 = { :type => "MIT", :file => "LICENSE" }
  s.author                  = { "Ivan Fabijanovic" => "ivan-fabijanovic@live.com" }
  s.ios.deployment_target   = "10.0"
  s.source                  = { :git => "https://github.com/DaylightLtd/ios-utils.git", :tag => "v1.0" }
  s.frameworks              = "Foundation", "UIKit"

  s.dependency              'RxSwift', '~> 4.0'
  s.dependency              'RxCocoa', '~> 4.0'
end

