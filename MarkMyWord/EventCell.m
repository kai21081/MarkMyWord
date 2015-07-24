//
//  EventCell.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "EventCell.h"

@implementation EventCell

-(void)awakeFromNib{
  [self.homeTeamView.layer setCornerRadius:15.0f];
  [self.awayTeamView.layer setCornerRadius:15.0f];
}

@end
