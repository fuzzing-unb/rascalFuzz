module util::FileIO

import IO;
import String;

alias bytes = list[int];

bytes read(str file) {
	return readFileBytes(toLocation("file://" + file));
}

bool write(str file, bytes input) {
	try
		writeFileBytes(toLocation("file://" + file), input);
	catch:
		return false;
	return true;
}
