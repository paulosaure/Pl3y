//
//  MusicViewController.m
//  MuseStatsIos
//
//  Created by Paul Lavoine on 29/12/2015.
//  Copyright © 2015 InteraXon. All rights reserved.
//

#import "MusicViewController.h"
#import <MediaPlayer/MPMediaPlaylist.h>
#import <MediaPlayer/MPMediaQuery.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EchoNest.h"

@interface MusicViewController ()

@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) MPMediaItemCollection *currentPlaylist;
@property (nonatomic, strong) MPMusicPlayerController *musicController;
@property (weak, nonatomic) IBOutlet UILabel *echoNestLabel;

@end

@implementation MusicViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPlaylist];
    [self configureVolume];
    
    self.musicController = [MPMusicPlayerController systemMusicPlayer];
}

- (IBAction)testGETButtonAction:(id)sender
{
    [ENAPI initWithApiKey:@"SRXVQ1NIU3ZL7W0ZN" ConsumerKey:@"274d310b15a17ff76fe5ddc5470c20f4" AndSharedSecret:@"gjOlBQGoR++lmibbBQiQYQ"];
    
    ENAPIRequest *request = [ENAPIRequest requestWithEndpoint:@"artist/blogs"];
    request.delegate = self;                              // our class implements ENAPIRequestDelegate
    [request setValue:@"Radiohead" forParameter:@"name"]; // name=Radiohead
    [request setIntegerValue:15 forParameter:@"results"]; // results=15
    [request startAsynchronous];
    
    [request setBoolValue:YES forParameter:@"fuzzy_match"];
    [request setFloatValue:0.5f forParameter:@"min_hotttnesss"];
    // multiple values
    NSArray *descriptions = [NSArray arrayWithObjects:@"mood:chill", @"location:london", nil];
    [request setValue:descriptions forParameter:@"description"];
    
    [request startAsynchronous];
    NSLog(@"Request 1");

    //
    //    ENAPIRequest * req = [[ENAPIRequest alloc] initWithEndpoint:@"sandbox/access"];
    //
    //    // Note - you must agree to the sandbox terms of service to gain
    //    //        access to the individual artist sandboxes
    //
    //    [req setValue:@"assetId text" forParameter:@"id"];     // id={desired-asset}
    //    [req setValue:@"emi_gorillaz" forParameter:@"sandbox"]; // sandbox=emi_gorillaz
    //
    //    req.delegate = self;                        // our class implements ENAPIRequestDelegate
    //
    //    [req startAsynchronous];
}

//- (void)requestFinished:(ENAPIRequest *)request
//{
//    NSAssert1(200 == request.responseStatusCode, @"Expected 200 OK, Got: %ld", request.responseStatusCode);
//    NSLog(@"Request Finished");
//    NSArray *blogs = [request.response valueForKeyPath:@"response.blogs"];
//}

- (void)requestFailed:(ENAPIRequest *)request
{
    NSLog(@"Request Failed");
}

- (void)configureVolume
{
    // Init volume View
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    volumeView.showsRouteButton = NO;
    volumeView.showsVolumeSlider = NO;
    
    __weak __typeof(self)weakSelf = self;
    [[volumeView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[UISlider class]])
         {
             __strong __typeof(weakSelf)strongSelf = weakSelf;
             strongSelf.volumeSlider = obj;
             *stop = YES;
         }
     }];
}

- (void)initPlaylist
{
    // Retrieve all musics
//    MPMediaQuery *fullList = [[MPMediaQuery alloc] init];
//    NSArray *mediaList = [fullList items];
    
    // Retrieve all playlists
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    
    if ([playlists count] == 0)
    {
        NSLog(@"You have 0 playlists ...");
        return;
    }
    
    for (MPMediaPlaylist *playlist in playlists)
    {
        NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
        
        NSArray *songs = [playlist items];
        for (MPMediaItem *song in songs)
        {
            NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
            NSString *songComments = [song valueForProperty: MPMediaItemPropertyComments];
            NSLog (@"\t\t%@ - Comment : %@", songTitle, songComments);
        }
    }
    
    // Select a random playlist
    self.currentPlaylist = [playlists objectAtIndex:arc4random_uniform((uint32_t)[playlists count])];
    
    // Init music controller with playlist
    [self.musicController setQueueWithItemCollection:self.currentPlaylist];
    
    // Init music controller music
    self.musicController.nowPlayingItem = [self.currentPlaylist.items objectAtIndex:0];
}

#pragma mark - Actions

- (IBAction)volumeUp:(id)sender
{
    self.volumeSlider.value = 0.7f;
}

- (IBAction)volumeDown:(id)sender
{
    self.volumeSlider.value = 0.3f;
}

- (IBAction)nextSong:(id)sender
{
    [self.musicController skipToPreviousItem];
}

- (IBAction)previousSong:(id)sender
{
    [self.musicController skipToNextItem];
}

- (IBAction)pauseMusic:(id)sender
{
    [self.musicController pause];
}

- (IBAction)startMusic:(id)sender
{
     [self.musicController play];
}

- (IBAction)restartMusic:(id)sender
{
    [self.musicController skipToBeginning];
}

@end
