module util::FuzzTraceExecution


import running::Runner;
import IO;
import DateTime;

loc fuzzTraceOut = |cwd:///fuzzTrace.out|;

public void initlogResult() {
	touch(fuzzTraceOut);
}
public void logResult(RunnerResult result, int run) {
	appendToFile(fuzzTraceOut, "[<printDateTime(now())>] Fuzz Run <run>: Status-\> <result.result> Input-\> <result.outcome>\n");
}