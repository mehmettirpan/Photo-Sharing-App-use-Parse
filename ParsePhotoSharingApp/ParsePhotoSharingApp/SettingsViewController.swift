//
//  SettingsViewController.swift
//  ParsePhotoSharingApp
//
//  Created by Mehmet Tırpan on 23.03.2024.
//

import UIKit
import Parse

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func logOutClicked(_ sender: Any) {
        
        PFUser.logOutInBackground { (error) in
            if error != nil {
                let alert = UIAlertController(title: "Hata", message: error?.localizedDescription ?? "Hata", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "toViewController", sender: nil)
            }
        }
    }
    
    
}
