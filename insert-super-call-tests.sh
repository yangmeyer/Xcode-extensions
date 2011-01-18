#!/bin/sh

source 'insert-super-call-v2.sh'

# pretty
super_call_from_definition "- (id) helloWorld:(NSString*)greeting {" | sed s/*/

# tight
super_call_from_definition "-(id)helloWorld:(NSString*)greeting{"

# loose
super_call_from_definition "  -  (id)   helloWorld:  (NSString *) greeting  {"

# no return type
super_call_from_definition "- helloWorld:(NSString*)greeting"

# no return type tight
super_call_from_definition "-helloWorld:(NSString*)greeting"

# categories
super_call_from_definition "- (id <Category>) helloWorld:(NSString <Special> *) greeting"

# multiple parameters
super_call_from_definition "- (id) helloWorld:(NSString*)greeting andBye:(BOOL)bye {" 

# line break
super_call_from_definition "- (id) helloWorld:(NSString*)greeting\n andBye:(BOOL)bye {"

# class method
super_call_from_definition "+ (NSString*) stringFromString:(NSString*)str \n{"
