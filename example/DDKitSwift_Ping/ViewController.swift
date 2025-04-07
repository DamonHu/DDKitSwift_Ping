//
//  ViewController.swift
//  ping-zxkit
//
//  Created by Damon on 2023/4/17.
//

import UIKit
import DDKitSwift
import DDPingTools

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
        let plugin = DDKitSwift_Ping(url: "https://baidu.com")
        DDKitSwift.regist(plugin: plugin)
    }

    func createUI() {
        self.view.backgroundColor = UIColor.white
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 60))
        button.setTitle("开始测试", for: .normal)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(_start), for: .touchUpInside)
    }

    @objc func _start() {
        DDKitSwift.show()
    }
}

