//
//  DLLog.h
//  DLLog
//
//  Created by Vincent Esche on 7/28/14.
//  Copyright (c) 2014 Vincent Esche. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <asl.h>

#ifdef __cplusplus
extern "C" {
#endif
	
	// See documentation for further info on log level usage:
	// http://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/LoggingErrorsAndWarnings.html#//apple_ref/doc/uid/10000172i-SW8-SW1
	
	typedef NS_ENUM(NSUInteger, DLLogLevel) {
		DLLogLevelEmergency = ASL_LEVEL_EMERG,
		DLLogLevelAlert = ASL_LEVEL_ALERT,
		DLLogLevelCritical = ASL_LEVEL_CRIT,
		DLLogLevelError = ASL_LEVEL_ERR,
		DLLogLevelWarning = ASL_LEVEL_WARNING,
		DLLogLevelNotice = ASL_LEVEL_NOTICE,
		DLLogLevelInfo = ASL_LEVEL_INFO,
		DLLogLevelDebug = ASL_LEVEL_DEBUG
	};
	
	void DLLogPushLevelFilter(DLLogLevel level);
	void DLLogPopLevelFilter();
	void DLLogPerformWithLevelFilter(DLLogLevel level, void(^block)(void));
	
	id DLLogAnyContext();
	void DLLogBeginContextObservation(NSArray *contexts);
	void DLLogEndContextObservation(NSArray *contexts);
	void DLLogPerformWithContextObservation(NSArray *contexts, void(^block)(void));
	
#ifndef DL_LOG_STATIC_OVERRULE_LEVEL
#ifndef NDEBUG
#define DL_LOG_STATIC_OVERRULE_LEVEL ASL_LEVEL_DEBUG
#else
#define DL_LOG_STATIC_OVERRULE_LEVEL ASL_LEVEL_NOTICE
#endif
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_EMERG
	void DLLogEmergency(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogEmergencyInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogEmergency(...)
#define DLLogEmergencyInContext(...)
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_ALERT
	void DLLogAlert(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogAlertInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogAlert(...)
#define DLLogAlertInContext(...)
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_CRIT
	void DLLogCritical(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogCriticalInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogCritical(...)
#define DLLogCriticalInContext(...)
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_ERR
	void DLLogError(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogErrorInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogError(...)
#define DLLogErrorInContext(...)
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_WARNING
	void DLLogWarning(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogWarningInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogWarning(...)
#define DLLogWarningInContext(...)
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_NOTICE
	void DLLogNotice(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogNoticeInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogNotice(...)
#define DLLogNoticeInContext(...)
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_INFO
	void DLLogInfo(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogInfoInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogInfo(...)
#define DLLogInfoInContext(...)
#endif
	
#if DL_LOG_STATIC_OVERRULE_LEVEL >= ASL_LEVEL_DEBUG
	void DLLogDebug(NSString *format, ...) NS_FORMAT_FUNCTION(1,2);
	void DLLogDebugInContext(id context, NSString *format, ...) NS_FORMAT_FUNCTION(2,3);
#else
#define DLLogDebug(...)
#define DLLogDebugInContext(...)
#endif
	
#ifdef __cplusplus
}
#endif