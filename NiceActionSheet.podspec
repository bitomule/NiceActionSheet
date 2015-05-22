#
#  Be sure to run `pod spec lint NSDate+RelativeFormatter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "NiceActionSheet"
  s.version      = "0.1.1"
  s.summary      = "Custom UIViewController displayed as action sheet with better style."

  s.description  = <<-DESC
                  UIViewController displayed as action sheeet with better style.
                  * Allows multiple rows
                  * Easy tu customize
                  * Uses auto layout
                  * Displayed with a nice animation
                   DESC

  s.homepage     = "https://github.com/bitomule/NiceActionSheet"
  s.license      = "MIT"


  s.author             = { "David Collado Sela" => "bitomule@gmail.com" }
  s.social_media_url   = "http://twitter.com/bitomule"

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/bitomule/NiceActionSheet.git", :tag => "0.1.1" }

  s.source_files = 'Source/*.swift'
  s.dependency 'EasyConstraints', '~> 0.1.0'
  s.requires_arc = true

end
