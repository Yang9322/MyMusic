//
//  MusicHandler.h
//  MyMusic
//
//  Created by He yang on 16/2/1.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicHandler : NSObject


+ (void)cacheMusicCoverWithMusicEntities:(NSArray *)musicEntities currentIndex:(NSInteger)currentIndex;

+ (void)configNowPlayingInfoCenter;

@end
