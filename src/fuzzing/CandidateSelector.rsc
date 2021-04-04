module fuzzing::CandidateSelector

import fuzzing::Mutator;
import Prelude;
import util::Math;

alias Seed = tuple[int weight, str input];
alias WeightedPopulation = tuple[list[Seed] seeds, list[int] runningTotals];

WeightedPopulation addSeed(WeightedPopulation population, Seed seed){
	int i = size(population.seeds)-1;
	while(i >= 0 && seed > population.seeds[i]){
		population.runningTotals[i] += seed.weight;
		i -= 1;
	}
	population.seeds = insertAt(population.seeds, i+1, seed);
	if(i < 0){
		population.runningTotals = insertAt(population.runningTotals, 0, seed.weight);
	} else {
		population.runningTotals = insertAt(population.runningTotals, i+1, seed.weight+population.runningTotals[i]);
	}
	return population;
}

str selectCandidateNormalized(WeightedPopulation population){
	real targetDistance = arbReal()*last(population.runningTotals);
    int guessedIndex = 0;
    while (population.runningTotals[guessedIndex] <= targetDistance){
        weight = population.seeds[guessedIndex].weight;
        hopDistance = targetDistance - population.runningTotals[guessedIndex] ;
        hopIndex = 1 + toInt(hopDistance / weight);
        guessedIndex += hopIndex;
    }
    return population.seeds[guessedIndex].input;
}

public str generateCandidate(WeightedPopulation population, int maxMutations){
	return recursiveMutations(selectCandidateNormalized(population), 1+arbInt(maxMutations));
}