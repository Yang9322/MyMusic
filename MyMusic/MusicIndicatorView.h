//
//  MusicIndicatorView.h
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,IndicatorViewState){
    IndicatorViewStateStopped = 0,
    IndicatorViewStatePlaying,
    IndicatorViewStatePaused
};

@interface MusicIndicatorView : UIView

@property (nonatomic, assign) IndicatorViewState state;

@property (nonatomic, assign) BOOL hidesWhenStopped;


@end
