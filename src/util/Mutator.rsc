module util::Mutator

import Prelude;
import util::Math;

str pseudoFlipRandomChar(str s, int bitPos){
	splitPoint = arbInt(size(s));
	return substring(s,0,splitPoint) + stringChar(charAt(s, splitPoint) + toInt(pow(2,bitPos))) + substring(s,splitPoint+1, size(s));
}

str deleteRandomChar(str s){
	splitPoint = arbInt(size(s));
	return substring(s,0,splitPoint) + substring(s,splitPoint+1, size(s));
}

str insertRandomChar(str s, int maxChar){
	splitPoint = arbInt(size(s));
	return substring(s,0,splitPoint) + stringChar(arbInt(maxChar)) + substring(s,splitPoint, size(s));
}

void main(){
	println(deleteRandomChar("asdf"));
	println(insertRandomChar("asdf", 255));
	println(pseudoFlipRandomChar("asdf", 2));
}
