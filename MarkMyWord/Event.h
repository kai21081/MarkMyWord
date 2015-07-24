//
//  Event.h
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Event : NSObject

@property (strong, nonatomic) NSString *eventID;
@property (strong, nonatomic) NSString *eventImageURL;
@property (strong, nonatomic) NSDate *expirationDate;
@property (strong, nonatomic) UIImage *eventImage;
@property (strong, nonatomic) NSArray *predictions;
@property (strong, nonatomic) NSString *homeTeam;
@property (strong, nonatomic) NSString *awayTeam;
@property (nonatomic) int currentIndex;

@end
