module util::ShellExecFuzzer

import Prelude;
import List;


@javaClass{util.ShellExecFuzzer}
java int createProcessAndWait(str cmd, list[str] args, int timeout) throws IO; 
