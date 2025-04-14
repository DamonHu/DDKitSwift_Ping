//
//  DDPingViewController.swift
//  DDKitSwift_Ping
//
//  Created by Damon on 2025/4/14.
//

import UIKit
import DDPingTools

class DDPingViewController: UIViewController {
    private var logList = [String]()
    private var pingTool: DDPingTools?
    var defaultUrl: String? {
        didSet {
            let text = defaultUrl?.replacingOccurrences(of: "http://", with: "")
            self.mTextField.text = text?.replacingOccurrences(of: "https://", with: "")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._createUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.pingTool?.stop()
    }
    

    //MARK: UI
    lazy var mTextField: UITextField = {
        let tTextField = UITextField()
        tTextField.keyboardType = .URL
        tTextField.translatesAutoresizingMaskIntoConstraints = false
        tTextField.font = .systemFont(ofSize: 14)
        tTextField.textColor = UIColor.dd.color(hexValue: 0x000000)
        tTextField.leftViewMode = .always
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 80, height: 40))
        view.backgroundColor = UIColor.dd.color(hexValue: 0xeeeeee)
        let label = UILabel(frame: CGRect.init(x: 10, y: 0, width: 60, height: 40))
        view.addSubview(label)
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.text = "https://"
        tTextField.leftView = view
        tTextField.layer.borderWidth = 1
        tTextField.layer.borderColor = UIColor.dd.color(hexValue: 0xcccccc).cgColor
        return tTextField
    }()
    
    lazy var mStartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitle("Stop", for: .selected)
        button.setTitleColor(UIColor.dd.color(hexValue: 0xffffff), for: .normal)
        button.setBackgroundImage(UIImage.dd.getImage(color: UIColor.dd.color(hexValue: 0x409eff)), for: .normal)
        button.setBackgroundImage(UIImage.dd.getImage(color: UIColor.dd.color(hexValue: 0xb8272c)), for: .selected)
        button.addTarget(self, action: #selector(_pingChange), for: .touchUpInside)
        return button
    }()
    
    lazy var mLogTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: .plain)
        tTableView.translatesAutoresizingMaskIntoConstraints = false
        tTableView.contentInsetAdjustmentBehavior = .never
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.backgroundColor = UIColor.clear
        tTableView.separatorStyle = .singleLine
        tTableView.delegate = self
        tTableView.dataSource = self
        tTableView.register(DDPingTableViewCell.self, forCellReuseIdentifier: "DDPingTableViewCell")
        tTableView.rowHeight = UITableView.automaticDimension
        return tTableView
    }()

}

extension DDPingViewController {
    func _createUI() {
        self.view.backgroundColor = UIColor.dd.color(hexValue: 0xffffff)
        
        self.view.addSubview(mTextField)
        mTextField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        mTextField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        mTextField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        mTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(mStartButton)
        mStartButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 50).isActive = true
        mStartButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -50).isActive = true
        mStartButton.topAnchor.constraint(equalTo: self.mTextField.bottomAnchor, constant: 16).isActive = true
        mStartButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.view.addSubview(mLogTableView)
        mLogTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        mLogTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        mLogTableView.topAnchor.constraint(equalTo: self.mStartButton.bottomAnchor, constant: 40).isActive = true
        mLogTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
    }
    
    func _loadData() {
        
    }
    
    @objc func _pingChange() {
        self.mTextField.resignFirstResponder()
        if  self.mStartButton.isSelected {
            self.pingTool?.stop()
            self.mStartButton.isSelected = false
            return
        }
        self.logList = []
        self.mStartButton.isSelected = true
        guard let url = URL(string: "https://" + (self.mTextField.text ?? "")) else { return }
        self.pingTool = DDPingTools(url: url)
        self.pingTool?.debugLog = false
        self.pingTool?.start(pingType: .any, interval: .second(3), complete: { [weak self] response, error in
            guard let self = self else { return }
            if let error = error {
                self.logList.insert("error: \(error)", at: 0)
            } else if let response = response {
                self.logList.insert("ip=\(response.pingAddressIP) bytes=\(response.responseBytes) time=\(response.responseTime.second * 1000)", at: 0)
            }
            self.mLogTableView.reloadData()
        })
    }
}

extension DDPingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.logList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DDPingTableViewCell") as! DDPingTableViewCell
        cell.selectionStyle = .none
        let model = self.logList[indexPath.row]
        cell.updateUI(text: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
