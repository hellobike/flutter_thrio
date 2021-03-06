/**
 * The MIT License (MIT)
 *
 * Copyright (c) 2019 Hellobike Group
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

package com.hellobike.flutter.thrio.navigator

import io.flutter.Log

internal object Log {
    var navigatorLogging = false;

    fun v(tag: String, message: String) {
        if (navigatorLogging) Log.v(tag, message) else {
        }
    }

    fun v(tag: String, message: String, tr: Throwable) {
        if (navigatorLogging) Log.v(tag, message, tr) else {
        }
    }

    fun i(tag: String, message: String) {
        if (navigatorLogging) Log.i(tag, message) else {
        }
    }

    fun i(tag: String, message: String, tr: Throwable) {
        if (navigatorLogging) Log.i(tag, message, tr) else {
        }
    }

    fun d(tag: String, message: String) {
        if (navigatorLogging) Log.d(tag, message) else {
        }
    }

    fun d(tag: String, message: String, tr: Throwable) {
        if (navigatorLogging) Log.d(tag, message, tr) else {
        }
    }

    fun w(tag: String, message: String) {
        if (navigatorLogging) Log.w(tag, message) else {
        }
    }

    fun w(tag: String, message: String, tr: Throwable) {
        if (navigatorLogging) Log.w(tag, message, tr) else {
        }
    }

    fun e(tag: String, message: String) {
        if (navigatorLogging) Log.e(tag, message) else {
        }
    }

    fun e(tag: String, message: String, tr: Throwable) {
        if (navigatorLogging) Log.e(tag, message, tr) else {
        }
    }

    fun wtf(tag: String, message: String) {
        if (navigatorLogging) Log.wtf(tag, message) else {
        }
    }

    fun wtf(tag: String, message: String, tr: Throwable) {
        if (navigatorLogging) Log.wtf(tag, message, tr) else {
        }
    }
}