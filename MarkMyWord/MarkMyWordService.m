//
//  MarkMyWordService.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 20..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "MarkMyWordService.h"
#import "JSONParseService.h"
#import "Prediction.h"

@interface MarkMyWordService()

@property (strong, nonatomic) NSString *token;
@end

@implementation MarkMyWordService

+(instancetype)sharedService{
  static MarkMyWordService *sharedMyService = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyService = [[self alloc]init];
  });
  return sharedMyService;
}

-(void)validateMyAccessToken:(NSString*)token completionHandler:(void(^)(BOOL, NSString*))completionHandler{
  NSString *urlString = @"https://mark-my-word.herokuapp.com/user";
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setValue:token forHTTPHeaderField:@"token"];
  [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if(error != nil){
      NSLog(@"Error validating token");
    }else{
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      switch (httpResponse.statusCode) {
        case 200:{
          NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            completionHandler(true, nil);
          }];
        }
          break;
        default:
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            completionHandler(false,nil);
          }];
          break;
      }
    }
  }]resume];
}

-(void)requestLoginWithEmail:(NSString *)email password:(NSString *)password completionHandler:(void(^)(BOOL,NSString*))completionHandler{
  NSString *urlString = @"https://mark-my-word.herokuapp.com/login";
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  NSString *authStr = [NSString stringWithFormat:@"%@:%@", email, password];
  NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
  NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
  [request setValue:authValue forHTTPHeaderField:@"Authorization"];
  [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error != nil) {
      NSLog(@"Error with Login");
    }else{
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
      switch (httpResponse.statusCode) {
        case 200:{
          NSString *token = [JSONParseService parseJSONForLogin:data];
          if (token) {
            [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"access_token"];
            self.token = token;
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
              completionHandler(true, nil);
            }];
          }
        }
          break;
        case 500:
          NSLog(@"SERVER ERROR!!!!");
          break;
          
        default:
          break;
      }
    }
  }]resume];
}

-(void)fetchAllEventsWithBlock:(void(^)(NSArray *, NSString *))completionHandler{
  NSString *urlString = @"https://mark-my-word.herokuapp.com/events";
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
  [request setValue:token forHTTPHeaderField:@"token"];
  [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if(error != nil){
      NSLog(@"Error getting all events");
    }else{
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      switch (httpResponse.statusCode) {
        case 200:{
          NSArray *events = [JSONParseService parseJSONForEvents:data];
          [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            completionHandler(events, nil);
          }];
        }
         
          break;
          
        default:
          break;
      }
    }
  }]resume];
}

-(void)updateEventWithEventID:(NSString *)eventID questions:(NSArray*)questions completionHandler:(void(^)(NSDictionary *results, NSString *error))completionHandler{
  NSString *urlString = @"https://mark-my-word.herokuapp.com/events";
  NSMutableArray *questionIdsArray = [[NSMutableArray alloc]init];
  NSString *answers = @"";
  for (int i = 0; i < questions.count ; i++){
    Prediction *question = (Prediction*)questions[i];
    [questionIdsArray addObject:question.question_ID];
    
    if ([question.selectedOption boolValue]) {
      answers = [answers stringByAppendingString:@"true"];
    }else{
      answers = [answers stringByAppendingString:@"false"];
    }
    if (i < questions.count - 1) {
      answers = [answers stringByAppendingString:@";"];
    }
  }
  NSString *questionIds = [questionIdsArray componentsJoinedByString:@";"];
  
  urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?eventId=%@&questionIds=%@&predictions=%@",eventID,questionIds,answers]];
  NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  request.HTTPMethod = @"POST";
  [request setValue:token forHTTPHeaderField:@"token"];
  [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error != nil) {
      NSLog(@"error updating event");
    }else{
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      switch (httpResponse.statusCode) {
        case 200:{
          NSDictionary *results = [JSONParseService parseJSONForSummary:data];
          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(results, nil);
          }];
        }
          break;
          
        default:
          break;
      }
    }
  }]resume];
}
@end
