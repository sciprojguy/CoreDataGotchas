// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Song.h instead.

#import <CoreData/CoreData.h>


extern const struct SongAttributes {
	__unsafe_unretained NSString *artist;
	__unsafe_unretained NSString *lengthInSeconds;
	__unsafe_unretained NSString *title;
} SongAttributes;

extern const struct SongRelationships {
	__unsafe_unretained NSString *genres;
} SongRelationships;

extern const struct SongFetchedProperties {
} SongFetchedProperties;

@class Genre;





@interface SongID : NSManagedObjectID {}
@end

@interface _Song : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SongID*)objectID;





@property (nonatomic, strong) NSString* artist;



//- (BOOL)validateArtist:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* lengthInSeconds;



@property int16_t lengthInSecondsValue;
- (int16_t)lengthInSecondsValue;
- (void)setLengthInSecondsValue:(int16_t)value_;

//- (BOOL)validateLengthInSeconds:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Genre *genres;

//- (BOOL)validateGenres:(id*)value_ error:(NSError**)error_;





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




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (Genre*)primitiveGenres;
- (void)setPrimitiveGenres:(Genre*)value;


@end
