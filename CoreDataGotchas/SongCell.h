//
//  SongCell.h
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//  This free-range code can be used by anyone for anything.  Enjoy.
//

#import <UIKit/UIKit.h>

#import "Song.h"
#import "SongsDataSource.h"

@interface SongCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *artist;
@property (nonatomic, strong) IBOutlet UILabel *duration;
@property (nonatomic, strong) IBOutlet UILabel *genres;

-(void)setFromDataSource:(SongsDataSource *)dataSource forRow:(NSInteger)row inSection:(NSInteger)section;

@end
