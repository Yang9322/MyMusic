//
//  MusicCell.m
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "MusicCell.h"
#import "MusicIndicatorView.h"

@interface MusicCell ()
@property (weak, nonatomic) IBOutlet UILabel *musicNumbelLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicArtistLabel;
@property (weak, nonatomic) IBOutlet MusicIndicatorView *musicIndicatorView;


@end

@implementation MusicCell

- (void)awakeFromNib {
    // Initialization code
}




-(void)setMusicEntity:(MusicEntity *)musicEntity{
    _musicEntity = musicEntity;
    _musicTitleLabel.text = musicEntity.title;
    _musicArtistLabel.text = musicEntity.artist;
    
}


-(void)setMusicNumber:(NSInteger)musicNumber{
    _musicNumber = musicNumber;
    _musicNumbelLabel.text = [NSString stringWithFormat:@"%ld", (long)musicNumber];
    _musicNumbelLabel.textAlignment = NSTextAlignmentCenter;
    if (musicNumber > 999) {
        _musicNumbelLabel.font = [UIFont systemFontOfSize:13];
    }
}


- (IndicatorViewState)state {
    return self.musicIndicatorView.state;
}

- (void)setState:(IndicatorViewState)state {
    self.musicIndicatorView.state = state;
    self.musicNumbelLabel.hidden = (state != IndicatorViewStateStopped);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
