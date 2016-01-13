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

@interface MusicViewController ()

@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) MPMediaItemCollection *currentPlaylist;
@property (nonatomic, strong) MPMusicPlayerController *musicController;

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
    
    // Select a playlist
    NSInteger randomPlaylist = arc4random_uniform([playlists count]);
    self.currentPlaylist = [playlists objectAtIndex:randomPlaylist];
    
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
