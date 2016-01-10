//
//  ChildIndicatorView.m
//  MyMusic
//
//  Created by He yang on 16/1/9.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "ChildIndicatorView.h"

@implementation ChildIndicatorView

+ (instancetype)sharedInstance {
    static ChildIndicatorView *_sharedMusicIndicator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedMusicIndicator = [[ChildIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 50, 44)];
    
    });
    
    return _sharedMusicIndicator;
}

@end
