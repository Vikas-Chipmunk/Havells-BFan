/*!
    Copyright [2015] Qualcomm Technologies International, Ltd.
*/
/* Note: this is an auto-generated file. */


#import <Foundation/Foundation.h>
#import "CSRRestBaseObject.h"


/*!
    Request Object for Updating Tenant Information.
*/

@interface CSRRestUpdateTenantInfoRequest : CSRRestBaseObject


/*!
    State of Tenant. This is either active, inactive or deleted.
*/
 typedef NS_OPTIONS(NSInteger, CSRRestUpdateTenantInfoRequestStateEnum) {
  CSRRestUpdateTenantInfoRequestStateEnumactive,
  CSRRestUpdateTenantInfoRequestStateEnuminactive,
  CSRRestUpdateTenantInfoRequestStateEnumdeleted,

};



/*!
    Name of Tenant
*/
@property(nonatomic) NSString* name;
  
/*!
    State of Tenant. This is either active, inactive or deleted.
*/
@property(nonatomic) CSRRestUpdateTenantInfoRequestStateEnum state;

/*!
  Constructs instance of CSRRestUpdateTenantInfoRequest

  @param name - (NSString*) Name of Tenant
  @param state - (CSRRestUpdateTenantInfoRequestStateEnum) State of Tenant. This is either active, inactive or deleted.
  
  @return instance of CSRRestUpdateTenantInfoRequest
*/
- (id) initWithname: (NSString*) name     
       state: (CSRRestUpdateTenantInfoRequestStateEnum) state;
       

@end
