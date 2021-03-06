#import "DiffFilesController.h"
#import "CodeController.h"


@interface DiffFilesController ()
@property(nonatomic,strong)NSArray *files;
@end


@implementation DiffFilesController

- (id)initWithFiles:(NSArray *)theFiles {
	self = [super initWithNibName:@"Files" bundle:nil];
	self.files = theFiles;
	return self;
}

#pragma mark TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section {
	return (self.files.count == 0) ? 1 : self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.font = [UIFont systemFontOfSize:14.0];
	}
	if (self.files.count == 0) {
		cell.textLabel.text = @"No files";
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else {
		NSDictionary *fileInfo = (self.files)[indexPath.row];
		NSString *patch =  fileInfo[@"patch"];
		cell.textLabel.text = fileInfo[@"filename"];
		cell.selectionStyle = patch ? UITableViewCellSelectionStyleBlue : UITableViewCellSelectionStyleNone;
		cell.accessoryType = patch ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	}
	return cell;
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.files.count == 0) return;
	id fileInfo = (self.files)[indexPath.row];
	if ([fileInfo isKindOfClass:[NSDictionary class]]) {
		CodeController *codeController = [[CodeController alloc] initWithFiles:self.files currentIndex:indexPath.row];
		[self.navigationController pushViewController:codeController animated:YES];
	}
}

#pragma mark Autorotation

- (BOOL)shouldAutorotate {
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self shouldAutorotate];
}

@end