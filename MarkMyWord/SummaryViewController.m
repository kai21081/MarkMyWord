//
//  SummaryViewController.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 19..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "SummaryViewController.h"
#import "SummaryCell.h"
#import "Prediction.h"
#import "AppDelegate.h"
#import "EventsViewController.h"

@interface SummaryViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.currentEvent.predictions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  SummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SummaryCell"];
  Prediction *prediction = self.currentEvent.predictions[indexPath.row];
  NSDictionary *globalStat = [self.results objectForKey:prediction.question_ID];
  NSNumber *numOfYes = [globalStat objectForKey:@"yes"];
  float nummy = [numOfYes floatValue];
  NSNumber *numOfTotal = [globalStat objectForKey:@"total"];
  float total = [numOfTotal floatValue];
  int yesPercentageInt = (int)(nummy/total * 1000);
  float yesPercentage = yesPercentageInt/1000.0f;
  cell.questionIndexLabel.text = [NSString stringWithFormat:@"Q%ld:",(long)indexPath.row + 1];
  cell.questionLabel.text = prediction.question;
  cell.userPredictionLabel.text = [prediction.selectedOption boolValue] == true?@"YES" : @"NO";
  cell.totalNumberLabel.text = [NSString stringWithFormat:@"%@ predictions",[NSNumber numberWithFloat:total]];
  cell.noPercentLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:(1-yesPercentage)*100]];
  cell.noPercentLabel.text = [cell.noPercentLabel.text stringByAppendingString:@"%"];
  cell.yesPercentLabel.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:yesPercentage*100]];

  cell.yesPercentLabel.text = [cell.yesPercentLabel.text stringByAppendingString:@"%"];
  [cell createCircleGraphWithYesPercentage:yesPercentage];
  return cell;
}

-(void)reloadData{
  [self.tableView reloadData];
}

- (IBAction)eventButtonPressed:(id)sender {
  UINavigationController *eventVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsVC"];
  [UIView transitionFromView:self.view toView:eventVC.view duration:0.6 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
    if(finished){
      AppDelegate *delegate = [UIApplication sharedApplication].delegate;
      delegate.window.rootViewController = eventVC;
    }
  }];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:false];
}


@end
