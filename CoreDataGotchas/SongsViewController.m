//
//  ViewController.m
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//

#import "SongsViewController.h"
#import "SongDetailViewController.h"
#import "SongCell.h"
#import "SongsDataSource.h"
#import "MusicManager.h"
#import "NSObject+UIAlertView_Blocks.h"

@interface SongsViewController ()
@property (nonatomic, strong) SongsDataSource *dataSource;
@property (nonatomic, strong) IBOutlet UITableView *songsTable;
@end

@implementation SongsViewController

-(void)reloadSongs:(NSNotification *)note
{
    _dataSource = nil;
    [[MusicManager defaultManager] songsWithCompletion:^(SongsDataSource *src, NSError *err) {
        if(nil == err)
        {
            self.dataSource = src;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_songsTable reloadData];
            });
        }
        else
        {
        }
    }];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadSongs:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadSongs:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numSections = 0;
    if(nil != _dataSource)
        numSections = [_dataSource numberOfSections];
    return numSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numRows = 0;
    if(nil != _dataSource)
        numRows = [_dataSource numberofSongsInSection:section];
    return numRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SongCell *cell = (SongCell *)[tableView dequeueReusableCellWithIdentifier:@"SongCell"];
    if(nil == cell)
        cell = (SongCell *)[[SongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SongCell"];
    [cell setFromDataSource:_dataSource forRow:indexPath.row inSection:indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UITableViewCellEditingStyleDelete == editingStyle)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Umm...", @"")
                message:NSLocalizedString(@"Do you really want to delete this song entry?", @"")
                delegate:nil
                cancelButtonTitle:NSLocalizedString(@"Nope", @"")
                otherButtonTitles:NSLocalizedString(@"Yep", @""), nil];
            [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex){
                if(0 == buttonIndex)
                {
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else
                {
                    NSDictionary *row = [_dataSource songAtIndex:indexPath.row inSection:indexPath.section];
                    [[MusicManager defaultManager] deleteSongWithId:row[@"objectID"] withCompletion:^(NSError *err) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_dataSource removeSongAtIndex:indexPath.row inSection:0];
                            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        });
                    }];
                }
            }];
        });
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([@"NewSongModal" isEqualToString:[segue identifier]])
    {
        SongDetailViewController *dvc = (SongDetailViewController *)[segue destinationViewController];
        dvc.isNewSong = YES;
    }
    else
    if([@"EditSongModal" isEqualToString:[segue identifier]])
    {
        SongDetailViewController *dvc = (SongDetailViewController *)[segue destinationViewController];
        dvc.isNewSong = NO;
        SongCell *cell = (SongCell *)sender;
        NSIndexPath *path = [_songsTable indexPathForCell:cell];
        NSDictionary *songDict = [_dataSource songAtIndex:path.row inSection:path.section];
        NSManagedObjectID *OID = songDict[@"objectID"];
        dvc.objectId = OID;
    }
}

@end
