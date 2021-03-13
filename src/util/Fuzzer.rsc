module util::Fuzzer

import Prelude;
import util::ShellExecFuzzer;


public void main() {
	int x = createProcessAndWait("/usr/bin/ld.bfd");
	print("Fuzzing...<x>\n");
}