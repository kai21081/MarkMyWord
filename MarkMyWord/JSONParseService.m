//
//  JSONParseService.m
//  MarkMyWord
//
//  Created by Jisoo Hong on 2015. 5. 18..
//  Copyright (c) 2015년 JHK. All rights reserved.
//

#import "JSONParseService.h"
#import "Event.h"
#import "Prediction.h"

@implementation JSONParseService
+(NSArray *)parseJSONForEvents:(NSData*)data{
  NSMutableArray *events = [[NSMutableArray alloc]init];
  NSError *error;
  NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
  if (error != nil) {
    //something wrong with JSON serialization
  }else{
    for (NSDictionary *eventObj in jsonObject) {
      Event *event = [[Event alloc]init];
      event.eventID = [eventObj objectForKey:@"_id"];
//      event.eventImageURL = [eventObj objectForKey:@"event_img_url"];
      event.homeTeam = [eventObj objectForKey:@"home"];
      event.awayTeam = [eventObj objectForKey:@"away"];
      event.expirationDate = [NSDate dateWithTimeIntervalSince1970:(int)[eventObj objectForKey:@"eventTimeUnix"]];
      NSMutableArray *predictions = [[NSMutableArray alloc]init];
      NSArray *predictionObjects = [eventObj objectForKey:@"questions"];
      for (NSDictionary *predictionObj in predictionObjects) {
        Prediction *prediction = [[Prediction alloc]init];
        prediction.question = [predictionObj objectForKey:@"question"];
        prediction.question_ID = [predictionObj objectForKey:@"_id"];
//        prediction.choice1Label = [predictionObj objectForKey:@"choice1"];
//        prediction.choice2Label = [predictionObj objectForKey:@"choice2"];
        [predictions addObject:prediction];
      }
      event.predictions = predictions;
      [events addObject:event];
    }
  }
  return events;
}

+(NSString *)parseJSONForLogin:(NSData*)data{
  NSError *error;
  NSString *token;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if(error != nil){
    
  }else{
    token = [jsonObject objectForKey:@"token"];
    return token;
  }
  return nil;
}

+(NSDictionary *)parseJSONForSummary:(NSData *)data{
  NSError *error;
  NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  if (error != nil) {
    //something wrong with JSON sericalization
  }else{
    return jsonObject;
  }
  return nil;
}
@end
