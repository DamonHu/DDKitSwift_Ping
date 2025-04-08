//
//  DDPingTools+zxkit.swift
//  DDPingTools
//
//  Created by Damon on 2021/4/29.
//

import Foundation
import DDKitSwift
import DDPingTools
import DDLoggerSwift

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: DDKitSwift_Ping.self).path(forResource: "DDKitSwift_Ping", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

//ZXKitPlugin
open class DDKitSwift_Ping: DDKitSwiftPluginProtocol {
    private var tool: DDPingTools?
    private var url: String
    
    public init(url: String) {
        self.url = url
    }
    
    public var pluginIdentifier: String {
        return "com.ddkit.DDKitSwift_Ping"
    }

    public var pluginIcon: UIImage? {
        return UIImageHDBoundle(named: "HDPingTool.png")
    }

    public var pluginTitle: String {
        return NSLocalizedString("Ping", comment: "")
    }

    public var pluginType: DDKitSwiftPluginType {
        return .ui
    }

    public func start() {
        guard let url = URL(string: self.url) else { return }
        //开始测试
        self.tool = DDPingTools(url: url)
        self.tool?.showNetworkActivityIndicator = .none
        self.tool?.debugLog = false
        self.tool!.start(pingType: .any, interval: .second(5)) { (response, error) in
            if let error = error {
                printError(error.localizedDescription)
            } else if let response = response {
                let time = Int(response.responseTime.second * 1000)
                var backgroundColor = UIColor.dd.color(hexValue: 0x5dae8b)
                if time >= 100 {
                    backgroundColor = UIColor.dd.color(hexValue: 0xaa2b1d)
                } else if (time >= 50 && time < 100) {
                    backgroundColor = UIColor.dd.color(hexValue: 0xf0a500)
                }
                
                let config = DDPluginItemConfig.text(title: NSAttributedString(string: "\(time)ms", attributes: [NSAttributedString.Key.foregroundColor : UIColor.dd.color(hexValue: 0xffffff)]), backgroundColor: backgroundColor)
                DDKitSwift.updateListItem(plugin: self, config: config)
            }
        }
    }
    
    public var isRunning: Bool {
        return self.tool?.isRunning ?? false
    }
    
    public func stop() {
        self.tool?.stop()
        DDKitSwift.updateListItem(plugin: self, config: .default)
    }
}
