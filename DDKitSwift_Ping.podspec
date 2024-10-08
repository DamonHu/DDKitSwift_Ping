Pod::Spec.new do |s|
s.name = 'DDKitSwift_Ping'
s.swift_version = '5.0'
s.version = '3.0.6'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'PingTools plugin for ZXKit, build by HDPingTools'
s.homepage = 'https://github.com/DamonHu/DDKitSwift_Ping'
s.authors = { 'DamonHu' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/DamonHu/DDKitSwift_Ping.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '12.0'
s.resource_bundles = {
    'DDKitSwift_Ping' => ['pod/assets/**/*']
}
s.source_files = "pod/*.swift"
s.dependency 'DDKitSwift/core', '~> 3'
s.dependency 'DDPingTools', '~> 3'
s.documentation_url = 'https://github.com/DamonHu/DDKitSwift_Ping'
end
