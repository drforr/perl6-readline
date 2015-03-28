use v6;
use NativeCall;

constant LIB = 'libreadline.so.5';

sub readline( Str $prompt ) returns Str
  is native( LIB ) { ... }
sub add_history( Str $prompt )
  is native( LIB ) { ... }

# typedef void rl_vcpfunc_t( char* );

#
# Alternate interface
#
#   $lHandler is a rl_vcpfunc_t callback function.
#
#sub rl_callback_handler_install( Str $prompt, OpaquePointer $lHandler )
#sub rl_callback_handler_install( Str $prompt, &callback( Str ) )
#  is native( LIB ) { ... }
sub rl_callback_read_char( )
  is native( LIB ) { ... }
sub rl_callback_handler_remove( )
  is native( LIB ) { ... }

class ReadLine {
  method readline( $prompt ) { readline( $prompt ) }
  method add_history( $prompt ) { add_history( $prompt ) }

#  method rl_callback_handler_install( $prompt, $callback ) {
#    rl_callback_handler_install( $prompt, $callback );
#  }
  method rl_callback_read_char( $prompt ) { rl_callback_read_char( $prompt ) }
  method rl_callback_handler_remove( $prompt ) { rl_callback_handler_remove( $prompt ) }
    
}
