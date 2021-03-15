module util::FuzzerMain

import Prelude;
import util::ShellExecFuzzer;


public void main(str arg = "") {
	int x = createProcessAndWait("/usr/bin/cat", ["sdsds"]);
	print("Fuzzing...<x>\n");
}