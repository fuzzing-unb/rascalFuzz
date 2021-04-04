module tests::TestSelector

import fuzzing::Mutator;
import fuzzing::CandidateSelector;
import util::Benchmark;
import util::Math;
import Prelude;

tuple[map[str element, int occurs], real] benchmark(str (&T) selector, &T population, int epochs){
	start_time = realTime();
	return <distribution([selector(population) | int _ <- [0..epochs]]), toReal(realTime() - start_time) / 1000>;
}

test bool testWeightedPopulationConstruct(){

	list[Seed] seedPool = [
	  <6,"bar">,
	  <5,"test">,
	  <4,"blah">,
	  <3,"foo">,
	  <3,"asdf">,
	  <2,"test2">,
	  <2,"qwerty">,
	  <1,"test1">
	];
	WeightedPopulation goalPopulation = <seedPool,[6,11,15,18,21,23,25,26]>;
	list[WeightedPopulation] testPopulations = [];
	for(int n <- [0..3]){
		seedPoolAux = seedPool;
		testPopulations += <[],[]>;
		while(!isEmpty(seedPoolAux)){
			<seed, seedPoolAux> = takeOneFrom(seedPoolAux);
			testPopulations[n] = addSeed(testPopulations[n], seed);
		}
	}
	return testPopulations[0] == testPopulations[1] 
		&& testPopulations[1] == testPopulations[2] 
		&& testPopulations[2] == goalPopulation;
}

test bool testWeightedPopulationDistribution(){
	list[Seed] seedPool = [
	  <6,"bar">,
	  <5,"test">,
	  <4,"blah">,
	  <3,"foo">,
	  <3,"asdf">,
	  <2,"test2">,
	  <2,"qwerty">,
	  <1,"test1">
	];
	WeightedPopulation goalPopulation = <[],[]>;
	epochs = 10000;
	for(Seed seed <- seedPool){
		goalPopulation = addSeed(goalPopulation, seed);
	}
	<populationDistribution, elapsedTime> = benchmark(selectCandidateNormalized, goalPopulation, epochs);
	println("<elapsedTime>s");
	
	seedMap = toMapUnique(invert(seedPool));
	return (true | it && abs(toReal(seedMap[seed])/last(goalPopulation.runningTotals) - toReal(populationDistribution[seed])/epochs) < 0.1 | str seed <- populationDistribution);
}