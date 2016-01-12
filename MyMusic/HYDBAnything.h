//
//  HYDBAnything.h
//  HYDBAnythingDemo
//
//  Created by DeveloperHY on 15/10/24.
//  Copyright © 2015年 DeveloperHY. All rights reserved.
//

#ifndef HYDBAnything_h
#define HYDBAnything_h

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#pragma mark ------------------------------- interface -------------------------------

#if TARGET_OS_IPHONE

    #define HYEdgeInsets    UIEdgeInsets
    #define HYOffset        UIOffset
    #define valueWithHYOffset   valueWithUIOffset
    #define valueWithHYEdgeInsets   valueWithUIEdgeInsets

#elif TARGET_OS_MAC

    #define HYEdgeInsets    NSEdgeInsets
    #define HYOffset        NSOffset
    #define valueWithHYOffset   valueWithNSOffset
    #define valueWithHYEdgeInsets   valueWithNSEdgeInsets

#endif

#define stringify               __STRING
#define HYType(var)             __typeof__((var))
#define HYBox(var)              __HY_box(@encode(HYType(var)), (var))
#define HYBoxToString(var)      [HYBox(var) description]
#define HYTypeStringOfVar(var)  __HY_type_string_for_var(@encode(HYType(var)), (var))

static NSDictionary * HYDictionaryFromObject(NSObject * object);
static NSString * HYJsonFromObject(NSObject * object);
static NSString * HYXmlFromObject(NSObject * object);
static NSString * HYViewHierarchyDescription(UIView * view);

#ifdef DEBUG
    #define HYPrintf(fmt, ...)  printf("📍%s + %d🎈 %s\n", __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__]UTF8String])
    #define HYDBAnyVar(var)     HYPrintf(@"%s = %@", #var, HYBox(var))
    #define HYPrintAnything(x)  printf("📍%s + %d🎈 %s\n", __PRETTY_FUNCTION__, __LINE__, #x)
    #define HYDBObjectAsJson(obj)   printf("📍%s + %d🎈 %s\n", __PRETTY_FUNCTION__, __LINE__, __HY_json_db_object_string(obj).UTF8String)
    #define HYDBObjectAsXml(obj)    printf("📍%s + %d🎈 %s\n", __PRETTY_FUNCTION__, __LINE__, __HY_xml_db_object_string(obj).UTF8String)
    #define HYDBViewHierarchy(view) printf("📍%s + %d🎈%s =\n%s\n", __PRETTY_FUNCTION__, __LINE__, #view, HYViewHierarchyDescription(view).UTF8String)
#else
    #define HYPrintf(fmt, ...)
    #define HYDBAnyVar(any)
    #define HYPrintAnything(x)
    #define HYDBObjectAsJson(obj)
    #define HYDBObjectAsXml(obj)
    #define HYDBViewHierarchy(view)
#endif

#pragma mark ------------------------------- implementation -------------------------------

