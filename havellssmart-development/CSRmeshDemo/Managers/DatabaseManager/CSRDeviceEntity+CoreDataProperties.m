//
//  CSRDeviceEntity+CoreDataProperties.m
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 10/02/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CSRDeviceEntity+CoreDataProperties.h"

@implementation CSRDeviceEntity (CoreDataProperties)

@dynamic appearance;
@dynamic authCode;
@dynamic deviceHash;
@dynamic deviceId;
@dynamic favourite;
@dynamic groups;
@dynamic isAssociated;
@dynamic isAssociatedToAPlace;
@dynamic modelHigh;
@dynamic modelLow;
@dynamic name;
@dynamic nGroups;
@dynamic uuid;
@dynamic uuidString;
@dynamic areas;
@dynamic relationshipToFavourites;
@dynamic relationshipToMyRules;

@end
