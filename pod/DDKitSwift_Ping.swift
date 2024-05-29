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
    guard let bundlePath = Bundle(for: DDKitSwift_Ping.self).path(forResource: "ping-zxkit", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

//ZXKitPlugin
open class DDKitSwift_Ping: DDKitSwiftPluginProtocol {
    private var tool = DDPingTools()
    
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
        if self.tool.isRunning {
            self.tool.stop()
            return
        }
        DDKitSwift.show(.input(placeholder: self.tool.hostName ?? "www.apple.com", text: self.tool.hostName, endEdit: { [weak self] (url) in
            guard let self = self, !url.isEmpty else { return }
            self.tool.hostName = url
            DDKitSwift.hide()
            DDLoggerSwift.show()
            self.tool.start(pingType: .any, interval: .second(10)) { (response, error) in
                if let error = error {
                    printError(error.localizedDescription)
                } else if let response = response {
                    let time = Int(response.responseTime.second * 1000)
                    printInfo("ping: \(response.pingAddressIP) sent \(response.responseBytes) data bytes, response:  \(time)ms")

                    var backgroundColor = UIColor.dd.color(hexValue: 0x5dae8b)
                    if time >= 100 {
                        backgroundColor = UIColor.dd.color(hexValue: 0xaa2b1d)
                    } else if (time >= 50 && time < 100) {
                        backgroundColor = UIColor.dd.color(hexValue: 0xf0a500)
                    }
                    DDKitSwift.updateFloatButton(config: DDKitSwiftButtonConfig(title: "\(time)ms", backgroundColor: backgroundColor), plugin: self)
                }
            }
        }))
    }
    
    public var isRunning: Bool {
        return self.tool.isRunning
    }
    
    public func stop() {
        self.tool.stop()
    }
}
