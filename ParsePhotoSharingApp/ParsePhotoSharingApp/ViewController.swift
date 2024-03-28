//
//  ViewController.swift
//  ParsePhotoSharingApp
//
//  Created by Mehmet Tırpan on 22.03.2024.
//

import UIKit
import Parse

class ViewController: UIViewController {

    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        

    }
    
    
         
    @IBAction func logInClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != "" {
            
            PFUser.logInWithUsername(inBackground: usernameText.text!, password: passwordText.text!) { user, error in
                if error != nil{
                    self.hataMesajGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata")
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        }else{
            self.hataMesajGoster(title: "Hata!", message: "Kullanıcı adı ve parola Girmelisiniz")
        }
    }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if usernameText.text != "" && passwordText.text != ""{
            let user = PFUser()
            user.username = usernameText.text
            user.password = passwordText.text
            
            user.signUpInBackground { succes, error in
                if error != nil{
                    self.hataMesajGoster(title: "Hata!", message: error?.localizedDescription ?? "Hata") // ??"Hata" eğer hata mesajı yoksa bu hatayı yaz demek
                }else{
                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                }
            }
        } else {
            hataMesajGoster(title: "Hata!", message: "Kullanıcı Adı ve Parola Girmelisiniz")
        }
    }
    
    
    
    func hataMesajGoster(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

