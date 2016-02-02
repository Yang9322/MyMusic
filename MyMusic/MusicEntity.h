//
//  MusicEntity.h
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicEntity : NSObject

@property (nonatomic, copy) NSNumber *musicId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *music_url;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, assign) BOOL isFavorited;


@end
