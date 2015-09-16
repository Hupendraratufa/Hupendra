#import "Constants1.h"
#import <Foundation/Foundation.h>

@interface RateManager : NSObject <UIAlertViewDelegate>

- (void)showReviewApp;
+ (RateManager *)sharedManager;

@end
