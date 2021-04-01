module FuzzerMain

import running::Runner;
import util::Math;
import IO;
import util::Benchmark;


public void main(str arg = "") {


  start_time = realTime();
  compose(Runner(PrintRunner, ["Birolo", "Bozo"]));
        
  for(n <- [0 .. 9999]) {
    //RunnerResult \return = compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo<n>", "/usr/bin/vi")));
    //assert \return.result == HANG() : "Must hang";     

    compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo<n>", "/usr/bin/bc")));
    compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo<n>", "/usr/bin/c++filt")));
    real time_enlapsed = toReal(realTime() - start_time) / 1000;
    real fcps = n / time_enlapsed;
    println("[<time_enlapsed>s] cases <n> | fcps <fcps>");
  } 

}