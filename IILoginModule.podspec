#
# Be sure to run `pod lib lint IILoginModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'IILoginModule'
    s.version          = '0.1.0'
    s.summary          = 'IILoginModule.'

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!

    s.description      = <<-DESC
    cloudplus loginmodule
    DESC

    s.homepage         = 'https://github.com/hatjs880328s/IILoginModule'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'hatjs880328s' => 'shanwzh@inspur.com' }
    s.source           = { :git => 'https://github.com/hatjs880328s/IILoginModule.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

    s.ios.deployment_target = '8.0'

    s.source_files = 'IILoginModule/Classes/**/*.{h,m}'
    s.resource = 'IILoginModule/Classes/**/*.{xib}'

    s.swift_version = '5.0'

    # s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }

    s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES", 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1'}

    # s.pod_target_xcconfig = { 'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES' }

    s.dependency 'IIBLL'
    s.dependency 'IIOCUtis'
    s.dependency 'II18N'
    s.dependency 'IIOCBIZUti'
    s.dependency 'MJExtension'
end
