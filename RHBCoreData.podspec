Pod::Spec.new do |s|
    s.name             = 'RHBCoreData'
    s.version          = '1.1.0'
    s.summary          = 'CoreData extensions and stuff.'

    s.description      = <<-DESC
    RHBCoreData provides CoreData extensions and stuff.
                       DESC

    s.homepage         = "https://github.com/sisoje/#{s.name}"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Lazar Otasevic' => 'redhotbits@gmail.com' }
    s.source           = { :git => "https://github.com/sisoje/#{s.name}.git", :tag => s.version.to_s }
    s.social_media_url = 'https://twitter.com/redhotbits'
    s.documentation_url = "https://raw.githubusercontent.com/sisoje/#{s.name}/master/README.md"

    s.swift_version = '5.0'
    s.platforms = { :ios => "10.3", :watchos => "3.0", :tvos => "10.0", :osx => "10.12" }
    s.source_files = 'Sources/**/*'
    s.dependency 'RHBFoundation'
    s.test_spec 'RHBCoreDataTests' do |test_spec|
        test_spec.dependency 'RHBFoundationTestUtilities'
        test_spec.dependency 'RHBCoreDataTestUtilities'
        test_spec.requires_app_host = false
        test_spec.source_files = 'Tests/**/*'
    end
end
