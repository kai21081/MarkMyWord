//
//  EventsViewController.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "EventsViewController.h"
#import "JSONParseService.h"
#import "EventCell.h"
#import "PredictionViewController.h"
#import "MainContainerViewController.h"
#import "MarkMyWordService.h"

@interface EventsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *events;
@end

@implementation EventsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#ifdef DEBUG
    NSURL *url =[[NSBundle mainBundle]URLForResource:@"EventJSON" withExtension:@"json"];
    NSData *jsonData = [[NSData alloc]initWithContentsOfURL:url];
    self.events = [JSONParseService parseJSONForEvents:jsonData];
#else
  [[MarkMyWordService sharedService] fetchAllEventsWithBlock:^(NSArray *events, NSString *error) {
    self.events = events;
    [self.tableView reloadData];
  }];
#endif


  self.tableView.dataSource = self;
  self.tableView.delegate = self;
    // Do any additional setup after loading the view.
  
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
  if([segue.identifier isEqualToString:@"ShowFirstPrediction"]){
    MainContainerViewController *mainContainerVC = (MainContainerViewController*)segue.destinationViewController;
    mainContainerVC.event = self.events[[self.tableView indexPathForSelectedRow].row];
    mainContainerVC.event.currentIndex = 0;
    
  }
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  return self.events.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  EventCell *cell = (EventCell*)[tableView dequeueReusableCellWithIdentifier:@"EventCell"];
  //cell.eventImage.image = [UIImage imageNamed:@"eventLogo"];
  Event *event = (Event*)self.events[indexPath.row];
  cell.homeTeamLabel.text = event.homeTeam;
  cell.awayTeamLabel.text = event.awayTeam;
  NSDate *now = [NSDate date];
  NSDateComponents *hourComponets =
  [[[NSCalendar alloc]init] components:NSCalendarUnitHour fromDate:now];
  long hour = [hourComponets hour];
  cell.expirationLabel.text = [NSString stringWithFormat:@"Expires in %ld hours",hour];
  return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
