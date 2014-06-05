//
//  NewThing.m
//  Testing
//
//  Created by Danny on 6/2/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import "NewThing.h"

@implementation NewThing

- (instancetype) initWithCreator:(NSString *)creatorName creatorID:(NSNumber *)creatorID ThingName:(NSString *) thingName thingThumbnail:(NSString *)thingThumbnail thingPublicURL:(NSString *)thingPublicURL thingID:(NSNumber *)thingID{
    self = [super init];
    if(self){
        _creatorName = creatorName;
        _creatorID = creatorID;
        _thingName = thingName;
        _thingThumbnail = thingThumbnail;
        _thingPublicURL = thingPublicURL;
        _thingID = thingID;
    }
    return self;
}

+ (NSArray *) thingArrayFromThingDictionaries:(NSArray *)thingsArray{
    NSMutableArray *finalThings = [NSMutableArray new];
    for (NSDictionary *thing in thingsArray) {
        if ([thing isKindOfClass:[NSDictionary class]]) {
            [finalThings addObject:[NewThing thingFromThingDictionary:thing]];
        }
    }
    return finalThings;
}

+(NewThing *) thingFromThingDictionary:(NSDictionary *)thingDictionary{
    
    NSString *thingPreviewThumbnail = thingDictionary[@"thumbnail"];
    NSString *pattern = @"(thumb.medium.jpg)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    NSString *largePreviewThumbnail = [regex stringByReplacingMatchesInString:thingPreviewThumbnail options:0 range:NSMakeRange(0, [thingPreviewThumbnail length]) withTemplate:@"display_medium.jpg"];

    NewThing *newThing = [[NewThing alloc]initWithCreator:thingDictionary[@"creator"][@"name"]
                                                creatorID:thingDictionary[@"creator"][@"id"]
                                                ThingName:thingDictionary[@"name"]
                                           thingThumbnail:largePreviewThumbnail
                                           thingPublicURL:thingDictionary[@"public_url"]
                                                  thingID:thingDictionary[@"id"]];
    return newThing;
}

@end
