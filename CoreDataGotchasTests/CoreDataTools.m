//
//  CoreDataTools.m
//  CoreDataMigration
//
//  Created by Chris Woodard on 6/18/13.
//  Copyright (c) 2013 Chris Woodard. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "CoreDataTools.h"
#import "MusicManager.h"

@implementation CoreDataTools

// @interface CoreDataTools : NSObject

+(NSString *)pathForStoredDatabaseNamed:(NSString *)aString
{
    NSBundle *bundle = [NSBundle bundleForClass:[MusicManager class]];
    return [bundle pathForResource:aString ofType:@"db"];
}

+(NSString *)pathToDocumentsForPersistentStoreNamed:(NSString *)aString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    return [NSString stringWithFormat:@"%@/%@", paths[0], aString];
}

//+(NSURL *)urlForModelNamed:(NSString *)modelName
//{
//}

+(NSArray *)versionsOfModelAtURL:(NSURL *)momdURL
{
    NSMutableArray *models = [NSMutableArray arrayWithCapacity:0];
    NSString *path = [momdURL path];
    NSFileManager *mgr = [NSFileManager defaultManager];
    NSDirectoryEnumerator *e = [mgr enumeratorAtPath:path];
    id obj;
    while( obj = [e nextObject] )
    {
        if([obj isKindOfClass:[NSString class]])
        {
            NSString *s = (NSString *)obj;
            if([@"mom" isEqualToString:[s substringWithRange:NSMakeRange(s.length-3, 3)]])
            {
                [models addObject:s];
            }
        }
    }
    return models;
}


/******
utility method to do a diff of one version of a core data model to another version of a core data model.  useful
for retro-fitting custom migraiton policies.  by convention, version n-1 goes on left and version n goes on right
 ******/

