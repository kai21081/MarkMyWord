//
//  SummaryCell.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 21..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "SummaryCell.h"

@interface SummaryCell()
@property (strong, nonatomic) CAShapeLayer *yesCircleLayer;
@property (nonatomic) float yesPercentage;
@end

@implementation SummaryCell

-(void)awakeFromNib{

}

-(void)createCircleGraphWithYesPercentage:(float)percentage{
  self.yesPercentage = percentage;
  [self.circleGraphView.layer setCornerRadius:self.circleGraphView.frame.size.width/2];
  self.myCenter = CGPointMake(self.circleGraphView.frame.size.width/2, self.circleGraphView.frame.size.height/2);
  self.lineWidth = 15;
  self.radius = self.circleGraphView.frame.size.width/2 - self.lineWidth/2;
  self.yesCircleLayer = [self createCircleWithCenter: self.myCenter
                                              radius: self.radius
                                     startPercentage:0.0 endPercentage:self.yesPercentage color:[UIColor greenColor] lineWidth:self.lineWidth duration:1*self.yesPercentage key:@"YesCircleAnimation"];
  
  //[self.circleGraphView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  [self.circleGraphView.layer addSublayer:self.yesCircleLayer];
}

-(CAShapeLayer *)createCircleWithCenter:(CGPoint)center radius:(float)radius startPercentage:(float)startPercentage endPercentage:(float)endPercentage color:(UIColor*)color lineWidth:(int)lineWidth duration:(int)duration key:(NSString*)key{
  CAShapeLayer *circle=[CAShapeLayer layer];
  float startAngle = startPercentage == 0? 2*M_PI*0-M_PI_2 : startPercentage*2*M_PI*1-M_PI_2;
  float endAngle = endPercentage*2*M_PI*1-M_PI_2;
  circle.path=[UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES].CGPath;
  circle.fillColor=[UIColor clearColor].CGColor;
  circle.strokeColor=color.CGColor;
  circle.lineWidth=lineWidth;
  
  CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
  animation.duration = startPercentage == 0? duration*endPercentage : duration*startPercentage;
  animation.removedOnCompletion=NO;
  animation.fromValue=@(0);
  animation.toValue=@(1);
  animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  animation.delegate =self;
  [circle addAnimation:animation forKey:key];
  return circle;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{
  if ([[self.yesCircleLayer animationForKey:@"YesCircleAnimation"] isEqual:theAnimation]){
    CAShapeLayer *noCircle = [self createCircleWithCenter: self.myCenter
                                                   radius: self.radius
                                          startPercentage:self.yesPercentage endPercentage:1.0 color:[UIColor redColor] lineWidth:self.lineWidth duration:1*(1-self.yesPercentage) key:@"NoCircleAnimation"];
    [self.circleGraphView.layer addSublayer:noCircle];
  }
}
@end
