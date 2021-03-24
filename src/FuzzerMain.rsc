module FuzzerMain

import running::Runner;

public void main(str arg = "") {

  compose(Runner(PrintRunner, ["Birolo", "Bozo"]));
  for(n <- [99 .. 0]) {
    compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo<n>", "/usr/bin/echo")));
    compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo<n>", "/usr/bin/c++filt")));
    RunnerResult \return = compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo<n>", "/usr/bin/vi")));
    assert \return.result == HANG() : "Must hang";     
  } 

}