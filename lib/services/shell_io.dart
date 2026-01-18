import 'dart:io' as io;

class ProcessResult {
  final int exitCode;
  final String stdout;
  final String stderr;

  ProcessResult(this.exitCode, this.stdout, this.stderr);
}

class Shell {
  Future<ProcessResult> run(String command, List<String> args) async {
    final result = await io.Process.run(command, args);
    return ProcessResult(
      result.exitCode,
      result.stdout.toString(),
      result.stderr.toString(),
    );
  }
}

final shell = Shell();
