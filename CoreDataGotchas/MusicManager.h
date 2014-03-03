//
//  MusicManager.h
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//

#import <Foundation/Foundation.h>

#import "Song.h"
#import "SongsDataSource.h"

@interface MusicManager : NSObject

+(MusicManager *)defaultManager;

-(void)songsWithCompletion:(void(^)(SongsDataSource *src, NSError *err))completion;
-(void)songForObjectId:(NSManagedObjectID *)OID withCompletion:(void(^)(NSDictionary *song, NSError *err))completion;

-(void)addSongForDictionary:(NSDictionary *)songDict withCompletion:(void(^)(NSError *err))completion;
-(void)updateSongWithId:(NSManagedObjectID *)songId withDictionary:(NSDictionary *)songDict withCompletion:(void(^)(NSError *err))completion;
-(void)deleteSongWithId:(NSManagedObjectID *)songId withCompletion:(void(^)(NSError *err))completion;

@end
