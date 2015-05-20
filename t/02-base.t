use v6;

use Test;

plan 1;

use Readline;

my $r = Readline.new;

##############################################################################
#
# /* A static variable for holding the line. */
# static char *line_read = (char *)NULL;
# 
# /* Read a string, and return a pointer to it.
#    Returns NULL on EOF. */
# char *
# rl_gets ()
# {
#   /* If the buffer has already been allocated,
#      return the memory to the free pool. */
#   if (line_read)
#     {
#       free (line_read);
#       line_read = (char *)NULL;
#     }
# 
#   /* Get a line from the user. */
#   line_read = readline ("");
# 
#   /* If the line has any text in it,
#      save it on the history. */
#   if (line_read && *line_read)
#     add_history (line_read);
# 
#   return (line_read);
# }
# 
##############################################################################

##############################################################################
#
# /* Invert the case of the COUNT following characters. */
# int
# invert_case_line (count, key)
#      int count, key;
# {
#   register int start, end, i;
# 
#   start = rl_point;
# 
#   if (rl_point >= rl_end)
#     return (0);
# 
#   if (count < 0)
#     {
#       direction = -1;
#       count = -count;
#     }
#   else
#     direction = 1;
#       
#   /* Find the end of the range to modify. */
#   end = start + (count * direction);
# 
#   /* Force it to be within range. */
#   if (end > rl_end)
#     end = rl_end;
#   else if (end < 0)
#     end = 0;
# 
#   if (start == end)
#     return (0);
# 
#   if (start > end)
#     {
#       int temp = start;
#       start = end;
#       end = temp;
#     }
# 
#   /* Tell readline that we are modifying the line,
#      so it will save the undo information. */
#   rl_modifying (start, end);
# 
#   for (i = start; i != end; i++)
#     {
#       if (_rl_uppercase_p (rl_line_buffer[i]))
#         rl_line_buffer[i] = _rl_to_lower (rl_line_buffer[i]);
#       else if (_rl_lowercase_p (rl_line_buffer[i]))
#         rl_line_buffer[i] = _rl_to_upper (rl_line_buffer[i]);
#     }
#   /* Move point to on top of the last character changed. */
#   rl_point = (direction == 1) ? end - 1 : start;
#   return (0);
# }
# 
#############################################################################

#############################################################################
# 
# static void cb_linehandler (char *);
# 
# int running;
# const char *prompt = "rltest$ ";
# 
# /* Callback function called for each line when accept-line executed, EOF
#    seen, or EOF character read.  This sets a flag and returns; it could
#    also call exit(3). */
# static void
# cb_linehandler (char *line)
# {
#   /* Can use ^D (stty eof) or `exit' to exit. */
#   if (line == NULL || strcmp (line, "exit") == 0)
#     {
#       if (line == 0)
#         printf ("\n");
#       printf ("exit\n");
#       /* This function needs to be called to reset the terminal settings,
#          and calling it from the line handler keeps one extra prompt from
#          being displayed. */
#       rl_callback_handler_remove ();
# 
#       running = 0;
#     }
#   else
#     {
#       if (*line)
#         add_history (line);
#       printf ("input line: %s\n", line);
#       free (line);
#     }
# }
# 
# int
# main (int c, char **v)
# {
#   fd_set fds;
#   int r;
# 
#   /* Install the line handler. */
#   rl_callback_handler_install (prompt, cb_linehandler);
# 
#   /* Enter a simple event loop.  This waits until something is available
#      to read on readline's input stream (defaults to standard input) and
#      calls the builtin character read callback to read it.  It does not
#      have to modify the user's terminal settings. */
#   running = 1;
#   while (running)
#     {
#       FD_ZERO (&fds);
#       FD_SET (fileno (rl_instream), &fds);    
# 
#       r = select (FD_SETSIZE, &fds, NULL, NULL, NULL);
#       if (r < 0)
#         {
#           perror ("rltest: select");
#           rl_callback_handler_remove ();
#           break;
#         }
# 
#       if (FD_ISSET (fileno (rl_instream), &fds))
#         rl_callback_read_char ();
#     }
# 
#   printf ("rltest: Event loop has exited\n");
#   return 0;
# }
# 
#############################################################################

