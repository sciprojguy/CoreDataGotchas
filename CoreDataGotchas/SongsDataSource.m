//
//  SongsDataSource.m
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//

#import "SongsDataSource.h"

@interface SongsDataSource ()
@property (nonatomic, strong) NSMutableArray *songs;
@end

@implementation SongsDataSource

-(id)initWithSongs:(NSArray *)arrayOfSongs
{
    self = [super init];
    if(nil != self)
    {
        self.songs = [NSMutableArray arrayWithArray:arrayOfSongs];
    }
    return self;
}

-(NSInteger)numberOfSections
{
    return 1;
}

-(NSInteger)numberofSongsInSection:(NSInteger)section
{
    return [_songs count];
}

-(NSDictionary *)songAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    return _songs[index];
}

-(void)removeSongAtIndex:(NSInteger)index inSection:(NSInteger)section
{
    [_songs removeObjectAtIndex:index];
}

@end
