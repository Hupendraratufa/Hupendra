#import <Foundation/Foundation.h>
#import "Constants1.h"
@interface LocalNotificationManager : NSObject


@property(nonatomic, strong)NSString *message;

-(id)initWithMessage:(NSString*)message;
-(id)initWithDayIntervalArray: (NSArray*)daysArray withText: (NSString*)message andSoundFile: (NSString*)soundFileName;
-(void) scheduleNotifications:(NSString *)soundFileName andDaysArray:(NSArray*)daysArray;

- (void)testNotificationsSecondsWithSoundFileName:(NSString *)soundFileName andMessage:(NSString*)message;


@end
