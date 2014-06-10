//
//  LoginViewController.swift
//  TutorialAVOSCloud-Swift
//
//  Created by Qihe Bian on 6/9/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var userTextField:UITextField?
    var passwordTextField:UITextField?
    
    override func loadView() {
        super.loadView()
        var scrollView:UIScrollView = UIScrollView(frame:super.view.frame)
        self.view = scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Log In"
        self.view.backgroundColor = RGB(50, 50, 50)
        
        var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "keyboardHide:")
        tapGestureRecognizer.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        var textField:UITextField = UITextField(frame: CGRectMake(0, 0, 218, 31))
        textField.center = CGPointMake(self.view.frame.size.width/2, 35)
        textField.font = UIFont.systemFontOfSize(14)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(textField)
        self.userTextField = textField;
        
        textField = UITextField(frame: CGRectMake(0, 0, 218, 31))
        textField.center = CGPointMake(self.view.frame.size.width/2, 75)
        textField.font = UIFont.systemFontOfSize(14)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.secureTextEntry = true
        self.view.addSubview(textField)
        self.passwordTextField = textField
        
        self.userTextField!.placeholder = "Your User name"
        self.userTextField!.text = ""
        self.passwordTextField!.placeholder = "Your password"
        self.passwordTextField!.text = ""
        
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 218, 37);
        button.center = CGPointMake(self.view.frame.size.width/2, 120);
        button.setTitleColor(RGB(0, 145, 255), forState: UIControlState.Normal)
        button.setTitle("Log In", forState: UIControlState.Normal)
        button.addTarget(self, action: "logInPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
        
        var label:UILabel = UILabel(frame: CGRectMake(85, 156, 0, 0))
        label.textColor = UIColor.whiteColor()
        label.text = "New user?"
        label.font = UIFont.systemFontOfSize(17)
        label.sizeToFit()
        self.view.addSubview(label)
        
        button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(188, 148, 81, 37);
        button.setTitleColor(RGB(0, 145, 255), forState: UIControlState.Normal)
        button.setTitle("Sign Up", forState: UIControlState.Normal)
        button.addTarget(self, action: "registerPressed:", forControlEvents: UIControlEvents.TouchUpInside)
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
    func logInPressed(sender:AnyObject) {
        AVUser.logInWithUsernameInBackground(self.userTextField!.text, password: self.passwordTextField!.text, block: {
            user, error in
            if (user) {
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
    
    func registerPressed(sender:AnyObject) {
        var vc:RegisterViewController = RegisterViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func keyboardHide(tap:UITapGestureRecognizer) {
        self.userTextField!.resignFirstResponder()
        self.passwordTextField!.resignFirstResponder()
    }
    
}
