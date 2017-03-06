//
//  NetworkManager.h

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

+ (instancetype) sharedManager;

- (void) startMonitoringExistConnection: (void (^)()) existConnection notExistConnection: (void (^)()) notExistConnection;
- (void) stopMonitoringConnection;

- (void) getRssFeedWithUrl: (NSString *) URLStrng successHandler: (void(^) (NSData *rssData)) success andFailureHandler: (void(^) (NSError *error)) failure;


@end
