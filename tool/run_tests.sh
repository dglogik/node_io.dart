#!/usr/bin/env bash
set -e
dart2js -o test/test.js test/test.dart
node tool/honey.js test/test.js
rm -rf test/test.js*
