//
//  YURLResponse.h
//  yushiyi
//
//  Created by yu shiyi on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@class YURLRequest;

/**
 * A response protocol for TTURLRequest. This protocol is used upon the successful retrieval of
 * data from a TTURLRequest. The processResponse method is used to process the data, whether it
 * be an image or an XML string.
 *
 * @see TTURLDataResponse
 * @see TTURLImageResponse
 */
@protocol YURLResponse <NSObject>
@required

/**
 * Processes the data from a successful request and determines if it is valid.
 *
 * If the data is not valid, return an error. The data will not be cached if there is an error.
 *
 * @param  request    The request this response is bound to.
 * @param  response   The response object, useful for getting the status code.
 * @param  data       The data received from the TTURLRequest.
 * @return NSError if there was an error parsing the data. nil otherwise.
 *
 * @required
 */
- (NSError*)request:(YURLRequest*)request processResponse:(NSHTTPURLResponse*)response
               data:(id)data;

@optional
/**
 * Processes the data from a unsuccessful request to construct a custom NSError object.
 *
 * @param  request    The request this response is bound to.
 * @param  response   The response object, useful for getting the status code.
 * @param  data       The data received from the TTURLRequest.
 * @return NSError to construct for this response.
 *
 * @optional
 */
- (NSError*)request:(YURLRequest*)request processErrorResponse:(NSHTTPURLResponse*)response
               data:(id)data;
@end