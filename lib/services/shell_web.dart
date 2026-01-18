class ProcessResult {
  final int exitCode;
  final String stdout;
  final String stderr;

  ProcessResult(this.exitCode, this.stdout, this.stderr);
}

class Shell {
  Future<ProcessResult> run(String command, List<String> args) async {
    // Mock behavior for Live Demo
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    return ProcessResult(0, "Mock Success", "");
  }
}

final shell = Shell();
