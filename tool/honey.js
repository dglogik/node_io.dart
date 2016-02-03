#!/usr/bin/env node

// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Javascript preamble, that lets the output of dart2js run on V8's d8 shell.

// Node wraps files and provides them with a different `this`. The global
// `this` can be accessed through `global`.

global.location = {
  href: "file://" + process.cwd() + "/"
};
global.scheduleImmediate = setImmediate;
global.self = global;
global.require = require;
global.process = process;

function computeCurrentScript() {
  try {
    throw new Error();
  } catch (e) {
    var stack = e.stack;
    var re = new RegExp("^ *at [^(]*\\((.*):[0-9]*:[0-9]*\\)$", "mg");
    var lastMatch = null;
    do {
      var match = re.exec(stack);
      if (match != null) lastMatch = match;
    } while (match != null);
    return lastMatch[1];
  }
}

var cachedCurrentScript = null;
global.document = {
  get currentScript() {
    if (cachedCurrentScript == null) {
      cachedCurrentScript = {
        src: computeCurrentScript()
      };
    }
    return cachedCurrentScript;
  }
};

global.dartDeferredLibraryLoader = function(uri, successCallback, errorCallback) {
  try {
    load(uri);
    successCallback();
  } catch (error) {
    errorCallback(error);
  }
};

(function() {
  var module = require('module'),
      vm = require('vm'),
      fs = require('fs'),
      path = require('path');

  if(process.argv.length < 3)
    return;

  var files = process.argv.splice(2);

  files.forEach(function(file) {
    file = fs.readFileSync(path.normalize(file)).toString();
    vm.runInThisContext(module.wrap(file))(exports, require, module, __filename, __dirname);
  });
})();
