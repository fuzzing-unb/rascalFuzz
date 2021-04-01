module tests::TestMutator

import fuzzing::Mutator;


test bool testMutate(){
	return mutate("asdf") != "asdf" 
		&& mutate("asdf") != "asdf"
		&& mutate("asdf") != "asdf" 
		&& mutate(mutate("asdf")) != "asdf";
}
