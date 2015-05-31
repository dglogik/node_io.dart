part of node_io.common;

JsObject _child = require("child_process");

enum ProcessStartMode {
  /// Normal child process.
  NORMAL,
  /// Detached child process with no open communication channel.
  DETACHED,
  /// Detached child process with stdin, stdout and stderr still open
  /// for communication with the child.
  DETACHED_WITH_STDIO
}

abstract class Process {
  bool kill([ProcessSignal signal = ProcessSignal.SIGTERM]);

  static bool killPid(int pid, [ProcessSignal signal = ProcessSignal.SIGTERM]) {
    return false;
  }

  static Future<ProcessResult> run(String executable,
      List<String> arguments,
      {String workingDirectory,
      Map<String, String> environment,
      bool includeParentEnvironment: true,
      bool runInShell: false,
      Encoding stdoutEncoding: SYSTEM_ENCODING,
      Encoding stderrEncoding: SYSTEM_ENCODING}) {
    return null;
  }

  static ProcessResult runSync(String executable,
      List<String> arguments,
      {String workingDirectory,
      Map<String, String> environment,
      bool includeParentEnvironment: true,
      bool runInShell: false,
      Encoding stdoutEncoding: SYSTEM_ENCODING,
      Encoding stderrEncoding: SYSTEM_ENCODING}) {
    var env = {};
    if(includeParentEnvironment)
      env.addAll(Platform.environment);
    if(environment != null)
      env.addAll(environment);

    JsObject obj;
    if(runInShell) {
      arguments.insert(0, executable);
      obj = _child.callMethod("spawnSync", ["/bin/sh", arguments, new JsObject.jsify({
        "cwd": workingDirectory,
        "env": env,
        "input": arguments.join(" ")
      })]);
    } else {
      obj = _child.callMethod("spawnSync", [executable, arguments, new JsObject.jsify({
        "cwd": workingDirectory,
        "env": env
      })]);
    }
    
    var stdout = stdoutEncoding.decode(bufToList(obj["stdout"]));
    var stderr = stderrEncoding.decode(bufToList(obj["stderr"]));

    return new ProcessResult(obj["status"], obj["pid"], stdout, stderr);
  }

  static Future<Process> start(String executable,
      List<String> arguments,
      {String workingDirectory,
      Map<String, String> environment,
      bool includeParentEnvironment: true,
      bool runInShell: false,
      ProcessStartMode mode: ProcessStartMode.NORMAL}) {
    return null;
  }
}

class ProcessResult {
  final int exitCode;
  final int pid;
  final stdout;
  final stderr;

  ProcessResult(this.exitCode, this.pid, this.stdout, this.stderr);
}

class ProcessSignal {
  static const ProcessSignal SIGHUP = const ProcessSignal._(1, "SIGHUP");
  static const ProcessSignal SIGINT = const ProcessSignal._(2, "SIGINT");
  static const ProcessSignal SIGQUIT = const ProcessSignal._(3, "SIGQUIT");
  static const ProcessSignal SIGILL = const ProcessSignal._(4, "SIGILL");
  static const ProcessSignal SIGTRAP = const ProcessSignal._(5, "SIGTRAP");
  static const ProcessSignal SIGABRT = const ProcessSignal._(6, "SIGABRT");
  static const ProcessSignal SIGBUS = const ProcessSignal._(7, "SIGBUS");
  static const ProcessSignal SIGFPE = const ProcessSignal._(8, "SIGFPE");
  static const ProcessSignal SIGKILL = const ProcessSignal._(9, "SIGKILL");
  static const ProcessSignal SIGUSR1 = const ProcessSignal._(10, "SIGUSR1");
  static const ProcessSignal SIGSEGV = const ProcessSignal._(11, "SIGSEGV");
  static const ProcessSignal SIGUSR2 = const ProcessSignal._(12, "SIGUSR2");
  static const ProcessSignal SIGPIPE = const ProcessSignal._(13, "SIGPIPE");
  static const ProcessSignal SIGALRM = const ProcessSignal._(14, "SIGALRM");
  static const ProcessSignal SIGTERM = const ProcessSignal._(15, "SIGTERM");
  static const ProcessSignal SIGCHLD = const ProcessSignal._(17, "SIGCHLD");
  static const ProcessSignal SIGCONT = const ProcessSignal._(18, "SIGCONT");
  static const ProcessSignal SIGSTOP = const ProcessSignal._(19, "SIGSTOP");
  static const ProcessSignal SIGTSTP = const ProcessSignal._(20, "SIGTSTP");
  static const ProcessSignal SIGTTIN = const ProcessSignal._(21, "SIGTTIN");
  static const ProcessSignal SIGTTOU = const ProcessSignal._(22, "SIGTTOU");
  static const ProcessSignal SIGURG = const ProcessSignal._(23, "SIGURG");
  static const ProcessSignal SIGXCPU = const ProcessSignal._(24, "SIGXCPU");
  static const ProcessSignal SIGXFSZ = const ProcessSignal._(25, "SIGXFSZ");
  static const ProcessSignal SIGVTALRM = const ProcessSignal._(26, "SIGVTALRM");
  static const ProcessSignal SIGPROF = const ProcessSignal._(27, "SIGPROF");
  static const ProcessSignal SIGWINCH = const ProcessSignal._(28, "SIGWINCH");
  static const ProcessSignal SIGPOLL = const ProcessSignal._(29, "SIGPOLL");
  static const ProcessSignal SIGSYS = const ProcessSignal._(31, "SIGSYS");

  final int _signalNumber;
  final String _name;

  const ProcessSignal._(this._signalNumber, this._name);

  String toString() => _name;

  // TODO:
  // Stream<ProcessSignal> watch() => _ProcessUtils._watchSignal(this);
}
