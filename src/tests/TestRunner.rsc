module tests::TestRunner

import running::Runner;

test bool testPrintRunner() {
	RunnerResult \return = compose(Runner(PrintRunner, ["Birolo", "Bozo"]));
	return \return.result == PASS(); 	
}

test bool testProgramRunnerMustPass() {   
	RunnerResult \return = compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo", "/usr/bin/echo")));
	return \return.result == PASS(); 	
}

test bool testProgramRunnerMustHang() {
	RunnerResult \return = compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo", "vi")));
	return \return.result == HANG();
}