module running::ProgramRunner

import running::Runner;
import fuzzing::Mutator;
import util::FileIO;
import util::ShellExecFuzzer;
import Exception;

// The lowest return value with special meaning (signals: kill -l)                                                                                                                                                     
int LowerReturnValue = 126;

alias ProgramRunnerArgs = tuple[list[str] inp, str program];

ProgramRunnerArgs () helperMutator2ProgramRunner(str seed, str cmd) = 
	ProgramRunnerArgs () { return <[mutate(seed)], cmd>; };
	
ProgramRunnerArgs () helperPopulationMutator2ProgramRunner(set[str] population, str cmd, int maxMutations) = 
	ProgramRunnerArgs () { return <[generateCandidate(population, maxMutations)], cmd>; };

ProgramRunnerArgs () helperPopulationMutator2ProgramRunnerFile(set[str] population, str cmd, int maxMutations, int run) = 
	ProgramRunnerArgs () {
		out = "/tmp/<cmd>:popMutator:<run>";
		write(out, generateCandidate(population, maxMutations));	
		return <[out], cmd>; 
	};

	
RunnerResult ProgramRunner(ProgramRunnerArgs () generator) {
  args = generator();
  seed = args.inp;
  cmd = args.program;
  
  try    
    ret = createProcessAndWait(cmd, seed, 1);
  catch IO("Timed out!"):
    return <HANG(), seed>;
        
  if (ret == 0) { 
    return <PASS(), seed>;
  } else if (ret != 0) {
	if (ret >= LowerReturnValue)
		return <SIGNALED(ret), seed>;
	else
		return <FAIL(ret), seed>;  
  } else {
    return <UNRESOLVED(), seed>;  
  }
}
