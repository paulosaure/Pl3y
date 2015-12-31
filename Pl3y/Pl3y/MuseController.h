//
//  MuseController.h
//  MuseStatsIos
//
//  Created by Paul Lavoine on 29/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Muse.h"

@class AppDelegate;

@interface MuseController : NSObject

+ (instancetype)sharedInstance;
- (void)resumeInstance;
- (void)reconnectToMuse;
- (void)registerDataListeners;

@property (strong, nonatomic) id<IXNMuse> muse;
@property (strong, nonatomic) NSArray *listenedObjects;

@end
