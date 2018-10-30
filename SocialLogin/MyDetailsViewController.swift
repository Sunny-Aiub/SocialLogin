//
//  MyDetailsViewController.swift
//  SocialLogin
//
//  Created by Md. Mahadhi Hassan Chowdhury on 10/29/18.
//  Copyright © 2018 Md. Mahadhi Hassan Chowdhury. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class MyDetailsViewController: UIViewController {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var myImgView: UIImageView!
    
    
    var detailsInfo = MyInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(detailsInfo.name)
        
        lblId.text = detailsInfo.id
        lblName.text = detailsInfo.name
        lblEmail.text = detailsInfo.email
        getProfilePicture()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnLogOutAction(_ sender: Any) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backTPreviousController(_ sender: Any) {
        
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func getProfilePicture() {
        
        if let url = NSURL(string: detailsInfo.imgUrl) {
            if let data = NSData(contentsOf: url as URL){
                self.myImgView.image = UIImage(data: data as Data)
            }
        }

    }
}

