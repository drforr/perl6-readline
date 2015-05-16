#!/usr/bin/env perl6
use v6;
use Readline;

#my %history;
#while my $response = readline( "prompt here (<cr> to exit)> " ) {
#  if $response ~~ /\S/ {
#    unless %history{$response} {
#      add_history( $response );
#      %history{$response} = 1;
#    }
#  }
#  say "[$response]";
#}

my Int $running;
my Str $prompt = 'rltest$ ';

# 
# Callback function called for each line when accept-line executed, EOF
# seen, or EOF character read.  This sets a flag and returns; it could
# also call exit(3).
# 
sub cb_linehandler( Str $line ) {
  # Can use ^D or 'exit' to exit
  if $line eq '' or $line eq 'exit' {
    if $line eq '' {
      say();
    }
    say 'exit';
    # This function needs to be called to reset the terminal settings,
    # and calling it from the line handler keeps one extra prompt from
    # being displayed.
    rl_callback_handler_remove();

    $running = 0;
  }
  else {
    if $line ne '' {
      add_history( $line );
    }
    say "input line: {$line}";
  }
}

rl_callback_handler_install( $prompt, &cb_linehandler );

# #my $rl_instream := cglobal( LIB, 'rl_instream', int32 ); # 64-bit pointer
# #my $rl_instream := cglobal( LIB, 'rl_instream', num64 ); # 64-bit pointer
# #my $rl_instream := cglobal( LIB, 'rl_instream', Pointer ); # 64-bit pointer
# my $rl_instream := cglobal( LIB, 'rl_instream', Pointer[void] );
# say "Foo: {$rl_instream}";
#
# sub main ( ) {
# #  my fd_set $fds; # XXX
#   my $fds;
#   int $r;
#   #
#   # Install the line handler.
#   #
#   rl_callback_handler_install ( $prompt, &cb_linehandler );
#
#   # Enter a simple event loop.  This waits until something is available
#   # to read on readline's input stream (defaults to standard input) and
#   # calls the builtin character read callback to read it.  It does not
#   # have to modify the user's terminal settings.
#
#   $running = 1;
#   while $running {
# #    FD_ZERO( \$fds );
# #    FD_SET( fileno( rl_instream ), \$fds );
# #
# #    $r = select( FD_SETSIZE, \$fds, Nil, Nil, Nil );
# #    if $r < 0 {
#       perror 'rltest: select';
#       rl_callback_handler_remove();
#       break;
# #    }
# #    if FD_ISSET( fileno( $rl_instream ), \$fds ) { # $rl_instream is exported
#       rl_callback_read_char();
# #    }
#   }
#
#   say 'rltest: Event loop has exited';
#   return 0;
# }
#
# main();
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

