#!/usr/bin/env perl6
use v6;
use ReadLine;

my $readline = ReadLine.new;
while my $response = $readline.readline( "prompt here (<cr> to exit)> " ) {
  if $response ~~ /\S/ {
    $readline.add_history( $response );
  }
  say "[$response]";
}

#
# Event loop version
#
# my $callback = sub( Str $input ) { $global ~= $input };
#
# $readline.rl_callback_handler_install( "New prompt> ", $callback );
# my $running = 1;
# while $running {
#  select();
# }
