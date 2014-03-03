//
//  SongDetailViewController.h
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//  This free-range code can be used by anyone for anything.  Enjoy.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Song.h"

#import "SongsDataSource.h"

@interface SongDetailViewController : UIViewController

@property (nonatomic, assign) BOOL isNewSong;
@property (nonatomic, strong) NSManagedObjectID *objectId;

-(IBAction)cancel:(id)obj;
-(IBAction)done:(id)obj;

@end
