#!/usr/bin/env perl6
use v6;
use ReadLine;

my $readline = ReadLine.new;
while my $response = $readline.readline( "prompt here (<cr> to exit)> " ) {
  if $response ~~ /ding/ {
    $readline.ding;
  }
  elsif $response ~~ /\S/ {
    $readline.add-history( $response );
  }
  say "[$response]";
}
