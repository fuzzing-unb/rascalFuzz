module util::Runner

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
RunnerResult ProgramRunner(ProgramRunnerArgs () generator) {
  args = generator();
  seed = args.inp;
  cmd = args.program;
    
  ret = createProcessAndWait(cmd, seed);
  println("<ret>");
  if (ret == 0) { 
    return <PASS(), seed>;
  } else if (ret != 0) {
    return <FAIL(), seed>;  
  } else {
    return <UNRESOLVED(), seed>;  
  }
}

public void main() {

  ProgramRunnerArgs () createFuzzerMutatorForProgram(str seed, str cmd) =  ProgramRunnerArgs () { return <[mutate(seed)], cmd>; };
   
  compose(Runner(PrintRunner, ["Birolo", "Bozo"]));   
  compose(Runner(ProgramRunner, createFuzzerMutatorForProgram("Birolo", "/usr/bin/echo"))); 
}
