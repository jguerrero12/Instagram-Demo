//
//  InstaFeedViewController.swift
//  Instagram-Demo
//
//  Created by Jose Guerrero on 3/12/17.
//  Copyright © 2017 Jose Guerrero. All rights reserved.
//

import UIKit
import Parse

class InstaFeedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //UI Elements
    @IBOutlet weak var tableView: UITableView!
    
    //Private Variables
    private var messages: [PFObject]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 240
        tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
        getPosts()
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! InstagramPostTableViewCell
        let post = messages?[indexPath.row]
        
        cell.instagramPost = post
        
        /*
         if let user = message?["user"] as? PFUser {
         cell.userLabel.text = user.username
         }
         else{
         UIView.animate(withDuration: 0.25) { () -> Void in
         let firstView = cell.stackView.arrangedSubviews[0]
         firstView.isHidden = true
         }
         }
         */
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if error == nil {
                self.dismiss(animated: true, completion: {
                    
                })
            }
            else {
                let alert = UIAlertController(title: "Opps!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                // add the OK action to the alert controller
                alert.addAction(OKAction)
                self.present(alert, animated: true) {
                    
                }
            }
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func onRequestPhoto(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        let sizedOrigImage = resize(image: originalImage, newSize: CGSize(width: 1008, height: 756))
        let sizedEditedImage = resize(image: editedImage, newSize: CGSize(width: 1008, height: 756))
        
        dismiss(animated: true, completion: nil)
        
        let alert = UIAlertController(title: "Add a comment...", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Comment..."
        }
        
        let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        alert.addAction(CancelAction)
        let OKAction = UIAlertAction(title: "OK", style: .destructive) { (action) in
            Post.postUserImage(image: originalImage, withCaption: alert.textFields?[0].text, withCompletion: { (success: Bool, error: Error?) in
                if success {
                    print("user posted image!")
                    self.getPosts()
                    self.tableView.reloadData()
                }
                else{
                    let alert = UIAlertController(title: "Opps!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                    // create an OK action
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    // add the OK action to the alert controller
                    alert.addAction(OKAction)
                    self.present(alert, animated: true) {
                        
                    }
                }
            })
        }
        alert.addAction(OKAction)
        
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func getPosts(){
        // construct PFQuery
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            if let posts = posts {
                self.messages = posts
            } else {
                let alert = UIAlertController(title: "Ugh!", message: "\(error!.localizedDescription)", preferredStyle: .alert)
                // create an OK action
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                }
                // add the OK action to the alert controller
                alert.addAction(OKAction)
                self.present(alert, animated: true) {
                    
                }
            }
        }
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
