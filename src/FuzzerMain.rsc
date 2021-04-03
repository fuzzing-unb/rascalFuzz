module FuzzerMain

import running::Runner;
import util::Math;
import IO;
import Set;
import util::Benchmark;


public void main(str arg = "") {


  start_time = realTime();
  compose(Runner(PrintRunner, ["Birolo", "Bozo"]));
  population = {"Birolo", "Bozo"};
  //RunnerResult \return = compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo", "vi")));
  //assert \return.result == HANG() : "Must hang"; 
        
  for(n <- [0 .. 9999]) {    
    
    population += compose(Runner(ProgramRunner, helperPopulationMutator2ProgramRunner(population, "bc", 2)))[1][0];
    real time_enlapsed = toReal(realTime() - start_time) / 1000;
    real fcps = n / time_enlapsed;
    println("[<time_enlapsed>s] cases <n> | fcps <fcps>");
  } 

}
