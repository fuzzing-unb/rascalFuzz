module util::FuzzerMain

import Prelude;
import util::ShellExecFuzzer;


public void main(str arg = "") {
	int x = createProcessAndWait("/usr/bin/ld.bfd");
	print("Fuzzing...<x>\n");
}