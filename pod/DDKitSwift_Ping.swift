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
        let vc = DDPingViewController()
        vc.defaultUrl = self.url
        DDKitSwift.getCurrentNavigationVC()?.pushViewController(vc, animated: true)
    }
    
    public var isRunning: Bool {
        return false
    }
    
    public func stop() {
        
    }
}
