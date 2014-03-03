// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Song.h instead.

#import <CoreData/CoreData.h>


extern const struct SongAttributes {
	 NSString *artist;
	 NSString *lengthInSeconds;
	 NSString *songId;
	 NSString *title;
} SongAttributes;

extern const struct SongRelationships {
} SongRelationships;

extern const struct SongFetchedProperties {
} SongFetchedProperties;







@interface SongID : NSManagedObjectID {}
@end

@interface _Song : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SongID*)objectID;





@property (nonatomic, retain) NSString* artist;



//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* lengthInSeconds;



@property int16_t lengthInSecondsValue;
- (int16_t)lengthInSecondsValue;
- (void)setLengthInSecondsValue:(int16_t)value_;

//- (BOOL)validateLengthInSeconds:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSNumber* songId;



@property int32_t songIdValue;
- (int32_t)songIdValue;
- (void)setSongIdValue:(int32_t)value_;

//- (BOOL)validateSongId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






@end

@interface _Song (CoreDataGeneratedAccessors)

@end

@interface _Song (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveArtist;
- (void)setPrimitiveArtist:(NSString*)value;




- (NSNumber*)primitiveLengthInSeconds;
- (void)setPrimitiveLengthInSeconds:(NSNumber*)value;

- (int16_t)primitiveLengthInSecondsValue;
- (void)setPrimitiveLengthInSecondsValue:(int16_t)value_;




- (NSNumber*)primitiveSongId;
- (void)setPrimitiveSongId:(NSNumber*)value;

- (int32_t)primitiveSongIdValue;
- (void)setPrimitiveSongIdValue:(int32_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
