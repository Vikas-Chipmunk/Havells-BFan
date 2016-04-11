//
// Copyright 2014 - 2015 Qualcomm Technologies International, Ltd.
//

#import <Foundation/Foundation.h>
#import "CSRmeshApi.h"

/*!
 * @header ActuatorModelApi is a part of the CSRmesh Api and provides a set of methods related to the Actuator Model.
 */

typedef NS_ENUM (uint16_t, CSRActuatorTypes) {
    CSRActuatorTypes_Unknown = 0,
    CSRActuatorTypes_internal_air_temperature = 1,
    CSRActuatorTypes_external_air_temperature = 2,
    CSRActuatorTypes_desired_air_temperature = 3,
    CSRActuatorTypes_internal_humidity = 4,
    CSRActuatorTypes_external_humidity = 5,
    CSRActuatorTypes_external_dewpoint = 6,
    CSRActuatorTypes_internal_door = 7,
    CSRActuatorTypes_external_door = 8,
    CSRActuatorTypes_internal_window = 9,
    CSRActuatorTypes_external_window = 10,
    CSRActuatorTypes_solar_energy = 11,
    CSRActuatorTypes_number_of_activations = 12,
    CSRActuatorTypes_fridge_temperature = 13,
    CSRActuatorTypes_desired_fridge_temperature = 14,
    CSRActuatorTypes_freezer_temperature = 15,
    CSRActuatorTypes_desired_freezer_temperature = 16,
    CSRActuatorTypes_oven_temperature = 17,
    CSRActuatorTypes_desired_oven_temperature = 18,
    CSRActuatorTypes_seat_occupied = 19,
    CSRActuatorTypes_washing_machine_state = 20,
    CSRActuatorTypes_dish_washer_state = 21,
    CSRActuatorTypes_clothes_dryer_state = 22,
    CSRActuatorTypes_toaster_state = 23,
    CSRActuatorTypes_carbon_dioxide = 24,
    CSRActuatorTypes_carbon_monoxide = 25,
    CSRActuatorTypes_smoke = 26,
    CSRActuatorTypes_water_level = 27,
    CSRActuatorTypes_hot_water_temperature = 28,
    CSRActuatorTypes_cold_water_temperature = 29,
    CSRActuatorTypes_desired_water_temperature = 30,
    CSRActuatorTypes_cooker_hob_back_left_state = 31,
    CSRActuatorTypes_desired_cooker_hob_back_left_state = 32,
    CSRActuatorTypes_cooker_hob_front_left_state = 33,
    CSRActuatorTypes_desired_cooker_hob_front_left_state = 34,
    CSRActuatorTypes_cooker_hob_back_middle_state = 35,
    CSRActuatorTypes_desired_cooker_hob_back_middle_state = 36,
    CSRActuatorTypes_cooker_hob_front_middle_state = 37,
    CSRActuatorTypes_desired_cooker_hob_front_middle_state = 38,
    CSRActuatorTypes_cooker_hob_back_right_state = 39,
    CSRActuatorTypes_desired_cooker_hob_back_right_state = 40,
    CSRActuatorTypes_cooker_hob_front_right_state = 41,
    CSRActuatorTypes_desired_cooker_hob_front_right_state = 42,
    CSRActuatorTypes_desired_wakeup_alarm_time = 43,
    CSRActuatorTypes_desired_second_wakeup_alarm_time = 44,
    CSRActuatorTypes_passive_infrared_state = 45,
    CSRActuatorTypes_water_flowing = 46,
    CSRActuatorTypes_desired_water_flow = 47,
    CSRActuatorTypes_audio_level = 48,
    CSRActuatorTypes_desired_audio_level= 49,
    CSRActuatorTypes_fan_speed = 50,
    CSRActuatorTypes_desired_fan_speed = 51,
    CSRActuatorTypes_wind_speed = 52,
    CSRActuatorTypes_wind_speed_gust = 53,
    CSRActuatorTypes_wind_direction = 54,
    CSRActuatorTypes_wind_direction_gust = 55,
    CSRActuatorTypes_rain_fall_last_hour = 56,
    CSRActuatorTypes_rain_fall_today = 57,
    CSRActuatorTypes_barometric_pressure = 58,
    CSRActuatorTypes_soil_temperature = 59,
    CSRActuatorTypes_soil_moisture = 60,
    CSRActuatorTypes_window_cover_position = 61,
    CSRActuatorTypes_desired_window_cover_position = 62,
    CSRActuatorTypes_generic_1_byte = 63,
    CSRActuatorTypes_generic_2_byte = 64,
    CSRLastActuatorType                         // This must always be at the end of the table
};



@protocol ActuatorModelApiDelegate <NSObject>
@optional


/*!
 * @brief didGetActuatorTypes. An acknowledgement to the request to get the Actuator Types. This callback will be replaced with success and failure code blocks in the next version therefore please discontinue its use.
 * @param deviceId - (NSNumber *) The ID of this device. Refer to the delegate MeshServiceApi.didAssociateDevice
 * @param actuatorTypesArray - (NSArray *) Array of unsigned short NSNumber values that represent the Actuator types.
 * @param meshRequestId - (NSNumber *) The ID assigned to the Api call that triggered this callback.
 */
-(void) didGetActuatorTypes :(NSNumber *)deviceId actuatorTypesArray:(NSArray *)actuatorTypesArray meshRequestId:(NSNumber *)meshRequestId;