+(NSDictionary *)diffModelAtURL:(NSURL *)leftModelURL withModelAtURL:(NSURL *)rightModelURL
{
    NSMutableDictionary *diffDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    NSManagedObjectModel *leftModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:leftModelURL];
    NSManagedObjectModel *rightModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:rightModelURL];
    
    NSDictionary *leftEntities = [leftModel entitiesByName];
    NSArray *leftEntityNames = [leftEntities allKeys];
    
    NSDictionary *rightEntities = [rightModel entitiesByName];
    NSArray *rightEntityNames = [rightEntities allKeys];
    
    NSMutableSet *commonEntities = [NSMutableSet setWithArray:leftEntityNames];
    [commonEntities intersectSet:[NSSet setWithArray:rightEntityNames]];
    
    NSMutableSet *entitiesOnlyInLeft = [NSMutableSet setWithArray:leftEntityNames];
    [entitiesOnlyInLeft minusSet:commonEntities];
    
    NSMutableSet *entitiesOnlyInRight = [NSMutableSet setWithArray:rightEntityNames];
    [entitiesOnlyInRight minusSet:commonEntities];
    
    NSMutableArray *entitiesRemoved = [NSMutableArray arrayWithCapacity:0];
    for( NSString *entityName in entitiesOnlyInLeft )
    {
        // tbd - change this to a @{@"name":entityName,@"type":entityType}
        [entitiesRemoved addObject:[entityName copy]];
    }
    
    if(entitiesRemoved.count>0)
        diffDict[@"entitiesRemoved"] = entitiesRemoved;
    
    NSMutableArray *entitiesAdded = [NSMutableArray arrayWithCapacity:0];
    for( NSString *entityName in entitiesOnlyInRight )
    {
        NSEntityDescription *ed = rightEntities[entityName];
        
        NSDictionary *properties = ed.propertiesByName;
        NSMutableDictionary *edNew = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableArray *edProperties = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *edRelationships = [NSMutableArray arrayWithCapacity:0];
        for( id propertyName in [properties allKeys] )
        {
            id property = properties[propertyName];
            if([property isKindOfClass:[NSAttributeDescription class]])
            {
                NSAttributeDescription *ad = (NSAttributeDescription *)property;
                NSString *adClassName = (ad.attributeValueClassName!=nil)?ad.attributeValueClassName:@"null";
                
                [edProperties addObject:@{@"name":ad.name, @"type":adClassName, @"numtype":@(ad.attributeType)}];
            }
        }
        edNew[@"name"] = entityName;
        edNew[@"properties"] = edProperties;
        edNew[@"relationships"] = edRelationships;
        [entitiesAdded addObject:edNew];
    }
    
    if(entitiesAdded.count>0)
        diffDict[@"entitiesAdded"] = entitiesAdded;
    
    // now for all of the common entities go through and compare their properties
    for( NSString *commonEntityName in commonEntities )
    {
        NSEntityDescription *leftEntity = leftEntities[ commonEntityName ];
        NSDictionary *leftProperties = [leftEntity propertiesByName];
        NSArray *propertyNamesForLeftEntity = [leftProperties allKeys];
        NSDictionary *leftRelationships = [leftEntity relationshipsByName];
        NSArray *relationshipNamesForLeftEntity = [leftRelationships allKeys];
        
        NSEntityDescription *rightEntity = rightEntities[ commonEntityName ];
        NSDictionary *rightProperties = [rightEntity propertiesByName];
        NSArray *propertyNamesForRightEntity = [rightProperties allKeys];
        NSDictionary *rightRelationships = [rightEntity relationshipsByName];
        NSArray *relationshipNamesForRightEntity = [rightRelationships allKeys];
        
        // get properties and diff them the same way
        NSMutableSet *commonPropertyNames = [NSMutableSet setWithArray:propertyNamesForLeftEntity];
        [commonPropertyNames intersectSet:[NSSet setWithArray:propertyNamesForRightEntity]];
        
        NSMutableSet *propertiesOnlyOnLeftEntities = [NSMutableSet setWithArray:propertyNamesForLeftEntity];
        [propertiesOnlyOnLeftEntities minusSet:commonPropertyNames];
        
        NSMutableSet *propertiesOnlyOnRightEntities = [NSMutableSet setWithArray:propertyNamesForRightEntity];
        [propertiesOnlyOnRightEntities minusSet:commonPropertyNames];

        // get properties and diff them the same way
        NSMutableSet *commonRelationshipNames = [NSMutableSet setWithArray:relationshipNamesForLeftEntity];
        [commonRelationshipNames intersectSet:[NSSet setWithArray:relationshipNamesForRightEntity]];
        
        NSMutableSet *relationshipsOnlyOnLeftEntities = [NSMutableSet setWithArray:relationshipNamesForLeftEntity];
        [relationshipsOnlyOnLeftEntities minusSet:commonRelationshipNames];
        
        NSMutableSet *relationshipsOnlyOnRightEntities = [NSMutableSet setWithArray:relationshipNamesForRightEntity];
        [relationshipsOnlyOnRightEntities minusSet:commonRelationshipNames];
        
        // now for each of these categories we sift them into properties and relationships
        NSMutableArray *removedProperties = [NSMutableArray arrayWithCapacity:0];
        for( id propertyName in propertiesOnlyOnLeftEntities )
        {
            [removedProperties addObject:[propertyName copy]];
        }
        
        NSMutableArray *removedRelationships = [NSMutableArray arrayWithCapacity:0];
        for( id rel in relationshipsOnlyOnLeftEntities )
        {
            NSString *relName = rel;
            [removedRelationships addObject:[relName copy]];
        }
        
        NSMutableArray *addedProperties = [NSMutableArray arrayWithCapacity:0];
        for( id propertyName in propertiesOnlyOnRightEntities )
        {
            id property = rightProperties[propertyName];
            if([property isKindOfClass:[NSAttributeDescription class]])
            {
                NSAttributeDescription *pd = (NSAttributeDescription *)rightProperties[propertyName];
                NSString *propName = [[rightProperties[propertyName] valueForKey:@"name"] copy];
                NSString *propValueType = pd.attributeValueClassName;
                NSDictionary *addedProperty = @{
                    @"name":propName,
                    @"type":propValueType,
                    @"numtype":@(pd.attributeType)
                };
                [addedProperties addObject:addedProperty];
            }
        }
        
        NSMutableArray *addedRelationships = [NSMutableArray arrayWithCapacity:0];
        for( id relName in relationshipsOnlyOnRightEntities )
        {
            NSRelationshipDescription *rd = (NSRelationshipDescription *)rightRelationships[relName];
            NSString *destEntityName = rd.destinationEntity.name;
            BOOL isToMany = rd.isToMany;
            NSDictionary *addedRelationship = @{
                @"name":relName,
                @"dest":destEntityName,
                @"isToMany":@(isToMany),
                @"minCount":@(rd.minCount),
                @"maxCount":@(rd.maxCount)
            };
            [addedRelationships addObject:addedRelationship];
        }
        
        // properties that have changed type etc
        NSMutableArray *changedProperties = [NSMutableArray arrayWithCapacity:0];
        for( id propName in commonPropertyNames )
        {
            id leftProperty = leftProperties[propName];
            id rightProperty = rightProperties[propName];
            if([leftProperty isKindOfClass:[NSAttributeDescription class]] && [rightProperty isKindOfClass:[NSAttributeDescription class]])
            {
                NSAttributeDescription *leftAd = (NSAttributeDescription *)leftProperty;
                
                NSAttributeDescription *rightAd = (NSAttributeDescription *)rightProperty;
                
                BOOL propertyHasChanged = NO;
                
                NSString *leftClassName = (nil != leftAd.attributeValueClassName)?leftAd.attributeValueClassName:@"null";
                NSString *rightClassName = (nil != rightAd.attributeValueClassName)?rightAd.attributeValueClassName:@"null";
                // has type changed?
                if(NO == [rightClassName isEqualToString:leftClassName])
                    propertyHasChanged = YES;
                if(leftAd.attributeType != rightAd.attributeType)
                    propertyHasChanged = YES;
                
                if(propertyHasChanged)
                {
                    
                    NSDictionary *changedProperty = @{
                        @"name":propName,
                        @"oldTypeStr":leftClassName,
                        @"newTypeStr":rightClassName,
                        @"oldAttrType":@(leftAd.attributeType),
                        @"newAttrType":@(rightAd.attributeType)
                    };
                    [changedProperties addObject:changedProperty];
                }
            }
        }
        
        NSMutableArray *changedRelationships = [NSMutableArray arrayWithCapacity:0];
        for( id relName in commonRelationshipNames )
        {
            NSRelationshipDescription *leftRd = (NSRelationshipDescription *)leftRelationships[relName];
            NSRelationshipDescription *rightRd = (NSRelationshipDescription *)rightRelationships[relName];

            BOOL relationshipHasChanged = NO;
            if(NO == [leftRd.name isEqualToString:rightRd.name])
                relationshipHasChanged = YES;
            if(leftRd.minCount != rightRd.maxCount)
                relationshipHasChanged = YES;
            if(leftRd.maxCount != rightRd.maxCount)
                relationshipHasChanged = YES;
            if(leftRd.isToMany != rightRd.isToMany)
                relationshipHasChanged = YES;
            
            if(relationshipHasChanged)
            {
                NSDictionary *changedRelationship = @{
                    @"name":relName,
                    @"oldDest":leftRd.destinationEntity.name,
                    @"newDest":rightRd.destinationEntity.name,
                    @"oldIsToMany":@(leftRd.isToMany),
                    @"newIsToMany":@(rightRd.isToMany),
                    @"oldMinCount":@(leftRd.minCount),
                    @"newMinCount":@(rightRd.minCount),
                    @"oldMaxCount":@(leftRd.maxCount),
                    @"newMaxCount":@(rightRd.maxCount)
                };
                [changedRelationships addObject:changedRelationship];
            }
        }
        
        BOOL entityHasChanges = NO;
        if(addedProperties.count>0)
            entityHasChanges = YES;
        if(addedRelationships.count>0)
            entityHasChanges = YES;
        if(removedProperties.count>0)
            entityHasChanges = YES;
        if(removedRelationships.count>0)
            entityHasChanges = YES;
        if(changedProperties.count>0)
            entityHasChanges = YES;
        if(changedRelationships.count>0)
            entityHasChanges = YES;
        
        if(entityHasChanges)
        {
            if(nil == diffDict[@"changedEntities"])
                diffDict[@"changedEntities"] = [NSMutableDictionary dictionaryWithCapacity:0];
            
            NSMutableDictionary *entityChanges = [NSMutableDictionary dictionaryWithCapacity:0];
            if(addedProperties.count>0)
                entityChanges[@"newProperties"] = addedProperties;
            if(addedRelationships.count>0)
                entityChanges[@"newRelationships"] = addedRelationships;
            if(removedProperties.count>0)
                entityChanges[@"removedProperties"] = removedProperties;
            if(removedRelationships.count>0)
                entityChanges[@"removedRelationships"] = removedRelationships;
            if(changedProperties.count>0)
                entityChanges[@"changedProperties"] = changedProperties;
            if(changedRelationships.count>0)
                entityChanges[@"changedRelationships"] = changedRelationships;
            if(nil == diffDict[@"changedEntities"][commonEntityName])
                diffDict[@"changedEntities"][commonEntityName] = [NSMutableDictionary dictionaryWithCapacity:0];
            diffDict[@"changedEntities"][commonEntityName] = entityChanges;
        }
       
    }


    return diffDict;
}

