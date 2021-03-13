package util;

import java.io.IOException;

import org.rascalmpl.interpreter.IEvaluatorContext;

import io.usethesource.vallang.IInteger;
import io.usethesource.vallang.IString;
import io.usethesource.vallang.IValueFactory;

public class ShellExecFuzzer {

	private final IValueFactory vf;
	
	public ShellExecFuzzer(IValueFactory vf) {
		this.vf = vf;
	}
		
	public IInteger createProcessAndWait(IString cmd, IEvaluatorContext ctx) throws IOException, InterruptedException {
		IInteger processReturnCode = null;		
		ProcessBuilder builder = new ProcessBuilder(cmd.getValue());
		Process process = builder.start();
		processReturnCode = vf.integer(process.waitFor());
		return processReturnCode;
	}
}
