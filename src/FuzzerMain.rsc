module FuzzerMain

import running::Runner;
import running::ProgramRunner;
import util::FuzzTraceExecution;
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


public void main(str arg) {

  println(arg);
  start_time = startFuzzTime();
  initlogResult();
  population = {"Birolo", "Bozo"};
       
  for(runs <- [0 .. 9999]) {
    ret = compose(Runner(ProgramRunner, helperPopulationMutator2ProgramRunner(population, arg, 2)));
    logResult(ret, runs);
    population += ret[1][0];
    timer = endFuzzTime(start_time, runs); 
    println("[<timer.enlapsed>s] cases <runs> | fcps <timer.fcps>");
  } 

}
