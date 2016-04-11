/*!
    Copyright [2015] Qualcomm Technologies International, Ltd.
*/
/* Note: this is an auto-generated file. */


#import <Foundation/Foundation.h>
#import "CSRRestGetTenantsResponse.h"
#import "CSRRestCreateTenantRequest.h"
#import "CSRRestCreateTenantResponse.h"
#import "CSRRestTenantInfoResponse.h"
#import "CSRRestUpdateTenantInfoRequest.h"
#import "CSRRestGetSitesResponse.h"
#import "CSRRestCreateSiteRequest.h"
#import "CSRRestCreateSiteResponse.h"
#import "CSRRestSiteInfoResponse.h"
#import "CSRRestUpdateSiteInfoRequest.h"
#import "CSRRestBaseObject.h"
#import "CSRRestApiStatusCode.h"
#import "CSRRestErrorResponse.h"
#import "CSRRestBaseApi.h"


/*!
  CSRRestMeshConfigApi is a part of the CSR Mesh Api and provides a set of related methods.
*/
@interface CSRRestMeshConfigApi: CSRRestBaseApi


/*!
  Get Tenant List
 
  This API retrieves a list of tenants for a solution.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param queryType - (NSString*)  Type of Query.
  @param pattern - (NSString*) [optional] URL encoded regular expression for pattern matching, applicable only if query_type field value is query_by_name.
  @param state - (NSString*) [optional] State of Tenant.
  @param pageSize - (NSNumber*) [optional] Maximum number of results to be returned in a page.
  @param page - (NSNumber*) [optional] Page number (starting at 0) to return.
  @param maximum - (NSNumber*) [optional] Maximum number of results to return.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestGetTenantsResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestGetTenantsResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) getTenants : (NSString*) csrmeshApplicationCode 
     queryType : (NSString*) queryType 
     pattern : (NSString*) pattern 
     state : (NSString*) state 
     pageSize : (NSNumber*) pageSize 
     page : (NSNumber*) page 
     maximum : (NSNumber*) maximum 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestGetTenantsResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Create Tenant
 
  This API creates a tenant for a solution.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param createTenantRequest - (CSRRestCreateTenantRequest*)  Request Object for creating tenant.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestCreateTenantResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestCreateTenantResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) createTenant : (NSString*) csrmeshApplicationCode 
     createTenantRequest : (CSRRestCreateTenantRequest*) createTenantRequest 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestCreateTenantResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Get Tenant Information
 
  This API retrieves information for a tenant.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestTenantInfoResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestTenantInfoResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) getTenantInfo : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestTenantInfoResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Create Tenant
 
  This API creates a tenant with a predefined Tenant ID.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param createTenantRequest - (CSRRestCreateTenantRequest*)  Request Object for creating tenant.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestCreateTenantResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestCreateTenantResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) createTenant : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     createTenantRequest : (CSRRestCreateTenantRequest*) createTenantRequest 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestCreateTenantResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Delete Tenant
 
  This API deletes a tenant.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param responseBlock An optional block which receives the results of the resource load.
          If success, error object will be nil. If failure a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) deleteTenant : (NSString*) csrmeshApplicationCode
     tenantId : (NSString*) tenantId 
     responseHandler :(void (^)(NSNumber* meshRequestId,NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Update Tenant Information
 
  This API updates information for a tenant.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param updateTenantInfoRequest - (CSRRestUpdateTenantInfoRequest*)  Request Object for updating tenant information.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestTenantInfoResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestTenantInfoResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) updateTenant : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     updateTenantInfoRequest : (CSRRestUpdateTenantInfoRequest*) updateTenantInfoRequest 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestTenantInfoResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Get all Sites
 
  This API retrieves all sites for a tenant.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param queryType - (NSString*)  Type of Query.
  @param pattern - (NSString*) [optional] URL encoded regular expression for pattern matching. This parameter is only applicable if query_type field value is query_by_name.
  @param state - (NSString*) [optional] State of Site.
  @param pageSize - (NSNumber*) [optional] Maximum number of results to be returned in a page.
  @param page - (NSNumber*) [optional] Page number (starting at 0) to return.
  @param maximum - (NSNumber*) [optional] Maximum number of results to return.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestGetSitesResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestGetSitesResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) getSites : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     queryType : (NSString*) queryType 
     pattern : (NSString*) pattern 
     state : (NSString*) state 
     pageSize : (NSNumber*) pageSize 
     page : (NSNumber*) page 
     maximum : (NSNumber*) maximum 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestGetSitesResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Create Site
 
  This API creates a site for a tenant.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param createSiteRequest - (CSRRestCreateSiteRequest*)  Request Object for creating tenant.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestCreateSiteResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestCreateSiteResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) createSite : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     createSiteRequest : (CSRRestCreateSiteRequest*) createSiteRequest 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestCreateSiteResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Get Site Information
 
  This API retrieves information for a site.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param siteId - (NSString*)  Site ID.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestSiteInfoResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestSiteInfoResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) getSiteInfo : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     siteId : (NSString*) siteId 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestSiteInfoResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Create Site
 
  This API creates a site with a predefined Site ID.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param siteId - (NSString*)  Site ID.
  @param createSiteRequest - (CSRRestCreateSiteRequest*)  Request Object for creating tenant.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestCreateSiteResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestCreateSiteResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) createSite : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     siteId : (NSString*) siteId 
     createSiteRequest : (CSRRestCreateSiteRequest*) createSiteRequest 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestCreateSiteResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Delete Site
 
  This API deletes a site.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param siteId - (NSString*)  Site ID.
  @param responseBlock An optional block which receives the results of the resource load.
          If success, error object will be nil. If failure a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) deleteSite : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     siteId : (NSString*) siteId 
     responseHandler :(void (^)(NSNumber* meshRequestId,NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



/*!
  Update Site Information
 
  This API updates information for a site.
 
  @param csrmeshApplicationCode - (NSString*)  Application Code of calling application.
  @param tenantId - (NSString*)  Tenant ID.
  @param siteId - (NSString*)  Site ID.
  @param updateSiteInfoRequest - (CSRRestUpdateSiteInfoRequest*)  Request Object for Updating Application Information.
  @param responseBlock An optional block which receives the results of the resource load.
         If success, a valid object of CSRRestSiteInfoResponse is returned with nil object of NSError and CSRRestErrorResponse.
         If failure, an error object of NSError is returned with nil object of CSRRestSiteInfoResponse and also  a detailed error object of CSRRestErrorResponse for specific error codes and messages may available. See CSRRestApiStatusCode and NSError+StatusCode for more information's on error code details.

  @return meshRequestId - (NSNumber*) The id of the request. Pair up with the id returned in callback handlers.
 */
- (NSNumber*) updateSite : (NSString*) csrmeshApplicationCode 
     tenantId : (NSString*) tenantId 
     siteId : (NSString*) siteId 
     updateSiteInfoRequest : (CSRRestUpdateSiteInfoRequest*) updateSiteInfoRequest 
     responseHandler :(void (^)(NSNumber* meshRequestId, CSRRestSiteInfoResponse* output, NSError* error, CSRRestErrorResponse* errorResponse))responseBlock;



@end
