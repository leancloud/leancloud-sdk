//
//  RegisterViewController.swift
//  TutorialAVOSCloud-Swift
//
//  Created by Qihe Bian on 6/9/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    var userRegisterTextField:UITextField?
    var passwordRegisterTextField:UITextField?
    
    override func loadView() {
        super.loadView()
        var scrollView:UIScrollView = UIScrollView(frame:super.view.frame)
        self.view = scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sign Up"
        self.view.backgroundColor = RGB(50, 50, 50)
        
        var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "keyboardHide:")
        tapGestureRecognizer.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        var textField:UITextField = UITextField(frame: CGRectMake(0, 0, 218, 31))
        textField.center = CGPointMake(self.view.frame.size.width/2, 35)
        textField.font = UIFont.systemFontOfSize(14)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(textField)
        self.userRegisterTextField = textField;
        
        textField = UITextField(frame: CGRectMake(0, 0, 218, 31))
        textField.center = CGPointMake(self.view.frame.size.width/2, 75)
        textField.font = UIFont.systemFontOfSize(14)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.secureTextEntry = true
        self.view.addSubview(textField)
        self.passwordRegisterTextField = textField
        
        self.userRegisterTextField!.placeholder = "Username"
        self.userRegisterTextField!.text = ""
        self.passwordRegisterTextField!.placeholder = "Password"
        self.passwordRegisterTextField!.text = ""
        
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 218, 37);
        button.center = CGPointMake(self.view.frame.size.width/2, 120);
        button.setTitleColor(RGB(0, 145, 255), forState: UIControlState.Normal)
        button.setTitle("Sign Up", forState: UIControlState.Normal)
        button.addTarget(self, action: "signUpUserPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    //Login button pressed
    func signUpUserPressed(sender:AnyObject) {
        var user:AVUser = AVUser()
        user.username = self.userRegisterTextField!.text;
        user.password = self.passwordRegisterTextField!.text;
        user.signUpInBackgroundWithBlock({
            succeeded, error in
            if (!error) {
                //Open the wall
                var vc:WallPicturesViewController = WallPicturesViewController()
                self.navigationController.pushViewController(vc, animated: true)
            } else {
                //Something bad has ocurred
                var errorString:NSString = error.userInfo.objectForKey("error") as NSString
                var errorAlertView:UIAlertView = UIAlertView(title: "Error", message: errorString, delegate: nil, cancelButtonTitle: "OK")
                errorAlertView.show()
            }
            })
    }
    
    func keyboardHide(tap:UITapGestureRecognizer) {
        self.userRegisterTextField!.resignFirstResponder()
        self.passwordRegisterTextField!.resignFirstResponder()
    }
}