#/* fileman.c -- A tiny application which demonstrates how to use the
#   GNU Readline library.  This application interactively allows users
#   to manipulate files and their modes. */
#
##ifdef HAVE_CONFIG_H
##  include <config.h>
##endif
#
##include <sys/types.h>
##ifdef HAVE_SYS_FILE_H
##  include <sys/file.h>
##endif
##include <sys/stat.h>
#
##ifdef HAVE_UNISTD_H
##  include <unistd.h>
##endif
#
##include <fcntl.h>
##include <stdio.h>
##include <errno.h>
#
##if defined (HAVE_STRING_H)
##  include <string.h>
##else /* !HAVE_STRING_H */
##  include <strings.h>
##endif /* !HAVE_STRING_H */
#
##ifdef HAVE_STDLIB_H
##  include <stdlib.h>
##endif
#
##include <time.h>
#
##include <readline/readline.h>
##include <readline/history.h>
#
#extern char *xmalloc PARAMS((size_t));
#
#/* The names of functions that actually do the manipulation. */
#int com_list PARAMS((char *));
#int com_view PARAMS((char *));
#int com_rename PARAMS((char *));
#int com_stat PARAMS((char *));
#int com_pwd PARAMS((char *));
#int com_delete PARAMS((char *));
#int com_help PARAMS((char *));
#int com_cd PARAMS((char *));
#int com_quit PARAMS((char *));
#
#/* A structure which contains information on the commands this program
#   can understand. */
#
#typedef struct {
#  char *name;			/* User printable name of the function. */
#  rl_icpfunc_t *func;		/* Function to call to do the job. */
#  char *doc;			/* Documentation for this function.  */
#} COMMAND;
#
#COMMAND commands[] = {
#  { "cd", com_cd, "Change to directory DIR" },
#  { "delete", com_delete, "Delete FILE" },
#  { "help", com_help, "Display this text" },
#  { "?", com_help, "Synonym for `help'" },
#  { "list", com_list, "List files in DIR" },
#  { "ls", com_list, "Synonym for `list'" },
#  { "pwd", com_pwd, "Print the current working directory" },
#  { "quit", com_quit, "Quit using Fileman" },
#  { "rename", com_rename, "Rename FILE to NEWNAME" },
#  { "stat", com_stat, "Print out statistics on FILE" },
#  { "view", com_view, "View the contents of FILE" },
#  { (char *)NULL, (rl_icpfunc_t *)NULL, (char *)NULL }
#};
#
#/* Forward declarations. */
#char *stripwhite ();
#COMMAND *find_command ();
#
#/* The name of this program, as taken from argv[0]. */
#char *progname;
#
#/* When non-zero, this global means the user is done using this program. */
#int done;
#
#char *
#dupstr (s)
#     char *s;
#{
#  char *r;
#
#  r = xmalloc (strlen (s) + 1);
#  strcpy (r, s);
#  return (r);
#}
#
#main (argc, argv)
#     int argc;
#     char **argv;
#{
#  char *line, *s;
#
#  progname = argv[0];
#
#  initialize_readline ();	/* Bind our completer. */
#
#  /* Loop reading and executing lines until the user quits. */
#  for ( ; done == 0; )
#    {
#      line = readline ("FileMan: ");
#
#      if (!line)
#        break;
#
#      /* Remove leading and trailing whitespace from the line.
#         Then, if there is anything left, add it to the history list
#         and execute it. */
#      s = stripwhite (line);
#
#      if (*s)
#        {
#          add_history (s);
#          execute_line (s);
#        }
#
#      free (line);
#    }
#  exit (0);
#}
#
#/* Execute a command line. */
#int
#execute_line (line)
#     char *line;
#{
#  register int i;
#  COMMAND *command;
#  char *word;
#
#  /* Isolate the command word. */
#  i = 0;
#  while (line[i] && whitespace (line[i]))
#    i++;
#  word = line + i;
#
#  while (line[i] && !whitespace (line[i]))
#    i++;
#
#  if (line[i])
#    line[i++] = '\0';
#
#  command = find_command (word);
#
#  if (!command)
#    {
#      fprintf (stderr, "%s: No such command for FileMan.\n", word);
#      return (-1);
#    }
#
#  /* Get argument to command, if any. */
#  while (whitespace (line[i]))
#    i++;
#
#  word = line + i;
#
#  /* Call the function. */
#  return ((*(command->func)) (word));
#}
#
#/* Look up NAME as the name of a command, and return a pointer to that
#   command.  Return a NULL pointer if NAME isn't a command name. */
#COMMAND *
#find_command (name)
#     char *name;
#{
#  register int i;
#
#  for (i = 0; commands[i].name; i++)
#    if (strcmp (name, commands[i].name) == 0)
#      return (&commands[i]);
#
#  return ((COMMAND *)NULL);
#}
#
#/* Strip whitespace from the start and end of STRING.  Return a pointer
#   into STRING. */
#char *
#stripwhite (string)
#     char *string;
#{
#  register char *s, *t;
#
#  for (s = string; whitespace (*s); s++)
#    ;
#    
#  if (*s == 0)
#    return (s);
#
#  t = s + strlen (s) - 1;
#  while (t > s && whitespace (*t))
#    t--;
#  *++t = '\0';
#
#  return s;
#}
#
#/* **************************************************************** */
#/*                                                                  */
#/*                  Interface to Readline Completion                */
#/*                                                                  */
#/* **************************************************************** */
#
#char *command_generator PARAMS((const char *, int));
#char **fileman_completion PARAMS((const char *, int, int));
#
#/* Tell the GNU Readline library how to complete.  We want to try to complete
#   on command names if this is the first word in the line, or on filenames
#   if not. */
#initialize_readline ()
#{
#  /* Allow conditional parsing of the ~/.inputrc file. */
#  rl_readline_name = "FileMan";
#
#  /* Tell the completer that we want a crack first. */
#  rl_attempted_completion_function = fileman_completion;
#}
#
#/* Attempt to complete on the contents of TEXT.  START and END bound the
#   region of rl_line_buffer that contains the word to complete.  TEXT is
#   the word to complete.  We can use the entire contents of rl_line_buffer
#   in case we want to do some simple parsing.  Return the array of matches,
#   or NULL if there aren't any. */
#char **
#fileman_completion (text, start, end)
#     const char *text;
#     int start, end;
#{
#  char **matches;
#
#  matches = (char **)NULL;
#
#  /* If this word is at the start of the line, then it is a command
#     to complete.  Otherwise it is the name of a file in the current
#     directory. */
#  if (start == 0)
#    matches = rl_completion_matches (text, command_generator);
#
#  return (matches);
#}
#
#/* Generator function for command completion.  STATE lets us know whether
#   to start from scratch; without any state (i.e. STATE == 0), then we
#   start at the top of the list. */
#char *
#command_generator (text, state)
#     const char *text;
#     int state;
#{
#  static int list_index, len;
#  char *name;
#
#  /* If this is a new word to complete, initialize now.  This includes
#     saving the length of TEXT for efficiency, and initializing the index
#     variable to 0. */
#  if (!state)
#    {
#      list_index = 0;
#      len = strlen (text);
#    }
#
#  /* Return the next name which partially matches from the command list. */
#  while (name = commands[list_index].name)
#    {
#      list_index++;
#
#      if (strncmp (name, text, len) == 0)
#        return (dupstr(name));
#    }
#
#  /* If no names matched, then return NULL. */
#  return ((char *)NULL);
#}
#
#/* **************************************************************** */
#/*                                                                  */
#/*                       FileMan Commands                           */
#/*                                                                  */
#/* **************************************************************** */
#
#/* String to pass to system ().  This is for the LIST, VIEW and RENAME
#   commands. */
#static char syscom[1024];
#
#/* List the file(s) named in arg. */
#com_list (arg)
#     char *arg;
#{
#  if (!arg)
#    arg = "";
#
#  sprintf (syscom, "ls -FClg %s", arg);
#  return (system (syscom));
#}
#
#com_view (arg)
#     char *arg;
#{
#  if (!valid_argument ("view", arg))
#    return 1;
#
##if defined (__MSDOS__)
#  /* more.com doesn't grok slashes in pathnames */
#  sprintf (syscom, "less %s", arg);
##else
#  sprintf (syscom, "more %s", arg);
##endif
#  return (system (syscom));
#}
#
#com_rename (arg)
#     char *arg;
#{
#  too_dangerous ("rename");
#  return (1);
#}
#
#com_stat (arg)
#     char *arg;
#{
#  struct stat finfo;
#
#  if (!valid_argument ("stat", arg))
#    return (1);
#
#  if (stat (arg, &finfo) == -1)
#    {
#      perror (arg);
#      return (1);
#    }
#
#  printf ("Statistics for `%s':\n", arg);
#
#  printf ("%s has %d link%s, and is %d byte%s in length.\n",
#	  arg,
#          finfo.st_nlink,
#          (finfo.st_nlink == 1) ? "" : "s",
#          finfo.st_size,
#          (finfo.st_size == 1) ? "" : "s");
#  printf ("Inode Last Change at: %s", ctime (&finfo.st_ctime));
#  printf ("      Last access at: %s", ctime (&finfo.st_atime));
#  printf ("    Last modified at: %s", ctime (&finfo.st_mtime));
#  return (0);
#}
#
#com_delete (arg)
#     char *arg;
#{
#  too_dangerous ("delete");
#  return (1);
#}
#
#/* Print out help for ARG, or for all of the commands if ARG is
#   not present. */
#com_help (arg)
#     char *arg;
#{
#  register int i;
#  int printed = 0;
#
#  for (i = 0; commands[i].name; i++)
#    {
#      if (!*arg || (strcmp (arg, commands[i].name) == 0))
#        {
#          printf ("%s\t\t%s.\n", commands[i].name, commands[i].doc);
#          printed++;
#        }
#    }
#
#  if (!printed)
#    {
#      printf ("No commands match `%s'.  Possibilties are:\n", arg);
#
#      for (i = 0; commands[i].name; i++)
#        {
#          /* Print in six columns. */
#          if (printed == 6)
#            {
#              printed = 0;
#              printf ("\n");
#            }
#
#          printf ("%s\t", commands[i].name);
#          printed++;
#        }
#
#      if (printed)
#        printf ("\n");
#    }
#  return (0);
#}
#
#/* Change to the directory ARG. */
#com_cd (arg)
#     char *arg;
#{
#  if (chdir (arg) == -1)
#    {
#      perror (arg);
#      return 1;
#    }
#
#  com_pwd ("");
#  return (0);
#}
#
#/* Print out the current working directory. */
#com_pwd (ignore)
#     char *ignore;
#{
#  char dir[1024], *s;
#
#  s = getcwd (dir, sizeof(dir) - 1);
#  if (s == 0)
#    {
#      printf ("Error getting pwd: %s\n", dir);
#      return 1;
#    }
#
#  printf ("Current directory is %s\n", dir);
#  return 0;
#}
#
#/* The user wishes to quit using this program.  Just set DONE non-zero. */
#com_quit (arg)
#     char *arg;
#{
#  done = 1;
#  return (0);
#}
#
#/* Function which tells you that you can't do this. */
#too_dangerous (caller)
#     char *caller;
#{
#  fprintf (stderr,
#           "%s: Too dangerous for me to distribute.  Write it yourself.\n",
#           caller);
#}
#
#/* Return non-zero if ARG is a valid argument for CALLER, else print
#   an error message and return zero. */
#int
#valid_argument (caller, arg)
#     char *caller, *arg;
#{
#  if (!arg || !*arg)
#    {
#      fprintf (stderr, "%s: Argument required.\n", caller);
#      return (0);
#    }
#
#  return (1);
#}
#
#############################################################################

