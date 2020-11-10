// The MIT License (MIT)
//
// Copyright (c) 2019 foxsofter
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "NavigatorRouteObservers.h"
#import "NavigatorFlutterEngineFactory.h"
#import "NavigatorLogger.h"

@interface NavigatorRouteObservers ()

@property (nonatomic, readwrite) ThrioRegistrySet<id<NavigatorRouteObserverProtocol> > *observers;

@end

@implementation NavigatorRouteObservers

- (instancetype)init {
    if (self = [super init]) {
        _observers = [ThrioRegistrySet set];
        [_observers registry:NavigatorFlutterEngineFactory.shared];
    }
    return self;
}

- (void)didPush:(NavigatorRouteSettings *)routeSettings {
    ThrioRegistrySet *routeObservers = [self.observers copy];
    for (id<NavigatorRouteObserverProtocol> observer in routeObservers) {
        if ([observer respondsToSelector:@selector(didPush:)]) {
            [observer didPush:routeSettings];
        }
    }
}

- (void)didPop:(NavigatorRouteSettings *)routeSettings {
    ThrioRegistrySet *routeObservers = [self.observers copy];
    for (id<NavigatorRouteObserverProtocol> observer in routeObservers) {
        if ([observer respondsToSelector:@selector(didPop:)]) {
            [observer didPop:routeSettings];
        }
    }
}

- (void)didPopTo:(NavigatorRouteSettings *)routeSettings {
    ThrioRegistrySet *routeObservers = [self.observers copy];
    for (id<NavigatorRouteObserverProtocol> observer in routeObservers) {
        if ([observer respondsToSelector:@selector(didPopTo:)]) {
            [observer didPopTo:routeSettings];
        }
    }
}

- (void)didRemove:(NavigatorRouteSettings *)routeSettings {
    ThrioRegistrySet *routeObservers = [self.observers copy];
    for (id<NavigatorRouteObserverProtocol> observer in routeObservers) {
        if ([observer respondsToSelector:@selector(didRemove:)]) {
            [observer didRemove:routeSettings];
        }
    }
}

@end
