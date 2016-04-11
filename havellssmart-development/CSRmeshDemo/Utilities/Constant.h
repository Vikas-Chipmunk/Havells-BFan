//
//  Constant.h
//  CSRmeshDemo
//
//  Created by Bimal Sharma on 28/01/16.
//  Copyright © 2016 Cambridge Silicon Radio Ltd. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

#define APPLICATION_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey] //@"CSRmeshDemo"


#define TEMPERATURE_SENSOR_RULE_1 @"<30"
#define TEMPERATURE_SENSOR_RULE_2 @">30"

#define LUMINANCE_SENSOR_RULE_1 @"<50"
#define LUMINANCE_SENSOR_RULE_2 @">50"

#define MOTION_SENSOR_RULE_1 @"Motion True"
#define MOTION_SENSOR_RULE_2 @"Motion False"


#define SENSOR_TYPE_MOTION @"Motion"
#define SENSOR_TYPE_TEMPERATURE @"Temperature"
#define SENSOR_TYPE_LUMINANCE @"Luminance"


#endif /* Constant_h */
