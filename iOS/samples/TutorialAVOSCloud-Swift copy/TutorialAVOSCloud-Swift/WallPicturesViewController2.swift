//
//  WallPicturesViewController.swift
//  TutorialAVOSCloud-Swift
//
//  Created by Qihe Bian on 6/9/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

import UIKit

class WallPicturesViewController: UIViewController {
    var wallScroll:UIScrollView!
    var wallObjectsArray:NSArray?
    var activityIndicator:UIActivityIndicatorView?
    
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
        
        self.title = "Wall"
        self.view.backgroundColor = RGB(50, 50, 50)
        self.wallScroll = self.view as UIScrollView
        
        var item:UIBarButtonItem = UIBarButtonItem(title: "Upload", style: UIBarButtonItemStyle.Plain, target: self, action: "goUpload:")
        self.navigationItem.rightBarButtonItem = item
        
        item = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutPressed:")
        self.navigationItem.leftBarButtonItem = item
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let subviews:AnyObject[] = self.view.subviews
        if(subviews != nil) {
            for var i:Int = 0; i < subviews.count; ++i {
                var viewToRemove:AnyObject = subviews[i]
                if(viewToRemove.isMemberOfClass(UIView)) {
                    viewToRemove.removeFromSuperview()
                }
            }
        }
        self.getWallImages()
    }
    
    /*
    // #pragma mark - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    func loadWallViews() {
//        var subviews:NSArray = NSArray(objects: self.wallScroll.subviews)
        let subviews:AnyObject[] = self.view.subviews
        if(subviews != nil) {
            for var i:Int = 0; i < subviews.count; ++i {
                var viewToRemove:AnyObject = subviews[i]
                if(viewToRemove.isMemberOfClass(UIView)) {
                    viewToRemove.removeFromSuperview()
                }
            }
        }
        
        var originY:Float = 10;
        
        for  var i:Int = 0; i < self.wallObjectsArray?.count; ++i {
            var wallObject:AVObject = self.wallObjectsArray?.objectAtIndex(i) as AVObject
            
            //Build the view with the image and the comments
            var wallImageView:UIView = UIView(frame: CGRectMake(10, originY, self.view.frame.size.width - 20, 300))
            
            //Add the image
            var image:AVFile = wallObject.objectForKey(KEY_IMAGE) as AVFile
            var userImage:UIImageView = UIImageView(image: UIImage(data: image.getData()))
            userImage.frame = CGRectMake(0, 0, wallImageView.frame.size.width, 200);
            userImage.contentMode = UIViewContentMode.ScaleAspectFit;
            wallImageView.addSubview(userImage)
            
            //Add the info label (User and creation date)
            var creationDate:NSDate = wallObject.createdAt
            var df:NSDateFormatter = NSDateFormatter()
            df.dateFormat = "HH:mm dd/MM yyyy"
            
            var infoLabel:UILabel = UILabel(frame: CGRectMake(0, 210, wallImageView.frame.size.width,15))
            var u:NSString = wallObject.objectForKey(KEY_USER) as NSString
            var d:String = df.stringFromDate(creationDate)
            infoLabel.text = "Uploaded by: \(u), \(d)"
            infoLabel.font = UIFont(name: "Arial-ItalicMT", size: 9)
            infoLabel.textColor = UIColor.whiteColor()
            infoLabel.backgroundColor = UIColor.clearColor()
            wallImageView.addSubview(infoLabel)
            
            //Add the comment
            var commentLabel:UILabel = UILabel(frame: CGRectMake(0, 240, wallImageView.frame.size.width, 15))
            commentLabel.text = wallObject.objectForKey(KEY_COMMENT) as? NSString
            commentLabel.font = UIFont(name: "ArialMT", size: 13)
            commentLabel.textColor = UIColor.whiteColor()
            commentLabel.backgroundColor = UIColor.clearColor()
            wallImageView.addSubview(commentLabel)
            
            self.wallScroll.addSubview(wallImageView)
            
            
            originY = originY + wallImageView.frame.size.width + 20;
            
        }
        
        //Set the bounds of the scroll
        self.wallScroll.contentSize = CGSizeMake(self.wallScroll.frame.size.width, originY);
        
        //Remove the activity indicator
        if(self.activityIndicator){
            self.activityIndicator!.stopAnimating()
            self.activityIndicator!.removeFromSuperview()
        }
    }
    
    //Get the list of images
    func getWallImages() {
        //Prepare the query to get all the images in descending order
        var query:AVQuery = AVQuery(className: WALL_OBJECT)
        query.orderByDescending(KEY_CREATION_DATE)
        query.findObjectsInBackgroundWithBlock ({
            objects, error in
            if (!error) {
                //Everything was correct, put the new objects and load the wall
                self.wallObjectsArray = objects
                
                self.loadWallViews()
                
            } else {
                //Remove the activity indicator
                self.activityIndicator!.stopAnimating()
                self.activityIndicator!.removeFromSuperview()
                
                //Show the error
                var errorString:NSString = error.userInfo.objectForKey("error") as NSString
                self.showErrorView(errorString)
            }
            })
        
    }
    
    func logoutPressed(sender:AnyObject) {
        self.navigationController.popViewControllerAnimated(true)
    }
    
    func goUpload(sender:AnyObject) {
        var vc:UploadImageViewController = UploadImageViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    func showErrorView(errorMsg:NSString) {
        
        var errorAlertView:UIAlertView = UIAlertView(title: "Error", message: errorMsg, delegate: nil, cancelButtonTitle: "OK")
        errorAlertView.show()
    }
}
