module running::Runner

data ReturnStatus 
  = PASS()
  | FAIL(int status)
  | SIGNALED(int status)
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

