//
//  LoginViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 23/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func logInButton(_ sender: UIButton) {
        ApiClient.signIn(email: loginField.text ?? "", password: passwordField.text ?? "") { (result) in
            switch result {
            case .success(let user):
                UserDefaults.standard.setValue(user.data.user.email, forKey: "Email")
                UserDefaults.standard.setValue(user.data.user.authentication_token, forKey: "Token")
                UserDefaults.standard.synchronize()
                let mainScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! MainScreenTabBarViewController
                self.navigationController?.pushViewController(mainScreenViewController, animated: true)
                
            case .failure(let error):
                print(error.localizedDescription)
                let alert = UIAlertController(title: "Wrong login or password", message: "Please try again", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK=(", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let email = UserDefaults.standard.value(forKey: "Email") ?? nil
        let token = UserDefaults.standard.value(forKey: "Token") ?? nil
        
        if (token != nil) {
            if (email != nil) {
                let mainScreenViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainScreen") as! MainScreenTabBarViewController
                self.navigationController?.pushViewController(mainScreenViewController, animated: true)
            }
        }
    }
    
        // Do any additional setup after loading the view.
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
