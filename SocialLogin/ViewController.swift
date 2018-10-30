//
//  ViewController.swift
//  SocialLogin
//
//  Created by Md. Mahadhi Hassan Chowdhury on 10/29/18.
//  Copyright © 2018 Md. Mahadhi Hassan Chowdhury. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    var myInfo: Array = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        
         print(FBSDKAccessToken.current())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("In view did load")
        //createSignInButtonForFacebook()
        loginButton.delegate  = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        //create Sign In Button for Google
        createSignInButtonForGoogle()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createSignInButtonForGoogle() {
        
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: loginButton.frame.origin.x + 16, y: loginButton.frame.origin.y + 40, width: loginButton.frame.width, height: loginButton.frame.height)
       
        view.addSubview(googleButton)
        
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
        
        self.firebaseAuthenticationUsingFbLogin()
        
        //for fetching fb details
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
    
    
    // for Firebase Authentication with Facebook
    func firebaseAuthenticationUsingFbLogin()  {
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken:accessTokenString)
        
        Auth.auth().signInAndRetrieveData(with: credentials) { (user, error) in
            if error != nil {
                print("Oopps! Invalid Fb User;", error!)
                return
            }
            print("Login Successfull with User:", user!)
            
            let user = Auth.auth().currentUser
            if let user = user {
                let uid = user.uid
                let email = user.email
                let photoURL = user.photoURL
                print("Firebase User EMail:", email! )
                print(uid)
                print(photoURL!)
            }
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
    
    func createSignInButtonForFacebook() {
        //used for programatically creating login button
         let loginButton = FBSDKLoginButton()
         view.addSubview(loginButton)
         loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50  )
    }
    
}

