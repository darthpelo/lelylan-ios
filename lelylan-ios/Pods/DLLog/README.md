# DLLog

Unlike most other major programming languages Objective-C (or rather the Foundation framework) does not provide a way to filter (usually via level) which messages are passed to the log (through NSLog for example). **DLLog** aims to fill that gap.

## Usage

### Logging

With the functions provided by **DLLog** you can log messages at different levels:

```objc
void DLLogEmergency(NSString *format, ...);
void DLLogAlert(NSString *format, ...);
void DLLogCritical(NSString *format, ...);
void DLLogError(NSString *format, ...);
void DLLogWarning(NSString *format, ...);
void DLLogNotice(NSString *format, ...);
void DLLogInfo(NSString *format, ...);
void DLLogDebug(NSString *format, ...);
```

which then get filtered depending on the current log filter level.

### Filtering

By default the log priority filter level is set to:

- `Notice` for **release** builds, and
- `Debug` for **debug** builds.

Log messages can be **filtered** by defining a level filter either at **compile-time** or at **run-time**.

Statically defined **compile-time level filters overrule dynamic run-time filters**, as they cause all log calls of unwanted levels to simply get **stripped away during compilation**.

The use of **run-time filters** is **optional**.

See README section **"Static Level Filters"** and **"Dynamic Level Filters"** for more info.

### Contexts

For every of the functions listed above there exists a variant with an additional `context` parameter:

```objc
void DLLog...InContext(id context, NSString *format, ...);
```

See README section **"Context Filters"** for more info on those variants.

## Static Level Filters

To set a compile-time by add a `#define DL_LOG_STATIC_OVERRULE_LEVEL ASL_LEVEL_ERR` above your first use of `DLLog...`. Alternatively any of the [**"Log Message Priority Levels"**](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/LoggingErrorsAndWarnings.html#//apple_ref/doc/uid/10000172i-SW8-SW1) (or their numeric values) defined in the `<asl.h>` (`/usr/include/asl.h`) system header can be used:

- `ASL_LEVEL_EMERG`
- `ASL_LEVEL_ALERT`
- `ASL_LEVEL_CRIT`
- `ASL_LEVEL_ERR`
- `ASL_LEVEL_WARNING`
- `ASL_LEVEL_NOTICE`
- `ASL_LEVEL_INFO`
- `ASL_LEVEL_DEBUG`

To omit all logs with a priority lower than `Error` one would define it like this:

```objc
#define DL_LOG_STATIC_OVERRULE_LEVEL ASL_LEVEL_ERR
```

or go to the target's **"Build Settings"** and under **"Preprocessor Macros"** add `DL_LOG_STATIC_OVERRULE_LEVEL=3` (`3` here being the numeric value of `ASL_LEVEL_ERR`, as defined in `<asl.h>`).

## Dynamic Level Filters

**DLLog** utilizes an internal stack to handle the pushing and popping of level filters at run-time.

**Level filtering** is implemented as **opt-out**!
You need to specifically filter-out unwanted logs using level filters.

To **adjust level filters at run-time** use these functions:

```objc
void DLLogPushLevelFilter(DLLogLevel level);
void DLLogPopLevelFilter();
```

To reduce the burden of remembering to keep any calls to `DLLogPushLevelFilter(...)` in sync with an eveny number of calls to `DLLogPopLevelFilter()` one can use a block-based (exception safe) convenience wrapper:

```objc
void DLLogPerformWithLevelFilter(DLLogLevel level, void(^block)(void));
```

See the project's `main.m` file for a more thorough overview of how to use **DLLog**'s run-time filtering with levels.

Note: **Pushing** or **popping** run-time level filters **from multiple threads** is **discouraged**, as this can **lead to race-conditions** (same applies to the block-based wrapper).

## Context Filters

**DLLog** utilizes an internal counted set to handle the beginning and ending of context observations at run-time.

**Context observation** is implemented as **opt-in**!  
You need to specifically subscribe to wanted logs using context observations.

To adjust context observations at run-time use these functions:

```objc
void DLLogBeginContextObservation(NSArray *contexts);
void DLLogEndContextObservation(NSArray *contexts);
```

To observe any available context there is a specific wildcard-context to observe:

```objc
id DLLogAnyContext();
```

Just like with the levels-bases API there is a block-based (exception safe) convenience wrapper for context-based observing:

```objc
void DLLogPerformWithContextObservation(NSArray *contexts, void(^block)(void));
```

**Multiple contexts** can be subscribed to or unsubscribed from **at the same time**.

See the project's `main.m` file for a more thorough overview of how to use **DLLog**'s run-time filtering with contexts.

Note: **Beginning** or **ending** run-time context filters **from multiple threads** is **discouraged**, as this can **lead to race-conditions** (same applies to the block-based wrapper).


## Installation

Just copy the files in `"DLLog/Classes/..."` into your project.

Alternatively you can install DLLog into your project with [CocoaPods](http://cocoapods.org/).  
Just add it to your Podfile: `pod 'DLLog'`

## ARC

**DLLog** uses **automatic reference counting (ARC)**.

## Dependencies

None.

## Creator

Vincent Esche ([@regexident](http://twitter.com/regexident))

## License

**DLLog** is available under a **modified BSD-3 clause license** with the **additional requirement of attribution**. See the `LICENSE` file for more info.