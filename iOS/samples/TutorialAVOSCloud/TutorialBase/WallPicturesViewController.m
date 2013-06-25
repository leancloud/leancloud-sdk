//
//  WallPicturesViewController.m
//  TutorialAVOSCloud
//
//

#import "WallPicturesViewController.h"
#import "UploadImageViewController.h"

#import <AVOSCloud/AVOSCloud.h>

#import "Constants.h"

@interface WallPicturesViewController () {

}

@property (nonatomic, retain) NSArray *wallObjectsArray;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;


-(void)getWallImages;
-(void)loadWallViews;
-(void)showErrorView:errorString;

@end

@implementation WallPicturesViewController

@synthesize wallObjectsArray = _wallObjectsArray;
@synthesize wallScroll = _wallScroll;
@synthesize activityIndicator = _loadingSpinner;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.wallScroll = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]){
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }

    //Reload the wall
    [self getWallImages];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark Wall Load
//Load the images on the wall
//Load the images on the wall
-(void)loadWallViews
{
    //Clean the scroll view
    for (id viewToRemove in [self.wallScroll subviews]){
        
        if ([viewToRemove isMemberOfClass:[UIView class]])
            [viewToRemove removeFromSuperview];
    }
    
    
    //For every wall element, put a view in the scroll
    int originY = 10;
    
    for (AVObject *wallObject in self.wallObjectsArray){
        
        
        //Build the view with the image and the comments
        UIView *wallImageView = [[UIView alloc] initWithFrame:CGRectMake(10, originY, self.view.frame.size.width - 20 , 300)];
        
        //Add the image
        AVFile *image = (AVFile *)[wallObject objectForKey:KEY_IMAGE];
        UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageWithData:image.getData]];
        userImage.frame = CGRectMake(0, 0, wallImageView.frame.size.width, 200);
        [wallImageView addSubview:userImage];
        
        //Add the info label (User and creation date)
        NSDate *creationDate = wallObject.createdAt;
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm dd/MM yyyy"];
        
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, wallImageView.frame.size.width,15)];
        infoLabel.text = [NSString stringWithFormat:@"Uploaded by: %@, %@", [wallObject objectForKey:KEY_USER], [df stringFromDate:creationDate]];
        infoLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:9];
        infoLabel.textColor = [UIColor whiteColor];
        infoLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:infoLabel];
        
        //Add the comment
        UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 240, wallImageView.frame.size.width, 15)];
        commentLabel.text = [wallObject objectForKey:KEY_COMMENT];
        commentLabel.font = [UIFont fontWithName:@"ArialMT" size:13];
        commentLabel.textColor = [UIColor whiteColor];
        commentLabel.backgroundColor = [UIColor clearColor];
        [wallImageView addSubview:commentLabel];
        
        [self.wallScroll addSubview:wallImageView];
        
        
        originY = originY + wallImageView.frame.size.width + 20;
        
    }
    
    //Set the bounds of the scroll
    self.wallScroll.contentSize = CGSizeMake(self.wallScroll.frame.size.width, originY);
    
    //Remove the activity indicator
    [self.activityIndicator stopAnimating];
    [self.activityIndicator removeFromSuperview];
}



#pragma mark Receive Wall Objects

//Get the list of images
-(void)getWallImages
{
    //Prepare the query to get all the images in descending order
    AVQuery *query = [AVQuery queryWithClassName:WALL_OBJECT];
    [query orderByDescending:KEY_CREATION_DATE];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            //Everything was correct, put the new objects and load the wall
            self.wallObjectsArray = nil;
            self.wallObjectsArray = [[NSArray alloc] initWithArray:objects];
            
            [self loadWallViews];
            
        } else {
            //Remove the activity indicator
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            
            //Show the error
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
    }];

}


#pragma mark IB Actions


-(IBAction)logoutPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark Error Alert

-(void)showErrorView:(NSString *)errorMsg{
    
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}


@end
