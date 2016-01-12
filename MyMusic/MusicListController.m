//
//  MusicListController.m
//  MyMusic
//
//  Created by He yang on 16/1/8.
//  Copyright © 2016年 He yang. All rights reserved.
//

#import "MusicListController.h"
#import "MusicController.h"
#import "MJRefresh/MJRefresh.h"
#import "MusicEntity.h"
#import "MJExtension.h"
#import "MusicCell.h"
#import "MusicIndicatorView.h"
#import "ChildIndicatorView.h"
@interface MusicListController ()

@property (nonatomic, strong) NSMutableArray *musicEntities;
@property (nonatomic, assign) NSInteger currentIndex;


@end

@implementation MusicListController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createIndicatorView];

}


- (void)createIndicatorView{
    ChildIndicatorView *indicator = [ChildIndicatorView sharedInstance];
    indicator.hidesWhenStopped = NO;
    indicator.tintColor = [UIColor blueColor];
    HYDBAnyVar(indicator.state);

    if (indicator.state != IndicatorViewStatePlaying) {
        indicator.state = IndicatorViewStatePlaying;
        indicator.state = IndicatorViewStateStopped;
    }else{
        indicator.state = IndicatorViewStatePlaying;
    }
    
    indicator.state = IndicatorViewStatePlaying;
    
    [self.navigationController.navigationBar addSubview:indicator];
    
        UITapGestureRecognizer *tapInditator = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapIndicator)];
        tapInditator.numberOfTapsRequired = 1;
        [indicator addGestureRecognizer:tapInditator];
    
}



-(void)handleTapIndicator{
    MusicController *musicVC = [MusicController sharedInstance];
//    if (musicVC.musicEntities.count == 0) {
//        [self showMiddleHint:@"暂无正在播放的歌曲"];
//        return;
//    }
//    musicVC.dontReloadMusic = YES;
    [self presentVCWith:musicVC];
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Music List";
    
        _musicEntities = [NSMutableArray array];

      self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    [self.tableView.mj_header beginRefreshing];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)loadData{
    
    NSDictionary *dict = [self dictionaryWithContensOfJSON:@"music_list.json"];
     self.musicEntities = [MusicEntity mj_objectArrayWithKeyValuesArray:dict[@"data"]];
    [_musicEntities addObjectsFromArray:self.musicEntities];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
}


- (NSDictionary *)dictionaryWithContensOfJSON:(NSString *)fileName{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) {
        return nil;
    }
    return result;
}



#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicEntities.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *musicListCell = @"musicListCell";

    MusicEntity *music = _musicEntities[indexPath.row];
    MusicCell *cell = [tableView dequeueReusableCellWithIdentifier:musicListCell];
    cell.musicNumber = indexPath.row + 1;
    cell.musicEntity = music;
//    cell.delegate = self;
    [self updatePlaybackIndicatorOfCell:cell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 57;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MusicController *vc = [MusicController sharedInstance];
    vc.musicEntities = _musicEntities;
    vc.musicTitle = self.navigationItem.title;
    vc.specialIndex = indexPath.row;
    [self presentVCWith:vc];
    
    [self updateIndicatorWithIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)presentVCWith:(MusicController *)vc{
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:navVc animated:YES completion:nil];
}


- (void)updateIndicatorWithIndexPath: (NSIndexPath *)indexPath{
    for (MusicCell *cell in self.tableView.visibleCells) {
        cell.state = IndicatorViewStateStopped;
    }
    MusicCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.state = IndicatorViewStatePlaying;
}



- (void)updatePlaybackIndicatorOfCell:(MusicCell *)cell {

        cell.state = IndicatorViewStateStopped;
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
