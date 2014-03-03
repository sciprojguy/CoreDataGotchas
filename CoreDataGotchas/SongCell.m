//
//  SongCell.m
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//  This free-range code can be used by anyone for anything.  Enjoy.
//

#import "SongCell.h"

@implementation SongCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFromDataSource:(SongsDataSource *)dataSource forRow:(NSInteger)row inSection:(NSInteger)section
{
    NSDictionary *songDict = [dataSource songAtIndex:row inSection:section];
    self.title.text = songDict[@"title"];
    self.artist.text = songDict[@"artist"];
    long durationInSeconds = [songDict[@"lengthInSeconds"] longValue];
    
    //TODO - move this into utility class
    long minutes = durationInSeconds / 60;
    long seconds = durationInSeconds - minutes*60;
    self.duration.text = [NSString stringWithFormat:@"%ld min %ld sec", minutes, seconds];
}

@end
