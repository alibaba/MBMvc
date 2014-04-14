//
// OMPromise.h
// OMPromises
//
// Copyright (C) 2013,2014 Oliver Mader
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "OMPromise.h"

/** An OMDeferred is an abstract construct to control the outcome of an aligned
 OMPromise, which is used to proxy the outcome of an asynchronous operation.

 In order to model a long-running asynchronous operation, you would create an instance
 of OMDeferred using deferred. You use this instance to control the state of the
 underlying OMPromise, accessed by promise.

 You might call progress: multiple times to keep the user informed, followed by a final
 call to either fulfil:, in case everything went as expected, or fail: otherwise.
 
 If it is possible and desirable to stop or abort the abstracted operation, you should
 register a cancel-handler using cancelled:. Doing so makes the aligned promise
 implicitly cancellable, thus the handler is called once someone calls cancel on the
 promise.

 It's important to understand that the OMDeferred/OMPromise is sealed, once its stated
 has been changed by calling fulfil: or fail:. After that calls to progress:, fulfil:
 or fail: result in an exception.
 */
@interface OMDeferred : OMPromise

///---------------------------------------------------------------------------------------
/// @name Creation
///---------------------------------------------------------------------------------------

/** Create and return a new deferred.
 */
+ (OMDeferred *)deferred;

///---------------------------------------------------------------------------------------
/// @name Accessing the underlying promise
///---------------------------------------------------------------------------------------

/** Returns the associated promise.
 
 Proxies the outcome of the underlying bunch of work.
 */
- (OMPromise *)promise;

///---------------------------------------------------------------------------------------
/// @name Change state
///---------------------------------------------------------------------------------------

/** Finalizes the deferred by settings its state to OMPromiseStateFulfilled.
 
 Implicitly sets the progress to 1.
 
 @param result Result to set and propagate.
 @see fail:
 */
- (void)fulfil:(id)result;

/** Finalizes the deferred by settings its state to OMPromiseStateFailed.
 
 @param error Error to set and propagate.
 @see fulfil:
 */
- (void)fail:(NSError *)error;

/** Update the progress.
 
 The new progress has to be higher than the previous one. Equal values are skipped,
 but lower values raise an exception.
 
 @param progress Higher progress to set and propagate.
 */
- (void)progress:(float)progress;

///---------------------------------------------------------------------------------------
/// @name Cancellation
///---------------------------------------------------------------------------------------

/** Add a handler to be called on cancel.
 
 If at least one handler is registered, it is assumed that the corresponding promise
 supports cancellation. Once the promise is cancelled, it changes into a failed state
 with error code OMPromisesCancelledError and the corresponding cancel-handlers and
 fail-handlers are called.
 
 @param cancelHandler The block to be called, once the promise is cancelled.
 */
- (void)cancelled:(void (^)(OMDeferred *deferred))cancelHandler;

@end

