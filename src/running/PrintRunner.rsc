module running::PrintRunner

import IO;
import running::Runner;

RunnerResult PrintRunner(list[str] inp) {
	println(inp);
	return <PASS(), inp>;
}
