//
//  MuseController.m
//  MuseStatsIos
//
//  Created by Paul Lavoine on 29/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import "MuseController.h"
#import "LoggingListener.h"

@interface MuseController ()

@property (strong, nonatomic) IXNMuseManager *manager;
@property (strong, nonatomic) LoggingListener *loggingListener;
@property (strong, nonatomic) NSTimer *musePickerTimer;
@property (strong, nonatomic) AppDelegate *delegate;

@end

@implementation MuseController

#pragma mark - Shared instance
+ (instancetype)sharedInstance
{
    static MuseController *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MuseController alloc] init];
    });
    
    return sharedInstance;
}


- (id)init
{
    if (self = [super init])
    {

    }
    
    return self;
}

- (void)resumeInstance
{
    NSAssert([self.listenedObjects count] != 0, @"Il n'y a aucun objet à écouter dans la liste");
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    @synchronized (self.manager)
    {
        // All variables and listeners are already wired up; return.
        if (self.manager)
            return;
        self.manager = [IXNMuseManager sharedManager];
    }
    if (!self.muse)
    {
        // Intent: show a bluetooth picker, but only if there isn't already a
        // Muse connected to the device. Do this by delaying the picker by 1
        // second. If startWithMuse happens before the timer expires, cancel
        // the timer.
        self.musePickerTimer =
        [NSTimer scheduledTimerWithTimeInterval:1
                                         target:self
                                       selector:@selector(showPicker)
                                       userInfo:nil
                                        repeats:NO];
    }
    // to resume connection if we disconnected in applicationDidEnterBakcground::
    // else if (self.muse.getConnectionState == IXNConnectionStateDisconnected)
    //     [self.muse runAsynchronously];
    if (!self.loggingListener)
    {
        self.loggingListener = [[LoggingListener alloc] init];
    }
    
    
    [self.manager addObserver:self
                   forKeyPath:[self.manager connectedMusesKeyPath]
                      options:(NSKeyValueObservingOptionNew |
                               NSKeyValueObservingOptionInitial)
                      context:nil];
}

- (void)showPicker
{
    [self.manager showMusePickerWithCompletion:^(NSError *error)
     {
         if (error)
             NSLog(@"Error showing Muse picker: %@", error);
     }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:[self.manager connectedMusesKeyPath]])
    {
        NSSet *connectedMuses = [change objectForKey:NSKeyValueChangeNewKey];
        if (connectedMuses.count)
        {
            [self startWithMuse:[connectedMuses anyObject]];
        }
    }
}

- (void)startWithMuse:(id<IXNMuse>)muse
{
    // Uncomment to test Muse File Reader
    //    [self playMuseFile];
    @synchronized (self.muse)
    {
        if (self.muse)
            return;
        
        self.muse = muse;
    }
    [self.musePickerTimer invalidate];
    self.musePickerTimer = nil;
    
    for (NSNumber *type in self.listenedObjects)
    {
        [self.muse registerDataListener:self.loggingListener
                                   type:[type intValue]];
    }
    
    [self.muse registerConnectionListener:self.loggingListener];
    [self.muse runAsynchronously];
}

// This gets called by LoggingListener
- (void)sayHi
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Muse says hi"
                                                    message:@"Muse is now connected"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    NSLog(@"Muse is Now connected");
    [alert show];
}

- (void)reconnectToMuse
{
    [self.muse runAsynchronously];
}

/*
 * Simple example of getting data from the "*.muse" file
 */
- (void)playMuseFile
{
    NSLog(@"start play muse");
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"testfile.muse"];
    id<IXNMuseFileReader> fileReader = [IXNMuseFileFactory museFileReaderWithPathString:filePath];
    
    while ([fileReader gotoNextMessage])
    {
        IXNMessageType type = [fileReader getMessageType];
        int id_number = [fileReader getMessageId];
        int64_t timestamp = [fileReader getMessageTimestamp];
        NSLog(@"type: %d, id: %d, timestamp: %lld",
              (int)type, id_number, timestamp);
        switch(type) {
            case IXNMessageTypeEeg:
            case IXNMessageTypeQuantization:
            case IXNMessageTypeAccelerometer:
            case IXNMessageTypeBattery:
            {
                IXNMuseDataPacket* packet = [fileReader getDataPacket];
                NSLog(@"data packet = %d", (int)packet.packetType);
                break;
            }
            case IXNMessageTypeVersion:
            {
                IXNMuseVersion* version = [fileReader getVersion];
                NSLog(@"version = %@", version.firmwareVersion);
                break;
            }
            case IXNMessageTypeConfiguration:
            {
                IXNMuseConfiguration* config = [fileReader getConfiguration];
                NSLog(@"configuration = %@", config.bluetoothMac);
                break;
            }
            case IXNMessageTypeAnnotation:
            {
                IXNAnnotationData* annotation = [fileReader getAnnotation];
                NSLog(@"annotation = %@", annotation.data);
                break;
            }
            default:
                break;
        }
    }
}

@end
