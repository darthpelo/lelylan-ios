//
//  DLLog.m
//  DLLog
//
//  Created by Vincent Esche on 7/28/14.
//  Copyright (c) 2014 Vincent Esche. All rights reserved.
//

#import "DLLog.h"

static aslmsg dl_aslMsg;
static NSLock *dl_logLock;
static NSMutableArray *dl_logLevelStack;
static NSCountedSet *dl_logContextSet;

static void DLLogSetup() {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dl_logLock = [[NSLock alloc] init];
		dl_logLevelStack = [NSMutableArray array];
		dl_logContextSet = [NSCountedSet set];
		dl_aslMsg = asl_new(ASL_TYPE_MSG);
		asl_set(dl_aslMsg, ASL_KEY_FACILITY, "com.apple.console");
//		asl_set(dl_aslMsg, ASL_KEY_LEVEL, ASL_STRING_NOTICE);
		asl_set(dl_aslMsg, ASL_KEY_READ_UID, "-1");
		asl_add_log_file(NULL, STDERR_FILENO);
	});
}

DLLogLevel DLLogGetLevelFilter() {
	DLLogSetup();
	NSNumber *levelNumber = [dl_logLevelStack lastObject];
	DLLogLevel level = (levelNumber) ? levelNumber.unsignedIntegerValue : DLLogLevelDebug;
	return level;
}

const char *DLLogGetLevelName(DLLogLevel level) {
	static const char *levels[] = {"ASL_STRING_EMERG", "ASL_STRING_ALERT", "ASL_STRING_CRIT", "ASL_STRING_ERR", "ASL_STRING_WARNING", "ASL_STRING_NOTICE", "ASL_STRING_INFO", "ASL_STRING_DEBUG"};
	return levels[level];
}

void DLLogPushLevelFilter(DLLogLevel level) {
	DLLogSetup();
	[dl_logLock lock];
	[dl_logLevelStack addObject:@(level)];
	asl_set(dl_aslMsg, ASL_KEY_LEVEL, DLLogGetLevelName(level));
	[dl_logLock unlock];
}

void DLLogPopLevelFilter() {
	DLLogSetup();
	[dl_logLock lock];
	[dl_logLevelStack removeLastObject];
	DLLogLevel level = DLLogGetLevelFilter();
	asl_set(dl_aslMsg, ASL_KEY_LEVEL, DLLogGetLevelName(level));
	[dl_logLock unlock];
}

void DLLogInLevel(DLLogLevel level, NSString *format, va_list arguments) {
	NSCParameterAssert(format != nil);
	NSString *message = [[NSString alloc] initWithFormat:format arguments:arguments];
	asl_log(NULL, NULL, (level), "%s", [message UTF8String]);
}

void DLLogPerformWithLevelFilter(DLLogLevel level, void(^block)(void)) {
	NSCParameterAssert(block != nil);
	@try {
		DLLogPushLevelFilter(level);
		block();
		DLLogPopLevelFilter();
	}
	@catch (NSException *exception) {
		DLLogPopLevelFilter();
		[exception raise];
	}
}

id DLLogAnyContext() {
	return [NSNull null];
}

void DLLogBeginContextObservation(NSArray *contexts) {
	NSCParameterAssert(contexts != nil);
	DLLogSetup();
	[dl_logLock lock];
	for (id context in contexts) {
		[dl_logContextSet addObject:context];
	}
	[dl_logLock unlock];
}

void DLLogEndContextObservation(NSArray *contexts) {
	NSCParameterAssert(contexts != nil);
	DLLogSetup();
	[dl_logLock lock];
	for (id context in contexts) {
		[dl_logContextSet removeObject:context];
	}
	[dl_logLock unlock];
}

void DLLogPerformWithContextObservation(NSArray *contexts, void(^block)(void)) {
	NSCParameterAssert(block != nil);
	@try {
		DLLogBeginContextObservation(contexts);
		block();
	}
	@catch (NSException *exception) {
		[exception raise];
	}
	@finally {
		DLLogEndContextObservation(contexts);
	}
}

#define DL_LOG_FUNCTION_FOR_LEVEL(level) \
void DLLog##level(NSString *format, ...) { \
	NSCParameterAssert(format != nil); \
	DLLogLevel currentLevelFilter = DLLogGetLevelFilter(); \
	if (DLLogLevel##level <= currentLevelFilter) { \
		va_list arguments; \
		va_start(arguments, format); \
		asl_log(NULL, NULL, (DLLogLevel##level), "%s", [[[NSString alloc] initWithFormat:format arguments:arguments] UTF8String]); \
		va_end(arguments); \
	} \
}

#define DL_LOG_FUNCTION_FOR_CONTEXT(level) \
void DLLog##level##InContext(id context, NSString *format, ...) { \
	NSCParameterAssert(context != nil); \
	NSCParameterAssert(format != nil); \
	if ([dl_logContextSet containsObject:DLLogAnyContext()] || [dl_logContextSet containsObject:context]) { \
		va_list arguments; \
		va_start(arguments, format); \
		NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments]; \
		asl_log(NULL, NULL, (DLLogLevel##level), "(%s): %s", [[context description] UTF8String], [string UTF8String]); \
		va_end(arguments); \
	} \
}

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_EMERG
DL_LOG_FUNCTION_FOR_LEVEL(Emergency)
DL_LOG_FUNCTION_FOR_CONTEXT(Emergency)
#endif

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_ALERT
DL_LOG_FUNCTION_FOR_LEVEL(Alert)
DL_LOG_FUNCTION_FOR_CONTEXT(Alert)
#endif

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_CRIT
DL_LOG_FUNCTION_FOR_LEVEL(Critical)
DL_LOG_FUNCTION_FOR_CONTEXT(Critical)
#endif

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_ERR
DL_LOG_FUNCTION_FOR_LEVEL(Error)
DL_LOG_FUNCTION_FOR_CONTEXT(Error)
#endif

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_WARNING
DL_LOG_FUNCTION_FOR_LEVEL(Warning)
DL_LOG_FUNCTION_FOR_CONTEXT(Warning)
#endif

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_NOTICE
DL_LOG_FUNCTION_FOR_LEVEL(Notice)
DL_LOG_FUNCTION_FOR_CONTEXT(Notice)
#endif

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_INFO
DL_LOG_FUNCTION_FOR_LEVEL(Info)
DL_LOG_FUNCTION_FOR_CONTEXT(Info)
#endif

#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_DEBUG
DL_LOG_FUNCTION_FOR_LEVEL(Debug)
DL_LOG_FUNCTION_FOR_CONTEXT(Debug)
#endif

#undef DL_LOG_FUNCTION
