//
//  MusicHandler.m
//  MyMusic
//
//  Created by He yang on 16/2/1.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "MusicHandler.h"
#import "MusicEntity.h"
#import "BaseHelper.h"
#import "UIImageView+WebCache.h"
#import "MusicController.h"
#import <MediaPlayer/MediaPlayer.h>
@implementation MusicHandler


+(void)cacheMusicCoverWithMusicEntities:(NSArray *)musicEntities currentIndex:(NSInteger)currentIndex{
    NSInteger previousIndex = currentIndex - 1;
    NSInteger nextIndex = currentIndex + 1;
    previousIndex = previousIndex < 0 ? 0 : previousIndex;
    nextIndex = nextIndex == musicEntities.count? musicEntities.count - 1 : nextIndex;
    NSMutableArray *indexArray = [NSMutableArray array];
    [indexArray addObject:[NSNumber numberWithInteger:previousIndex]];
    [indexArray addObject:[NSNumber numberWithInteger:nextIndex]];
    for (NSNumber *indexNum in indexArray) {
        NSString *imageWidth = [NSString stringWithFormat:@"%.f",(SCREEN_WIDTH - 70) * 2];
        MusicEntity *music = musicEntities[indexNum.integerValue];
        NSURL *imageUrl = [BaseHelper qiniuImageCenter:music.pic withWidth:imageWidth withHeight:imageWidth];
        
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl.absoluteString];
        if (!image) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:imageUrl options:SDWebImageDownloaderUseNSURLCache progress:nil completed:nil];
        }
    }
}

+(void)configNowPlayingInfoCenter{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        MusicEntity *music = [MusicController sharedInstance].currentPlayingMusic;
        AVURLAsset *audioAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:music.music_url] options:nil];
        CMTime audioDuration = audioAsset.duration;
        float audioDurationSeconds = CMTimeGetSeconds(audioDuration);
        [dict setObject:music.title forKey:MPMediaItemPropertyTitle];
        [dict setObject:music.artist forKey:MPMediaItemPropertyArtist];
        [dict setObject:[MusicController sharedInstance].musicTitle forKey:MPMediaItemPropertyAlbumTitle];
        [dict setObject:@(audioDurationSeconds) forKey:MPMediaItemPropertyPlaybackDuration];
        CGFloat playerAlbumWidth = (SCREEN_WIDTH - 16) *2;
        UIImageView *playAlbum = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, playerAlbumWidth, playerAlbumWidth)];
        UIImage *placeholderImage = [UIImage imageNamed:@"music_lock_screen_placeholder"];
        NSURL *url = [BaseHelper qiniuImageCenter:music.pic
                                        withWidth:[NSString stringWithFormat:@"%.f",playerAlbumWidth]
                                       withHeight:[NSString stringWithFormat:@"%.f",playerAlbumWidth]];
        [playAlbum sd_setImageWithURL:url placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (!image) {
                image = [UIImage new];
                image = placeholderImage;
                
            }
            MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:image];
            playAlbum.contentMode = UIViewContentModeScaleAspectFill;
            [dict setObject:artWork forKey:MPMediaItemPropertyArtwork];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }];
    }
   
}

@end
