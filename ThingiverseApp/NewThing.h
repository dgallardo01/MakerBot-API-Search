//
//  NewThing.h
//  Testing
//
//  Created by Danny on 6/2/14.
//  Copyright (c) 2014 Danny. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewThing : NSObject

@property (nonatomic, strong) NSString * creatorName;
@property (nonatomic, strong) NSNumber * creatorID;
@property (nonatomic, strong) NSString * thingName;
@property (nonatomic, strong) NSString * thingThumbnail;
@property (nonatomic, strong) NSString * thingPublicURL;
@property (nonatomic, strong) NSNumber * thingID;

- (instancetype) initWithCreator:(NSString *)creatorName creatorID:(NSNumber *)creatorID ThingName:(NSString *) thingName thingThumbnail:(NSString *)thingThumbnail thingPublicURL:(NSString *)thingPublicURL thingID:(NSNumber *)thingID;

+ (NSArray *) thingArrayFromThingDictionaries:(NSArray *)thingsArray;

+ (instancetype) thingFromThingDictionary:(NSDictionary *)thing;

@end
