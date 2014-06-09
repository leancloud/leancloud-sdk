//
//  TPUploadImageViewController.m
//  TutorialAVOSCloud
//
//

#import "UploadImageViewController.h"

#import <AVOSCloud/AVOSCloud.h>

#import "Constants.h"

@interface UploadImageViewController ()

-(void)showErrorView:(NSString *)errorMsg;

@end

@implementation UploadImageViewController

@synthesize imgToUpload = _imgToUpload;
@synthesize username = _username;
@synthesize commentTextField = _commentTextField;

- (void)loadView {
    [super loadView];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:super.view.frame];
    self.view = scrollView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Upload";
    self.view.backgroundColor = RGB(50, 50, 50);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(sendPressed:)];
    self.navigationItem.rightBarButtonItem = item;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 33, self.view.frame.size.width - 40, 31)];
    textField.center = CGPointMake(self.view.frame.size.width/2, 35);
    textField.font = [UIFont systemFontOfSize:14];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Comment";
    [self.view addSubview:textField];
    self.commentTextField = textField;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 78, self.view.frame.size.width - 40, 170)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    self.imgToUpload = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 266, 124, 37);
    [button setTitleColor:RGB(0, 145, 255) forState:UIControlStateNormal];
    [button setTitle:@"Select Picture" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectPicturePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Actions

-(void)selectPicturePressed:(id)sender
{
    //Open a UIImagePickerController to select the picture
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self.navigationController presentViewController:imgPicker animated:YES completion:^{
        
    }];
}

-(void)sendPressed:(id)sender
{
    [self.commentTextField resignFirstResponder];
    
    //Disable the send button until we are ready
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    //Place the loading spinner
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [loadingSpinner setCenter:CGPointMake(self.view.frame.size.width/2.0, self.view.frame.size.height/2.0)];
    [loadingSpinner startAnimating];
    [self.view addSubview:loadingSpinner];
    
    //Upload a new picture
    NSData *pictureData = UIImagePNGRepresentation(self.imgToUpload.image);
    
    AVFile *file = [AVFile fileWithName:@"img" data:pictureData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (succeeded){
            
            //Add the image to the object, and add the comments, the user, and the geolocation (fake)
            AVObject *imageObject = [AVObject objectWithClassName:WALL_OBJECT];
            [imageObject setObject:file forKey:KEY_IMAGE];
            [imageObject setObject:[PFUser currentUser].username forKey:KEY_USER];
            [imageObject setObject:self.commentTextField.text forKey:KEY_COMMENT];
            
            AVGeoPoint *point = [AVGeoPoint geoPointWithLatitude:52 longitude:-4];
            [imageObject setObject:point forKey:KEY_GEOLOC];
            
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if (succeeded){
                    //Go back to the wall
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                    NSString *errorString = [[error userInfo] objectForKey:@"error"];
                    [self showErrorView:errorString];
                }
            }];
        }
        else{
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            [self showErrorView:errorString];
        }
        
        [loadingSpinner stopAnimating];
        [loadingSpinner removeFromSuperview];       
        
    } progressBlock:^(int percentDone) {
        
    }];
}

#pragma mark UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{
    
    [picker dismissModalViewControllerAnimated:YES];
    
    //Place the image in the imageview
    self.imgToUpload.image = img;
}

#pragma mark Error View


-(void)showErrorView:(NSString *)errorMsg
{
    UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMsg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [errorAlertView show];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.commentTextField resignFirstResponder];
}
@end
