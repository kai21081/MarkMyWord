//
//  SummaryCell.h
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 21..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *questionIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPredictionLabel;
@property (weak, nonatomic) IBOutlet UIView *circleGraphView;
@property (weak, nonatomic) IBOutlet UILabel *totalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *noPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesPercentLabel;
@property (nonatomic) int lineWidth;
@property (nonatomic) float radius;
@property (nonatomic) CGPoint myCenter;

-(void)createCircleGraphWithYesPercentage:(float)percentage;
@end
