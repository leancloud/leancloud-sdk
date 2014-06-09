//
//  TPUploadImageViewController.h
//  TutorialAVOSCloud
//
//

#import <UIKit/UIKit.h>

@interface UploadImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>


@property (nonatomic, strong) UIImageView *imgToUpload;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) NSString *username;

-(void)selectPicturePressed:(id)sender;

@end
