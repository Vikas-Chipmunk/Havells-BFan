//
//  Favourite+CoreDataProperties.h
//  CSRmeshDemo
//
//  Created by SudheerPalchuri on 07/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Favourite.h"

NS_ASSUME_NONNULL_BEGIN

@interface Favourite (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *x;
@property (nullable, nonatomic, retain) NSNumber *y;
@property (nullable, nonatomic, retain) NSNumber *alpha;
@property (nullable, nonatomic, retain) NSNumber *red;
@property (nullable, nonatomic, retain) NSNumber *green;
@property (nullable, nonatomic, retain) NSNumber *blue;
@property (nullable, nonatomic, retain) NSNumber *intensity;
@property (nullable, nonatomic, retain) NSString *name;

@end

NS_ASSUME_NONNULL_END
