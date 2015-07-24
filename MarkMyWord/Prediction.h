//
//  Prediction.h
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Prediction : NSObject

@property (strong, nonatomic) NSString *question_ID;
@property (strong, nonatomic) NSString *question;
@property (strong, nonatomic) NSString *choice1Label;
@property (strong, nonatomic) NSString *choice2Label;
@property (strong, nonatomic) NSNumber *selectedOption;


@end
