// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Javascript preamble, that lets the output of dart2js run on V8's d8 shell.

// Node wraps files and provides them with a different `this`. The global
// `this` can be accessed through `global`.

var self = this;
if (typeof global != "undefined") self = global;  // Node.js.

(function(self) {
    // Using strict mode to avoid accidentally defining global variables.
    "use strict"; // Should be first statement of this function.

    // Location (Uri.base)

    var workingDirectory;
    // TODO(sgjesse): This does not work on Windows.
    if (typeof os == "object" && "system" in os) {
        // V8.
        workingDirectory = os.system("pwd");
        var length = workingDirectory.length;
        if (workingDirectory[length - 1] == '\n') {
            workingDirectory = workingDirectory.substring(0, length - 1);
        }
    } else if (typeof process != "undefined" &&
        typeof process.cwd == "function") {
        // Node.js.
        workingDirectory = process.cwd();
    }
    self.location = { href: "file://" + workingDirectory + "/" };

    // Event loop.

    // Task queue as cyclic list queue.
    var taskQueue = new Array(8);  // Length is power of 2.
    var head = 0;
    var tail = 0;
    var mask = taskQueue.length - 1;
    function addTask(elem) {
        taskQueue[head] = elem;
        head = (head + 1) & mask;
        if (head == tail) _growTaskQueue();
    }
    function removeTask() {
        if (head == tail) return;
        var result = taskQueue[tail];
        taskQueue[tail] = undefined;
        tail = (tail + 1) & mask;
        return result;
    }
    function _growTaskQueue() {
        // head == tail.
        var length = taskQueue.length;
        var split = head;
        taskQueue.length = length * 2;
        if (split * 2 < length) {  // split < length / 2
            for (var i = 0; i < split; i++) {
                taskQueue[length + i] = taskQueue[i];
                taskQueue[i] = undefined;
            }
            head += length;
        } else {
            for (var i = split; i < length; i++) {
                taskQueue[length + i] = taskQueue[i];
                taskQueue[i] = undefined;
            }
            tail += length;
        }
        mask = taskQueue.length - 1;
    }

    // Mapping from timer id to timer function.
    // The timer id is written on the function as .$timerId.
    // That field is cleared when the timer is cancelled, but it is not returned
    // from the queue until its time comes.
    var timerIds = {};
    var timerIdCounter = 1;  // Counter used to assing ids.

    // Zero-timer queue as simple array queue using push/shift.
    var zeroTimerQueue = [];

    function addTimer(f, ms) {
        var id = timerIdCounter++;
        f.$timerId = id;
        timerIds[id] = f;
        if (ms == 0) {
            zeroTimerQueue.push(f);
        } else {
            addDelayedTimer(f, ms);
        }
        return id;
    }

    function nextZeroTimer() {
        while (zeroTimerQueue.length > 0) {
            var action = zeroTimerQueue.shift();
            if (action.$timerId !== undefined) return action;
        }
    }

    function nextEvent() {
        var action = removeTask();
        if (action) {
            return action;
        }
        do {
            action = nextZeroTimer();
            if (action) break;
            var nextList = nextDelayedTimerQueue();
            if (!nextList) {
                return;
            }
            var newTime = nextList.shift();
            advanceTimeTo(newTime);
            zeroTimerQueue = nextList;
        } while (true)
        var id = action.$timerId;
        clearTimerId(action, id);
        return action;
    }

    // Mocking time.
    var timeOffset = 0;
    var now = function() {
        // Install the mock Date object only once.
        // Following calls to "now" will just use the new (mocked) Date.now
        // method directly.
        installMockDate();
        now = Date.now;
        return Date.now();
    };
    var originalDate = Date;
    var originalNow = originalDate.now;
    function advanceTimeTo(time) {
        timeOffset = time - originalNow();
    }
    function installMockDate() {
        var NewDate = function Date(Y, M, D, h, m, s, ms) {
            if (this instanceof Date) {
                // Assume a construct call.
                switch (arguments.length) {
                    case 0:  return new originalDate(originalNow() + timeOffset);
                    case 1:  return new originalDate(Y);
                    case 2:  return new originalDate(Y, M);
                    case 3:  return new originalDate(Y, M, D);
                    case 4:  return new originalDate(Y, M, D, h);
                    case 5:  return new originalDate(Y, M, D, h, m);
                    case 6:  return new originalDate(Y, M, D, h, m, s);
                    default: return new originalDate(Y, M, D, h, m, s, ms);
                }
            }
            return new originalDate(originalNow() + timeOffset).toString();
        };
        NewDate.UTC = originalDate.UTC;
        NewDate.parse = originalDate.parse;
        NewDate.now = function now() { return originalNow() + timeOffset; };
        NewDate.prototype = originalDate.prototype;
        originalDate.prototype.constructor = NewDate;
        Date = NewDate;
    }

    // Heap priority queue with key index.
    // Each entry is list of [timeout, callback1 ... callbackn].
    var timerHeap = [];
    var timerIndex = {};
    function addDelayedTimer(f, ms) {
        var timeout = now() + ms;
        var timerList = timerIndex[timeout];
        if (timerList == null) {
            timerList = [timeout, f];
            timerIndex[timeout] = timerList;
            var index = timerHeap.length;
            timerHeap.length += 1;
            bubbleUp(index, timeout, timerList);
        } else {
            timerList.push(f);
        }
    }

    function nextDelayedTimerQueue() {
        if (timerHeap.length == 0) return null;
        var result = timerHeap[0];
        var last = timerHeap.pop();
        if (timerHeap.length > 0) {
            bubbleDown(0, last[0], last);
        }
        return result;
    }

    function bubbleUp(index, key, value) {
        while (index != 0) {
            var parentIndex = (index - 1) >> 1;
            var parent = timerHeap[parentIndex];
            var parentKey = parent[0];
            if (key > parentKey) break;
            timerHeap[index] = parent;
            index = parentIndex;
        }
        timerHeap[index] = value;
    }

    function bubbleDown(index, key, value) {
        while (true) {
            var leftChildIndex = index * 2 + 1;
            if (leftChildIndex >= timerHeap.length) break;
            var minChildIndex = leftChildIndex;
            var minChild = timerHeap[leftChildIndex];
            var minChildKey = minChild[0];
            var rightChildIndex = leftChildIndex + 1;
            if (rightChildIndex < timerHeap.length) {
                var rightChild = timerHeap[rightChildIndex];
                var rightKey = rightChild[0];
                if (rightKey < minChildKey) {
                    minChildIndex = rightChildIndex;
                    minChild = rightChild;
                    minChildKey = rightKey;
                }
            }
            if (minChildKey > key) break;
            timerHeap[index] = minChild;
            index = minChildIndex;
        }
        timerHeap[index] = value;
    }

    function addInterval(f, ms) {
        var id = timerIdCounter++;
        function repeat() {
            // Reactivate with the same id.
            repeat.$timerId = id;
            timerIds[id] = repeat;
            addDelayedTimer(repeat, ms);
            f();
        }
        repeat.$timerId = id;
        timerIds[id] = repeat;
        addDelayedTimer(repeat, ms);
        return id;
    }

    function cancelTimer(id) {
        var f = timerIds[id];
        if (f == null) return;
        clearTimerId(f, id);
    }

    function clearTimerId(f, id) {
        f.$timerId = undefined;
        delete timerIds[id];
    }

    function eventLoop(action) {
        while (action) {
            try {
                action();
            } catch (e) {
                if (typeof onerror == "function") {
                    onerror(e, null, -1);
                } else {
                    throw e;
                }
            }
            action = nextEvent();
        }
    }

    // Global properties. "self" refers to the global object, so adding a
    // property to "self" defines a global variable.
    self.self = self
    self.dartMainRunner = function(main, args) {
        // Initialize.
        var action = function() { main(args); }
        eventLoop(action);
    };
    self.setTimeout = addTimer;
    self.clearTimeout = cancelTimer;
    self.setInterval = addInterval;
    self.clearInterval = cancelTimer;
    self.scheduleImmediate = addTask;
    self.require = require;
    self.global = global;

    // Support for deferred loading.
    self.dartDeferredLibraryLoader = function(uri, successCallback, errorCallback) {
        try {
            load(uri);
            successCallback();
        } catch (error) {
            errorCallback(error);
        }
    };
})(self);

require('vm').runInThisContext(require('fs').readFileSync(require('path').normalize(process.argv[2])).toString());
