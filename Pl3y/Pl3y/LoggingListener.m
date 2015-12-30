//
//  Interaxon, Inc. 2015
//  MuseStatsIos
//

#import "LoggingListener.h"
#import "CustomViewController.h"
#import "MuseController.h"

@interface LoggingListener () {
    dispatch_once_t _connectedOnceToken;
}
@property (nonatomic) BOOL lastBlink;
@property (nonatomic) BOOL sawOneBlink;
@property (nonatomic, weak) AppDelegate* delegate;
@property (nonatomic) id<IXNMuseFileWriter> fileWriter;
@end

@implementation LoggingListener

- (instancetype)initWithDelegate:(AppDelegate *)delegate
{
    //    _delegate = delegate;
    /**
     * Set <key>UIFileSharingEnabled</key> to true in Info.plist if you want
     * to see the file in iTunes
     */
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(
    //        NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *filePath =
    //        [documentsDirectory stringByAppendingPathComponent:@"new_muse_file.muse"];
    //    self.fileWriter = [IXNMuseFileFactory museFileWriterWithPathString:filePath];
    //    [self.fileWriter addAnnotationString:1 annotation:@"fileWriter created"];
    //    [self.fileWriter flush];
    return self;
}

- (void)receiveMuseDataPacket:(IXNMuseDataPacket *)packet
{
    
    //    NSLog(@"packetType : %d", packet.packetType);
    
    switch (packet.packetType) {
        case IXNMuseDataPacketTypeBattery:
            [[NSNotificationCenter defaultCenter] postNotificationName:batteryNotification object:packet.values];
            //            NSLog(@"battery packet received");
            //            [self.fileWriter addDataPacket:1 packet:packet];
            break;
        case IXNMuseDataPacketTypeAccelerometer:
            [[NSNotificationCenter defaultCenter] postNotificationName:accelerometerNotification object:packet.values];
            //            NSLog(@"Accelerometre");
            break;
        case IXNMuseDataPacketTypeMellow:
            [[NSNotificationCenter defaultCenter] postNotificationName:mellowNotification object:packet.values];
            break;
        case IXNMuseDataPacketTypeConcentration:
            [[NSNotificationCenter defaultCenter] postNotificationName:contentrationNotification object:packet.values];
            break;
        case IXNMuseDataPacketTypeHorseshoe:
            [[NSNotificationCenter defaultCenter] postNotificationName:horsesShoeNotification object:packet.values];
            break;
        case IXNMuseDataPacketTypeAlphaRelative:
            [[NSNotificationCenter defaultCenter] postNotificationName:alphaNotification object:packet.values];
            break;
        case IXNMuseDataPacketTypeBetaRelative:
            [[NSNotificationCenter defaultCenter] postNotificationName:betaNotification object:packet.values];
            break;
        case IXNMuseDataPacketTypeDeltaRelative:
            [[NSNotificationCenter defaultCenter] postNotificationName:deltaNotification object:packet.values];
            break;
        case IXNMuseDataPacketTypeThetaRelative:
            [[NSNotificationCenter defaultCenter] postNotificationName:thetaNotification object:packet.values];
            break;
        case IXNMuseDataPacketTypeGammaRelative:
            [[NSNotificationCenter defaultCenter] postNotificationName:gammaNotification object:packet.values];
            break;
        default:
            break;
    }
}

- (void)receiveMuseArtifactPacket:(IXNMuseArtifactPacket *)packet
{
    if (!packet.headbandOn)
        return;
    
    if (!self.sawOneBlink)
    {
        self.sawOneBlink = YES;
        self.lastBlink = !packet.blink;
    }
    if (self.lastBlink != packet.blink)
    {
        if (packet.blink)
            //            NSLog(@"blink");
            self.lastBlink = packet.blink;
    }
}

- (void)receiveMuseConnectionPacket:(IXNMuseConnectionPacket *)packet
{
    NSString *state;
    switch (packet.currentConnectionState)
    {
        case IXNConnectionStateDisconnected:
            state = @"disconnected";
            //            [self.fileWriter addAnnotationString:1 annotation:@"disconnected"];
            //            [self.fileWriter flush];
            break;
        case IXNConnectionStateConnected:
            state = @"connected";
            //            [self.fileWriter addAnnotationString:1 annotation:@"connected"];
            break;
        case IXNConnectionStateConnecting:
            state = @"connecting";
            //            [self.fileWriter addAnnotationString:1 annotation:@"connecting"];
            break;
        case IXNConnectionStateNeedsUpdate: state = @"needs update"; break;
        case IXNConnectionStateUnknown: state = @"unknown"; break;
        default: NSAssert(NO, @"impossible connection state received");
    }
    NSLog(@"connect: %@", state);
    if (packet.currentConnectionState == IXNConnectionStateConnected) {
        //        [self.delegate sayHi];
    } else if (packet.currentConnectionState == IXNConnectionStateDisconnected) {
        // XXX IMPORTANT
        // -connect, -disconnect, and -execute *MUST NOT* be on any code path
        // that starts with a connection event listener, except through an
        // asynchronous scheduled event, such as the below call to reconnect.
        //
        // These messages can cause this connection listener to synchronously
        // fire, without giving the OS a chance to clean up resources or
        // perform scheduled IO. This is a known issue that will be fixed in a
        // future release of the SDK.
        NSLog(@"DELEGATE NEEDED");
        //        [self.delegate performSelector:@selector(reconnectToMuse)
        //                            withObject:nil
        //                            afterDelay:0];
    }
}

- (void)reconnectToMuse
{
    NSLog(@"Reconnect To muse");
//    [[MuseController sharedInstance] reconnectToMuse];
}

@end
