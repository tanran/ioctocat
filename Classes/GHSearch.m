#import "GHSearch.h"
#import "GHUser.h"
#import "GHRepository.h"
#import "NSURL+Extensions.h"


@implementation GHSearch

- (id)initWithURLFormat:(NSString *)theFormat {
	self = [super init];
	self.urlFormat = theFormat;
	return self;
}

- (NSString *)resourcePath {
	// Dynamic resourcePath, because it depends on the
	// searchTerm which isn't always available in advance
	NSString *encodedSearchTerm = [self.searchTerm stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *path = [NSString stringWithFormat:self.urlFormat, encodedSearchTerm];
	return path;
}

- (void)setValues:(NSDictionary *)theDict {
	BOOL usersSearch = theDict[@"users"] ? YES : NO;
	NSMutableArray *resources = [NSMutableArray array];
	for (NSDictionary *dict in (usersSearch ? theDict[@"users"] : theDict[@"repositories"])) {
		GHResource *resource = nil;
		if (usersSearch) {
			resource = [[GHUser alloc] initWithLogin:dict[@"login"]];
			[resource setValues:dict];
		} else {
			resource = [[GHRepository alloc] initWithOwner:dict[@"owner"] andName:dict[@"name"]];
			[resource setValues:dict];
		}
		[resources addObject:resource];
	}
	self.results = resources;
}

@end