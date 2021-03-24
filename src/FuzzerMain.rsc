module FuzzerMain

import Prelude;
import running::Runner;


public void main(str arg = "") {

  compose(Runner(PrintRunner, ["Birolo", "Bozo"]));
  for(n <- [99 .. 0]) {
    compose(Runner(ProgramRunner, helperProgramRunner("Birolo<n>", "/usr/bin/echo")));
    compose(Runner(ProgramRunner, helperProgramRunner("Birolo<n>", "/usr/bin/c++filt")));    
  } 

}