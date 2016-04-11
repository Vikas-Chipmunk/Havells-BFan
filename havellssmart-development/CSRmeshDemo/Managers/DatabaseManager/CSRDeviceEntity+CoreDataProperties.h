//
//  CSRDeviceEntity+CoreDataProperties.h
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 10/02/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CSRDeviceEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CSRDeviceEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *appearance;
@property (nullable, nonatomic, retain) NSData *authCode;
@property (nullable, nonatomic, retain) NSData *deviceHash;
@property (nullable, nonatomic, retain) NSNumber *deviceId;
@property (nullable, nonatomic, retain) NSNumber *favourite;
@property (nullable, nonatomic, retain) NSData *groups;
@property (nullable, nonatomic, retain) NSNumber *isAssociated;
@property (nullable, nonatomic, retain) NSNumber *isAssociatedToAPlace;
@property (nullable, nonatomic, retain) NSData *modelHigh;
@property (nullable, nonatomic, retain) NSData *modelLow;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *nGroups;
@property (nullable, nonatomic, retain) NSData *uuid;
@property (nullable, nonatomic, retain) NSString *uuidString;
@property (nullable, nonatomic, retain) NSSet<CSRAreaEntity *> *areas;
@property (nullable, nonatomic, retain) NSSet<Favourite *> *relationshipToFavourites;
@property (nullable, nonatomic, retain) MyRules *relationshipToMyRules;

@end

@interface CSRDeviceEntity (CoreDataGeneratedAccessors)

- (void)addAreasObject:(CSRAreaEntity *)value;
- (void)removeAreasObject:(CSRAreaEntity *)value;
- (void)addAreas:(NSSet<CSRAreaEntity *> *)values;
- (void)removeAreas:(NSSet<CSRAreaEntity *> *)values;

- (void)addRelationshipToFavouritesObject:(Favourite *)value;
- (void)removeRelationshipToFavouritesObject:(Favourite *)value;
- (void)addRelationshipToFavourites:(NSSet<Favourite *> *)values;
- (void)removeRelationshipToFavourites:(NSSet<Favourite *> *)values;

@end

NS_ASSUME_NONNULL_END
