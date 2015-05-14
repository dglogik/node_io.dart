# node_io

This library is a drop-in replacement for most of the common dart:io utilities, built for running Dart code on node.js.

You can use this to run your library on node.js, develop apps with Electron, write Atom plugins (combined with atom.dart), and
whatever else you might need node.js for.

We aren't trying to replace usage of the standalone Dart VM with node.js, but for some use cases node.js is needed, and currently
there isn't a good way in Dart to communicate with the system if running on the node.js runtime.

## Notes

If you plan on using WebSockets, the npm dependency of 'ws' needs to be added to your package.json. This is due to node.js not
shipping with a WebSockets implementation by default.

## Using node_io

Using node_io should be rather straightforward, use it with dart2js. We use our own custom tool, honey, for managing packaging
for a node.js environment. If you've ever used Dart code in a browser, you are familiar with the .js that needs to be included
for the Dart code to interact with JavaScript code and run. Honey uses a custom version of that script which includes bindings
to things like require(), which is essential to node_io's functions.

To run a compiled dart2js script, run 'node tool/honey.js <file>'. A solution will be added in the future for the modified
dart2js preamble to be prepended to a .js file, removing the need for a runtime script.

## Contributing

Feel free to submit pull requests as node_io nears API completion. Right now, only a subset of the dart:io functions are actually
supported. Any help with this cause would be fantastic.

Our tests also need some work. Eventually, we would like to create a pull request for Dart's new test package with node.js support.

You can also contact us (kaendfinger or mbullington) on the #dart Freenode IRC channel with any questions.