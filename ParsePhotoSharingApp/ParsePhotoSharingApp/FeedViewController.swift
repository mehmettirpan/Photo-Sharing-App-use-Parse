//
//  FeedViewController.swift
//  ParsePhotoSharingApp
//
//  Created by Mehmet Tırpan on 23.03.2024.
//

import UIKit
import Parse

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    
    var postDizisi = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        verileriAl() // ekran açıldığında verileri almak için
        
        // ekranı yenileme yani veri eklenmiş mi diye kontrol etme
        let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(verileriAl), for: .valueChanged)
            tableView.refreshControl = refreshControl
        
    }
    
//    query yapma --->
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(verileriAl), name: NSNotification.Name(rawValue: "Yeni Post"), object: nil)
    }
    
    @objc func verileriAl(){
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt") // tarihe göre azlarak sırala demek decending olduğu için
        
        query.findObjectsInBackground { objects, error in
            if error != nil{
                self.hataMesaji(title: "Hata", message: error?.localizedDescription ?? "Hata")
            }else{
                if objects != nil {
                    if objects!.count > 0{
                        self.postDizisi.removeAll(keepingCapacity: false)
                        
                        for object in objects! {
                            if let username = object.object(forKey: "postsahibi") as? String{
                                if let userComment = object.object(forKey: "postyorum") as? String {
                                    if let userImage = object.object(forKey: "postgorsel") as? PFFileObject{
                                        let post = Post(username: username, userComment: userComment, userImage: userImage)
                                        self.postDizisi.append(post)
                                    }
                                }
                            }
                            
                        }
                        self.tableView.reloadData()
                    }
                }
            }
        }
        tableView.refreshControl?.endRefreshing()  // ekran yenileme durdurma
    }
    
    func hataMesaji(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
//    ------<
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print("postDizisi count: \(postDizisi.count)") // post dizisi doluluk testi
        return postDizisi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell // feedTableViewCell e ait olduğunu belirttik
        cell.usernameLabel.text = postDizisi[indexPath.row].username
        cell.userCommentLabel.text = postDizisi[indexPath.row].userComment
        postDizisi[indexPath.row].userImage.getDataInBackground { data, error in
            if error == nil {
                if let data = data {
                    cell.postImageView.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    


    
    


}
