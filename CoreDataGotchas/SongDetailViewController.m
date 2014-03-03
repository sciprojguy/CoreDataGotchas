//
//  SongDetailViewController.m
//  CoreDataGotchas
//
//  Created by Chris Woodard on 2/27/14.
//
//  This free-range code can be used by anyone for anything.  Enjoy.
//

#import "SongDetailViewController.h"
#import "Song.h"
#import "MusicManager.h"

#import "NSObject+UIAlertView_Blocks.h"

@interface SongDetailViewController ()
@property (nonatomic, strong) IBOutlet UITextField *titleField;
@property (nonatomic, strong) IBOutlet UITextField *artistField;
@property (nonatomic, strong) IBOutlet UITextField *durationField;
@property (nonatomic, strong) IBOutlet UITableView *genresTable;
@end

@implementation SongDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];

    if(NO == _isNewSong)
    {
        [[MusicManager defaultManager] songForObjectId:_objectId withCompletion:^(NSDictionary *songDict, NSError *err) {
            if(nil == err)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // assign field values from songDict
                    self.titleField.text = songDict[@"title"];
                    self.artistField.text = songDict[@"artist"];
                    self.durationField.text = [NSString stringWithFormat:@"%@", songDict[@"lengthInSeconds"]];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh-Oh", @"")
                        message:NSLocalizedString(@"No such song, something must be wrong.", @"")
                        delegate:nil
                        cancelButtonTitle:NSLocalizedString(@"Drat!", @"")
                        otherButtonTitles: nil];
                    [alertView showWithCompletion:nil];
                });
            }
        }];
    }
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissMe
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)cancel:(id)obj
{
    [self dismissMe];
}

-(IBAction)done:(id)obj
{
    NSString *songTitle = self.titleField.text;
    NSString *songArtist = self.artistField.text;
    NSNumber *songDuration = @([self.durationField.text integerValue]);
    
    NSDictionary *songDict = @{
        @"title":songTitle,
        @"artist":songArtist,
        @"lengthInSeconds":songDuration
    };
    
    if(_isNewSong)
    {
        [[MusicManager defaultManager] addSongForDictionary:songDict withCompletion:^(NSError *err) {
            if(nil == err)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissMe];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh-Oh", @"")
                        message:NSLocalizedString(@"Can't save song, something must be very wrong wrong.", @"")
                        delegate:nil
                        cancelButtonTitle:NSLocalizedString(@"Drat!", @"")
                        otherButtonTitles: nil];
                    [alertView showWithCompletion:nil];
                });
            }
        }];
    }
    else
    {
        [[MusicManager defaultManager] updateSongWithId:_objectId withDictionary:songDict withCompletion:^(NSError *err) {
            if(nil == err)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissMe];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh-Oh", @"")
                        message:NSLocalizedString(@"Can't save song, something must be very wrong wrong.", @"")
                        delegate:nil
                        cancelButtonTitle:NSLocalizedString(@"Drat!", @"")
                        otherButtonTitles: nil];
                    [alertView showWithCompletion:nil];
                });
            }
        }];
    }
}

@end
