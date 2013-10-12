//
//  YGlobalCore.h
//  yushiyi
//
//  Created by yu shiyi on 12-7-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


/**
 * Creates a mutable array which does not retain references to the objects it contains.
 *
 * Typically used with arrays of delegates.
 */
NSMutableArray* YCreateNonRetainingArray();

/**
 * Creates a mutable dictionary which does not retain references to the values it contains.
 *
 * Typically used with dictionaries of delegates.
 */
NSMutableDictionary* YCreateNonRetainingDictionary();

/**
 * Tests if an object is an array which is not empty.
 */
BOOL YIsArrayWithItems(id object);

/**
 * Tests if an object is a set which is not empty.
 */
BOOL YIsSetWithItems(id object);

/**
 * Tests if an object is a string which is not empty.
 */
BOOL YIsStringWithAnyText(id object);

/**
 * Swap the two method implementations on the given class.
 * Uses method_exchangeImplementations to accomplish this.
 */
void YSwapMethods(Class cls, SEL originalSel, SEL newSel);
