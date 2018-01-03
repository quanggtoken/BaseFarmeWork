#
# Be sure to run `pod lib lint BaseFramework.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BaseFramework'
  s.version          = '0.1.3'
  s.summary          = 'A short description of BaseFramework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/quanggtoken/BaseFarmework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'quang.le@gtoken.com' => 'levietquangt2@gmail.com' }
  s.source           = { :git => 'https://github.com/quanggtoken/BaseFarmework.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BaseFramework/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BaseFramework' => ['BaseFramework/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire', '~> 4.5'
  s.dependency 'SwiftyJSON'
  s.dependency 'ObjectMapper', '~> 3.1'
  s.dependency 'SnapKit', '~> 4.0.0'
  s.dependency 'Kingfisher', '~> 4.0'
  s.dependency 'Localize-Swift', '~> 2.0'
  s.dependency 'EKAlgorithms', '~> 0.2'
  s.dependency 'Zip', '~> 1.1'
  s.dependency 'FileBrowser', '~> 1.0'
  s.dependency 'SVProgressHUD', '~> 2.2.2'
  s.dependency 'SDWebImage'
  s.dependency 'IQKeyboardManagerSwift', '5.0.0'
  s.dependency 'SPTPersistentCache', '~> 1.1.0'
  s.dependency 'IQKeyboardManagerSwift', '5.0.0'
  s.dependency 'OAuthSwift', '1.2.0'
  s.dependency 'RNCryptor', '5.0.2'
end
