//
//  ViewController.swift
//  SocialLogin
//
//  Created by Md. Mahadhi Hassan Chowdhury on 10/29/18.
//  Copyright © 2018 Md. Mahadhi Hassan Chowdhury. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    var myInfo: Array = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In view did load")
        
        //used for programatically creating login button
        /*
                 let loginButton = FBSDKLoginButton()
                 view.addSubview(loginButton)
                 loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50  )
         
         */
        
        loginButton.delegate  = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        print("Did Log Out of Facebook")
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print(error)
            return
        }
        
        print("successfully logged in")
        showDetails()
    }
    
    func showDetails()  {
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.type(large)"]).start{
            (connection, result, err) in
            if err != nil {
                print("Failed graph", err!)
                return
            }
            print(result!)
            
            let dict = result as! NSDictionary
            print(dict)
            self.goToAnotherView(dict: dict)
           
        }
    }
    
    func goToAnotherView(dict: NSDictionary) {
        
        let name : String = dict["name"] as! String
        let id : String = dict["id"] as! String
        let email : String = dict["email"] as! String
        let imgUrl : String = ((dict.object(forKey: "picture") as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "url") as! String
        print(imgUrl)
        
        let myInfo = MyInfo()
        myInfo.id = id
        myInfo.name = name
        myInfo.email = email
        myInfo.imgUrl = imgUrl
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyBoard.instantiateViewController(withIdentifier: "MyDetailsViewController") as! MyDetailsViewController
        // self.present(newViewController, animated: true, completion: nil)
        newVC.detailsInfo = myInfo
        //self.navigationController?.pushViewController(newVC, animated: true)
        self.present(newVC, animated: true, completion: nil)
    }
    
}

