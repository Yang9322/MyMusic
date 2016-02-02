//
//  MusicController.m
//  MyMusic
//
//  Created by He yang on 16/1/10.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "MusicController.h"
#import "ChildIndicatorView.h"
#import "MusicSlider.h"
#import "BaseHelper.h"
#import "UIImageView+WebCache.h"
#import "UIView+Animations.h"
#import "MusicHandler.h"
#import "Track.h"
#import "NSString+Additions.h"


static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface MusicController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingContraints;
@property (nonatomic,strong)NSTimer *musicDurationTimer;
@property (nonatomic,assign)NSInteger currentIndex;
@property (nonatomic,strong)ChildIndicatorView *sharedIndicator;
@property (nonatomic,strong)NSMutableArray *originArray;
@property (nonatomic,strong)NSMutableArray *randomArray;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *previousMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *nextMusicButton;
@property (weak, nonatomic) IBOutlet UIButton *musicToggleButton;
@property (weak, nonatomic) IBOutlet UIButton *musicCycleButton;
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet MusicSlider *musicSlider;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *musicTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroudImageView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

@property (nonatomic,assign) BOOL musicIsPlaying;

@end

@implementation MusicController


+ (instancetype)sharedInstance{
    static MusicController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[UIStoryboard storyboardWithName:@"Music" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"music"];
        sharedController.streamer = [[DOUAudioStreamer alloc] init];
    });
    return sharedController;
}


#pragma mark - button clicked

- (IBAction)dismissBtnClicked:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        weakSelf.dontReloadMusic = NO;
//        weakSelf.lastMusicUrl = [weakSelf currentPlayingMusic].musicUrl.mutableCopy;
    }];
}
- (IBAction)musicCycleButtonClicked:(id)sender {
}
- (IBAction)musicPreviousButtonClikcked:(id)sender {
}
- (IBAction)musicToggleButtonClicked:(id)sender {
}
- (IBAction)musicNextButtonClicked:(id)sender {
    if (_musicEntities.count == 1) {
        return;
    }
    if (_musicCycleType == MusicCycleTypeShuffle && _musicEntities.count >2) {
        [self setupRandomMusicIfNeeded];
    }
    
}


- (void)setupRandomMusicIfNeeded{
    [self  loadOriginArrayIfNeeded];
    int t = arc4random()%_originArray.count;
    _randomArray[0] = _originArray[t];
    _originArray[t] = _originArray.lastObject;
    [_originArray removeLastObject];
    self.currentIndex = [_randomArray[0] integerValue];
}


#pragma mark -  life cycle



- (void)viewDidLoad {
    [super viewDidLoad];
    [self adapterIphone4];
    _musicDurationTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSliderValue:) userInfo:nil repeats:YES];
    _currentIndex = 0;
    _sharedIndicator = [ChildIndicatorView sharedInstance];
    _originArray = [NSMutableArray array];
    _randomArray = [NSMutableArray array];
    
    [self addPanGesgure];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _musicCycleType = [GVUserDefaults standardUserDefaults].musicCycleType;
    [self setupRadioMusicIfNeeded];
    
    if (_dontReloadMusic && _streamer) {
        return;
    }
    _currentIndex = 0;
    [_originArray removeAllObjects];
    
    
    [self loadOriginArrayIfNeeded];
    
    [self createStreamer];
    
}




#pragma mark -  basic setup
-(void)adapterIphone4{
    if (IS_IPHONE_4_OR_LESS) {
        CGFloat margin = 40;
        _leadingContraint.constant = margin;
        _trailingContraints.constant = margin;
    }
    

}


- (void)setupMusicViewWithMusicEntity:(MusicEntity *)entity{
    _musicEntity = entity;
    _musicTitleLabel.text = _musicEntity.title;
    _singerLabel.text = _musicEntity.artist;
    _musicTitleLabel.text = _musicTitle;
    [self setupBackgroundImage];
    [self checkMusicFavoritedIcon];
}