#
# readline() blocks, so we can't feed STDIN.
#
#lives_ok { readline( 'foo' ) }, 'readline call';

#=item readline( Str $prompt ) returns Str
#
#=item rl-initialize( ) returns Int
#
#    Initialize or re-initialize Readline's internal state. It's not strictly necessary to call this; readline() calls it before reading any input.
#
#=item rl-ding( ) returns Int
#
#    Ring the terminal bell, obeying the setting of bell-style.
#
#=begin History
#
#These methods let you add, delete and manipulate history entries. See the L<examples/echo.pl6> script for usage.
#
#=item add-history( Str $history )
#
#    Place string C<$history> at the end of the history list. The associated data field (if any) is set to NULL.
#
#=item using-history( )
#
#    Begin a session in which the history functions might be used. This initializes the interactive variables.
#
#    Author's note - C<add-history()> works fine without this call, maybe it's for methods that require state.
#
#=item history-get-history-state( ) returns HISTORY_STATE
#
#    Return a structure describing the current state of the input history.
#
#=item history-set-history-state( HISTORY_STATE $state )
#
#    Set the state of the history list according to C<$state>.
#
#=item add-history-time( Str $timestamp )
#
#    Change the time stamp associated with the most recent history entry to C<$timestamp>.
#
#=item remove-history( Int $which ) returns HIST_ENTRY
#
#    Remove history entry at offset C<$which> from the history. The removed element is returned so you can free the line, data, and containing structure.
#
#=item free-history-entry( HIST_ENTRY $entry ) returns histdata_t
#
#    Free the history entry C<$entry> and any history library private data associated with it. Returns the application-specific data so the caller can dispose of it.
#
#=item replace-history-entry( Int $which, Str $line, histdata_t $data ) returns HIST_ENTRY
#
#    Make the history entry at offset C<$which> have C<$line> and C<$data>. This returns the old entry so the caller can dispose of any application-specific data. In the case of an invalid C<$which>, a NULL pointer is returned.
#
#=item clear-history( )
#
#    Clear the history list by deleting all the entries.
#
#=item stifle-history( Int $max )
#
#    Stifle the history list, remembering only the last C<$max> entries.
#
#=item unstifle-history( )
#
#    Stop stifling the history. This returns the previously-set maximum number of history entries (as set by stifle_history()). The value is positive if the history was stifled, negative if it wasn't.
#
#=item history-is-stifled( ) returns Bool
#
#    Returns True if the history is stifled, False if not. The C version returns non-zero if the history is stifled, this gets converted to a Perl6 boolean.
#   
#=item history-list( ) returns CArray[HIST_ENTRY]
#
#    Return a NULL terminated array of HIST_ENTRY * which is the current input history. Element 0 of this list is the beginning of time. If there is no history, return NULL.
#
#=item where-history( ) returns Int
#
#    Returns the offset of the current history element.
#
#=item current-history( Int $which ) returns HIST_ENTRY
#
#    Return the history entry at the position C<$which>, as determined by C<where-history()>. If there is no entry there, return a NULL pointer.
#
#=item history-get( Int $which ) returns HIST_ENTRY
#
#    Return the history entry at position C<$which>, starting from C<$history_base> (see section 2.4 History Variables). If there is no entry there, or if offset is greater than the history length, return a NULL pointer.
#
#=item history-get-time( HIST_ENTRY $entry ) returns time_t
#
#    Return the time stamp associated with the history entry C<$entry>.
#
#=item history-total-bytes( ) returns Int
#
#    Return the number of bytes that the primary history entries are using. This function returns the sum of the lengths of all the lines in the history.
#
#=item history-set-pos( Int $pos ) returns Int
#
#    Set the current history offset to C<$pos>, an absolute index into the list. Returns 1 on success, 0 if C<$pos> is less than zero or greater than the number of history entries.
#
#=item previous-history( ) returns HIST_ENTRY
#
#    Back up the current history offset to the previous history entry, and return a pointer to that entry. If there is no previous entry, return a NULL pointer.
#
#=item next-history( ) returns HIST_ENTRY
#
#    Move the current history offset forward to the next history entry, and return the a pointer to that entry. If there is no next entry, return a NULL pointer.
#
#=item history-search( Str $text, Int $pos ) returns Int
#
#    Search the history for C<$text>, starting at history offset C<$pos>. If direction is less than 0, then the search is through previous entries, otherwise through subsequent entries. If string is found, then the current history index is set to that history entry, and the value returned is the offset in the line of the entry where string was found. Otherwise, nothing is changed, and a -1 is returned.
#
#=item history-search-prefix( Str $prefix, Int $pos ) returns Int
#
#    Search the history for a line prefixed with C<$prefix>, starting at history offset C<$pos>. The search is anchored: matching lines must begin with C<$prefix>. If direction is less than 0, then the search is through previous entries, otherwise through subsequent entries. If string is found, then the current history index is set to that entry, and the return value is 0. Otherwise, nothing is changed, and a -1 is returned.
#
#=item history-search-pos( Str $text, Int $pos, Int $dir ) returns Int
#
#    Search for C<$text> in the history list, starting at C<$pos>, an absolute index into the list. If C<$direction> is negative, the search proceeds backward from C<$pos>, otherwise forward. Returns the absolute index of the history element where C<$text> was found, or -1 otherwise.
#
#=item read-history( Str $filename ) returns Int
#
#    Add the contents of C<$filename> to the history list, a line at a time. If C<$filename> is Empty, then read from `~/.history'. Returns 0 if successful, or errno if not.
#
#=item read-history-range( Str $filename, Int $from, Int $to ) returns Int
#
#    Read a range of lines from C<$filename>, adding them to the history list. Start reading at line C<$from> and end at C<$to>. If C<$from> is zero, start at the beginning. If C<$to> is less than C<$from>, then read until the end of the file. If filename is Empty, then read from `~/.history'. Returns 0 if successful, or errno if not.
#
#=item write-history( Str $filename ) returns Int
#
#    Write the current history to C<$filename>, overwriting C<$filename> if necessary. If C<$filename> is NULL, then write the history list to `~/.history'. Returns 0 on success, or errno on a read or write error.
#
#=item append-history( Int $offset, Str $filename ) returns Int
#
#    Append the elements starting at C<$offset> of the history list to C<$filename>. If C<$filename> is Empty, then append to `~/.history'. Returns 0 on success, or errno on a read or write error.
#
#=item history-truncate-file( Str $filename, Int $nLines ) returns Int
#
#    Truncate the history file C<$filename>, leaving only the last C<$nLines> lines. If C<$filename> is Empty, then `~/.history' is truncated. Returns 0 on success, or errno on failure.
#
#=item history-expand( Str $string, Pointer[Str] $output ) returns Int
#
#    Expand C<$string>, placing the result into C<$output>, a pointer to a string (see section 1.1 History Expansion). Returns:
#
#    0  If no expansions took place (or, if the only change in the text was the removal of escape characters preceding the history expansion character);
#    1  if expansions did take place;
#    -1 if there was an error in expansion;
#    2  if the returned line should be displayed, but not executed, as with the :p modifier (see section 1.1.3 Modifiers).
#
#    If an error occurred in expansion, then output contains a descriptive error message.
#
#=item history-arg-extract( Int $first, Int $last, Str $string ) returns Str
#
#    Extract a string segment consisting of the C<$first> through C<$last> arguments present in C<$string>. Arguments are split using C<history_tokenize()>.
#
#=item get-history-event( Str $string, Pointer[Int] $cIndex, Str $delimiting-quote ) returns Str
#
#    Returns the text of the history event beginning C<$$cIndex> characters into C<$string>.  C<$$cIndex> is modified to point to after the event specifier. At function entry, C<$cIndex> points to the index into string where the history event specification begins. qchar is a character that is allowed to end the event specification in addition to the "normal" terminating characters.
#
#    Editor's note: C<$$cIndex> may be a byte offset into C<$string> rather than a character offset, so Unicode users beware.
#
#    Editor's note - C<$delimiting-quote> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_get_history_event()> instead.
#
#    DELIMITING_QUOTE is a character that is allowed to end the string specification for what to search for in addition to the normal characters `:', ` ', `\t', `\n', and sometimes `?'.
#
#=item history-tokenize( Str $string ) returns CArray[Str]
#
#    Return an array of tokens parsed out of C<$string>, much as the shell might. The tokens are split on the characters in the C<$history_word_delimiters> variable, and shell quoting conventions are obeyed.
#
#=end History
#
#=begin Keymap
#
#These methods let you manipulate the built-in key mappings.
#
#=item rl-make-bare-keymap( ) returns Keymap
#
#    Returns a new, empty keymap. The space for the keymap is allocated with malloc(); the caller should free it by calling rl_free_keymap() when done.
#
#=item rl-copy-keymap( Keymap $map ) returns Keymap
#
#    Return a new keymap which is a copy of C<$map>.
#
#=item rl-make-keymap( ) returns Keymap
#
#    Return a new keymap with the printing characters bound to C<$rl_insert>, the lowercase Meta characters bound to run their equivalents, and the Meta digits bound to produce numeric arguments.
#
#=item rl-discard-keymap( Keymap $map )
#
#    Free the storage associated with the data in C<$map>. The caller should free the pointer to C<$map>.
#
#=item rl-free-keymap( Keymap $map )
#
#    Free all storage associated with C<$map>. This calls C<rl_discard_keymap()> to free subordindate keymaps and macros.
#
#=item rl-get-keymap-by-name( Str $name ) returns Keymap
#
#    Return the keymap matching C<$name>. C<$name> is one which would be supplied in a set keymap inputrc line (see section 1.3 Readline Init File).
#
#=item rl-get-keymap( ) returns Keymap
#
#    Returns the currently active keymap.
#
#=item rl-get-keymap-name( Keymap $map ) returns Str
#
#    Return the name matching C<$map>. name is one which would be supplied in a set keymap inputrc line (see section 1.3 Readline Init File).
#
#=item rl-set-keymap( Keymap $map )
#
#    Makes C<$map> the currently active keymap.
#
#=end Keymap
#
#=begin Callback
#
#These functions let you use L<Readline> as an interactive event loop.
#
#=item rl-callback-handler-install( Str $prompt, &callback (Str) )
#
#    Set up the terminal for readline I/O and display the initial expanded value of C<$prompt>. Save the value of lhandler to use as a handler function to call when a complete line of input has been entered. The handler function receives the text of the line as an argument.
#
#=item rl-callback-read-char( )
#
#    Whenever an application determines that keyboard input is available, it should call rl_callback_read_char(), which will read the next character from the current input source. If that character completes the line, rl_callback_read_char will invoke the lhandler function installed by rl_callback_handler_install to process the line. Before calling the lhandler function, the terminal settings are reset to the values they had before calling rl_callback_handler_install. If the lhandler function returns, and the line handler remains installed, the terminal settings are modified for Readline's use again. EOF is indicated by calling lhandler with a NULL line.
#
#=item rl-callback-handler-remove( )
#
#    Restore the terminal to its initial state and remove the line handler. This may be called from within a callback as well as independently. If the handler installed by rl_callback_handler_install does not exit the program, either this function or the function referred to by the value of rl_deprep_term_function should be called before the program exits to reset the terminal settings.
#
#=end Callback
#
#=begin Prompt
#
#These methods manage the readline prompt.
#
#=item rl-set-prompt( Str $prompt ) returns Int
#
#    Make Readline use C<$prompt> for subsequent redisplay. This calls C<rl_expand_prompt()> to expand the prompt and sets C<$rl_prompt> to the result.
#
#=item rl-expand-prompt( Str $prompt ) returns Int
#
#    Expand any special character sequences in C<$prompt> and set up the local Readline prompt redisplay variables. This function is called by C<readline()>. It may also be called to expand the primary prompt if the C<rl_on_new_line_with_prompt()> function or C<$rl-already_prompted> variable is used. It returns the number of visible characters on the last line of the (possibly multi-line) prompt. Applications may indicate that the prompt contains characters that take up no physical screen space when displayed by bracketing a sequence of such characters with the special markers C<RL_PROMPT_START_IGNORE> and C<RL_PROMPT_END_IGNORE> (declared in `readline.h' and exposed in the Readline module as constants.) This may be used to embed terminal-specific escape sequences in prompts.
#
#=end Prompt
#
#=begin Binding
#
#=item rl-bind-key( Str $key, &callback (Int, Int --> Int) ) returns Int
#
#    rl_bind_key() takes two arguments: C<$key> is the character that you want to bind, and the callback function is called when key is pressed. Binding TAB to C<rl_insert()> makes TAB insert itself. C<rl_bind_key()> returns non-zero if key is not a valid ASCII character code (between 0 and 255).
#
#    Editor's note - C<$key> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_bind_key()> instead.
#
#=item rl-bind-key-in-map( Str $key, &callback (Int, Int --> Int), Keymap $map ) returns Int
#
#    Bind C<$key> to function in C<$map>. Returns non-zero in the case of an invalid key.
#
#    Editor's note - C<$delimiting-quote> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_bind_key_in_map()> instead.
#
#=item rl-unbind-key( Int $key ) returns Bool
#
#    Bind C<$key> to the null function in the currently active keymap. Returns C<False> in case of error.
#
#    Editor's note - C<$key> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_unbind_key()> instead.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_unbind_key()> function rather than the Perl6 layer.
#
#=item rl-unbind-key-in-map( Str $key, Keymap $map ) returns Bool
#
#    Bind C<$key> to the null function in C<$map>. Returns False in case of error.
#
#    Editor's note - C<$key> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_unbind_key_in_map()> instead.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_unbind_key_in_map()> function rather than the Perl6 layer.
#
#=item rl-bind-key-if-unbound( Str $key, &callback (Int, Int --> Int) ) returns Bool
#
#    Binds C<$key> to function if it is not already bound in the currently active keymap. Returns False in the case of an invalid key or if key is already bound.
#
#    Editor's note - C<$key> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_bind_key_if_unbound()> instead.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_bind_key_if_unbound()> function rather than the Perl6 layer.
#
#=item rl-bind-key-if-unbound-in-map( Str $key, &callback (Int, Int --> Int), Keymap $map ) returns Bool
#
#    Binds C<$key> to function if it is not already bound in C<$map>. Returns False in the case of an invalid key or if C<$key> is already bound.
#
#    Editor's note - C<$key> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_bind_key_if_unbound_in_map()> instead.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_bind_keyseq()> function rather than the Perl6 layer.
#
#=item rl-unbind-function-in-map ( &callback (Int, Int --> Int), Keymap $map ) returns Int
#
#    Unbind all keys that execute function in C<$map>.
#
#=item rl-bind-keyseq( Str $keyseq, &callback (Int, Int --> Int) ) returns Bool
#
#    Bind the key sequence represented by the string C<$keyseq> to the function function, beginning in the current keymap. This makes new keymaps as necessary. Returns False if C<$keyseq> is invalid.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_bind_keyseq()> function rather than the Perl6 layer.
#
#=item rl-bind-keyseq-in-map( Str $keyseq, &callback (Int, Int --> Int), Keymap $k ) returns Bool
#
#    Bind the key sequence represented by the string C<$keyseq> to the callback function. This makes new keymaps as necessary. Initial bindings are performed in map. The return value is False if C<$keyseq> is invalid.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_bind_keyseq_in_map()> function rather than the Perl6 layer.
#
#=item rl-bind-keyseq-if-unbound( Str $keyseq, &callback (Int, Int --> Int) ) returns Bool
#
#    Binds keyseq to function if it is not already bound in the currently active keymap. Returns False in the case of an invalid keyseq or if C<$keyseq> is already bound.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_bind_keyseq_if_unbound()> function rather than the Perl6 layer.
#
#=item rl-bind-keyseq-if-unbound-in-map( Str $str, &callback (Int, Int --> Int), Keymap $k ) returns Bool
#
#    Binds keyseq to function if it is not already bound in map. Returns non-zero in the case of an invalid keyseq or if keyseq is already bound.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_bind_keyseq_if_unbound_in_map()> function rather than the Perl6 layer.
#
#=item rl-generic-bind( Int $i, Str $keyseq, Str $t, Keymap $map ) returns Int
#
#    Bind the key sequence represented by the string C<$keyseq> to the arbitrary pointer data. type says what kind of data is pointed to by data; this can be a function (ISFUNC), a macro (ISMACR), or a keymap (ISKMAP). This makes new keymaps as necessary. The initial keymap in which to do bindings is map.
#
#=end Binding
#
#=item rl-add-defun( Str $str, &callback (Int, Int --> Int), Str $key ) returns Int
#
#    Add name to the list of named functions. Make function be the function that gets called. If C<$key> is not -1, then bind it to function using rl_bind_key().
#
#    Editor's note - C<$key> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_add_defun()> instead.
#
#    Using this function alone is sufficient for most applications. It is the recommended way to add a few functions to the default functions that Readline has built in. If you need to do something other than adding a function to Readline, you may need to use the underlying functions described below.
#
#=item rl-variable-value( Str $variable ) returns Str
#
#    Return a string representing the value of the Readline variable C<$variable>. For boolean variables, this string is either `on' or `off'.
#
#=item rl-variable-bind( Str $variable, Str $value ) returns Int
#
#    Make the Readline variable C<$variable> have value C<$alue>. This behaves as if the readline command `set variable value' had been executed in an inputrc file (see section 1.3.1 Readline Init File Syntax).
#
#=item rl-set-key( Str $str, &callback (Int, Int --> Int), Keymap $map )
#
#    Equivalent to C<rl-bind-keyseq-in-map()>.
#
#=item rl-macro-bind( Str $keyseq, Str $macro, Keymap $map ) returns Int
#
#    Bind the key sequence C<$keyseq> to invoke the macro C<$macro>. The binding is performed in C<$map>. When C<$keyseq> is invoked, the macro will be inserted into the line. This function is deprecated; use C<rl_generic_bind()> instead.
#
#=item rl-named-function( Str $s ) returns &callback (Int, Int --> Int)
#
#    Return the function with name name.
#
#=item rl-function-of-keyseq( Str $keyseq, Keymap $map, Pointer[Int] $type ) returns &callback (Int, Int --> Int)
#
#    Return the function invoked by C<$keyseq> in keymap C<$map>. If C<$map> is Nil, the current keymap is used. If C<$type> is not Nil, the type of the object is returned in the int variable it points to (one of ISFUNC, ISKMAP, or ISMACR).
#
#=item rl-list-funmap-names( )
#
#    Print the names of all bindable Readline functions to rl_outstream.
#
#=item rl-invoking-keyseqs-in-map( Pointer[&callback (Int, Int --> Int)] $p-cmd, Keymap $map ) returns CArray[Str]
#
#    Return an array of strings representing the key sequences used to invoke function in the keymap C<$map>.
#
#=item rl-invoking-keyseqs( Pointer[&callback (Int, Int --> Int)] $p-cmd ) returns CArray[Str]
#
#    Return an array of strings representing the key sequences used to invoke function in the current keymap.
#
#=item rl-function-dumper( Bool $readable )
#
#    Print the readline function names and the key sequences currently bound to them to C<$rl_outstream>. If C<$readable> is True, the list is formatted in such a way that it can be made part of an inputrc file and re-read.
#
#    Editor's note - The Perl6 layer translates True values of C<$readable> to non-zero, so if you want to specify a particular Int value, please use the underlying C<rl_function_dumper()> call.
#
#=item rl-macro-dumper( Bool $readable )
#
#    Print the key sequences bound to macros and their values, using the current keymap, to C<$rl_outstream>. If C<$readable> is True, the list is formatted in such a way that it can be made part of an inputrc file and re-read.
#
#    Editor's note - The Perl6 layer translates True values of C<$readable> to non-zero, so if you want to specify a particular Int value, please use the underlying C<rl_macro_dumper()> call.
#
#=item rl-variable-dumper( Bool $readable )
#
#    Print the readline variable names and their current values to C<$rl_outstream>. If readable is True, the list is formatted in such a way that it can be made part of an inputrc file and re-read.
#
#    Editor's note - The Perl6 layer translates True values of C<$readable> to non-zero, so if you want to specify a particular Int value, please use the underlying C<rl_variable_dumper()> call.
#
#=item rl-read-init-file( Str $filename )
#
#    Read keybindings and variable assignments from C<$filename> (see section 1.3 Readline Init File).
#
#=item rl-parse-and-bind( Str $line ) returns Int
#
#    Parse C<$line> as if it had been read from the inputrc file and perform any key bindings and variable assignments found (see section 1.3 Readline Init File).
#
#=item rl-add-funmap-entry( Str $name, &callback (Int, Int --> Int) ) returns Int
#
#    Add C<$name> to the list of bindable Readline command names, and make function the function to be called when name is invoked.
#
#=item rl-funmap-names( ) returns CArray[Str]
#
#    Return a NULL terminated array of known function names. The array is sorted. The array itself is allocated, but not the strings inside. You should free the array, but not the pointers, using free or rl_free when you are done.
#
#=item rl-push-macro-input( Str $macro )
#
#    Cause C<$macro> to be inserted into the line, as if it had been invoked by a key bound to a macro. Not especially useful; use C<rl_insert_text()> instead.
#
#=item rl-free-undo-list( )
#
#    Free the existing undo list.
#
#=item rl-do-undo( ) returns Int
#
#    Undo the first thing on the undo list. Returns False if there was nothing to undo, True if something was undone.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_do_undo()> function rather than the Perl6 layer.
#
#=item rl-begin-undo-group( ) returns Int
#
#    Begins saving undo information in a group construct. The undo information usually comes from calls to rl_insert_text() and rl_delete_text(), but could be the result of calls to rl_add_undo().
#
#=item rl-end-undo-group( ) returns Int
#
#    Closes the current undo group started with rl_begin_undo_group (). There should be one call to rl_end_undo_group() for each call to rl_begin_undo_group().
#
#=item rl-modifying( Int $start, Int $end ) returns Int
#
#    Tell Readline to save the text between C<$start> and C<$end> as a single undo unit. It is assumed that you will subsequently modify that text.
#
#=item rl-redisplay( )
#
#    Change what's displayed on the screen to reflect the current contents of rl_line_buffer.
#
#=item rl-on-new-line( ) returns Int
#
#    Tell the update functions that we have moved onto a new (empty) line, usually after outputting a newline.
#
#=item rl-on-new-line-with-prompt( ) returns Int
#
#    Tell the update functions that we have moved onto a new line, with C<$rl_prompt> already displayed. This could be used by applications that want to output the prompt string themselves, but still need Readline to know the prompt string length for redisplay. It should be used after setting rl_already_prompted.
#
#=item rl-forced-update-display( ) returns Int
#
#    Force the line to be updated and redisplayed, whether or not Readline thinks the screen display is correct.
#
#=item rl-clear-message( ) returns Int
#
#    Clear the message in the echo area. If the prompt was saved with a call to rl_save_prompt before the last call to rl_message, call rl_restore_prompt before calling this function.
#
#=item rl-reset-line-state( ) returns Int
#
#    Reset the display state to a clean state and redisplay the current line starting on a new line.
#
#=item rl-crlf( ) returns Int
#
#    Move the cursor to the start of the next screen line.
#
#=item rl-show-char( Str $c ) returns Int
#
#    Display character c on rl_outstream. If Readline has not been set to display meta characters directly, this will convert meta characters to a meta-prefixed key sequence. This is intended for use by applications which wish to do their own redisplay.
#
#    Editor's note - C<$key> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_show_char()> instead.
#
#=item rl-save-prompt( )
#
#    Save the local Readline prompt display state in preparation for displaying a new message in the message area with rl_message().
#
#=item rl-restore-prompt( )
#
#    Restore the local Readline prompt display state saved by the most recent call to rl_save_prompt. if rl_save_prompt was called to save the prompt before a call to rl_message, this function should be called before the corresponding call to rl_clear_message.
#
#=item rl-replace-line( Str $text, Int $clear-undo )
#
#    Replace the contents of C<$rl_line_buffer> with C<$text>. The point and mark are preserved, if possible. If C<$clear-undo> is non-zero, the undo list associated with the current line is cleared.
#
#=item rl-insert-text( Str $text ) returns Int
#
#    Insert C<$text> into the line at the current cursor position. Returns the number of characters inserted.
#
#=item rl-delete-text( Int $start, Int $end ) returns Int
#
#    Delete the text between C<$start> and C<$end> in the current line. Returns the number of characters deleted.
#
#=item rl-kill-text( Int $start, Int $end ) returns Int
#
#    Copy the text between C<$start> and C<$end> in the current line to the kill ring, appending or prepending to the last kill if the last command was a kill command. The text is deleted. If C<$start> is less than C<$end>, the text is appended, otherwise prepended. If the last command was not a kill, a new kill ring slot is used.
#
#=item rl-copy-text( Int $start, Int $end ) returns Str
#
#    Return a copy of the text between C<$start> and C<$end> in the current line.
#
#=item rl-prep-terminal( Int $meta-flag )
#
#    Modify the terminal settings for Readline's use, so readline() can read a single character at a time from the keyboard. The C<$meta-flag> argument should be non-zero if Readline should read eight-bit input.
#
#=item rl-deprep-terminal( )
#
#    Undo the effects of C<rl_prep_terminal()>, leaving the terminal in the state in which it was before the most recent call to C<rl_prep_terminal()>.
#
#=item rl-tty-set-default-bindings( Keymap $map )
#
#    Read the operating system's terminal editing characters (as would be displayed by stty) to their Readline equivalents. The bindings are performed in keymap C<$map>.
#
#=item rl-tty-unset-default-bindings( Keymap $map )
#
#    Reset the bindings manipulated by C<$rl_tty_set_default_bindings> so that the terminal editing characters are bound to C<$rl_insert>. The bindings are performed in keymap C<$map>.
#
#=item rl-reset-terminal( Str $terminal-name ) returns Int
#
#    Reinitialize Readline's idea of the terminal settings using C<$terminal-name> as the terminal type (e.g., vt100). If terminal_name is NULL, the value of the TERM environment variable is used.
#
#=item rl-resize-terminal( )
#
#    Update Readline's internal screen size by reading values from the kernel.
#
#=item rl-set-screen-size( Int $rows, Int $cols )
#
#    Set Readline's idea of the terminal size to C<$rows> rows and C<$cols> columns. If either C<$rows> or C<$cols> is less than or equal to 0, Readline's idea of that terminal dimension is unchanged.
#
#If an application does not want to install a SIGWINCH handler, but is still interested in the screen dimensions, Readline's idea of the screen size may be queried.
#
#=item rl-get-screen-size( Pointer[Int] $rows, Pointer[Int] $cols )
#
#    Return Readline's idea of the terminal's size in the variables pointed to by the arguments.
#
#=item rl-reset-screen-size( )
#
#    Cause Readline to reobtain the screen size and recalculate its dimensions.
#
#=item rl-get-termcap( Str $cap ) returns Str
#
#    Retrieve the string value of the termcap capability C<$cap>. Readline fetches the termcap entry for the current terminal name and uses those capabilities to move around the screen line and perform other terminal-specific operations, like erasing a line. Readline does not use all of a terminal's capabilities, and this function will return values for only those capabilities Readline uses.
#
#=item rl-extend-line-buffer( Int $len )
#
#    Ensure that rl_line_buffer has enough space to hold C<$len> characters, possibly reallocating it if necessary.
#
#=item rl-alphabetic( Str $c ) returns Bool
#
#    Return True if c is an alphabetic character.
#
#    Editor's note - The underlying C function returns non-zero on error, this is mapped onto a Perl6 Bool type. If you want the original behavior, call the underlying C<rl_alphabetic()> function rather than the Perl6 layer.
#
#    Editor's note - C<$c> is an integer in the underlying C API - If you want to use the actual C function call, please call C<rl_alphabetic()> instead.
#
#=item rl-free( Pointer $mem )
#
#    Deallocate the memory pointed to by C<$mem>. C<$mem> must have been allocated by malloc.
#
#=begin Signals
#
#These methods manipulate signal handling for L<Readline>.
#
#=item rl-set-signals( ) returns Int
#
#    Install Readline's signal handler for SIGINT, SIGQUIT, SIGTERM, SIGHUP, SIGALRM, SIGTSTP, SIGTTIN, SIGTTOU, and SIGWINCH, depending on the values of rl_catch_signals and rl_catch_sigwinch.
#
#=item rl-clear-signals( ) returns Int
#
#    Remove all of the Readline signal handlers installed by C<rl_set_signals()>.
#
#=item rl-cleanup-after-signal( )
#
#    This function will reset the state of the terminal to what it was before readline() was called, and remove the Readline signal handlers for all signals, depending on the values of C<$rl-catch-signals> and C<$rl-catch-sigwinch>.
#
#=item rl-reset-after-signal( )
#
#    This will reinitialize the terminal and reinstall any Readline signal handlers, depending on the values of C<$rl_catch_signals> and C<$rl_catch_sigwinch>.
#
#    If an application does not wish Readline to catch SIGWINCH, it may call C<rl_resize_terminal()> or C<rl_set_screen_size()> to force Readline to update its idea of the terminal size when a SIGWINCH is received.
#
#=item rl-free-line-state( )
#
#    This will free any partial state associated with the current input line (undo information, any partial history entry, any partially-entered keyboard macro, and any partially-entered numeric argument). This should be called before C<rl_cleanup_after_signal()>. The Readline signal handler for SIGINT calls this to abort the current input line.
#
#=item rl-echo-signal( Int $c )
#
#    If an application wishes to install its own signal handlers, but still have readline display characters that generate signals, calling this function with sig set to SIGINT, SIGQUIT, or SIGTSTP will display the character generating that signal.
#
#=end Signals
#
#=item rl-set-paren-blink-timeout( Int $c ) returns Int
#
#    Set the time interval (in microseconds) that Readline waits when showing a balancing character when blink-matching-paren has been enabled.
#
#=item rl-complete-internal( Int $what-to-do ) returns Int
#
#    Complete the word at or before point. C<$what-to-do> says what to do with the completion. A value of `?' means list the possible completions. `TAB' means do standard completion. `*' means insert all of the possible completions. `!' means to display all of the possible completions, if there is more than one, as well as performing partial completion. `@' is similar to `!', but possible completions are not listed if the possible completions share a common prefix.
#
#=item rl-username-completion-function ( Str $text, Int $i ) returns Str
#
#    A completion generator for usernames. C<$text> contains a partial username preceded by a random character (usually `~'). As with all completion generators, state is zero on the first call and non-zero for subsequent calls.
#
#=item rl-filename-completion-function ( Str $text, Int $i ) returns Str
#
#    A generator function for filename completion in the general case. C<$text> is a partial filename. The Bash source is a useful reference for writing application-specific completion functions (the Bash completion functions call this and other Readline functions).
#
#=item rl-completion-mode( Pointer[&callback (Int, Int --> Int)] $cfunc ) returns Int
#
#    Returns the appropriate value to pass to C<rl_complete_internal()> depending on whether C<$cfunc> was called twice in succession and the values of the show-all-if-ambiguous and show-all-if-unmodified variables. Application-specific completion functions may use this function to present the same interface as rl_complete().
#
#=item rl-save-state( readline_state $sp ) returns Int
#
#    Save a snapshot of Readline's internal state to C<$sp>. The contents of the readline_state structure are documented in `readline.h'. The caller is responsible for allocating the structure.
#
#=item tilde-expand( Str $str ) returns Str
#
#    Return a new string which is the result of tilde-expanding C<$str>.
#
#=item tilde-expand-word( Str $filename ) returns Str
#
#    Do the work of tilde expansion on C<$filename>.  C<$filename> starts with a tilde.  If there is no expansion, call C<$tilde_expansion_failure_hook>.
#
#=item tilde-find-word( Str, Int, Pointer[Int] ) returns Str
#
#    Find the portion of the string beginning with ~ that should be expanded.
#
#=item rl-restore-state( readline_state $sp ) returns Int
#
#    Restore Readline's internal state to that stored in C<$sp>, which must have been saved by a call to C<rl_save_state()>. The contents of the readline_state structure are documented in `readline.h'. The caller is responsible for freeing the structure.
#
#=end METHODS
#############################################################################
