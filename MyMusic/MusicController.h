//
//  MusicController.h
//  MyMusic
//
//  Created by He yang on 16/1/10.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOUAudioStreamer.h"
#import "GVUserDefaults+Properties.h"
#import "MusicEntity.h"


@protocol MusicControllerDelegate <NSObject>

@optional
- (void)updatePlaybackIndicatorOfVisisbleCells;


@end


@interface MusicController : UIViewController
@property(nonatomic,copy)NSString *musicTitle;
@property (nonatomic,strong)NSMutableArray *musicEntities;
@property (nonatomic,assign)NSInteger specialIndex;
@property (nonatomic, assign) MusicCycleType musicCycleType;
@property (nonatomic, assign) BOOL dontReloadMusic;
@property (nonatomic,strong)MusicEntity *musicEntity;
@property (nonatomic,weak)id<MusicControllerDelegate> delegate;
@property (nonatomic, strong) DOUAudioStreamer *streamer;
+ (instancetype)sharedInstance;

- (MusicEntity *)currentPlayingMusic;

@end
