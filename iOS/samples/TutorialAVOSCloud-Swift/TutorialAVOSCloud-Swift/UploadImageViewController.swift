//
//  UploadImageViewController.swift
//  TutorialAVOSCloud-Swift
//
//  Created by Qihe Bian on 6/9/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

import UIKit

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imgToUpload:UIImageView?
    var commentTextField:UITextField?
    //    var username:NSString?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    override func loadView() {
        super.loadView()
        var scrollView:UIScrollView = UIScrollView(frame:super.view.frame)
        self.view = scrollView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Upload"
        self.view.backgroundColor = RGB(50, 50, 50)
        
        var item:UIBarButtonItem = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Plain, target: self, action: "sendPressed:")
        self.navigationItem.rightBarButtonItem = item
        
        var tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "keyboardHide:")
        tapGestureRecognizer.cancelsTouchesInView = false;
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        var textField:UITextField = UITextField(frame: CGRectMake(20, 33, self.view.frame.size.width - 40, 31))
        textField.center = CGPointMake(self.view.frame.size.width/2, 35)
        textField.font = UIFont.systemFontOfSize(14)
        textField.borderStyle = UITextBorderStyle.RoundedRect
        textField.placeholder = "Comment"
        self.view.addSubview(textField)
        self.commentTextField = textField
        
        var imageView:UIImageView = UIImageView(frame: CGRectMake(20, 78, self.view.frame.size.width - 40, 170))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit;
        self.view.addSubview(imageView)
        self.imgToUpload = imageView
        
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(20, 266, 124, 37);
        button.setTitleColor(RGB(0, 145, 255), forState: UIControlState.Normal)
        button.setTitle("Select Picture", forState: UIControlState.Normal)
        button.addTarget(self, action: "selectPicturePressed:", forControlEvents: UIControlEvents.TouchUpInside)
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
    func selectPicturePressed(sender:AnyObject) {
        //Open a UIImagePickerController to select the picture
        var imgPicker:UIImagePickerController = UIImagePickerController()
        imgPicker.delegate = self;
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        
        self.navigationController.presentViewController(imgPicker, animated: true, completion: {})
    }
    
    func sendPressed(sender:AnyObject) {
        //Upload a new picture
        var image:UIImage? = self.imgToUpload!.image
        if(image == nil) {
            return
        }
        self.commentTextField!.resignFirstResponder()
        self.navigationItem.rightBarButtonItem.enabled = false
        //Place the loading spinner
        var loadingSpinner:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        loadingSpinner.center = CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)
        loadingSpinner.startAnimating()
        self.view.addSubview(loadingSpinner)
        

        var pictureData:NSData = UIImagePNGRepresentation(self.imgToUpload!.image)
        
        var file:AVFile = AVFile.fileWithName("img", data:pictureData) as AVFile
        var s:UploadImageViewController = self
        file.saveInBackgroundWithBlock({
            succeeded, error in
            if (succeeded){
                
                //Add the image to the object, and add the comments, the user, and the geolocation (fake)
                var imageObject:AVObject = AVObject(className: WALL_OBJECT)
                imageObject.setObject(file, forKey:KEY_IMAGE)
                var u:AVUser = AVUser.currentUser()
                var uname:NSString = u.username
                imageObject.setObject(uname, forKey:KEY_USER)
                var comment:String = self.commentTextField!.text
                if(comment != nil) {
                    imageObject.setObject(comment, forKey:KEY_COMMENT)
                }
                
                var point:AVGeoPoint = AVGeoPoint(latitude:52, longitude:-4)
                imageObject.setObject(point, forKey:KEY_GEOLOC)
                
                imageObject.saveInBackgroundWithBlock({
                    succeeded, error in
                    if (succeeded){
                        //Go back to the wall
                        s.navigationController.popViewControllerAnimated(true)
                    }
                    else{
                        var errorString:NSString? = error.userInfo.objectForKey("error") as? NSString
                        self.showErrorView(errorString)
                    }
                    })
            }
            else{
                var errorString:NSString? = error.userInfo.objectForKey("error") as? NSString
                self.showErrorView(errorString)
            }
            
            loadingSpinner.stopAnimating()
            loadingSpinner.removeFromSuperview()
            
            }, progressBlock:{
                percentDone in
                
            })
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        
        picker.dismissModalViewControllerAnimated(true)
        
        //Place the image in the imageview
        self.imgToUpload!.image = image;
    }
    
    func showErrorView(errorMsg:NSString!) {
        if(errorMsg != nil) {
            var errorAlertView:UIAlertView = UIAlertView(title: "Error", message: errorMsg, delegate: nil, cancelButtonTitle: "OK")
            errorAlertView.show()
        }
    }
    
    func keyboardHide(tap:UITapGestureRecognizer) {
        self.commentTextField!.resignFirstResponder()
    }
}
