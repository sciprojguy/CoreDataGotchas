//
//  CoreDataTools.h
//  CoreDataMigration
//
//  Created by Chris Woodard on 6/18/13.
//  Copyright (c) 2013 Chris Woodard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataTools : NSObject

+(NSArray *)versionsOfModelAtURL:(NSURL *)momdURL;
+(NSDictionary *)diffModelAtURL:(NSURL *)leftModelURL withModelAtURL:(NSURL *)rightModelURL;
+(void)compareModelEntities:(NSManagedObjectModel *)leftModel withModel:(NSManagedObjectModel *)rightModel;
+(void)dumpModel:(NSManagedObjectModel *)model;

@end
