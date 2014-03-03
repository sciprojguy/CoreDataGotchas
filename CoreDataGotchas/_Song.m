// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Song.m instead.

#import "_Song.h"

const struct SongAttributes SongAttributes = {
	.artist = @"artist",
	.lengthInSeconds = @"lengthInSeconds",
	.title = @"title",
};

const struct SongRelationships SongRelationships = {
	.genres = @"genres",
};

const struct SongFetchedProperties SongFetchedProperties = {
};

@implementation SongID
@end

@implementation _Song

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Song";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Song" inManagedObjectContext:moc_];
}

- (SongID*)objectID {
	return (SongID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"lengthInSecondsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"lengthInSeconds"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic artist;






@dynamic lengthInSeconds;



- (int16_t)lengthInSecondsValue {
	NSNumber *result = [self lengthInSeconds];
	return [result shortValue];
}

- (void)setLengthInSecondsValue:(int16_t)value_ {
	[self setLengthInSeconds:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveLengthInSecondsValue {
	NSNumber *result = [self primitiveLengthInSeconds];
	return [result shortValue];
}

- (void)setPrimitiveLengthInSecondsValue:(int16_t)value_ {
	[self setPrimitiveLengthInSeconds:[NSNumber numberWithShort:value_]];
}





@dynamic title;






@dynamic genres;

	






@end
