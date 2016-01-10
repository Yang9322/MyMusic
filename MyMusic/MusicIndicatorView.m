//
//  MusicIndicatorView.m
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "MusicIndicatorView.h"
#import "IndicatorContentView.h"
@interface MusicIndicatorView ()

@property (nonatomic,readonly) IndicatorContentView *contentView;
@property (nonatomic,assign)BOOL hasInstalledContraints;


@end

@implementation MusicIndicatorView


- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}


-(void)commonInit{
    self.layer.masksToBounds = YES;
    _contentView = [[IndicatorContentView alloc] init];
    [self addSubview:_contentView];
    [self prepareLayoutPriorities];
    [self setNeedsUpdateConstraints];
    self.state = IndicatorViewStateStopped;
    self.hidesWhenStopped = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    
}

- (void)prepareLayoutPriorities
{
    // Custom views should set default values for both orientations on creation,
    // based on their content, typically to NSLayoutPriorityDefaultLow or NSLayoutPriorityDefaultHigh.
//    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [self setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
//    
//    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
//    [self setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
}

- (void)updateConstraints
{
    if (!self.hasInstalledContraints) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0.0]];
        
        //      [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        //          make.center.mas_equalTo(self.center);
        //
        //      }];
        //
        self.hasInstalledContraints = YES;
    }
    
    [super updateConstraints];
}


- (CGSize)intrinsicContentSize{
    
//    NSLog(@" 111---  %@ ---111",[NSValue valueWithCGSize:[self.contentView intrinsicContentSize]] );

    return [self.contentView intrinsicContentSize];
}


//- (UIView *)viewForBaselineLayout{
//    return self.contentView;
//}
//
//- (CGSize)sizeThatFits:(CGSize)size{
//    return [self intrinsicContentSize];
//}

-(void)setHidesWhenStopped:(BOOL)hidesWhenStopped{
    _hidesWhenStopped = hidesWhenStopped;
    if (self.state == IndicatorViewStateStopped) {
        self.hidden = self.hidesWhenStopped;
    }
}


-(void)setState:(IndicatorViewState)state{
    _state = state;
    
    if (self.state == IndicatorViewStateStopped) {
        [self stopAnimating];
        if (self.hidesWhenStopped) {
            self.hidden = YES;
        }
    }else{
        if (self.state == IndicatorViewStatePlaying) {
            [self startAnimating];
        }else if (self.state == IndicatorViewStatePaused){
            [self stopAnimating];
        }
        self.hidden = NO;
    }
}


- (void)startAnimating
{
    if (self.contentView.isOscillating) {
        return;
    }
    
    [self.contentView stopDecay];
    [self.contentView startOscillation];
}

- (void)stopAnimating
{
    if (!self.contentView.isOscillating) {
        return;
    }
    
    [self.contentView stopOscillation];
    [self.contentView startDecay];
}


- (void)applicationWillEnterForeground:(NSNotification*)notification
{
    // When an app entered background, UIKit removes all animations
    // even if it's an infinite animation.
    // So we restart the animation here if it should be when the app came back to foreground.
    if (self.state == IndicatorViewStatePlaying) {
        [self startAnimating];
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
