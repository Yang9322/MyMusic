//
//  Track.h
//  MyMusic
//
//  Created by He yang on 16/2/1.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DOUAudioFile.h"

@interface Track : NSObject<DOUAudioFile>

@property (nonatomic,strong)NSURL *audioFileURL;
@property (nonatomic,strong)NSURL *tempFileURL;
@property (nonatomic,strong)NSURL *cacheFileURL;


@end
