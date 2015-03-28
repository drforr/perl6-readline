use v6;
use NativeCall;

constant LIB = 'libreadline.so.5';

sub readline( Str $prompt ) returns Str
  is native( LIB ) { ... }
sub add_history( Str $prompt )
  is native( LIB ) { ... }

#
# Modifying Text
#
sub rl_insert_text( Str $text ) returns Int
  is native( LIB ) { ... }
sub rl_delete_text( Int $start, Int $end ) returns Int
  is native( LIB ) { ... }
sub rl_copy_text( Int $start, Int $end ) returns Str
  is native( LIB ) { ... }
sub rl_kill_text( Int $start, Int $end ) returns Int
  is native( LIB ) { ... }
sub rl_push_macro_input( Str $macro ) returns Int
  is native( LIB ) { ... }

#
# Character Input
#
sub rl_read_key( ) returns Int
  is native( LIB ) { ... }
#sub rl_read_key( FD $fd ) returns Int
#  is native( LIB ) { ... }
sub rl_stuff_char( Int $c ) returns Int
  is native( LIB ) { ... }
sub rl_execute_next( Int $c ) returns Int
  is native( LIB ) { ... }
sub rl_clear_pending_input( ) returns Int
  is native( LIB ) { ... }
sub rl_set_keyboard_input_timeout( Int $u ) returns Int
  is native( LIB ) { ... }


#
# Terminal Management
#
sub rl_prep_terminal( Int $meta_flag )
  is native( LIB ) { ... }
sub rl_deprep_terminal( )
  is native( LIB ) { ... }
#sub rl_tty_set_default_bindings( OpaquePointer $kmap )
#  is native( LIB ) { ... }
#sub rl_tty_unset_default_bindings( OpaquePointer $kmap )
#  is native( LIB ) { ... }
sub rl_reset_terminal( Str $terminal_name ) returns Int
  is native( LIB ) { ... }

#
# Utility Functions
#
#sub rl_save_state( Int $readable ) returns Int
#   is native( LIB ) { ... }
#sub rl_restore_state( Int $readable ) returns Int
#   is native( LIB ) { ... }
sub rl_free( OpaquePointer $mem )
  is native( LIB ) { ... }
sub rl_replace_line( Str $text, Int $clear_undo )
  is native( LIB ) { ... }
sub rl_extend_line_buffer( Int $len )
  is native( LIB ) { ... }
sub rl_initialize( ) returns Int
  is native( LIB ) { ... }
sub rl_ding( ) returns Int
  is native( LIB ) { ... }
sub rl_alphabetic( Int $c ) returns Int
  is native( LIB ) { ... }
#sub rl_display_match_list( Int $c ) returns Int
#  is native( LIB ) { ... }

#
# Miscellaneous Functions
#
#rl_macro_bind is deprecated

sub rl_macro_dumper( Int $readable )
   is native( LIB ) { ... }
sub rl_variable_bind( Str $variable, Str $value ) returns Int
  is native( LIB ) { ... }
sub rl_variable_value( Str $variable ) returns Str
  is native( LIB ) { ... }
sub rl_variable_dumper( Int $readable )
  is native( LIB ) { ... }
sub rl_set_paren_blink_timeout( Int $u )
  is native( LIB ) { ... }
sub rl_get_termcap( Str $cap ) returns Str
  is native( LIB ) { ... }
sub rl_clear_history( )
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
