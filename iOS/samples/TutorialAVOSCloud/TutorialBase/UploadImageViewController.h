//
//  TPUploadImageViewController.h
//  TutorialAVOSCloud
//
//

#import <UIKit/UIKit.h>

@interface UploadImageViewController : UIViewController <UIPickerViewDelegate>


@property (nonatomic, strong) IBOutlet UIImageView *imgToUpload;
@property (nonatomic, strong) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) NSString *username;

-(IBAction)selectPicturePressed:(id)sender;

@end
