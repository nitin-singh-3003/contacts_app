//
//  SettingsViewController.swift
//  Contacts
//
//  Created by Nitin Singh on 29/01/20.
//  Copyright © 2020 Nitin Singh. All rights reserved.
//

import UIKit

protocol SettingsProviderProtocol: class {
    func sortBy(_ sortBy: SortBy)
}

enum SortBy {
    case name
    case number
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsProviderProtocol?
    var sortingMethod: SortBy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onNameTextClicked() {
        sortingMethod = .name
        delegate?.sortBy(.name)
    }
    
    @IBAction func onClickDismiss() {
        self.navigationController?.popViewController(animated: true)
    }
}


