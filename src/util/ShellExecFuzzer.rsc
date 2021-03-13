module util::ShellExecFuzzer

import Prelude;


@javaClass{util.ShellExecFuzzer}
@reflect{for stdout}
java int createProcessAndWait(str cmd) throws IO; 
