module fuzzing::Mutator

import List;
import Set;
import String;
import IO;
import util::Math;

/* TODO:
	1) handle character encoding
	2) actual bit flip, how to apply bitwise xor in Rascal?
*/

int maxChar = 255;

 tuple[str head, int splitPoint, str tail] randomStringSplit(str s){
	int stringSize = size(s);
	if(stringSize > 0){
		splitPoint = arbInt(stringSize);
		return <substring(s,0,splitPoint), charAt(s, splitPoint), substring(s,splitPoint+1, stringSize)>;
	} else {
		return <"", 0, "">;
	}
}

str pseudoFlipRandomChar(str s){
	splitString = randomStringSplit(s);
	int bitPos = arbInt(floor(log(maxChar, 2))+1);
	bitFlippedChar = stringChar(splitString.splitPoint + toInt(pow(2,bitPos)));
	return splitString.head + bitFlippedChar + splitString.tail;
}

str deleteRandomChar(str s){
	splitString = randomStringSplit(s);
	return splitString.head + splitString.tail;
}

str insertRandomChar(str s){
	splitString = randomStringSplit(s);
	randomChar = stringChar(arbInt(maxChar));
	if(isEmpty(splitString.tail) && arbInt(2) == 0){
		randomChar = stringChar(splitString.splitPoint) + randomChar;
	} else {
		randomChar += stringChar(splitString.splitPoint);
	}
	return splitString.head + randomChar + splitString.tail;
}

public str mutate(str s){
	mutators = [
		pseudoFlipRandomChar,
		deleteRandomChar,
		insertRandomChar
	];
	randomMutator = mutators[arbInt(size(mutators))];
	return randomMutator(s);	
}

str recursiveMutations(str s, int numMutations){
	if(numMutations > 0){
		return recursiveMutations(mutate(s), numMutations-1);
	} else {
		return mutate(s);
	}
}

public str generateCandidate(set[str] population, int maxMutations){
	str seedCandidate = getOneFrom(population);
	return recursiveMutations(seedCandidate, 1+arbInt(maxMutations));
}

void main(){
	println(deleteRandomChar(""));
	println(recursiveMutations("asdfqwerty", 4));
	set[str] population = {"Testando 123", "asdfqwerty", "foobar"};
	println(generateCandidate(population, 5));
	println(generateCandidate(population, 5));
	println(generateCandidate(population, 5));
	
}
