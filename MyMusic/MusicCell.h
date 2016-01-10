//
//  MusicCell.h
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicEntity.h"
#import "MusicIndicatorView.h"
@interface MusicCell : UITableViewCell


@property (nonatomic,strong) MusicEntity *musicEntity;
@property (nonatomic, assign) NSInteger musicNumber;
@property (nonatomic, assign) IndicatorViewState state;


@end