static inline id __HY_box(const char * type, ...)
{
    va_list variable_param_list;
    va_start(variable_param_list, type);
    
    id object = nil;
    
    if (strcmp(type, @encode(id)) == 0) {
        id param = va_arg(variable_param_list, id);
        object = param;
    }
    else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint param = (CGPoint)va_arg(variable_param_list, CGPoint);
        object = [NSValue valueWithCGPoint:param];
    }
    else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize param = (CGSize)va_arg(variable_param_list, CGSize);
        object = [NSValue valueWithCGSize:param];
    }
    else if (strcmp(type, @encode(CGVector)) == 0) {
        CGVector param = (CGVector)va_arg(variable_param_list, CGVector);
        object = [NSValue valueWithCGVector:param];
    }
    else if (strcmp(type, @encode(CGRect)) == 0) {
        CGRect param = (CGRect)va_arg(variable_param_list, CGRect);
        object = [NSValue valueWithCGRect:param];
    }
    else if (strcmp(type, @encode(NSRange)) == 0) {
        NSRange param = (NSRange)va_arg(variable_param_list, NSRange);
        object = [NSValue valueWithRange:param];
    }
    else if (strcmp(type, @encode(CFRange)) == 0) {
        CFRange param = (CFRange)va_arg(variable_param_list, CFRange);
        object = [NSValue value:&param withObjCType:type];
    }
    else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
        CGAffineTransform param = (CGAffineTransform)va_arg(variable_param_list, CGAffineTransform);
        object = [NSValue valueWithCGAffineTransform:param];
    }
    else if (strcmp(type, @encode(CATransform3D)) == 0) {
        CATransform3D param = (CATransform3D)va_arg(variable_param_list, CATransform3D);
        object = [NSValue valueWithCATransform3D:param];
    }
    else if (strcmp(type, @encode(SEL)) == 0) {
        SEL param = (SEL)va_arg(variable_param_list, SEL);
        object = NSStringFromSelector(param);
    }
    else if (strcmp(type, @encode(Class)) == 0) {
        Class param = (Class)va_arg(variable_param_list, Class);
        object = NSStringFromClass(param);
    }
    else if (strcmp(type, @encode(HYOffset)) == 0) {
        HYOffset param = (HYOffset)va_arg(variable_param_list, HYOffset);
        object = [NSValue valueWithHYOffset:param];
    }
    else if (strcmp(type, @encode(HYEdgeInsets)) == 0) {
        HYEdgeInsets param = (HYEdgeInsets)va_arg(variable_param_list, HYEdgeInsets);
        object = [NSValue valueWithHYEdgeInsets:param];
    }
    else if (strcmp(type, @encode(short)) == 0) {
        short param = (short)va_arg(variable_param_list, int);
        object = @(param);
    }
    else if (strcmp(type, @encode(int)) == 0) {
        int param = (int)va_arg(variable_param_list, int);
        object = @(param);
    }
    else if (strcmp(type, @encode(long)) == 0) {
        long param = (long)va_arg(variable_param_list, long);
        object = @(param);
    }
    else if (strcmp(type, @encode(long long)) == 0) {
        long long param = (long long)va_arg(variable_param_list, long long);
        object = @(param);
    }
    else if (strcmp(type, @encode(float)) == 0) {
        float param = (float)va_arg(variable_param_list, double);
        object = @(param);
    }
    else if (strcmp(type, @encode(double)) == 0) {
        double param = (double)va_arg(variable_param_list, double);
        object = @(param);
    }
    else if (strcmp(type, @encode(BOOL)) == 0) {
        BOOL param = (BOOL)va_arg(variable_param_list, int);
        object = param ? @"YES" : @"NO";
    }
    else if (strcmp(type, @encode(bool)) == 0) {
        bool param = (bool)va_arg(variable_param_list, int);
        object = param ? @"true" : @"false";
    }
    else if (strcmp(type, @encode(char)) == 0) {
        char param = (char)va_arg(variable_param_list, int);
        object = [NSString stringWithFormat:@"%c", param];
    }
    else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short param = (unsigned short)va_arg(variable_param_list, unsigned int);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int param = (unsigned int)va_arg(variable_param_list, unsigned int);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long param = (unsigned long)va_arg(variable_param_list, unsigned long);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long param = (unsigned long long)va_arg(variable_param_list, unsigned long long);
        object = @(param);
    }
    else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char param = (unsigned char)va_arg(variable_param_list, unsigned int);
        object = [NSString stringWithFormat:@"%c", param];
    }
    else {
        void * param = (void *)va_arg(variable_param_list, void *);
        object = [NSString stringWithFormat:@"%p", param];
    }
    
    va_end(variable_param_list);
    
    return object;
}

static inline char __HY_first_char_for_string(const char * string)
{
    if (strlen(string) > 0) {
        return string[0];
    }
    else {
        return '\0';
    }
}

static inline char __HY_last_char_for_string(const char * string)
{
    if (strlen(string) > 0) {
        return string[strlen(string) - 1];
    }
    else {
        return '\0';
    }
}

