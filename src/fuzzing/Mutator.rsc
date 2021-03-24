module fuzzing::Mutator

import Prelude;
import util::Math;

/* TODO:
	1) handle character encoding
	2) actual bit flip, how to apply bitwise xor in Rascal?  
*/

int maxChar = 255;

tuple[str head, int splitPoint, str tail] randomStringSplit(str s){
	splitPoint = arbInt(size(s));
	return <substring(s,0,splitPoint), charAt(s, splitPoint), substring(s,splitPoint+1, size(s))>;
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

str mutate(str s){
	mutators = [
		pseudoFlipRandomChar,
		deleteRandomChar,
		insertRandomChar
	];
	randomMutator = mutators[arbInt(size(mutators))];
	return randomMutator(s);	
}

void main(){
	println(mutate("asdf"));
	println(mutate("asdf"));
	println(mutate("asdf"));
	println(mutate(mutate("asdf")));
}
