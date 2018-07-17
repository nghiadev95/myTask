//
//  ProfileViewController.swift
//  myTask
//
//  Created by Nghia Nguyen on 7/16/18.
//  Copyright © 2018 Quang Nghia. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnUpdate.roundedButton(byCorners: [.allCorners], cornerRadii: CGSize(width: btnUpdate.frame.width/2, height: btnUpdate.frame.width/2))
        tfName.text = user.name
    }
    
    @IBAction func btnUpdatePressed(_ sender: Any) {
        guard let name = tfName.text, !name.isEmpty else {
            makeToast(message: "Name must not be empty")
            return
        }
        UserService.shared.update(user: user, name: name) { [weak self] (isSuccess) in
            if isSuccess {
                self?.makeToast(message: "Update Name successful")
            } else {
                self?.makeToast(message: "Have an error when update name")
            }
            self?.pop(animated: true)
        }
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        pop(animated: true)
    }
}
