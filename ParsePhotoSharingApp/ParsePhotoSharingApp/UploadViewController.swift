//
//  UploadViewController.swift
//  ParsePhotoSharingApp
//
//  Created by Mehmet Tırpan on 23.03.2024.
//

import UIKit
import Parse

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var yorumTextField: UITextField!
    
    @IBOutlet weak var paylasButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let keyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeyiSakla))
        view.addGestureRecognizer(keyboardRecognizer)
        
        imageView.isUserInteractionEnabled = true // kullanıcı bununla iletişime geçebilir üstüne tıklayabilir
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        paylasButton.isEnabled = false
    }
    

    @objc func gorselSec() {
        // Kullanıcıya fotoğraf seçme yöntemini seçtirecek olan menüyü oluşturur.
        let actionSheet = UIAlertController(title: "Select a Photo", message: "Choose a source", preferredStyle: .actionSheet)
        
        // Eğer cihazda kamera kullanılabilir durumdaysa, 'Camera' seçeneğini ekler.
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
                self?.presentPicker(sourceType: .camera) // Kamera arayüzünü açar.
            }))
        }
        
        // 'Photo Library' seçeneğini ekler. Kullanıcı bu seçeneği seçtiğinde fotoğraf kütüphanesi arayüzünü açar.
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            self?.presentPicker(sourceType: .photoLibrary)
        }))
        
        // 'Cancel' seçeneğini ekler. Bu seçenek menüyü kapatır.
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Menüyü ekranda gösterir.
        present(actionSheet, animated: true)
    }

    private func presentPicker(sourceType: UIImagePickerController.SourceType) {
        // UIImagePickerController nesnesi oluşturur ve ayarlarını yapılandırır.
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil) // Picker arayüzünü açar.
    }

    // UIImagePickerControllerDelegate metodları
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Kullanıcı bir görsel seçtiğinde bu metod çağrılır. Seçilen görseli imageView'a atar.
        imageView.image = info[.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil) // Picker arayüzünü kapatır.
        paylasButton.isEnabled = true // Paylaş butonunu etkinleştirir.
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Kullanıcı seçim yapmadan picker arayüzünü kapattığında bu metod çağrılır.
        picker.dismiss(animated: true, completion: nil) // Picker arayüzünü kapatır.
    }

    @objc func klavyeyiSakla(){
        view.endEditing(true)
    }
    
    @IBAction func shareButtonClicked(_ sender: Any) {
        paylasButton.isEnabled = false // paylaş butonuna defalarca basmasın diye devre dışı bıraktık
        
        let post = PFObject(className: "Post")
        
       
//        // görseli dataya çevirip eklemek gerekli, parse ın kedni dosyalama sınıfndan faydalanacağız
        let data = imageView.image?.jpegData(compressionQuality: 0.5)
        if let data = data{
            if PFUser.current() != nil{
                let parseImage = PFFileObject(name: "image.jpg", data: data)
                
                post["postgorsel"] = parseImage
                post["postyorum"] = yorumTextField.text!
                post["postsahibi"] = PFUser.current()!.username!
                
                post.saveInBackground { success, error in
                    if error != nil{
                        let alert = UIAlertController(title: "Hata", message: error?.localizedDescription, preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okButton)
                        self.present(alert, animated: true, completion: nil)
                    }else{ // hata yoksa yani başarıyla kaydetmişse
                        
                        self.yorumTextField.text = ""
                        self.imageView.image = UIImage(named: "Click to add photo") // imageView'ın adı (asset deki)
                        self.tabBarController?.selectedIndex = 0
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Yeni Post"), object: nil)
                    }
                }
            }
        }
    }
    
    
    

}
