module tests::TestMutator

import fuzzing::Mutator;

test bool testMutate(){
	return mutate("asdf") != "asdf" 
		&& mutate("asdf") != "asdf"
		&& mutate("asdf") != "asdf" 
		&& mutate(mutate("asdf")) != "asdf";
}

test bool testEmptySeed(){
	return deleteRandomChar("") == "";
}

test bool testRecursiveMutations(){
	return recursiveMutations("asdfqwerty", 4) != "asdfqwerty";
}