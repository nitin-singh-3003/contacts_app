//
//  SettingsViewController.swift
//  Contacts
//
//  Created by Nitin Singh on 29/01/20.
//  Copyright © 2020 Nitin Singh. All rights reserved.
//

import UIKit

protocol SettingsProviderProtocol: class {
    func sortBy(_ sortBy: String)
}

enum SortBy: String {
    case name
    case number
    case userDefault
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsProviderProtocol?
    var sortingMethod: SortBy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onNameTextClicked() {
        
        sortingMethod = .name
        delegate?.sortBy(SortBy.name.rawValue)
        
        
    }
    
    @IBAction func resetUserDefault(_ sender: Any) {
        delegate?.sortBy(SortBy.userDefault.rawValue)
        UserDefaults.standard.set("", forKey: "Sorted")
    }
    
    @IBAction func onClickDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}



