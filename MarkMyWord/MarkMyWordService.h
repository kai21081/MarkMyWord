//
//  MarkMyWordService.h
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MarkMyWordService : NSObject

+(instancetype)sharedService;
-(void)validateMyAccessToken:(NSString*)token completionHandler:(void(^)(BOOL, NSString*))completionHandler;
-(void)requestLoginWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void(^)(BOOL,NSString*))completionHandler;
-(void)fetchAllEventsWithBlock:(void(^)(NSArray *events, NSString *error))completionHandler;
-(void)updateEventWithEventID:(NSString *)eventID questions:(NSArray*)questions completionHandler:(void(^)(NSDictionary *results, NSString *error))completionHandler;
@end
