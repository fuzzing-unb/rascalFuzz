module util::ShellExecFuzzer

import List;
import Exception;

@javaClass{util.ShellExecFuzzer}
java int createProcessAndWait(str cmd, list[str] args, int timeout) throws IO; 
