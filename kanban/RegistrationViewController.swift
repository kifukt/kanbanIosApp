//
//  RegistrationViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 23/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    let backgroundColor = AppColor.beige
    let textColor = AppColor.blue
    let buttonColor = AppColor.orange
    let textFieldColor = AppColor.yellow
    
    @IBOutlet weak var registrationLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmationTextField: UITextField!
    
    @IBOutlet weak var registerButtonLabel: UIButton!
    
    @IBAction func registerButton(_ sender: UIButton) {
        ApiClient.register(with: emailTextField.text ?? "",
                           password: passwordTextField.text ?? "",
                           passwordConfirmation: confirmationTextField.text ?? "") { (result) in
                            if result {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let mainScreenViewController = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC")
                                self.navigationController?.pushViewController(mainScreenViewController, animated: true)
                            } else {
                                let alert = UIAlertController(title: "This e-mail has already registered", message: "Please try again", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK=(", style: .cancel, handler: nil))
                                self.present(alert, animated: true)
                            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = false
        
        self.view.backgroundColor = backgroundColor
        
        registrationLabel.textColor = textColor
        registrationLabel.font = registrationLabel.font.withSize(30)
        
        emailTextField.backgroundColor = textFieldColor
        
        passwordTextField.backgroundColor = textFieldColor
        
        confirmationTextField.backgroundColor = textFieldColor
        
        registerButtonLabel.setTitleColor(textColor, for: .normal)
    }

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