+(void)compareModelEntities:(NSManagedObjectModel *)leftModel withModel:(NSManagedObjectModel *)rightModel
{
    NSDictionary *leftEntities = [leftModel entitiesByName];
    NSArray *leftEntityNames = [leftEntities allKeys];
    
    NSDictionary *rightEntities = [rightModel entitiesByName];
    NSArray *rightEntityNames = [rightEntities allKeys];
    
    NSMutableSet *commonEntities = [NSMutableSet setWithArray:leftEntityNames];
    [commonEntities intersectSet:[NSSet setWithArray:rightEntityNames]];
    
    NSMutableSet *entitiesOnlyInLeft = [NSMutableSet setWithArray:leftEntityNames];
    [entitiesOnlyInLeft minusSet:commonEntities];
    
    NSMutableSet *entitiesOnlyInRight = [NSMutableSet setWithArray:rightEntityNames];
    [entitiesOnlyInRight minusSet:commonEntities];
    
    NSLog(@"left only: %@", entitiesOnlyInLeft);
    NSLog(@"right only: %@", entitiesOnlyInRight);
    NSLog(@"common: %@", commonEntities);
    
    // now for all of the common entities go through and compare their properties
    for( NSString *commonEntityName in commonEntities )
    {
        NSEntityDescription *leftEntity = leftEntities[ commonEntityName ];
        NSArray *propertyNamesForLeftEntity = [[leftEntity propertiesByName] allKeys];
        
        NSEntityDescription *rightEntity = rightEntities[ commonEntityName ];
        NSArray *propertyNamesForRightEntity = [[rightEntity propertiesByName] allKeys];
        
        // get properties and relationships and diff them the same way
        NSMutableSet *commonProperties = [NSMutableSet setWithArray:propertyNamesForLeftEntity];
        [commonProperties intersectSet:[NSSet setWithArray:propertyNamesForRightEntity]];
        
        NSMutableSet *propertiesOnlyOnLeftEntities = [NSMutableSet setWithArray:propertyNamesForLeftEntity];
        [propertiesOnlyOnLeftEntities minusSet:commonProperties];
        
        NSMutableSet *propertiesOnlyOnRightEntities = [NSMutableSet setWithArray:propertyNamesForRightEntity];
        [propertiesOnlyOnRightEntities minusSet:commonProperties];
        
        // now display property diffs - left only, right only, 
    }
}

