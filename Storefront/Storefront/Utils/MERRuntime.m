//
//  MERRuntime.m
//  Storefront
//
//  Created by Joshua Tessier on 2014-09-21.
//  Copyright (c) 2014 Shopify Inc. All rights reserved.
//

#import "MERRuntime.h"

#import "MERObject.h"
#import <objc/runtime.h>

NSSet* __attribute__((overloadable)) class_getMERProperties(Class clazz, BOOL includeSuper)
{
	if (clazz == [NSObject class]) {
		return [[NSSet alloc] init];
	}
	else {
		NSMutableSet *propertyNames = [[NSMutableSet alloc] init];
		unsigned int outCount = 0;
		objc_property_t *properties = class_copyPropertyList(clazz, &outCount);
		
		for (unsigned int i = 0; i < outCount; ++i) {
			objc_property_t property = properties[i];
			const char *propertyName = property_getName(property);
			if (propertyName != NULL) {
				[propertyNames addObject:@(propertyName)];
			}
		}
		
		free(properties);
		
		if (includeSuper) {
			Class superClass = class_getSuperclass(clazz);
			if (superClass) {
				[propertyNames unionSet:class_getMERProperties(superClass)];
			}
		}
		return [propertyNames copy];
	}
}

NSSet* __attribute__((overloadable)) class_getMERProperties(Class clazz)
{
	return class_getMERProperties(clazz, YES);
}
