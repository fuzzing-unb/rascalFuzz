module running::Runner

import Prelude;
import util::ShellExecFuzzer;
import fuzzing::Mutator;

data ReturnStatus 
  = PASS()
  | FAIL()
  | UNRESOLVED()
  | HANG()
  ;


alias RunnerResult = tuple[ReturnStatus result, list[str] outcome];

data  Runner[&T] 
  = Runner(RunnerResult (&T) run, &T param)  
  ;

 
public RunnerResult compose(Runner[&T] runner) {    
  return runner.run(runner.param);
} 

RunnerResult PrintRunner(list[str] inp) {
  println(inp);
  return <PASS(), inp>;
}

alias ProgramRunnerArgs = tuple[list[str] inp, str program];
ProgramRunnerArgs () helperMutator2ProgramRunner(str seed, str cmd) =  ProgramRunnerArgs () { return <[mutate(seed)], cmd>; };
ProgramRunnerArgs () helperPopulationMutator2ProgramRunner(set[str] population, str cmd, int maxMutations) =  ProgramRunnerArgs () { return <[generateCandidate(population, maxMutations)], cmd>; };


RunnerResult ProgramRunner(ProgramRunnerArgs () generator) {
  args = generator();
  seed = args.inp;
  cmd = args.program;
  
  try    
    ret = createProcessAndWait(cmd, seed, 1);
  catch:
    return <HANG(), seed>;
        
  if (ret == 0) { 
    return <PASS(), seed>;
  } else if (ret != 0) {
    return <FAIL(), seed>;  
  } else {
    return <UNRESOLVED(), seed>;  
  }
}


public void main() {   
  compose(Runner(PrintRunner, ["Birolo", "Bozo"]));   
  compose(Runner(ProgramRunner, helperMutator2ProgramRunner("Birolo", "/usr/bin/echo"))); 
}
