//
//  LoginViewController.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 19..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "LoginViewController.h"
#import "MarkMyWordService.h"
#import "EventsViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *loginView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.emailTextField.delegate = self;
  self.passwordTextField.delegate = self;
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loginViewTapped)];
  [self.loginView addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

-(void)loginViewTapped{
#ifdef DEBUG
  UINavigationController *eventsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsVC"];
  [UIView transitionFromView:self.view toView:eventsVC.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = eventsVC;
  }];
#else
  if (self.emailTextField.text.length > 0 && self.passwordTextField.text.length > 0) {
    NSString *emailAddress = self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [[MarkMyWordService sharedService] requestLoginWithEmail:emailAddress password:password completionHandler:^(BOOL hasToken, NSString *error) {
      if (hasToken) {
        UINavigationController *eventsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EventsVC"];
      
        [UIView transitionFromView:self.view toView:eventsVC.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
          AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
          appDelegate.window.rootViewController = eventsVC;
        }];
      }
    }];
  }
#endif
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  return [textField resignFirstResponder];
}

@end
