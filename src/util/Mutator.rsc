module util::Mutator

import Prelude;
import util::Math;

tuple[str head, int splitPoint, str tail] randomStringSplit(str s){
	splitPoint = arbInt(size(s));
	return <substring(s,0,splitPoint), charAt(s, splitPoint), substring(s,splitPoint+1, size(s))>;
}

str pseudoFlipRandomChar(str s, int bitPos){
	splitString = randomStringSplit(s);
	bitFlippedChar = stringChar(splitString.splitPoint + toInt(pow(2,bitPos)));
	return splitString.head + bitFlippedChar + splitString.tail;
}

str deleteRandomChar(str s){
	splitString = randomStringSplit(s);
	return splitString.head + splitString.tail;
}

str insertRandomChar(str s, int maxChar){
	splitString = randomStringSplit(s);
	randomChar = stringChar(arbInt(maxChar));
	return splitString.head + randomChar + splitString.tail;
}

void main(){
	println(deleteRandomChar("asdf"));
	println(insertRandomChar("asdf", 255));
	println(pseudoFlipRandomChar("asdf", 2));
}
