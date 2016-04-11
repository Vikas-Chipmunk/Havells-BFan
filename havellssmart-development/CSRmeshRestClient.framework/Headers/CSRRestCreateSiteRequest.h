/*!
    Copyright [2015] Qualcomm Technologies International, Ltd.
*/
/* Note: this is an auto-generated file. */


#import <Foundation/Foundation.h>
#import "CSRRestBaseObject.h"
#import "CSRRestSiteInfoObject.h"


/*!
    Request Object for Creating Site.
*/

@interface CSRRestCreateSiteRequest : CSRRestBaseObject


/*!
    State of site. This is either active or inactive. Transactions are not permitted for inactive sites. Default value:inactive
*/
 typedef NS_OPTIONS(NSInteger, CSRRestCreateSiteRequestStateEnum) {
  CSRRestCreateSiteRequestStateEnumactive,
  CSRRestCreateSiteRequestStateEnuminactive,

};



/*!
    Name of Site
*/
@property(nonatomic) NSString* name;
  
/*!
    State of site. This is either active or inactive. Transactions are not permitted for inactive sites. Default value:inactive
*/
@property(nonatomic) CSRRestCreateSiteRequestStateEnum state;

/*!
    Array of Mesh and respective Gateways associated with the site.
*/
@property(nonatomic) NSArray* meshes;
  
/*!
  Constructs instance of CSRRestCreateSiteRequest

  @param name - (NSString*) Name of Site
  @param state - (CSRRestCreateSiteRequestStateEnum) State of site. This is either active or inactive. Transactions are not permitted for inactive sites. Default value:inactive
  @param meshes - (NSArray*) Array of Mesh and respective Gateways associated with the site.
  
  @return instance of CSRRestCreateSiteRequest
*/
- (id) initWithname: (NSString*) name     
       state: (CSRRestCreateSiteRequestStateEnum) state     
       meshes: (NSArray*) meshes;
       

@end
