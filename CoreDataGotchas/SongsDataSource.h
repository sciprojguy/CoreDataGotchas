//
//  SongsDataSource.h
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//  This free-range code can be used by anyone for anything.  Enjoy.
//

#import <Foundation/Foundation.h>

@interface SongsDataSource : NSObject

-(id)initWithSongs:(NSArray *)arrayOfSongs;
-(NSInteger)numberOfSections;
-(NSInteger)numberofSongsInSection:(NSInteger)section;
-(NSDictionary *)songAtIndex:(NSInteger)index inSection:(NSInteger)section;
-(void)removeSongAtIndex:(NSInteger)index inSection:(NSInteger)section;

@end
