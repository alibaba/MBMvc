# OMPromises [![Supported Platforms](https://cocoapod-badges.herokuapp.com/p/OMPromises/badge.svg)](http://cocoadocs.org/docsets/OMPromises) [![Version](https://cocoapod-badges.herokuapp.com/v/OMPromises/badge.svg)](http://cocoadocs.org/docsets/OMPromises) [![Build Status](https://travis-ci.org/b52/OMPromises.png?branch=master)](https://travis-ci.org/b52/OMPromises)

A tested and fully documented promises library inspired by [Promises/A] with
certain additions and changes to better fit the common Objective-C patterns.

If you are completely unfamiliar with promises, I recommend you to read some
articles and tutorials like one of [1], [2], [3] or [4]. Some method names
might differ but the idea is mostly the same.

## Features

The main features of OMPromises are listed below.

* Fully tested and documented
* Clean interface and separation of concerns
* Support for chaining and callbacks, using `then:`, `rescue:`, `fulfilled:`,
  `failed:` and `progressed:`, similar to most other libraries
* Chaining blocks are protected against exceptions
* Support for progress notifications, unlike other libraries
* Optional support for cancellation
* Queue based block execution if needed
* Various combinators
* **New:** Promise-based HTTP request API separated from the core

## Installation

The recommended approach for installing OMPromises is to use [CocoaPods] package
manager.

```bash
pod 'OMPromises', '~> 0.3.0'
```

If you want to make use of the new HTTP request API you also have to include
the new subspec. Have a look at the corresponding [header](Classes/HTTP)
files for more information.

```bash
pod 'OMPromises/HTTP', '~> 0.3.0'
```

## Documentation

All public classes, methods, properties and types are documented, thus each
copy of OMPromises comes with a full documentation found in the corresponding
[header](OMPromises) file.

An online and much more readable version, rendered using [appledoc],
can be found [here].

## Overview

### Creation - Making promises

Promises are represented by objects of type `OMPromise`.
Creating already fulfilled, failed or delayed promises that might get
fulfilled or fail is as simple as using one of the following static methods.

```objc
OMPromise *promise = [OMPromise promiseWithResult:@1337];
// promise.state == OMPromiseStateFulfilled
// promise.result == @1337

OMPromise *promise1SecLate = [OMPromise promiseWithResult:@1338 after:1.f];
// promise1SecLate.state == OMPromiseStateUnfulfilled
// promise1SecLate.result == nil
// ... after 1 second ..
// promise1SecLate.state == OMPromiseStateFulfilled
// promise1SecLate.result == @1338

OMPromise *failed = [OMPromise promiseWithError:[NSError ...]];
// failed.state == OMPromiseStateFailed
// failed.error == [NSError ...]

// To delay the fail use promiseWithError:after: similar to promiseWithResult:after:
```

One special property of promises is, that they make only one state transition from
_unfulfilled_ to either _failed_ or _fulfilled_. The promise itself doesn't provide
an interface to do such transitions. That's why a superior class,
called `OMDeferred`, exists, which yields a promise and is the only authority that
might change the state of the aligned promise.

Thus the promises used in the above example are read-only. To create promises
you might actually change you have to create a deferred, which you should keep to
yourself, and return the promise aligned to the newly created deferred. To keep
the promise informed you may use `progress:` multiple times, followed by at most
one call of either `fulfil:` or `fail:` on the deferred.

```objc
- (OMPromise *)workIntensiveButSynchronousMethod {
    OMDeferred *deferred = [OMDeferred deferred];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // do your long-running task, eventually provide information about the progress..
        while (running)
            [deferred progress:progress];

        if (failed) {
            [deferred fail:error];
        } else {
            [deferred fulfil:result];
        }
    });

    return deferred.promise;
}
```

If you don't need the progress you could also simplify above snippet like this:

```objc
- (OMPromise *)workIntensiveButSynchronousMethod {
    return [OMPromise promiseWithTask:^{
        // do the long running task
        // ...

        // once we are done, we return the result, an NSError is automatically
        // treated as failure
        return (failed) ? error : result;
    } on:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}
```

### Callbacks - Reacting on changes in state

Once you have an instance of an `OMPromise` you might want to act on state changes.
This is done by registering [blocks] using the methods `fulfilled:`, `failed:` and/or
`progressed:` which are called if the corresponding event happens. The methods
return `self` to simply chain multiple method calls and allow to register multiple
callbacks for the same event.

```objc
[[OMPromise promiseWithResult:@1337 after:1.f]
    fulfilled:^(id result) {
        // called after 1 second, result == @1337
    }];

OMPromise *networkRequest = [OMHTTPRequest get:@"http://google.com"
                                    parameters:nil
                                       options:nil];
[[[networkRequest
    fulfilled:^(OMHTTPResponse *response) {
        // called if the network request succeeded
    }]
    failed:^(NSError *error) {
        // otherwise ...
    }]
    progressed:^(float progress) {
        // describes the progress as a value between 0.f and 1.f
    }];
```

### Chaining - Creating promises depending on other promises

Sometimes it might be necessary to chain promises and to represent the chain
by a promise itself. E.g. create small parts each described by a promise and use certain
methods to combine these small parts to form a bigger picture.

The described behavior is achieved by using a method called `then:`. Similar to
`fulfilled:` it takes a block that is executed once the promise gets fulfilled, but
the block has to return a value. This value might be a new promise or any other
object which is then bound to the **newly created promise** returned by ``then:``.
If any promise in the chain fails, the whole chain fails and all consecutive then-blocks
are skipped.

