//
//  ViewController.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *imageLayer;
@property (strong, nonatomic) CAShapeLayer *yesCircleLayer;


@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CGPoint center = CGPointMake(self.imageLayer.frame.size.width/2, self.imageLayer.frame.size.height/2);
  self.yesCircleLayer = [self createCircleWithCenter: center
                                                  radius: self.imageLayer.frame.size.width/2
                                              startPercentage:1.0 endPercentage:.57 color:[UIColor greenColor] lineWidth:30 duration:1 key:@"YesCircleAnimation"];
  
  [self.imageLayer.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  [self.imageLayer.layer addSublayer:self.yesCircleLayer];
  
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
    CGPoint center = CGPointMake(self.imageLayer.frame.size.width/2, self.imageLayer.frame.size.height/2);
    CAShapeLayer *noCircle = [self createCircleWithCenter: center
                                                   radius: self.imageLayer.frame.size.width/2
                                          startPercentage:.57 endPercentage:1.0 color:[UIColor redColor] lineWidth:30 duration:1 key:@"NoCircleAnimation"];
    [self.imageLayer.layer addSublayer:noCircle];
  }
}
@end