static inline NSString * __HY_type_string_for_var(const char * type, ...)
{
    va_list variable_param_list;
    va_start(variable_param_list, type);
    
    NSString * typeString = nil;
    
    if (strcmp(type, @encode(id)) == 0) {
        
        id param = va_arg(variable_param_list, id);
        typeString = NSStringFromClass([param class]);
    }
    else if (strcmp(type, @encode(CGPoint)) == 0) {
        
        typeString = @stringify(CGPoint);
    }
    else if (strcmp(type, @encode(CGSize)) == 0) {
        
        typeString = @stringify(CGSize);
    }
    else if (strcmp(type, @encode(CGVector)) == 0) {

        typeString = @stringify(CGVector);
    }
    else if (strcmp(type, @encode(CGRect)) == 0) {

        typeString = @stringify(CGRect);
    }
    else if (strcmp(type, @encode(NSRange)) == 0) {

        typeString = @stringify(NSRange);
    }
    else if (strcmp(type, @encode(CFRange)) == 0) {

        typeString = @stringify(CFRange);
    }
    else if (strcmp(type, @encode(CGAffineTransform)) == 0) {

        typeString = @stringify(CGAffineTransform);
    }
    else if (strcmp(type, @encode(CATransform3D)) == 0) {

        typeString = @stringify(CATransform3D);
    }
    else if (strcmp(type, @encode(SEL)) == 0) {

        typeString = @stringify(SEL);
    }
    else if (strcmp(type, @encode(Class)) == 0) {

        typeString = @stringify(Class);
    }
    else if (strcmp(type, @encode(HYOffset)) == 0) {

        typeString = @stringify(HYOffset);
    }
    else if (strcmp(type, @encode(HYEdgeInsets)) == 0) {

        typeString = @stringify(HYEdgeInsets);
    }
    else if (strcmp(type, @encode(short)) == 0) {
       
        typeString = @stringify(short);
    }
    else if (strcmp(type, @encode(int)) == 0) {
     
        typeString = @stringify(int);
    }
    else if (strcmp(type, @encode(long)) == 0) {
      
        typeString = @stringify(long);
    }
    else if (strcmp(type, @encode(long long)) == 0) {
     
        typeString = @stringify(long long);
    }
    else if (strcmp(type, @encode(float)) == 0) {
 
        typeString = @stringify(float);
    }
    else if (strcmp(type, @encode(double)) == 0) {
     
        typeString = @stringify(double);
    }
    else if (strcmp(type, @encode(long double)) == 0) {
        
        typeString = @stringify(long double);
    }
    else if (strcmp(type, @encode(BOOL)) == 0) {

        typeString = @stringify(BOOL);
    }
    else if (strcmp(type, @encode(bool)) == 0) {

        typeString = @stringify(bool);
    }
    else if (strcmp(type, @encode(char)) == 0) {

        typeString = @stringify(char);
    }
    else if (strcmp(type, @encode(unsigned short)) == 0) {

        typeString = @stringify(unsigned short);
    }
    else if (strcmp(type, @encode(unsigned int)) == 0) {

        typeString = @stringify(unsigned int);
    }
    else if (strcmp(type, @encode(unsigned long)) == 0) {
 
        typeString = @stringify(unsigned long);
    }
    else if (strcmp(type, @encode(unsigned long long)) == 0) {

        typeString = @stringify(unsigned long long);
    }
    else if (strcmp(type, @encode(unsigned char)) == 0) {

        typeString = @stringify(unsigned char);
    }
    else if (strcmp(type, @encode(char *)) == 0) {
        
        typeString = @stringify(char *);
    }
    else if (strcmp(type, @encode(void)) == 0) {
        
        typeString = @stringify(void);
    }
    else if (strcmp(type, @encode(void *)) == 0) {
        
        typeString = @stringify(void *);
    }
    else if (__HY_first_char_for_string(type) == '[' && __HY_last_char_for_string(type) == ']') {
    
        typeString = @stringify(array);
    }
    else if (__HY_first_char_for_string(type) == '{' && __HY_last_char_for_string(type) == '}') {
        
        typeString = @stringify(struct);
    }
    else if (__HY_first_char_for_string(type) == '(' && __HY_last_char_for_string(type) == ')') {
        
        typeString = @stringify(union);
    }
    else if (__HY_first_char_for_string(type) == '^') {
        
        typeString = @stringify(pointer);
    }
    else if (__HY_first_char_for_string(type) == 'b') {
        
        typeString = @stringify(bit_field);
    }
    else if (strcmp(type, "?") == 0) {
        
        typeString = @stringify(unknown_type);
    }
    else {
        typeString = @"HYDBAnything：Can not distinguish temporarily!😂";
    }
    
    va_end(variable_param_list);
    
    return typeString;
}

