#import <CommonCrypto/CommonDigest.h>
#import "IOCAvatarLoader.h"
#import "NSURL+Extensions.h"

#define kAvatarMaxLogicalSize 64


@interface IOCAvatarLoader ()
@property(nonatomic,strong)id target;
@property(nonatomic,assign)SEL handle;

- (void)requestWithURL:(NSURL *)theURL;
@end


@implementation IOCAvatarLoader

+ (id)loaderWithTarget:(id)theTarget andHandle:(SEL)theHandle {
	return [[self.class alloc] initWithTarget:theTarget andHandle:theHandle];
}

- (id)initWithTarget:(id)theTarget andHandle:(SEL)theHandle {
	self = [super init];
	if (self) {
		self.target = theTarget;
		self.handle = theHandle;
	}
	return self;
}

- (NSInteger)gravatarSize {
	UIScreen *mainScreen = [UIScreen mainScreen];
	CGFloat deviceScale = ([mainScreen respondsToSelector:@selector(scale)]) ? [mainScreen scale] : 1.0;
	return kAvatarMaxLogicalSize * MAX(deviceScale, 1.0);
}

- (void)loadURL:(NSURL *)theURL {
	NSURL *gravatarURL = [NSURL URLWithFormat:@"%@&s=%d", theURL, self.gravatarSize];
	[self performSelectorInBackground:@selector(requestWithURL:) withObject:gravatarURL];
}

- (void)requestWithURL:(NSURL *)theURL {
	@autoreleasepool {
		NSData *gravatarData = [NSData dataWithContentsOfURL:theURL];
		UIImage *gravatarImage = [UIImage imageWithData:gravatarData];
		if (gravatarImage) [self.target performSelectorOnMainThread:self.handle withObject:gravatarImage waitUntilDone:NO];
	}
}

@end