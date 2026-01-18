class ProcessResult {
  final int exitCode;
  final String stdout;
  final String stderr;

  ProcessResult(this.exitCode, this.stdout, this.stderr);
}

class Shell {
  Future<ProcessResult> run(String command, List<String> args) {
    throw UnimplementedError();
  }
}

final shell = Shell();
