//
//  Places+CoreDataProperties.h
//  CSRmeshDemo
//
//  Created by SudheerPalchuri on 06/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Places.h"

NS_ASSUME_NONNULL_BEGIN

@interface Places (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<CSRDeviceEntity *> *relationshipToDevices;

@end

@interface Places (CoreDataGeneratedAccessors)

- (void)addRelationshipToDevicesObject:(CSRDeviceEntity *)value;
- (void)removeRelationshipToDevicesObject:(CSRDeviceEntity *)value;
- (void)addRelationshipToDevices:(NSSet<CSRDeviceEntity *> *)values;
- (void)removeRelationshipToDevices:(NSSet<CSRDeviceEntity *> *)values;

@end

NS_ASSUME_NONNULL_END
