//
//  LYSingleton.h
//  Leyingke
//
//  Created by yu on 12-11-28.
//  Copyright (c) 2012年 leyingke.com. All rights reserved.
//

#define LY_DECLARE_SINGLETON(_object_name_) \
@interface _object_name_(Singleton_PrivateMethod) \
+(id)allocWithZone:(NSZone*)zone NS_RETURNS_NOT_RETAINED;\
-(id)copyWithZone:(NSZone*)zone;\
-(oneway void)release;\
-(id)autorelease;\
-(id)retain;\
-(unsigned)retainCount;\
@end \
static _object_name_* _singleton_##_object_name_ = nil ;

#define LY_IMPLETEMENT_SINGLETON(_object_name_,_shared_obj_name_) \
+(_object_name_*)_shared_obj_name_ { \
@synchronized(self) { \
if (_singleton_##_object_name_ != nil) { \
return _singleton_##_object_name_;\
}\
_singleton_##_object_name_ = (_object_name_*)[[_object_name_ alloc] init];\
return _singleton_##_object_name_ ;\
}\
}\
\
+(id)allocWithZone:(NSZone*)zone { \
@synchronized(self) { \
if (_singleton_##_object_name_ != nil) { \
return _singleton_##_object_name_;\
}\
_singleton_##_object_name_ = [super allocWithZone:zone];\
return _singleton_##_object_name_ ;\
}\
}\
\
-(id)copyWithZone:(NSZone*)zone {\
return self;\
}\
\
-(oneway void)release {\
return ;\
}\
\
-(id)autorelease {\
return self;\
}\
\
-(id)retain {\
return self;\
}\
\
-(unsigned)retainCount {\
return 1;\
}\
