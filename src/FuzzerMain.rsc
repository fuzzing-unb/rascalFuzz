module FuzzerMain

import running::Runner;
import running::ProgramRunner;
import util::FuzzTraceExecution;
import util::FileIO;
import util::Math;
import util::Benchmark;
import IO;

int startFuzzTime() { 
  return realTime();
}

tuple[real enlapsed, real fcps] endFuzzTime(int start_time, int runs) {
  real time_enlapsed = toReal(realTime() - start_time) / 1000;
  real fcps = runs / time_enlapsed;
  return <time_enlapsed, fcps>;
}


public void main(str cmd, str inputFile = "") {

  start_time = startFuzzTime();
  initlogResult();
  
  set[str] population = {"Birolo", "Bozo"};
    
  if (inputFile != "") {
    population = {readText(inputFile)};
    println("<population>");
  }      
       
  for(runs <- [0 .. 9999]) {
    RunnerResult ret;
    if (inputFile != "") {
      ret = compose(Runner(ProgramRunner, helperPopulationMutator2ProgramRunnerFile(population, cmd, 16, runs)));
      population += readText(ret[1][0]);      
    } else {
      ret = compose(Runner(ProgramRunner, helperPopulationMutator2ProgramRunner(population, cmd, 2)));
      population += ret[1][0];      
    }
          
    logResult(ret, runs);
    timer = endFuzzTime(start_time, runs); 
    println("[<timer.enlapsed>s] cases <runs> | fcps <timer.fcps>");
  } 

}
