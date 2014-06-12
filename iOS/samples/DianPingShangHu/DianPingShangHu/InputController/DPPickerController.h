
#import "Type.h"
#import "Tag.h"

typedef NS_ENUM(NSUInteger, DataSource) {
	DataSourceType = (1UL << 1),
	DataSourceTag = (1UL << 2),
	DataSourceArea = (1UL << 3),
};

@class DPPickerController;
@protocol DPPickerControllerDelegate <NSObject>

@required
- (void)pickerController:(DPPickerController *)pickerController didSelectField:(NSString *)field;

@end

@interface DPPickerController : NSObject <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) DataSource dataSource;
@property (nonatomic, weak) id<DPPickerControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void)initDataSource;

@end
