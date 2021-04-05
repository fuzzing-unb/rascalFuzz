module running::Coverage

import IO;
import String;
import List;

set[tuple[str,int]] readGcovFile(str cSourceFilePath){
    gcovFile = cSourceFilePath + ".gcov";
    coverage = {};
    for(str line <- readFileLines(toLocation(gcovFile))){
    	elems = split(":", line);
        covered = trim(elems[0]);
        lineNumber = toInt(trim(elems[1]));
        if (startsWith(covered, "-") || startsWith(covered, "#")){
            continue;
        }
        coverage += <last(split("/", cSourceFilePath)), lineNumber>;
    }
    return coverage;
}