-(void)setupBackgroundImage{
    
    _albumImageView.layer.cornerRadius = 7;
    _albumImageView.layer.masksToBounds = YES;
    
    NSString *imageWidth = [NSString stringWithFormat:@"%.f",(SCREEN_WIDTH - 70) *2];
    NSURL *imageUrl = [BaseHelper qiniuImageCenter:_musicEntity.pic withWidth:imageWidth withHeight:imageWidth];
    [_backgroudImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    [_albumImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    if (![_visualEffectView isDescendantOfView:_backgroundView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = self.view.bounds;
        [_backgroundView addSubview:_visualEffectView];

    }
    
    [_backgroudImageView startTransitionAnimation];
    [_albumImageView startTransitionAnimation];
}

- (void)setupRadioMusicIfNeeded {
    _menuButton.hidden = NO;
    [self updateMusicCycleButton];
    [self checkCurrentIndex];
}

- (void)updateMusicCycleButton{
    switch (_musicCycleType) {
        case MusicCycleTypeLoopAll:
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        case MusicCycleTypeShuffle:
            [_musicCycleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
        case MusicCycleTypeLoopSingle:
            [_musicCycleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}


- (void)setBackgroudImage{
    _albumImageView.layer.cornerRadius = 7;
    _albumImageView.layer.masksToBounds = YES;
    NSString *imageWidth =[NSString stringWithFormat:@"%.f",(SCREEN_WIDTH - 70) * 2];
    NSURL *imageUrl = [BaseHelper qiniuImageCenter:_musicEntity.pic withWidth:imageWidth withHeight:imageWidth];
    [_backgroudImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    [_albumImageView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"music_placeholder"]];
    
    if (![_visualEffectView isDescendantOfView:_backgroundView]) {
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        _visualEffectView.frame = self.view.bounds;
        [_backgroundView addSubview:_visualEffectView];
        [_backgroundView bringSubviewToFront:_visualEffectView];
        
    }
    [_backgroudImageView startTransitionAnimation];
    [_albumImageView startTransitionAnimation];
}

-(void)addPanGesgure{
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBtnClicked:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipe];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


-(void)loadOriginArrayIfNeeded{
    if (_originArray.count == 0) {
        for (int i = 0; i < _musicEntities.count; i++) {
            [_originArray addObject:[NSNumber numberWithInt:i]];
        }
        NSNumber *currentNumber = [NSNumber numberWithInteger:_currentIndex];
        if ([_originArray containsObject:currentNumber]) {
            [_originArray removeObject:currentNumber];
        }
    }
}



- (void)setMusicIsPlaying:(BOOL)musicIsPlaying{
    _musicIsPlaying = musicIsPlaying;
    if (_musicIsPlaying) {
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
        
    }else{
        [_musicToggleButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}


#pragma mark music convenient method

-(void) loadPreviousAndNextMusicImage{
    [MusicHandler cacheMusicCoverWithMusicEntities:_musicEntities currentIndex:_currentIndex];

}


#pragma mark - handle music slider
-(void)updateSliderValue:(id)timer{
    if (!_streamer) {
        return;
    }
    if (_streamer.status == DOUAudioStreamerFinished) {
        [_streamer play];
    }
    if ([_streamer duration] == 0) {
        [_musicSlider setValue:0.0f animated:NO];
    }else{
        if (_streamer.currentTime >= _streamer.duration) {
            _streamer.currentTime -= _streamer.duration;
        }
        [_musicSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
        [self updateProgressLabelValue];
    }
    
}


- (void)updateProgressLabelValue{
    _beginTimeLabel.text = [NSString timeIntervalToMMSSFormat:_streamer.currentTime];
    _endTimeLabel.text = [NSString timeIntervalToMMSSFormat:_streamer.duration];
}


- (void)updateStatus{
   
    self.musicIsPlaying = NO;
    _sharedIndicator.state = IndicatorViewStateStopped;
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            self.musicIsPlaying = YES;
            _sharedIndicator.state = IndicatorViewStatePlaying;
            break;
        case DOUAudioStreamerPaused:
            break;
        case DOUAudioStreamerIdle:
            break;
        case DOUAudioStreamerFinished:
            if (_musicCycleType ==  MusicCycleTypeLoopSingle) {
                [_streamer play];
            }else{
                [self musicNextButtonClicked:nil];
            }
            
            break;
            case DOUAudioStreamerBuffering:
            _sharedIndicator.state = IndicatorViewStatePlaying;
            break;
            
            case DOUAudioStreamerError:
            break;
            
    }
    [self updateMusicsCellsState];
}


- (void)updateBufferingStatus{
    
}


#pragma mark audio handler

-(void)createStreamer{
    if (_specialIndex > 0) {
        _currentIndex = _specialIndex;
        _specialIndex = 0;
    }
    [self setupMusicViewWithMusicEntity:_musicEntities[_currentIndex]];

    [self loadPreviousAndNextMusicImage];
    
    [MusicHandler configNowPlayingInfoCenter];
    Track *track = [[Track alloc] init];
//    track.audioFileURL = [NSURL URLWithString:_musicEntity.music_url];
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:_musicEntity.fileName ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    track.audioFileURL = fileURL;
    
//    NSString *url = _musicEntity.music_url;
//    NSURL *fileURL = [NSURL URLWithString:url];
    

  
    @try {
        [self removeStreamerObserver];
    }
    @catch (NSException *exception) {
        
        
    }
    
    _streamer = nil;
    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    
    [self addStreamerObserver];
    [self.streamer play];

}



- (void)removeStreamerObserver{
    [_streamer removeObserver:self forKeyPath:@"status"];
    [_streamer removeObserver:self forKeyPath:@"duration"];
    [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
    
}


-(void)addStreamerObserver{
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }else if ([keyPath isEqualToString:@"duration"]){
        [self performSelector:@selector(updateSliderValue:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }else if ([keyPath isEqualToString:@"status"]){
        [self performSelector:@selector(updateBufferingStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}




#pragma mark - check current index

-(void)checkCurrentIndex{
    
    if ([self currentIndexIsInvalid]) {
        _currentIndex = 0;
    }
}


-(BOOL)currentIndexIsInvalid{
    return _currentIndex >= _musicEntities.count;
}


#pragma mark favoriteMusic

- (BOOL)hasBeenFavoriteMusic {
    return _musicEntity.isFavorited;
}

- (void)checkMusicFavoritedIcon {
    if ([self hasBeenFavoriteMusic]) {
        [_favoriteButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    }
}


#pragma mark MusicControllerDelegate
- (void)updateMusicsCellsState {
    if (_delegate && [_delegate respondsToSelector:@selector(updatePlaybackIndicatorOfVisisbleCells)]) {
        [_delegate updatePlaybackIndicatorOfVisisbleCells];
    }
}



#pragma mark public method

- (MusicEntity *)currentPlayingMusic {
    if (_musicEntities.count == 0) {
        _musicEntities = nil;
    }
    
    return _musicEntities[_currentIndex];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