/*!
 * @brief didGetActuatorValue. An acknowledgement to the request to set the Actuator State. This callback will be replaced with success and failure code blocks in the next version therefore please discontinue its use.
 * @param deviceId - (NSNumber *) The ID of this device. Refer to the delegate MeshServiceApi.didAssociateDevice
 * @param actuatorType - (NSNumber *) The actuator Type as an unsigned short NSNumber.
 * @param actuatorVaue - (NSNumber *) The actuator value as an NSNumber. For temperature this is a float and units are Kelvin
 * @param meshRequestId - (NSNumber *) The ID assigned to the Api call that triggered this callback.
 */
-(void) didGetActuatorValueAck :(NSNumber *)deviceId actuatorType:(NSNumber *)actuatorType  actuatorValue:(NSNumber *)actuatorValue meshRequestId:(NSNumber *)meshRequestId;


@end


@interface ActuatorModelApi : CSRmeshApi


/*!
 * @brief getTypes - request the Actuator Types that follow from the given given Actuator. If success is not nil then upon a successful transaction the success code block is executed and the callback didGetActuatorTypes shall be invoked. If the transaction fails then the failure code block shall be executed and the callback MeshServiceApi:didTimeoutMessage shall be invoked.
 * @param deviceId - (NSNumber *) The ID of this device. Refer to the delegate MeshServiceApi.didAssociateDevice
 * @param firstType - (NSNumber *) The first actuator type as an unsigned short.
 * @param success - Code block executed upon a successful transaction. The success code block parameters are (NSNumber *deviceId, NSNumber *actuatorType)
 * @param failure - Code block executed upon a failed transaction.
 * @return meshRequestId - (NSNumber *) The id of the request. If success is nil then it is assumed an acknowledge is not required and therefore nil shall be returned.
 */
- (NSNumber *)getTypes:(NSNumber *)deviceId
             firstType:(NSNumber *)firstType
               success:(void (^)(NSNumber *deviceId, NSArray *actuatorTypes)) success
               failure:(void (^)(NSError *error))failure;




-(NSNumber *) getTypes :(NSNumber *)deviceId firstType:(NSNumber *)firstType
__deprecated_msg("use -(NSNumber *) getTypes :(NSNumber *)deviceId firstType:(NSNumber *)firstType");

/*!
 * @brief setValue - Write the given value to the given actuator. If success is not nil then upon a successful transaction the success code block is executed and the callback didGetActuatorValue shall be invoked. If the transaction fails then the failure code block shall be executed and the callback MeshServiceApi:didTimeoutMessage shall be invoked.
 * @param deviceId - (NSNumber *) The ID of this device. Refer to the delegate MeshServiceApi.didAssociateDevice
 * @param actuatorType - (NSNumber *) The actuator type as an unsigned short wrapped up in an NSNumber.
 * @param actuatorValue - (NSNumber *) The value for an actuator as double wrapped in NSNumber. For temperature units are kelvin. Note for external_air_temperature the value is an unsigned32 and is a compound of two words. word 0 = lower temperature in Kelvin multiplied by 32. word 1 = upper temperature in Kelvin multiplied by 32.
 * @param success - Code block executed upon a successful transaction. The success code block parameters are (NSNumber *deviceId, NSNumber *actuatorType)
 * @param failure - Code block executed upon a failed transaction.
 * @return meshRequestId - (NSNumber *) The id of the request. If success is nil then it is assumed an acknowledge is not required and therefore nil shall be returned.
 */
-(NSNumber *) setValue:(NSNumber *)deviceId
          actuatorType:(NSNumber *)actuatorType
         actuatorValue:(NSNumber *)actuatorValue
               success:(void (^)(NSNumber *deviceId, NSNumber *actuatorType, NSNumber *actuatorValue)) success
               failure:(void (^)(NSError *error))failure;



-(NSNumber *) setValue:(NSNumber *)deviceId actuatorType:(NSNumber *)actuatorType actuatorValue:(NSNumber *)actuatorValue acknowledge:(NSNumber *)ack
__deprecated_msg("use -(NSNumber *) setValue:(NSNumber *)deviceId actuatorType:(NSNumber *)actuatorType actuatorValue:(NSNumber *)actuatorValue success:(void (^)(NSNumber *deviceId, NSNumber *actuatorType)) success failure:(void (^)(NSError *error))failure");


/*!
 * @brief getValue - Request the value for the given actuator. Upon a successful transaction the success code block is executed and the callback didGetActuatorValue shall be invoked. If the transaction fails then the failure code block shall be executed and the callback MeshServiceApi:didTimeoutMessage shall be invoked.
 * @param deviceId - (NSNumber *) The ID of this device. Refer to the delegate MeshServiceApi.didAssociateDevice
 * @param actuatorType - (NSNumber *) The actuator type as an unsigned short wrapped up in an NSNumber.
 * @param success - Code block executed upon a successful transaction. The success code block parameters are (NSNumber *deviceId, NSNumber *actuatorType)
 * @param failure - Code block executed upon a failed transaction.
 * @return meshRequestId - (NSNumber *) The id of the request. If success is nil then it is assumed an acknowledge is not required and therefore nil shall be returned.
 */
- (NSNumber *)getValue:(NSNumber *)deviceId
          actuatorType:(NSNumber *)actuatorType
               success:(void (^)(NSNumber *deviceId, NSNumber *actuatorType, NSNumber *actuatorValue)) success
               failure:(void (^)(NSError *error))failure;

// The Delegate for this object
@property (nonatomic, weak)   id<ActuatorModelApiDelegate>  actuatorModelApiDelegate;


@end

