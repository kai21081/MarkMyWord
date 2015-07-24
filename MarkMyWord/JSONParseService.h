//
//  JSONParseService.h
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONParseService : NSObject

+(NSArray *)parseJSONForEvents:(NSData*)data;
+(NSString *)parseJSONForLogin:(NSData*)data;
+(NSDictionary *)parseJSONForSummary:(NSData*)data;
@end
