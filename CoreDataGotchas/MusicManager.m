//
//  MusicManager.m
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//
//  This free-range code can be used by anyone for anything.  Enjoy.
//

#import "MusicManager.h"

@interface MusicManager ()
@property (nonatomic, strong) NSOperationQueue *myQueue;

@property (nonatomic, strong) NSManagedObjectContext *MOC;
@property (nonatomic, strong) NSManagedObjectModel *MOM;
@property (nonatomic, strong) NSPersistentStore *PS;
@property (nonatomic, strong) NSPersistentStoreCoordinator *PSC;

@end

@implementation MusicManager

+(MusicManager *)defaultManager
{
    static MusicManager *mgr = nil;
    static dispatch_once_t token = 0;
    dispatch_once( &token, ^{
    
        mgr = [[MusicManager alloc] init];
        mgr.myQueue = [[NSOperationQueue alloc] init];
        mgr.myQueue.maxConcurrentOperationCount = 1;
        
        [mgr setUpCoreData];
    });
    return mgr;
}

-(void)setUpCoreData
{
    NSError *err = nil;
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Music" withExtension:@"momd"];
    
    self.MOM = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.PSC = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_MOM];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES );
    NSString *docDirPath = [NSString stringWithFormat:@"%@/Music1.db", paths[0]];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                            nil];
    
    NSURL *ddURL = [[NSURL alloc] initFileURLWithPath:docDirPath];
    [_PSC addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:ddURL options:options error:&err];
   
    self.MOC = [[NSManagedObjectContext alloc] init];
    _MOC.persistentStoreCoordinator = _PSC;
}

-(void)songForObjectId:(NSManagedObjectID *)OID withCompletion:(void(^)(NSDictionary *songDict, NSError *err))completion
{
    [_myQueue addOperationWithBlock:^{
        NSError *err = nil;
        
        NSDictionary *songDict = nil;
        
        Song *song = (Song *)[_MOC objectWithID:OID];
        if(nil != song)
        {
            songDict = @{@"title":song.title, @"artist":song.artist, @"lengthInSeconds":song.lengthInSeconds};
        }
        if(completion)
            completion(songDict, err);
    }];
}

-(void)addSongForDictionary:(NSDictionary *)songDict withCompletion:(void(^)(NSError *err))completion
{
    [_myQueue addOperationWithBlock:^{
        NSError *err = nil;
        Song *newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:_MOC];
        
        newSong.title = songDict[@"title"];
        newSong.artist = songDict[@"artist"];
        newSong.lengthInSeconds = songDict[@"lengthInSeconds"];

        [_MOC save:&err];
        if(completion)
            completion(err);
    }];
}

-(void)updateSongWithId:(NSManagedObjectID *)songId withDictionary:(NSDictionary *)songDict withCompletion:(void(^)(NSError *err))completion
{
    [_myQueue addOperationWithBlock:^{
        Song *songToEdit = nil;
        NSError *err = nil;
        
        songToEdit = (Song *)[_MOC objectWithID:songId];
        if(nil != songDict[@"title"])
            songToEdit.title = songDict[@"title"];
        if(nil != songDict[@"artist"])
            songToEdit.artist = songDict[@"artist"];
        if(nil != songDict[@"lengthInSeconds"])
            songToEdit.lengthInSeconds = songDict[@"lengthInSeconds"];
        [_MOC save:&err];
        if(completion)
            completion(err);
    }];
}

-(void)deleteSongWithId:(NSManagedObjectID *)songId withCompletion:(void(^)(NSError *err))completion
{
    [_myQueue addOperationWithBlock:^{
        Song *songToEdit = nil;
        NSError *err = nil;
        songToEdit = (Song *)[_MOC objectWithID:songId];
        [_MOC deleteObject:songToEdit];
        [_MOC save:&err];
        if(completion)
            completion(err);
    }];
}

-(void)songsWithCompletion:(void(^)(SongsDataSource *src, NSError *err))completion
{
    [_myQueue addOperationWithBlock:^{
        NSError *err = nil;
        SongsDataSource *songsDS = nil;
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
        
        NSEntityDescription *songEntity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:_MOC];
        NSDictionary *attributes = [songEntity attributesByName];
        
        NSExpressionDescription* objectIdDesc = [[NSExpressionDescription alloc] init];
        objectIdDesc.name = @"objectID";
        objectIdDesc.expression = [NSExpression expressionForEvaluatedObject];
        objectIdDesc.expressionResultType = NSObjectIDAttributeType;

        NSAttributeDescription *titleAttr = attributes[@"title"];
        NSAttributeDescription *artistAttr = attributes[@"artist"];
        NSAttributeDescription *durationAttr = attributes[@"lengthInSeconds"];

        req.propertiesToFetch = @[titleAttr, artistAttr, durationAttr, objectIdDesc];
        req.resultType = NSDictionaryResultType;
        
        NSArray *songsArray = [_MOC executeFetchRequest:req error:&err];
        songsDS = [[SongsDataSource alloc] initWithSongs:songsArray];
        if(completion)
            completion(songsDS,err);
    }];
}

@end
