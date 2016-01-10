//
//  MusicEntity.m
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "MusicEntity.h"

@implementation MusicEntity
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{  @"musicId" : @"id"};
}

@end
