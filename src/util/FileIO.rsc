module util::FileIO

import IO;
import String;

alias bytes = list[int];
alias text = str;

bytes readBytes(str file) {
	return readFileBytes(toLocation("file://" + file));
}

text readText(str file) {
	return readFile(toLocation("file://" + file));
}

bool write(str file, text input) {
	try
		writeFile(toLocation("file://" + file), input);
	catch:
		return false;
	return true;
}


bool write(str file, bytes input) {
	try
		writeFileBytes(toLocation("file://" + file), input);
	catch:
		return false;
	return true;
}
