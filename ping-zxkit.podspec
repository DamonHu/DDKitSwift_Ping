Pod::Spec.new do |s|
s.name = 'ping-zxkit'
s.swift_version = '5.0'
s.version = '2.0.1'
s.license= { :type => "MIT", :file => "LICENSE" }
s.summary = 'PingTools plugin for ZXKit, build by HDPingTools'
s.homepage = 'https://github.com/ZXKitCode/ping-zxkit'
s.authors = { 'ZXKitCode' => 'dong765@qq.com' }
s.source = { :git => "https://github.com/ZXKitCode/ping-zxkit.git", :tag => s.version}
s.requires_arc = true
s.ios.deployment_target = '11.0'
s.resource_bundles = {
    'ping-zxkit' => ['pod/assets/**/*']
}
s.source_files = "pod/zxkit/*.swift"
s.dependency 'ZXKitCore', '~> 2.0'
s.dependency 'HDPingTools', '~> 2.0'
s.documentation_url = 'https://blog.hudongdong.com/ios/1169.html'
end