```objc
// get User by its email
- (OMPromise *)getUserByEmail:(NSString *email);

// get all Comments created by a User
- (OMPromise *)getCommentsOfUser:(User *)user;

// get all Comment messages by a User having a certain email address
- (OMPromise *)getCommentsByUsersEmail:(NSString *)email {
    OMPromise *chain = [[[self getUserByEmail:email]
        then:^id(User *user) {
            // we can chain by returning other promises
            return [self getCommentsOfUser:user];
        }]
        then:^id(NSArray *comments) {
            // but also any other object to perform e.g. value transformations
            NSMutableArray *commentMessages = [NSMutableArray array];
            for (Comment *comment in comments) {
                [commentMessages addObject:comment.message];
            }
            return commentMessages;
        }];

    // chain fails if either the first promise, returned by getUserByEmail:,
    // or the second once, returned by getCommentsOfUser:, fails;
    // otherwise the results are propagated from promise to promise until the
    // last promise, representing the chain, is fulfilled
    return chain;
}
```

In certain cases it might be required to recover from a failure and let the
chain continue as if everything happened correctly. That's when `rescue:` comes
into play. Similar to `then:` it returns a **newly created promise**,
but the supplied block is called if the _promise fails_.

```objc
// yields an UIImage if the user supplied an avatar
- (OMPromise *)getAvatarForUser:(User *)user;

// always returns an UIImage being either the User's supplied one or a dummy image
- (OMPromise *)getAvatarOrDummyForUser:(User *)user {
    OMPromise *chain = [[self getAvatarForUser:user]
        rescue:^id(NSError *error) {
            return [UIImage imageNamed:@"dummy_image.png"];
        }];

    // chain gets fulfilled always, due to rescue:
    return chain;
}

```

At that point some people might recognize the resemblance to monads in category theory.
If not, you might benefit from looking into [Haskell] and its concepts.

### Cancellation - Aborting an ongoing operation

If your abstracted operation is kinda heavy and long-running, you might want to
support _cancellation_. It allows the owner of the promise to `cancel` the
promise and thus the long-running operation, if possible. Once a promise is
cancelled, it switches into the failed state with an cancellation specific
error code.

A promise is by default not `cancellable`, but the owner of the deferred can
make it so by registering at least one cancel-handler using `cancelled:`.
It depends on the task and the use-case whether it makes sense to implement
the cancel-handler.

```objc
- (OMPromise *)get100GofData {
    OMDeferred *deferred = [OMDeferred deferred];
    [deferred cancelled:^(OMDeferred *this) {
        // cancel the download..
    }];
    return deferred.promise;
}

- (void)startDownloadAndAbort {
    OMPromise *dl = [self get100GofData];
    // dl.cancellable == YES

    // ...
    // for an unknown reason we dont need it anymore
    [dl cancel];

    // if cancelled, it switches into the failed state
    [dl failed:^(NSError *error) {
        // error.domain == OMPromisesErrorDomain
        // error.code == OMPromisesCancelledError
    }];
}
```

### Combinators & Transformers - Forming promise combinations besides chains

Currently only the following combinators are available, have a look at the documentation
for a more detailed explanation. Each combinator creates a reasonable progress
combination assuming an equal distribution of workload over all supplied promises.

* `join` - Remove one level of promise wrapping
* `chain:initial:` - Equal to applying multiple chaining/callback calls
* `all:` - Waits for all promises to get fulfilled, fails in case any promise fails.
* `any:` - Gets fulfilled if any one of the supplied promises does, otherwise it fails.

## Demonstration

Assume you want to get [Gravatar] images for a list of email addresses. Additionally
you prepared a fallback image for addresses that don't resolve to an image. Once all
images are fetched, you want to use them for further processing.

Here is how you would accomplish such task using OMPromises:

```objc
#import <OMPromises/OMPromises.h>

// lookup images in parallel
NSMutableArray *promises = [NSMutableArray array];
for (NSString *email in @[@"205e460b479e2e5b48aec07710c08d50",
                          @"9fcf5f5c3f289b330baff283b85f7705",
                          @"deadc0dedeadc0dedeadc0dedeadc0de"]) {
    OMPromise *image = [[OMHTTPRequest
                         get:@"http://www.gravatar.com/avatar/{hash}?d=404"
                         parameters:@{@"hash": email}
                         options:nil]
        rescue:^id(NSError *error) {
            // in case the promise failed, we supply a dummy image to use instead
            return [UIImage imageNamed:@"dummy_image.png"];
        }];
    [promises addObject:imagePromise];
}

// creae a combined promise and bind to its callbacks
[[[OMPromise all:promises]
    fulfilled:^(NSArray *images) {
        NSLog(@"Done. %i images loaded.", images.count);
        // do something with your images ...
    }]
    progressed:^(float progress) {
        NSLog(@"%.2f%%...", progress * 100.f);
    }];
```

## License

OMPromises is licensed under the terms of the MIT license.
Please see the [LICENSE](LICENSE) file for full details.

[Promises/A]: http://wiki.commonjs.org/wiki/Promises/A
[1]: http://blog.parse.com/2013/01/29/whats-so-great-about-javascript-promises/
[2]: https://coderwall.com/p/ijy61g
[3]: http://strongloop.com/strongblog/promises-in-node-js-with-q-an-alternative-to-callbacks/
[4]: http://sitr.us/2012/07/31/promise-pipelines-in-javascript.html
[CocoaPods]: http://cocoapods.org/
[appledoc]: https://github.com/tomaz/appledoc
[here]: http://cocoadocs.org/docsets/OMPromises/
[blocks]: https://developer.apple.com/library/ios/documentation/cocoa/Conceptual/Blocks/Articles/00_Introduction.html
[Haskell]: http://www.haskell.org
[gravatar]: http://www.gravatar.com
