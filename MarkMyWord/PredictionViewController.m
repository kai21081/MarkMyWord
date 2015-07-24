//
//  PredictionViewController.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "PredictionViewController.h"
#import "Prediction.h"
#import "MarkMyWordService.h"
#import "SummaryViewController.h"
#import "AppDelegate.h"

@interface PredictionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UIView *choice1View;
@property (weak, nonatomic) IBOutlet UIView *choice2View;
@property (weak, nonatomic) IBOutlet UILabel *choice1Label;
@property (weak, nonatomic) IBOutlet UIImageView *choice1ImageView;
@property (weak, nonatomic) IBOutlet UILabel *choice2Label;
@property (weak, nonatomic) IBOutlet UIImageView *choice2ImageView;
@property (weak, nonatomic) IBOutlet UIView *questionContainerView;
@property (weak, nonatomic) IBOutlet UIView *choice1LabelContainerView;
@property (weak, nonatomic) IBOutlet UIView *choice2LabelContainerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toolBarButton;
@property (strong, nonatomic) Prediction *currenctPrediction;
@end

@implementation PredictionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.currenctPrediction = [self.event.predictions objectAtIndex:self.event.currentIndex];
    // Do any additional setup after loading the view.
  self.question.text = self.currenctPrediction.question;
//  self.choice1Label.text = self.currenctPrediction.choice1Label;
//  self.choice2Label.text = self.currenctPrediction.choice2Label;
  UITapGestureRecognizer *tapChoice1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choice1Tapped)];
  [self.choice1View addGestureRecognizer:tapChoice1];
  UITapGestureRecognizer *tapChoice2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choice2Tapped)];
  [self.choice2View addGestureRecognizer:tapChoice2];
  [self.navigationController setTitle:[NSString stringWithFormat:@"Prediction %d/%lu",self.event.currentIndex,(unsigned long)self.currenctPrediction.question.length]];
  [self.questionContainerView.layer setCornerRadius:10.0f];
  [self.choice1LabelContainerView.layer setCornerRadius:10.0f];
  [self.choice2LabelContainerView.layer setCornerRadius:10.0f];
  [self.choice1View.layer setCornerRadius:10.0f];
  [self.choice2View.layer setCornerRadius:10.0f];
  if(self.event.currentIndex < self.event.predictions.count-1){
    self.toolBarButton.title = @"Next Prediction";
  }else{
    self.toolBarButton.title = @"Submit";
  }
}
-(void)choice1Tapped{
  self.choice1ImageView.image = [UIImage imageNamed:@"checkMark"];
  self.currenctPrediction.selectedOption = @1;
  self.choice2ImageView.image = [UIImage imageNamed:@"tapHere"];
}

-(void)choice2Tapped{
  self.choice1ImageView.image = [UIImage imageNamed:@"tapHere"];
  self.currenctPrediction.selectedOption = @0;
  self.choice2ImageView.image = [UIImage imageNamed:@"checkMark"];
}
- (IBAction)nextButtonPressed:(id)sender {
  if (self.currenctPrediction.selectedOption != nil){
    if (self.event.currentIndex+1 < self.event.predictions.count) {
      PredictionViewController *nextPredictionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PredictionVC"];
      self.event.currentIndex++;
      nextPredictionVC.event = self.event;
      [self.navigationController pushViewController:nextPredictionVC animated:true];
    }else{
#ifdef DEBUG
      NSString *resultsPath = [[NSBundle mainBundle] pathForResource:@"Results" ofType:@"plist"];
      NSDictionary *results = [NSDictionary dictionaryWithContentsOfFile:resultsPath];
      SummaryViewController *summaryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryVC"];
      // [self.navigationController pushViewController:summaryVC animated:true];
      [UIView transitionFromView:self.navigationController.view toView:summaryVC.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        delegate.window.rootViewController = summaryVC;
        summaryVC.results = results;
        summaryVC.currentEvent = self.event;
        [summaryVC reloadData];
      }];
#else
      [[MarkMyWordService sharedService]updateEventWithEventID:self.event.eventID questions:self.event.predictions completionHandler:^(NSDictionary *results, NSString *error) {
        SummaryViewController *summaryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryVC"];
       // [self.navigationController pushViewController:summaryVC animated:true];
        [UIView transitionFromView:self.navigationController.view toView:summaryVC.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
          AppDelegate *delegate = [UIApplication sharedApplication].delegate;
          delegate.window.rootViewController = summaryVC;
          summaryVC.results = results;
          summaryVC.currentEvent = self.event;
          [summaryVC reloadData];
        }];
      }];
#endif
    }
  }
}


@end
