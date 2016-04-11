//
//  MyRules+CoreDataProperties.h
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 11/02/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MyRules.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyRules (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *deviceId;
@property (nullable, nonatomic, retain) NSString *deviceName;
@property (nullable, nonatomic, retain) NSString *entityId;
@property (nullable, nonatomic, retain) NSString *rule;
@property (nullable, nonatomic, retain) NSString *sensorId;
@property (nullable, nonatomic, retain) NSString *sensorType;
@property (nullable, nonatomic, retain) NSSet<CSRDeviceEntity *> *relationshipToDeviceEntity;

@end

@interface MyRules (CoreDataGeneratedAccessors)

- (void)addRelationshipToDeviceEntityObject:(CSRDeviceEntity *)value;
- (void)removeRelationshipToDeviceEntityObject:(CSRDeviceEntity *)value;
- (void)addRelationshipToDeviceEntity:(NSSet<CSRDeviceEntity *> *)values;
- (void)removeRelationshipToDeviceEntity:(NSSet<CSRDeviceEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
