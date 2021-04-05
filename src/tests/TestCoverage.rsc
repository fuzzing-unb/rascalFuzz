module tests::TestCoverage

import running::Coverage;
import String;
import IO;

test bool testLoadGcovFile(){
	fileContents = "        -:    0:Source:main.c
	        -:    0:Graph:main.gcno
	        -:    0:Data:main.gcda
	        -:    0:Runs:2
	        -:    0:Programs:1
	        -:    1:/*  This file is part of GNU bc.
	        -:    2:
	        -:    3:    Copyright (C) 1991-1994, 1997, 2006, 2008, 2012-2017 Free Software Foundation, Inc.
	        -:    4:
	        -:    5:    This program is free software; you can redistribute it and/or modify
	        -:    6:    it under the terms of the GNU General Public License as published by
	        -:    7:    the Free Software Foundation; either version 3 of the License , or
	        -:    8:    (at your option) any later version.
	        -:    9:
	        -:   10:    This program is distributed in the hope that it will be useful,
	        -:   11:    but WITHOUT ANY WARRANTY; without even the implied warranty of
	        -:   12:    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	        -:   13:    GNU General Public License for more details.
	        -:   14:
	        -:   15:    You should have received a copy of the GNU General Public License
	        -:   16:    along with this program; see the file COPYING.  If not, see
	        -:   17:    \<http://www.gnu.org/licenses\>.
	        -:   18:
	        -:   19:    You may contact the author by:
	        -:   20:       e-mail:  philnelson@acm.org
	        -:   21:      us-mail:  Philip A. Nelson
	        -:   22:                Computer Science Department, 9062
	        -:   23:                Western Washington University
	        -:   24:                Bellingham, WA 98226-9062
	        -:   25:       
	        -:   26:*************************************************************************/
	        -:   27:
	        -:   28:/* main.c: The main program for bc.  */
	        -:   29:
	        -:   30:#include \"bcdefs.h\"
	        -:   31:#include \<signal.h\>
	        -:   32:#include \<errno.h\>
	        -:   33:#include \"proto.h\"
	        -:   34:#include \"getopt.h\"
	        -:   35:
	        -:   36:
	        -:   37:/* Variables for processing multiple files. */
	        -:   38:static char first_file;
	        -:   39:
	        -:   40:/* Points to the last node in the file name list for easy adding. */
	        -:   41:static file_node *last = NULL;
	        -:   42:
	        -:   43:#if defined(LIBEDIT)
	        -:   44:/* The prompt for libedit. */
	        -:   45:char el_pmtchars[] = \"\";
	        -:   46:static char *el_pmtfunc(void);
	        -:   47:static char *el_pmtfunc(void) { return el_pmtchars; }
	        -:   48:#endif
	        -:   49:
	        -:   50:/* long option support */
	        -:   51:static struct option long_options[] =
	        -:   52:{
	        -:   53:  {\"compile\",     0, &compile_only, TRUE},
	        -:   54:  {\"help\",        0, 0,             \'h\'},
	        -:   55:  {\"interactive\", 0, 0,             \'i\'},
	        -:   56:  {\"mathlib\",     0, &use_math,     TRUE},
	        -:   57:  {\"quiet\",       0, &quiet,        TRUE},
	        -:   58:  {\"standard\",    0, &std_only,     TRUE},
	        -:   59:  {\"version\",     0, 0,             \'v\'},
	        -:   60:  {\"warn\",        0, &warn_not_std, TRUE},
	        -:   61:
	        -:   62:  {0, 0, 0, 0}
	        -:   63:};
	        -:   64:
	        -:   65:
	        -:   66:static void
	    #####:   67:usage (const char *progname)
	        -:   68:{
	    #####:   69:  printf (\"usage: %s [options] [file ...]\\n%s%s%s%s%s%s%s\", progname,
	        -:   70:          \"  -h  --help         print this usage and exit\\n\",
	        -:   71:	  \"  -i  --interactive  force interactive mode\\n\",
	        -:   72:	  \"  -l  --mathlib      use the predefined math routines\\n\",
	        -:   73:	  \"  -q  --quiet        don\'t print initial banner\\n\",
	        -:   74:	  \"  -s  --standard     non-standard bc constructs are errors\\n\",
	        -:   75:	  \"  -w  --warn         warn about non-standard bc constructs\\n\",
	        -:   76:	  \"  -v  --version      print version information and exit\\n\");
	    #####:   77:}
	        -:   78:
	        -:   79:
	        -:   80:static void
	        2:   81:parse_args (int argc, char **argv)
	        -:   82:{
	        -:   83:  int optch;
	        2:   84:  int long_index;
	        -:   85:  file_node *temp;
	        -:   86:
	        -:   87:  /* Force getopt to initialize.  Depends on GNU getopt. */
	        2:   88:  optind = 0;
	        -:   89:
	        -:   90:  /* Parse the command line */
	        3:   91:  while (1)
	        -:   92:    {
	        3:   93:      optch = getopt_long (argc, argv, \"chilqswv\", long_options, &long_index);
	        -:   94:
	        3:   95:      if (optch == EOF)  /* End of arguments. */
	        -:   96:	break;
	        -:   97:
	        1:   98:      switch (optch)
	        -:   99:	{
	        -:  100:	case 0: /* Long option setting a var. */
	        -:  101:	  break;
	        -:  102:
	        -:  103:	case \'c\':  /* compile only */
	        1:  104:	  compile_only = TRUE;
	        1:  105:	  break;
	        -:  106:
	        -:  107:	case \'h\':  /* help */
	    #####:  108:	  usage(argv[0]);
	    #####:  109:	  bc_exit (0);
	    #####:  110:	  break;
	        -:  111:
	        -:  112:	case \'i\':  /* force interactive */
	    #####:  113:	  interactive = TRUE;
	    #####:  114:	  break;
	        -:  115:
	        -:  116:	case \'l\':  /* math lib */
	    #####:  117:	  use_math = TRUE;
	    #####:  118:	  break;
	        -:  119:
	        -:  120:	case \'q\':  /* quiet mode */
	    #####:  121:	  quiet = TRUE;
	    #####:  122:	  break;
	        -:  123:
	        -:  124:	case \'s\':  /* Non standard features give errors. */
	    #####:  125:	  std_only = TRUE;
	    #####:  126:	  break;
	        -:  127:
	        -:  128:	case \'v\':  /* Print the version. */
	    #####:  129:	  show_bc_version ();
	    #####:  130:	  bc_exit (0);
	    #####:  131:	  break;
	        -:  132:
	        -:  133:	case \'w\':  /* Non standard features give warnings. */
	    #####:  134:	  warn_not_std = TRUE;
	    #####:  135:	  break;
	        -:  136:
	        -:  137:	default:
	    #####:  138:	  usage(argv[0]);
	    #####:  139:	  bc_exit (1);
	    #####:  140:	}
	        -:  141:    }
	        -:  142:
	        -:  143:#ifdef QUIET
	        -:  144:  quiet = TRUE;
	        -:  145:#endif
	        -:  146:
	        -:  147:  /* Add file names to a list of files to process. */
	        3:  148:  while (optind \< argc)
	        -:  149:    {
	        1:  150:      temp = bc_malloc(sizeof(file_node));
	        1:  151:      temp-\>name = argv[optind];
	        1:  152:      temp-\>next = NULL;
	        1:  153:      if (last == NULL)
	        1:  154:	file_names = temp;
	        -:  155:      else
	    #####:  156:	last-\>next = temp;
	        1:  157:      last = temp;
	        1:  158:      optind++;
	        -:  159:    }
	        2:  160:}
	        -:  161:
	        -:  162:/* The main program for bc. */
	        -:  163:int
	        2:  164:main (int argc, char **argv)
	        -:  165:{
	        -:  166:  char *env_value;
	        2:  167:  char *env_argv[30];
	        -:  168:  int   env_argc;
	        -:  169:  
	        -:  170:  /* Interactive? */
	        2:  171:  if (isatty(0) && isatty(1)) 
	    #####:  172:    interactive = TRUE;
	        -:  173:
	        -:  174:#ifdef HAVE_SETVBUF
	        -:  175:  /* attempt to simplify interaction with applications such as emacs */
	        2:  176:  (void) setvbuf(stdout, NULL, _IOLBF, 0);
	        -:  177:#endif
	        -:  178:
	        -:  179:  /* Environment arguments. */
	        2:  180:  env_value = getenv (\"BC_ENV_ARGS\");
	        2:  181:  if (env_value != NULL)
	        -:  182:    {
	        -:  183:      env_argc = 1;
	    #####:  184:      env_argv[0] = strdup(\"BC_ENV_ARGS\");
	    #####:  185:      while (*env_value != 0)
	        -:  186:	{
	    #####:  187:	  if (*env_value != \' \')
	        -:  188:	    {
	    #####:  189:	      env_argv[env_argc++] = env_value;
	    #####:  190:	      while (*env_value != \' \' && *env_value != 0)
	    #####:  191:		env_value++;
	    #####:  192:	      if (*env_value != 0)
	        -:  193:		{
	    #####:  194:		  *env_value = 0;
	    #####:  195:		  env_value++;
	    #####:  196:		}
	        -:  197:	    }
	        -:  198:	  else
	    #####:  199:	    env_value++;
	        -:  200:	}
	    #####:  201:      parse_args (env_argc, env_argv);
	    #####:  202:    }
	        -:  203:
	        -:  204:  /* Command line arguments. */
	        2:  205:  parse_args (argc, argv);
	        -:  206:
	        -:  207:  /* Other environment processing. */
	        2:  208:  if (getenv (\"POSIXLY_CORRECT\") != NULL)
	    #####:  209:    std_only = TRUE;
	        -:  210:
	        2:  211:  env_value = getenv (\"BC_LINE_LENGTH\");
	        2:  212:  if (env_value != NULL)
	        -:  213:    {
	    #####:  214:      line_size = atoi (env_value);
	    #####:  215:      if (line_size \< 3 && line_size != 0)
	        -:  216:	line_size = 70;
	        -:  217:    }
	        -:  218:  else
	        2:  219:    line_size = 70;
	        -:  220:
	        -:  221:  /* Initialize the machine.  */
	        2:  222:  init_storage();
	        2:  223:  init_load();
	        -:  224:
	        -:  225:  /* Set up interrupts to print a message. */
	        2:  226:  if (interactive)
	    #####:  227:    signal (SIGINT, use_quit);
	        -:  228:
	        -:  229:  /* Initialize the front end. */
	        2:  230:  init_tree();
	        2:  231:  init_gen ();
	        2:  232:  is_std_in = FALSE;
	        2:  233:  first_file = TRUE;
	        2:  234:  if (!open_new_file ())
	    #####:  235:    bc_exit (1);
	        -:  236:
	        -:  237:#if defined(LIBEDIT)
	        -:  238:  if (interactive) {
	        -:  239:    /* Enable libedit support. */
	        -:  240:    edit = el_init (\"bc\", stdin, stdout, stderr);
	        -:  241:    hist = history_init();
	        -:  242:    el_set (edit, EL_EDITOR, \"emacs\");
	        -:  243:    el_set (edit, EL_HIST, history, hist);
	        -:  244:    el_set (edit, EL_PROMPT, el_pmtfunc);
	        -:  245:    el_source (edit, NULL);
	        -:  246:    history (hist, &histev, H_SETSIZE, INT_MAX);
	        -:  247:  }
	        -:  248:#endif
	        -:  249:
	        -:  250:#if defined(READLINE)
	        -:  251:  if (interactive) {
	        -:  252:    /* Readline support.  Set both application name and input file. */
	        -:  253:    rl_readline_name = \"bc\";
	        -:  254:    rl_instream = stdin;
	        -:  255:    using_history ();
	        -:  256:  }
	        -:  257:#endif
	        -:  258:
	        -:  259:  /* Do the parse. */
	        2:  260:  yyparse ();
	        -:  261:
	        -:  262:  /* End the compile only output with a newline. */
	        2:  263:  if (compile_only)
	        1:  264:    printf (\"\\n\");
	        -:  265:
	        2:  266:  bc_exit (0);
	        2:  267:  return 0; // to keep the compiler from complaining
	        2:  268:}
	        -:  269:
	        -:  270:
	        -:  271:/* This is the function that opens all the files. 
	        -:  272:   It returns TRUE if the file was opened, otherwise
	        -:  273:   it returns FALSE. */
	        -:  274:
	        -:  275:int
	        5:  276:open_new_file (void)
	        -:  277:{
	        -:  278:  FILE *new_file;
	        -:  279:  file_node *temp;
	        -:  280:
	        -:  281:  /* Set the line number. */
	        5:  282:  line_no = 1;
	        -:  283:
	        -:  284:  /* Check to see if we are done. */
	        5:  285:  if (is_std_in) return (FALSE);
	        -:  286:
	        -:  287:  /* Open the other files. */
	        3:  288:  if (use_math && first_file)
	        -:  289:    {
	        -:  290:      /* Load the code from a precompiled version of the math libarary. */
	        -:  291:      CONST char **mstr;
	        -:  292:
	        -:  293:      /* These MUST be in the order of first mention of each function.
	        -:  294:	 That is why \"a\" comes before \"c\" even though \"a\" is defined after
	        -:  295:	 after \"c\".  \"a\" is used in \"s\"! */
	    #####:  296:      (void) lookup (strdup(\"e\"), FUNCT);
	    #####:  297:      (void) lookup (strdup(\"l\"), FUNCT);
	    #####:  298:      (void) lookup (strdup(\"s\"), FUNCT);
	    #####:  299:      (void) lookup (strdup(\"a\"), FUNCT);
	    #####:  300:      (void) lookup (strdup(\"c\"), FUNCT);
	    #####:  301:      (void) lookup (strdup(\"j\"), FUNCT);
	        -:  302:      mstr = libmath;
	    #####:  303:      while (*mstr) {
	    #####:  304:           load_code (*mstr);
	    #####:  305:	   mstr++;
	        -:  306:      }
	    #####:  307:    }
	        -:  308:  
	        -:  309:  /* One of the argv values. */
	        3:  310:  if (file_names != NULL)
	        -:  311:    {
	        1:  312:      new_file = fopen (file_names-\>name, \"r\");
	        1:  313:      if (new_file != NULL)
	        -:  314:	{
	        1:  315:	  new_yy_file (new_file);
	        1:  316:	  temp = file_names;
	        1:  317:	  file_name  = temp-\>name;
	        1:  318:	  file_names = temp-\>next;
	        1:  319:	  free (temp);
	        1:  320:	  return TRUE;
	        -:  321:	}
	    #####:  322:      fprintf (stderr, \"File %s is unavailable.\\n\", file_names-\>name);
	    #####:  323:      bc_exit (1);
	    #####:  324:    }
	        -:  325:  
	        -:  326:  /* If we fall through to here, we should return stdin. */
	        2:  327:  new_yy_file (stdin);
	        2:  328:  is_std_in = TRUE;
	        2:  329:  return TRUE;
	        5:  330:}
	        -:  331:
	        -:  332:
	        -:  333:/* Set yyin to the new file. */
	        -:  334:
	        -:  335:void
	        3:  336:new_yy_file (FILE *file)
	        -:  337:{
	        3:  338:  if (!first_file) fclose (yyin);
	        3:  339:  yyin = file;
	        3:  340:  first_file = FALSE;
	        3:  341:}
	        -:  342:
	        -:  343:
	        -:  344:/* Message to use quit.  */
	        -:  345:
	        -:  346:void
	    #####:  347:use_quit (int sig)
	        -:  348:{
	        -:  349:#ifdef DONTEXIT
	        -:  350:  int save = errno;
	        -:  351:  write (1, \"\\n(interrupt) use quit to exit.\\n\", 31);
	        -:  352:  signal (SIGINT, use_quit);
	        -:  353:  errno = save;
	        -:  354:#else
	    #####:  355:  write (1, \"\\n(interrupt) Exiting bc.\\n\", 26);
	    #####:  356:  bc_exit(0);
	        -:  357:#endif
	    #####:  358:}";
	    
	    str filePath = "main.c";
	    writeFile(toLocation(filePath+".gcov"), fileContents);
	    println(readGcovFile(filePath));
	    
	    return true;

}