/*
 * Copyright (c) 2011 Easy Calendar
 */


#import "NSMutableArray+Move.h"

@implementation NSMutableArray(Move)

- (id) moveFirstObjectToEnd {
	id firstObject = [self objectAtIndex:0];
	[self removeObjectAtIndex:0];
	[self addObject:firstObject];
	return firstObject;
}

- (id) moveLastObjectToBegin {
	id lastObject = [self lastObject];
	[self removeObjectAtIndex:[self count] - 1];
	[self insertObject:lastObject atIndex:0];
	return lastObject;
}

@end
