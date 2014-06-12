
#import "DPPickerController.h"

@implementation DPPickerController

- (void)initDataSource
{
    switch (self.dataSource) {
        case DataSourceType:
            self.fetchedResultsController = [Type MR_fetchAllSortedBy:@"name"
                                                            ascending:NO
                                                        withPredicate:nil
                                                              groupBy:nil
                                                             delegate:nil
                                                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            break;
            
        case DataSourceTag:
            self.fetchedResultsController = [Tag MR_fetchAllSortedBy:@"name"
                                                            ascending:NO
                                                        withPredicate:nil
                                                              groupBy:nil
                                                             delegate:nil
                                                            inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            break;
			
		case DataSourceArea:
            self.fetchedResultsController = [Area MR_fetchAllSortedBy:@"name"
														   ascending:NO
													   withPredicate:nil
															 groupBy:nil
															delegate:nil
														   inContext:[NSManagedObjectContext MR_contextForCurrentThread]];
            break;
            
        default:
            break;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:component];
	return [sectionInfo numberOfObjects];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
	
	UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
	contentLabel.textAlignment = NSTextAlignmentCenter;
	contentLabel.backgroundColor = [UIColor clearColor];
	contentLabel.font = [UIFont systemFontOfSize:18.0];
	contentLabel.userInteractionEnabled = NO;
	
	NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:component]];
	
	contentLabel.text = [object valueForKey:@"name"];
	
	return contentLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    UILabel *contentLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
    [self.delegate pickerController:self didSelectField:contentLabel.text];
}

@end
