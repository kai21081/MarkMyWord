//
//  MainContainerViewController.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 19..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "MainContainerViewController.h"
#import "PredictionViewController.h"

@interface MainContainerViewController ()

@end

@implementation MainContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"PredictionVC"]){
    PredictionViewController *predictionVC = (PredictionViewController*)segue.destinationViewController;
    predictionVC.event = self.event;
  }
}
@end
