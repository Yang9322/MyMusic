//
//  IndicatorContentView.m
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "IndicatorContentView.h"

static const NSInteger kBarCount = 3;

static const CGFloat kBarWidth = 3.0;
static const CGFloat kBarIdleHeight = 3.0;

static const CGFloat kHorizonBarSpacing = 2.0;
static const CGFloat kRetinaHorizonBarSpacing = 1.5;

static const CGFloat kBarMinPeakHeight = 6.0;
static const CGFloat kBarMaxPeakHeight = 12.0;

static const CFTimeInterval kMinBaseOscillationPeriod = 0.6;
static const CFTimeInterval kMaxBaseOscillationPeriod = 0.8;

static NSString* const kOscillationAnimationKey = @"oscillation";

static const CFTimeInterval kDecayDuration = 0.3;
static NSString *const kDecayAnimationKey = @"decay";




@interface IndicatorContentView ()


@property(nonatomic,strong)NSArray *barLayers;
@property(nonatomic,assign)BOOL hasInstalledConstrans;

@end

@implementation IndicatorContentView

- (id)init{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self prepareBarLayers];
        [self tintColorDidChange];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


-(void)prepareBarLayers{
    
    NSMutableArray *barLayers = [NSMutableArray array];
    CGFloat xOffset = 0.0;
    for (NSInteger i = 0 ; i < kBarCount; i ++) {
        CALayer *layer = [self createBarLayerWithXOffset:xOffset layerIndex:i + 1];
        [barLayers addObject:layer];
        [self.layer addSublayer:layer];
        xOffset = CGRectGetMaxX(layer.frame) + [self horizontaiBarSpacing];
    }
    _barLayers = barLayers;
}


-(CALayer *)createBarLayerWithXOffset:(CGFloat )xOffset layerIndex:(NSInteger)layerIndex{
    CALayer *layer = [CALayer layer];
    layer.anchorPoint = CGPointMake(0.0, 1.0);
    layer.position = CGPointMake(xOffset, kBarMaxPeakHeight);
    layer.bounds = CGRectMake(0, 0, kBarWidth, (layerIndex * kBarMaxPeakHeight/kBarCount));
    
    return layer;
}


-(CGFloat)horizontaiBarSpacing{
    if ([UIScreen mainScreen].scale == 2.0) {
        return kRetinaHorizonBarSpacing;
    }else{
        return kHorizonBarSpacing;
    }
}


- (void)tintColorDidChange{
    for (CALayer *layer in _barLayers) {
        layer.backgroundColor = self.tintColor.CGColor;
    }
}


- (CGSize) intrinsicContentSize{
    CGRect unionFrame = CGRectZero;
    for (CALayer *layer in self.barLayers) {
        unionFrame = CGRectUnion(unionFrame, layer.frame);
    }
    return unionFrame.size;
}


-(void)updateConstraints{
    if (!self.hasInstalledConstrans) {
        CGSize size = [self intrinsicContentSize];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0
                                                           constant:size.width]];
     
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0
                                                          constant:size.height]];
        self.hasInstalledConstrans = YES;
    }
    [super updateConstraints];
}


-(BOOL)isOscillating{
    CAAnimation *animation = [self.barLayers.firstObject animationForKey:kOscillationAnimationKey];
    return (animation != nil);
}

#pragma Oscillation

-(void)startOscillation{
    CFTimeInterval basePeriod = kMinBaseOscillationPeriod + (drand48() * (kMaxBaseOscillationPeriod - kMinBaseOscillationPeriod));
    
    for (CALayer *layer in self.barLayers) {
        [self startOscillatingBarLayer:layer basePeriod:basePeriod];
    }
}


-(void)stopOscillation{
    for (CALayer *layer in self.barLayers) {
        [layer removeAnimationForKey:kOscillationAnimationKey];
    }
}


#pragma decay

-(void)startDecay{
    for (CALayer *layer in self.barLayers) {
        [self startDecayingBarLayer:layer];
    }
}



-(void)stopDecay{
    for (CALayer *layer in self.barLayers) {
        [layer removeAnimationForKey:kDecayAnimationKey];
    }
}


-(void)startOscillatingBarLayer : (CALayer *)layer basePeriod:(CFTimeInterval)basePeriod{
    
    CGFloat peakHeight = kBarMinPeakHeight + (arc4random_uniform(kBarMaxPeakHeight - kBarMinPeakHeight + 1));
    CGRect fromBouns = layer.bounds;
    fromBouns.size.height = kBarIdleHeight;
    
    CGRect toBounds = layer.bounds;
    toBounds.size.height = peakHeight;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:fromBouns];
    animation.toValue = [NSValue valueWithCGRect:toBounds];
//    NSLog(@" 111---animation.fromValue ->  %@ ---111",animation.fromValue );
//    NSLog(@" 222---animation.toValue ->  %@ ---222",animation.toValue );


    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    animation.duration = (basePeriod / 2) * (kBarMaxPeakHeight / peakHeight);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:animation forKey:kOscillationAnimationKey];
}

-(void)startDecayingBarLayer : (CALayer *)layer{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    animation.fromValue = [NSValue valueWithCGRect:((CALayer *)layer.presentationLayer).bounds];
    animation.toValue = [NSValue valueWithCGRect:layer.bounds];
    animation.duration = kDecayDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [layer addAnimation:animation  forKey:kDecayAnimationKey];
}



@end
