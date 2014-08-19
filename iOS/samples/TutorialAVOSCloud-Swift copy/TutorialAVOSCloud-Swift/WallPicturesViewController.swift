//
//  WallPicturesViewController.swift
//  TutorialAVOSCloud-Swift
//
//  Created by Qihe Bian on 6/10/14.
//  Copyright (c) 2014 AVOS. All rights reserved.
//

import UIKit

let imageViewTag:Int = 1001
let infoViewTag:Int = 1002
let commentViewTag:Int = 1003

class WallPicturesViewController: UITableViewController {
    var wallObjectsArray:NSArray?
    var activityIndicator:UIActivityIndicatorView?
    
    convenience init() {
        self.init(style: UITableViewStyle.Plain)
    }
    
    init(style: UITableViewStyle) {
        super.init(style: style)
        // Custom initialization
    }

    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Wall"
        self.view.backgroundColor = RGB(50, 50, 50)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        var item:UIBarButtonItem = UIBarButtonItem(title: "Upload", style: UIBarButtonItemStyle.Plain, target: self, action: "goUpload:")
        self.navigationItem.rightBarButtonItem = item
        
        item = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logoutPressed:")
        self.navigationItem.leftBarButtonItem = item
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.getWallImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // #pragma mark - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if(self.wallObjectsArray){
            return self.wallObjectsArray!.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 300
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
        var imageView:UIImageView? = cell.contentView.viewWithTag(imageViewTag) as? UIImageView
        if(imageView == nil) {
            var originY:Float = 10
            cell.backgroundColor = RGB(50, 50, 50)
            //Add the image
            imageView = UIImageView(frame: CGRectMake(0, 0, tableView.frame.size.width, 200))
            imageView!.frame = CGRectMake(0, 0, tableView.frame.size.width, 200);
            imageView!.contentMode = UIViewContentMode.ScaleAspectFit;
            imageView!.tag = imageViewTag
            cell.contentView.addSubview(imageView)
            
            //Add the info label (User and creation date)
            var label:UILabel = UILabel(frame: CGRectMake(0, 210, tableView.frame.size.width,15))
            label.font = UIFont(name: "Arial-ItalicMT", size: 9)
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.clearColor()
            label.tag = infoViewTag
            cell.contentView.addSubview(label)
            
            //Add the comment
            label = UILabel(frame: CGRectMake(0, 240, tableView.frame.size.width, 15))
            label.font = UIFont(name: "ArialMT", size: 13)
            label.textColor = UIColor.whiteColor()
            label.backgroundColor = UIColor.clearColor()
            label.tag = commentViewTag
            cell.contentView.addSubview(label)
            
        }
        var wallObject:AVObject = self.wallObjectsArray?.objectAtIndex(indexPath.row) as AVObject
        var image:AVFile = wallObject.objectForKey(KEY_IMAGE) as AVFile
        imageView!.image = UIImage(data: image.getData())
        
        var label:UILabel? = cell.contentView.viewWithTag(infoViewTag) as? UILabel
        var creationDate:NSDate = wallObject.createdAt
        var df:NSDateFormatter = NSDateFormatter()
        df.dateFormat = "HH:mm dd/MM yyyy"
        var u:NSString = wallObject.objectForKey(KEY_USER) as NSString
        var d:String = df.stringFromDate(creationDate)
        label!.text = "Uploaded by: \(u), \(d)"
        
        label = cell.contentView.viewWithTag(commentViewTag) as? UILabel
        label!.text = wallObject.objectForKey(KEY_COMMENT) as? NSString

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView?, canEditRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView?, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath?) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView?, moveRowAtIndexPath fromIndexPath: NSIndexPath?, toIndexPath: NSIndexPath?) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView?, canMoveRowAtIndexPath indexPath: NSIndexPath?) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
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
                
                self.tableView.reloadData()
                
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
