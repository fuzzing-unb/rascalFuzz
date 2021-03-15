package util;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IList;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;


public class ShellExecFuzzer {

	private final IValueFactory vf;
	private PrintWriter out;	
	
	public ShellExecFuzzer(IValueFactory vf) {
		this.vf = vf;
	}
		
	public IInteger createProcessAndWait(IString cmd, IList args) {
		//this.out = ctx.getOutPrinter();
		
		IInteger processReturnCode = null;
		
		List<String> argsList = new ArrayList<>();
		
		if (args != null && args.length() > 0) {
			argsList.add(cmd.getValue());
			for (int n = 0; n < args.length(); ++n) {
				if (args.get(n) instanceof IString) {
					String tmp = ((IString)args.get(n)).getValue();
					argsList.add(tmp);					
				}
			}
		} else {
			argsList.add(cmd.getValue());
		}
					 
		ProcessBuilder builder = new ProcessBuilder(argsList);
		Process process;
		try {
			process = builder.start();
			processReturnCode = vf.integer(process.waitFor());			
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
		}
		return processReturnCode;
	}
}