static NSObject * __HY_stringify_object_value(NSObject * object)
{
    if ([object isKindOfClass:[NSArray class]]) {
        
        NSMutableArray * arrayObject = [NSMutableArray array];
        
        for (id obj in (NSArray *)object) {
            [arrayObject addObject:__HY_stringify_object_value(obj)];
        }
        
        return [NSArray arrayWithArray:arrayObject];
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        
        NSMutableDictionary * dictionaryObject = [NSMutableDictionary dictionary];
        
        [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            [dictionaryObject setValue:__HY_stringify_object_value(obj) forKey:HYBoxToString(key)];
        }];
        
        return [NSDictionary dictionaryWithDictionary:dictionaryObject];
    }
    else if ([object isKindOfClass:[NSSet class]]) {
        
        NSMutableArray * arrayObject = [NSMutableArray array];
        
        for (id obj in (NSSet *)object) {
            [arrayObject addObject:__HY_stringify_object_value(obj)];
        }
        
        return [NSArray arrayWithArray:arrayObject];
    }
    else if ([object isKindOfClass:[NSOrderedSet class]]) {
        
        NSMutableArray * arrayObject = [NSMutableArray array];
        
        for (id obj in (NSOrderedSet *)object) {
            
            [arrayObject addObject:__HY_stringify_object_value(obj)];
        }
        
        return [NSArray arrayWithArray:arrayObject];
    }
    else {
        
        return HYBoxToString(object);
    }
}

static NSDictionary * HYDictionaryFromObject(NSObject * object)
{
    NSCAssert([object isKindOfClass:[NSObject class]], ([NSString stringWithFormat:@"HYDBAnything：%@ type error!", object]));
    
    NSMutableDictionary * objectDictionary = [NSMutableDictionary dictionary];
    
    unsigned int outCount = 0;
    
    objc_property_t * propertyList = class_copyPropertyList([object class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = propertyList[i];
        
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        
        if ([object respondsToSelector:NSSelectorFromString(propertyName)]) {
            
            @try {
                NSObject * propertyValue = [object valueForKey:propertyName];
                [objectDictionary setValue:__HY_stringify_object_value(propertyValue) forKey:propertyName];
            }
            @catch (NSException *exception) {
                HYDBAnyVar(exception);  //
                [objectDictionary setValue:nil forKey:propertyName];
            }
        }
    }
    free(propertyList);
    
    return [NSDictionary dictionaryWithDictionary:objectDictionary];
}

static NSString * __HY_json_db_object_string(NSObject * object)
{
    return [NSString stringWithFormat:@"%@ = %@", object.description, HYJsonFromObject(object)];
}

static NSString * __HY_xml_db_object_string(NSObject * object)
{
    return [NSString stringWithFormat:@"%@ = %@", object.description, HYXmlFromObject(object)];
}

static NSString * HYJsonFromObject(NSObject * object)
{
    NSError * error = nil;
    
    NSDictionary * objectDictionary = HYDictionaryFromObject(object);
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:objectDictionary options:NSJSONWritingPrettyPrinted error:&error];
    NSString * jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

static NSString * HYXmlFromObject(NSObject * object)
{
    NSError * error = nil;
    
    NSDictionary * objectDictionary = HYDictionaryFromObject(object);
    NSData * xmlData = [NSPropertyListSerialization dataWithPropertyList:objectDictionary format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
    NSString * xmlString = [[NSString alloc]initWithData:xmlData encoding:NSUTF8StringEncoding];
    return xmlString;
}

static NSString * __HY_view_hierarchy_description(UIView * view, NSInteger depth)
{
    static NSString * unitIndentSpaceString = @"    ";
    
    NSString * indentSpaceString = @" ";
    for (int i = 0; i < depth; i++) {
        indentSpaceString = [indentSpaceString stringByAppendingString:unitIndentSpaceString];
    }
    
    NSString * viewHierarchyDescription = [NSString stringWithFormat:@"%zi＃%@%@\n", depth, indentSpaceString, view];
    
    depth++;
    
    for (UIView * subview in view.subviews) {
        
        viewHierarchyDescription = [viewHierarchyDescription stringByAppendingString:__HY_view_hierarchy_description(subview, depth)];
    }
    
    return viewHierarchyDescription;
}

static NSString * HYViewHierarchyDescription(UIView * view)
{
    NSCAssert([view isKindOfClass:[UIView class]], @"");
    
    NSString * viewHierarchyDescription = @"";
    NSInteger depth = 0;
    viewHierarchyDescription = [viewHierarchyDescription stringByAppendingString:__HY_view_hierarchy_description(view, depth)];
    return viewHierarchyDescription;
}

#endif /* HYDBAnything_h */