+(void)dumpModel:(NSManagedObjectModel *)model
{
    NSDictionary *modelEntities = [model entitiesByName];
    NSArray *sortedEntityNames = [[modelEntities allKeys]
        sortedArrayUsingComparator:^NSComparisonResult(NSString *en1, NSString *en2) {
            return [en1 compare:en2];
        }
    ];
    for( NSString *name in sortedEntityNames )
    {
        NSLog(@"entity name: %@", name);
        NSEntityDescription *ed = modelEntities[name];
        for( id property in [ed properties] )
        {
            NSLog(@" ");
            if([property isKindOfClass:[NSAttributeDescription class]])
            {
                NSAttributeDescription *ad = (NSAttributeDescription *)property;
                NSLog(@">> property name: %@", ad.name);
                NSLog(@">> property isOptional: %d", ad.isOptional);
                NSLog(@">> property isTransient: %d", ad.isTransient);
                NSLog(@">> property type: %@", ad.attributeValueClassName);
            }
            else
            if([property isKindOfClass:[NSRelationshipDescription class]])
            {
                NSRelationshipDescription *rd = (NSRelationshipDescription *)property;
                NSEntityDescription *destEntity = rd.destinationEntity;
                NSLog(@">> relationship name: %@", rd.name);
                NSLog(@">> relationship dest: %@", destEntity.name);
                NSLog(@">> relationship isOptional: %d", rd.isOptional);
                NSLog(@">> relationship isTransient: %d", rd.isTransient);
                NSLog(@">> relationship toMany: %d", rd.isToMany);
            }
        }
    }
}

@end
