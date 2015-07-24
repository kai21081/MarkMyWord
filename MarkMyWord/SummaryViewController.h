//
//  SummaryViewController.h
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 19..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface SummaryViewController : UIViewController
@property (strong, nonatomic) NSDictionary *results;
@property (strong, nonatomic) Event *currentEvent;

-(void)reloadData;
@end
