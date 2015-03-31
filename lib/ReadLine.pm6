use v6;
use NativeCall;

constant LIB = 'libreadline.so.5';

class ReadLine {

  class Keymap is repr('CPointer') {
    # Returns a new, empty keymap. The space for the keymap is allocated with
    # malloc(); the caller should free it by calling rl_free_keymap()
    # when done. 
    #
    sub rl_make_bare_keymap ( ) returns Keymap
      is native( LIB ) { ... }
    method new() {
      rl_make_bare_keymap() }

    # Return a new keymap which is a copy of map. 
    #
    sub rl_copy_keymap ( Keymap $map ) returns Keymap
      is native( LIB ) { ... }
    method clone( Keymap $keymap ) {
      rl_copy_keymap( $keymap ) }

    # Return a new keymap with the printing characters bound to rl_insert, the
    # lowercase Meta characters bound to run their equivalents, and the Meta
    # digits bound to produce numeric arguments. 
    #
    sub rl_make_keymap ( ) returns Keymap
      is native( LIB ) { ... }
    method make( ) {
      rl_make_keymap() }

    # Returns the currently active keymap. 
    #
    sub rl_get_keymap ( ) returns Keymap
      is native( LIB ) { ... }
    method get( ) {
      rl_get_keymap() }

    # Return the keymap matching name. name is one which would be supplied in
    # a set keymap inputrc line (see section 1.3 Readline Init File). 
    #
    sub rl_get_keymap_by_name ( Str $name ) returns Keymap
      is native( LIB ) { ... }
    method get-by-name ( Str $name ) {
      rl_get_keymap_by_name( $name ) }

    # Return the name matching keymap. name is one which would be supplied in
    # a set keymap inputrc line (see section 1.3 Readline Init File). 
    #
    sub rl_get_keymap_name ( Keymap $keymap ) returns Str
      is native( LIB ) { ... }
    method get-by-keymap ( Keymap $keymap ) {
      rl_get_keymap_name( $keymap ) }

    # Makes keymap the currently active keymap. 
    #
    sub rl_set_keymap ( Keymap $keymap )
      is native( LIB ) { ... }
    method set( Keymap $keymap ) {
      rl_set_keymap( $keymap ) }

    # Free the storage associated with the data in keymap. The caller should
    # free keymap. 
    #
    sub rl_discard_keymap ( Keymap $keymap )
      is native( LIB ) { ... }
    method discard( Keymap $keymap ) {
      rl_discard_keymap( $keymap ) }

    # Free all storage associated with keymap. This calls rl_discard_keymap to
    # free subordindate keymaps and macros. 
    #
    sub rl_free_keymap ( Keymap $keymap )
      is native( LIB ) { ... }
    method free() {
      rl_free_keymap( self ) }
  }

  # 1
  #
  sub readline( Str $prompt ) returns Str
    is native( LIB ) { ... }
  method readline( Str $prompt ) {
    readline( $prompt ) }

  sub add_history( Str $prompt )
    is native( LIB ) { ... }
  method add-history( Str $prompt ) {
    add_history( $prompt ) }

  #
  # 2.4.3 Binding Keys
  #
#typedef int rl_command_func_t PARAMS((int, int));

  # Binds key to function in the currently active keymap. Returns non-zero in
  # the case of an invalid key. 
  #
  sub rl_bind_key ( Int $key, &callback ( Int, Int --> Int ) ) returns Int
    is native( LIB ) { ... }
  # XXX need method

  # Bind key to function in map. Returns non-zero in the case of an invalid
  # key. 
  #
  sub rl_bind_key_in_map ( Int $key, &callback ( Int, Int --> Int ), Keymap $map ) returns Int
    is native( LIB ) { ... }
  # XXX need method

  # Binds key to function if it is not already bound in the currently active
  # keymap. Returns non-zero in the case of an invalid key or if key is already
  # bound. 
  #
  sub rl_bind_key_if_unbound ( Int $key, &callback ( Int, Int --> Int ) ) returns Int
    is native( LIB ) { ... }
  # XXX need method

  # Binds key to function if it is not already bound in map. Returns non-zero
  # in the case of an invalid key or if key is already bound. 
  #
  sub rl_bind_key_if_unbound_in_map ( Int $key, &callback ( Int, Int --> Int ), Keymap $map ) returns Int
    is native( LIB ) { ... }
  # XXX need method

  # Bind key to the null function in the currently active keymap. Returns non-zero in case of error. 
  sub rl_unbind_key ( Int $key ) returns Int
    is native( LIB ) { ... }
  method unbind-key( Int $key ) {
    rl_unbind_key( $key ) }

  # Bind key to the null function in map. Returns non-zero in case of error. 
  sub rl_unbind_key_in_map ( Int $key, Keymap $map ) returns Int
    is native( LIB ) { ... }
  method unbind-key-in-map( Int $key, Keymap $map ) {
    rl_unbind_key_in_map( $key, $map ) }

  # Unbind all keys that execute function in map. 
  sub rl_unbind_function_in_map (&calback ( Int, Int --> Int ), Keymap $map) returns Int
    is native( LIB ) { ... }
  # XXX need method

  # Unbind all keys that are bound to command in map. 
  sub rl_unbind_command_in_map ( Str $command, Keymap $map ) returns Int
    is native( LIB ) { ... }
  method unbind-command-in-map ( Str $command, Keymap $map ) {
    rl_unbind_command_in_map( $command, $map ) }

  # Bind the key sequence represented by the string keyseq to the function
  # function, beginning in the current keymap. This makes new keymaps as
  # necessary. The return value is non-zero if keyseq is invalid. 
  #
  sub rl_bind_keyseq ( Str $keyseq, &callback ( Int, Int --> Int ) ) returns Int
    is native( LIB ) { ... }
  # XXX need method

  # Bind the key sequence represented by the string keyseq to the function
  # function. This makes new keymaps as necessary. Initial bindings are
  # performed in map. The return value is non-zero if keyseq is invalid. 
  #
  sub rl_bind_keyseq_in_map ( Str $keyseq, &callback ( Int, Int --> Int ), Keymap $map) returns Int
    is native( LIB ) { ... }
  # XXX needs method

  # Equivalent to rl_bind_keyseq_in_map. 
  #
  sub rl_set_key ( Str $keyseq, &callback ( Int, Int --> Int ), Keymap $map ) returns Int
    is native( LIB ) { ... }
  # XXX needs method

  # Binds keyseq to function if it is not already bound in the currently active
  # keymap. Returns non-zero in the case of an invalid keyseq or if keyseq is
  # already bound. 
  #
  sub rl_bind_keyseq_if_unbound ( Str $keyseq, &callback ( Int, Int --> Int ) ) returns Int
    is native( LIB ) { ... }
  # XXX needs method

  # Binds keyseq to function if it is not already bound in map. Returns
  # non-zero in the case of an invalid keyseq or if keyseq is already bound. 
  #
  sub rl_bind_keyseq_if_unbound_in_map ( Str $keyseq, &callback ( Int, Int --> Int ), Keymap $map) returns Int
    is native( LIB ) { ... }
  # XXX needs method

  # Bind the key sequence represented by the string keyseq to the arbitrary
  # pointer data. type says what kind of data is pointed to by data; this can
  # be a function (ISFUNC), a macro (ISMACR), or a keymap (ISKMAP). This makes
  # new keymaps as necessary. The initial keymap in which to do bindings is
  # map. 
  sub rl_generic_bind ( Str $type, Str $keyseq, Str $data, Keymap $map ) returns Int
    is native( LIB ) { ... }
  method generic-bind ( Str $type, Str $keyseq, Str $data, Keymap $map ) {
    rl_generic_bind( $type, $keyseq, $data, $map ) }

  # Parse line as if it had been read from the inputrc file and perform any key bindings and variable assignments found (see section 1.3 Readline Init File). 
  sub rl_parse_and_bind ( Str $line ) returns Int
    is native( LIB ) { ... }
  method parse-and-bind( Str $line ) {
    rl_parse_and_bind( $line ) }

  # Read keybindings and variable assignments from filename (see section 1.3 Readline Init File). 
  sub rl_read_init_file ( Str $filename ) returns Int
    is native( LIB ) { ... }
  method read-init-file( Str $filename ) {
    rl_read_init_file( $filename ) }

  #
  # 2.4.4 Associating Function Names and Bindings
  #

  # Return the function with name name. 
  #sub rl_command_func_t * rl_named_function ( Str $name )
  #  is native( LIB ) { ... }

  # Return the function invoked by keyseq in keymap map. If map is NULL, the current keymap is used. If type is not NULL, the type of the object is returned in the int variable it points to (one of ISFUNC, ISKMAP, or ISMACR). 
  #sub rl_command_func_t * rl_function_of_keyseq ( Str $keyseq, Keymap $map, int *type)
  #  is native( LIB ) { ... }

  # Return an array of strings representing the key sequences used to invoke function in the current keymap. 
  #sub char ** rl_invoking_keyseqs (rl_command_func_t *function)
  #  is native( LIB ) { ... }

  # Return an array of strings representing the key sequences used to invoke function in the keymap map. 
  #sub char ** rl_invoking_keyseqs_in_map (rl_command_func_t *function, Keymap $map)
  #  is native( LIB ) { ... }

  # Print the readline function names and the key sequences currently bound to them to rl_outstream. If readable is non-zero, the list is formatted in such a way that it can be made part of an inputrc file and re-read. 
  sub rl_function_dumper ( Int $readable )
    is native( LIB ) { ... }
  method function-dumper( Int $readable ) {
    rl_function_dumper( $readable ) }

  # Print the names of all bindable Readline functions to rl_outstream. 
  sub rl_list_funmap_names ( )
    is native( LIB ) { ... }
  method list-funmap-names( ) {
    rl_list_funmap_names( ) }

  # Return a NULL terminated array of known function names. The array is sorted. The array itself is allocated, but not the strings inside. You should free the array, but not the pointers, using free or rl_free when you are done. 
  #sub const char ** rl_funmap_names ( )
  #  is native( LIB ) { ... }

  # Add name to the list of bindable Readline command names, and make function the function to be called when name is invoked. 
  #sub rl_add_funmap_entry ( Str $name, rl_command_func_t *function ) returns Int
  #  is native( LIB ) { ... }

  #
  # 2.4.5 Allowing Undoing
  #

  # Begins saving undo information in a group construct. The undo information usually comes from calls to rl_insert_text() and rl_delete_text(), but could be the result of calls to rl_add_undo(). 
  sub rl_begin_undo_group ( ) returns Int
    is native( LIB ) { ... }
  method begin-undo-group( ) {
    rl_begin_undo_group( ) }

  # Closes the current undo group started with rl_begin_undo_group (). There should be one call to rl_end_undo_group() for each call to rl_begin_undo_group(). 
  sub rl_end_undo_group ( ) returns Int
    is native( LIB ) { ... }
  method end-undo-group( ) {
    rl_end_undo_group( ) }

  # Remember how to undo an event (according to what). The affected text runs from start to end, and encompasses text. 
  #sub rl_add_undo (enum undo_code what, Int $start, Int $end, Str $text)
  #  is native( LIB ) { ... }

  # Free the existing undo list. 
  sub rl_free_undo_list ( )
    is native( LIB ) { ... }
  method free-undo-list( ) {
    rl_free_undo_list( ) }

  # Undo the first thing on the undo list. Returns 0 if there was nothing to undo, non-zero if something was undone. 
  sub rl_do_undo ( ) returns Int
    is native( LIB ) { ... }
  method do-undo( ) {
    rl_do_undo( ) }

  # Tell Readline to save the text between start and end as a single undo unit. It is assumed that you will subsequently modify that text. 
  sub rl_modifying ( Int $start, Int $end ) returns Int
    is native( LIB ) { ... }
  method modifying( Int $start, Int $end ) {
    rl_modifying( $start, $end ) }

  #
  # 2.4.6 Redisplay
  #

  # Change what's displayed on the screen to reflect the current contents of rl_line_buffer. 
  sub rl_redisplay ( )
    is native( LIB ) { ... }
  method redisplay( ) {
    rl_redisplay( ) }

  # Force the line to be updated and redisplayed, whether or not Readline thinks the screen display is correct. 
  sub rl_forced_update_display ( ) returns Int
    is native( LIB ) { ... }
  method forced-update-display( ) {
    rl_forced_update_display( ) }

  # Tell the update functions that we have moved onto a new (empty) line, usually after outputting a newline. 
  sub rl_on_new_line ( ) returns Int
    is native( LIB ) { ... }
  method on-new-line( ) {
    rl_on_new_line( ) }

  # Tell the update functions that we have moved onto a new line, with rl_prompt already displayed. This could be used by applications that want to output the prompt string themselves, but still need Readline to know the prompt string length for redisplay. It should be used after setting rl_already_prompted. 
  sub rl_on_new_line_with_prompt ( ) returns Int
    is native( LIB ) { ... }
  method on-new-line-with-prompt( ) {
    rl_on_new_line_with_prompt( ) }

  # Reset the display state to a clean state and redisplay the current line starting on a new line. 
  sub rl_reset_line_state ( ) returns Int
    is native( LIB ) { ... }
  method reset-line-state( ) {
    rl_reset_line_state( ) }

  # Move the cursor to the start of the next screen line. 
  sub rl_crlf ( ) returns Int
    is native( LIB ) { ... }
  method crlf( ) {
    rl_crlf( ) }

  # Display character c on rl_outstream. If Readline has not been set to display meta characters directly, this will convert meta characters to a meta-prefixed key sequence. This is intended for use by applications which wish to do their own redisplay. 
  sub rl_show_char ( Int $c ) returns Int
    is native( LIB ) { ... }
  method show-char( Int $c ) {
    rl_show_char( $c ) }

  # The arguments are a format string as would be supplied to printf, possibly containing conversion specifications such as `%d', and any additional arguments necessary to satisfy the conversion specifications. The resulting string is displayed in the echo area. The echo area is also used to display numeric arguments and search strings. You should call rl_save_prompt to save the prompt information before calling this function. 
  #sub rl_message ( Str $msg, ...) returns Int
  #  is native( LIB ) { ... }

  # Clear the message in the echo area. If the prompt was saved with a call to rl_save_prompt before the last call to rl_message, call rl_restore_prompt before calling this function. 
  sub rl_clear_message ( ) returns Int
    is native( LIB ) { ... }
  method clear-message( ) {
    rl_clear_message( ) }

  # Save the local Readline prompt display state in preparation for displaying a new message in the message area with rl_message(). 
  sub rl_save_prompt ( )
    is native( LIB ) { ... }
  method save-prompt( ) {
    rl_save_prompt( ) }

  # Restore the local Readline prompt display state saved by the most recent call to rl_save_prompt. if rl_save_prompt was called to save the prompt before a call to rl_message, this function should be called before the corresponding call to rl_clear_message. 
  sub rl_restore_prompt ( )
    is native( LIB ) { ... }
  method restore-prompt( ) {
    rl_restore_prompt( ) }

  # Expand any special character sequences in prompt and set up the local Readline prompt redisplay variables. This function is called by readline(). It may also be called to expand the primary prompt if the rl_on_new_line_with_prompt() function or rl_already_prompted variable is used. It returns the number of visible characters on the last line of the (possibly multi-line) prompt. Applications may indicate that the prompt contains characters that take up no physical screen space when displayed by bracketing a sequence of such characters with the special markers RL_PROMPT_START_IGNORE and RL_PROMPT_END_IGNORE (declared in `readline.h'. This may be used to embed terminal-specific escape sequences in prompts. 
  sub rl_expand_prompt ( Str $prompt ) returns Int
    is native( LIB ) { ... }
  method expand-prompt( Str $prompt ) {
    rl_expand_prompt( $prompt ) }

  # Make Readline use prompt for subsequent redisplay. This calls rl_expand_prompt() to expand the prompt and sets rl_prompt to the result. 
  sub rl_set_prompt ( Str $prompt ) returns Int
    is native( LIB ) { ... }
  method set-prompt( Str $prompt ) {
    rl_set_prompt( $prompt ) }

  #
  # 2.4.7 Modifying Text
  #

  # Insert text into the line at the current cursor position. Returns the number of characters inserted. 
  sub rl_insert_text ( Str $text ) returns Int
    is native( LIB ) { ... }
  method insert-text( Str $text ) {
    rl_insert_text( $text ) }

  # Delete the text between start and end in the current line. Returns the number of characters deleted. 
  sub rl_delete_text ( Int $start, Int $end ) returns Int
    is native( LIB ) { ... }
  method delete-text( Int $start, Int $end ) {
    rl_delete_text( $start, $end ) }

  # Return a copy of the text between start and end in the current line. 
  sub rl_copy_text ( Int $start, Int $end ) returns Str
    is native( LIB ) { ... }
  method copy-text( Int $start, Int $end ) {
    rl_copy_text( $start, $end ) }

  # Copy the text between start and end in the current line to the kill ring, appending or prepending to the last kill if the last command was a kill command. The text is deleted. If start is less than end, the text is appended, otherwise prepended. If the last command was not a kill, a new kill ring slot is used. 
  sub rl_kill_text ( Int $start, Int $end ) returns Int
    is native( LIB ) { ... }
  method kill-text( Int $start, Int $end ) {
    rl_kill_text( $start, $end ) }

  # Cause macro to be inserted into the line, as if it had been invoked by a key bound to a macro. Not especially useful; use rl_insert_text() instead. 
  sub rl_push_macro_input ( Str $macro ) returns Int
    is native( LIB ) { ... }
  method push-macro-input( Str $macro ) {
    rl_push_macro_input( $macro ) }

  #
  # 2.4.8 Character Input
  #

  # Return the next character available from Readline's current input stream. This handles input inserted into the input stream via rl_pending_input (see section 2.3 Readline Variables) and rl_stuff_char(), macros, and characters read from the keyboard. While waiting for input, this function will call any function assigned to the rl_event_hook variable. 
  sub rl_read_key ( ) returns Int
    is native( LIB ) { ... }
  method read-key( ) {
    rl_read_key( ) }

  # Return the next character available from stream, which is assumed to be the keyboard. 
  #sub rl_getc (FILE *stream) returns Int
  #  is native( LIB ) { ... }

  # Insert c into the Readline input stream. It will be "read" before Readline attempts to read characters from the terminal with rl_read_key(). Up to 512 characters may be pushed back. rl_stuff_char returns 1 if the character was successfully inserted; 0 otherwise. 
  sub rl_stuff_char ( Int $c ) returns Int
    is native( LIB ) { ... }
  method stuff-char( Int $c ) {
    rl_stuff_char( $c ) }

  # Make c be the next command to be executed when rl_read_key() is called. This sets rl_pending_input. 
  sub rl_execute_next ( Int $c ) returns Int
    is native( LIB ) { ... }
  method execute-next( Int $c ) {
    rl_execute_next( $c ) }

  # Unset rl_pending_input, effectively negating the effect of any previous call to rl_execute_next(). This works only if the pending input has not already been read with rl_read_key(). 
  sub rl_clear_pending_input ( ) returns Int
    is native( LIB ) { ... }
  method clear-pending-input( ) {
    rl_clear_pending_input( ) }

  # While waiting for keyboard input in rl_read_key(), Readline will wait for u microseconds for input before calling any function assigned to rl_event_hook. u must be greater than or equal to zero (a zero-length timeout is equivalent to a poll). The default waiting period is one-tenth of a second. Returns the old timeout value. 
  sub rl_set_keyboard_input_timeout ( Int $u ) returns Int
    is native( LIB ) { ... }
  method set-keyboard-input-timeout( Int $u ) {
    rl_set_keyboard_input_timeout( $u ) }

  #
  # 2.4.9 Terminal Management
  #

  # Modify the terminal settings for Readline's use, so readline() can read a single character at a time from the keyboard. The meta_flag argument should be non-zero if Readline should read eight-bit input. 
  sub rl_prep_terminal ( Int $meta_flag )
    is native( LIB ) { ... }
  method prep-terminal( Int $meta-flag ) {
    rl_prep_terminal( $meta-flag ) }

  # Undo the effects of rl_prep_terminal(), leaving the terminal in the state in which it was before the most recent call to rl_prep_terminal(). 
  sub rl_deprep_terminal ( )
    is native( LIB ) { ... }
  method deprep-terminal( ) {
    rl_deprep_terminal( ) }

  # Read the operating system's terminal editing characters (as would be
  # displayed by stty) to their Readline equivalents. The bindings are
  # performed in kmap. 
  sub rl_tty_set_default_bindings ( Keymap $keymap )
    is native( LIB ) { ... }
  method tty-set-default-bindings ( Keymap $keymap ) {
    rl_tty_set_default_bindings( $keymap ) }

  # Reset the bindings manipulated by rl_tty_set_default_bindings so that the terminal editing characters are bound to rl_insert. The bindings are performed in kmap. 
  sub rl_tty_unset_default_bindings ( Keymap $kmap )
    is native( LIB ) { ... }
  sub tty-unset-default-bindings( Keymap $keymap ) {
    rl_tty_unset_default_bindings ( $keymap ) }

  # Reinitialize Readline's idea of the terminal settings using terminal_name as the terminal type (e.g., vt100). If terminal_name is NULL, the value of the TERM environment variable is used. 
  sub rl_reset_terminal ( Str $terminal_name ) returns Int
    is native( LIB ) { ... }
  method reset-terminal( Str $terminal-name ) {
    rl_reset_terminal( $terminal-name ) }

  #
  # 2.4.10 Utility Functions
  #

  # Save a snapshot of Readline's internal state to sp. The contents of the readline_state structure are documented in `readline.h'. The caller is responsible for allocating the structure. 
  #sub rl_save_state (struct readline_state *sp) returns Int
  #  is native( LIB ) { ... }

  # Restore Readline's internal state to that stored in sp, which must have been saved by a call to rl_save_state. The contents of the readline_state structure are documented in `readline.h'. The caller is responsible for freeing the structure. 
  #sub rl_restore_state (struct readline_state *sp) returns Int
  #  is native( LIB ) { ... }

  # Deallocate the memory pointed to by mem. mem must have been allocated by malloc. 
  #sub rl_free (void *mem)
  #  is native( LIB ) { ... }

  # Replace the contents of rl_line_buffer with text. The point and mark are preserved, if possible. If clear_undo is non-zero, the undo list associated with the current line is cleared. 
  sub rl_replace_line ( Str $text, Int $clear_undo )
    is native( LIB ) { ... }
  method replace-line( Str $text, Int $clear-undo ) {
    rl_replace_line( $text, $clear-undo ) }

  # Ensure that rl_line_buffer has enough space to hold len characters, possibly reallocating it if necessary. 
  sub rl_extend_line_buffer ( Int $len )
    is native( LIB ) { ... }
  method extend-line-buffer( Int $len ) {
    rl_extend_line_buffer( $len ) }

  # Initialize or re-initialize Readline's internal state. It's not strictly necessary to call this; readline() calls it before reading any input. 
  sub rl_initialize ( ) returns Int
    is native( LIB ) { ... }
  method initialize( ) {
    rl_initialize( ) }

  # Ring the terminal bell, obeying the setting of bell-style. 
  sub rl_ding ( ) returns Int
    is native( LIB ) { ... }
  method ding( ) {
    rl_ding( ) }

  # Return 1 if c is an alphabetic character. 
  sub rl_alphabetic ( Int $c ) returns Int
    is native( LIB ) { ... }
  method alphabetic( Int $c ) {
    rl_alphabetic( $c ) }

  # A convenience function for displaying a list of strings in columnar format on Readline's output stream. matches is the list of strings, in argv format, such as a list of completion matches. len is the number of strings in matches, and max is the length of the longest string in matches. This function uses the setting of print-completions-horizontally to select how the matches are displayed (see section 1.3.1 Readline Init File Syntax). When displaying completions, this function sets the number of columns used for display to the value of completion-display-width, the value of the environment variable COLUMNS, or the screen width, in that order. 
  #sub rl_display_match_list (char **matches, Int $len, Int $max )
  #  is native( LIB ) { ... }

  #
  # 2.4.11 Miscellaneous Functions
  #

  # Bind the key sequence keyseq to invoke the macro macro. The binding is performed in map. When keyseq is invoked, the macro will be inserted into the line. This function is deprecated; use rl_generic_bind() instead. 
  sub rl_macro_bind ( Str $keyseq, Str $macro, Keymap $map ) returns Int
    is native( LIB ) { ... }
  method macro-bind ( Str $keyseq, Str $macro, Keymap $keymap ) {
    rl_macro_bind ( $keyseq, $macro, $keymap ) }

  # Print the key sequences bound to macros and their values, using the current keymap, to rl_outstream. If readable is non-zero, the list is formatted in such a way that it can be made part of an inputrc file and re-read. 
  sub rl_macro_dumper ( Int $readable )
    is native( LIB ) { ... }
  method macro-dumper( Int $readable ) {
    rl_macro_dumper( $readable ) }

  # Make the Readline variable variable have value. This behaves as if the readline command `set variable value' had been executed in an inputrc file (see section 1.3.1 Readline Init File Syntax). 
  sub rl_variable_bind ( Str $variable, Str $value ) returns Int
    is native( LIB ) { ... }
  method variable-bind( Str $variable, Str $value ) {
    rl_variable_bind( $variable, $value ) }

  # Return a string representing the value of the Readline variable variable. For boolean variables, this string is either `on' or `off'. 
  sub rl_variable_value ( Str $variable ) returns Int
    is native( LIB ) { ... }
  method variable-value( Str $variable ) {
    rl_variable_value( $variable ) }

  # Print the readline variable names and their current values to rl_outstream. If readable is non-zero, the list is formatted in such a way that it can be made part of an inputrc file and re-read. 
  sub rl_variable_dumper ( Int $readable )
    is native( LIB ) { ... }
  method variable-dumper( Int $readable ) {
    rl_variable_dumper( $readable ) }

  # Set the time interval (in microseconds) that Readline waits when showing a balancing character when blink-matching-paren has been enabled. 
  sub rl_set_paren_blink_timeout ( Int $u ) returns Int
    is native( LIB ) { ... }
  method set-paren-blink-timeout( Int $u ) {
    rl_set_paren_blink_timeout( $u ) }

  # Retrieve the string value of the termcap capability cap. Readline fetches the termcap entry for the current terminal name and uses those capabilities to move around the screen line and perform other terminal-specific operations, like erasing a line. Readline does not use all of a terminal's capabilities, and this function will return values for only those capabilities Readline uses. 
  sub rl_get_termcap ( Str $cap ) returns Str
    is native( LIB ) { ... }
  method get-termcap( Str $cap ) {
    rl_get_termcap( $cap ) }

  # Clear the history list by deleting all of the entries, in the same manner as the History library's clear_history() function. This differs from clear_history because it frees private data Readline saves in the history list. 
  sub rl_clear_history ( )
    is native( LIB ) { ... }
  method clear-history( ) {
    rl_clear_history( ) }

  #
  # 2.4.12 Alternate Interface
  #

  # Set up the terminal for readline I/O and display the initial expanded value of prompt. Save the value of lhandler to use as a handler function to call when a complete line of input has been entered. The handler function receives the text of the line as an argument. 
  #sub rl_callback_handler_install ( Str $prompt, rl_vcpfunc_t *lhandler)
  #  is native( LIB ) { ... }

  # Whenever an application determines that keyboard input is available, it should call rl_callback_read_char(), which will read the next character from the current input source. If that character completes the line, rl_callback_read_char will invoke the lhandler function installed by rl_callback_handler_install to process the line. Before calling the lhandler function, the terminal settings are reset to the values they had before calling rl_callback_handler_install. If the lhandler function returns, and the line handler remains installed, the terminal settings are modified for Readline's use again. EOF is indicated by calling lhandler with a NULL line. 
  sub rl_callback_read_char ( )
    is native( LIB ) { ... }
  method callback-read-char( ) {
    rl_callback_read_char( ) }

  # Restore the terminal to its initial state and remove the line handler. This may be called from within a callback as well as independently. If the lhandler installed by rl_callback_handler_install does not exit the program, either this function or the function referred to by the value of rl_deprep_term_function should be called before the program exits to reset the terminal settings. 
  sub rl_callback_handler_remove ( )
    is native( LIB ) { ... }
  method callback-handler-remove( ) {
    rl_callback_handler_remove( ) }

  ##############################################################################

  #
  # 2.5 Readline Signal Handling
  #

  # Variable: int rl_catch_signals
  #     If this variable is non-zero, Readline will install signal handlers for SIGINT, SIGQUIT, SIGTERM, SIGHUP, SIGALRM, SIGTSTP, SIGTTIN, and SIGTTOU.
  # 
  #     The default value of rl_catch_signals is 1. 
  #
  #Variable: int rl_catch_sigwinch
  #    If this variable is set to a non-zero value, Readline will install a signal handler for SIGWINCH.
  #
  #    The default value of rl_catch_sigwinch is 1. 
  #
  #Variable: int rl_change_environment
  #    If this variable is set to a non-zero value, and Readline is handling SIGWINCH, Readline will modify the LINES and COLUMNS environment variables upon receipt of a SIGWINCH
  #
  #    The default value of rl_change_environment is 1. 

  # This function will reset the state of the terminal to what it was before readline() was called, and remove the Readline signal handlers for all signals, depending on the values of rl_catch_signals and rl_catch_sigwinch. 
  sub rl_cleanup_after_signal ( )
    is native( LIB ) { ... }
  method cleanup-after-signal( ) {
    rl_cleanup_after_signal( ) }

  # This will free any partial state associated with the current input line (undo information, any partial history entry, any partially-entered keyboard macro, and any partially-entered numeric argument). This should be called before rl_cleanup_after_signal(). The Readline signal handler for SIGINT calls this to abort the current input line. 
  sub rl_free_line_state ( )
    is native( LIB ) { ... }
  method free-line-state( ) {
    rl_free_line_state( ) }

  # This will reinitialize the terminal and reinstall any Readline signal handlers, depending on the values of rl_catch_signals and rl_catch_sigwinch. 
  sub rl_reset_after_signal ( )
    is native( LIB ) { ... }
  method reset-after-signal( ) {
    rl_reset_after_signal( ) }

  # If an application wishes to install its own signal handlers, but still have readline display characters that generate signals, calling this function with sig set to SIGINT, SIGQUIT, or SIGTSTP will display the character generating that signal. 
  sub rl_echo_signal_char ( Int $sig )
    is native( LIB ) { ... }
  method echo-signal-char( Int $sig ) {
    rl_echo_signal_char( $sig ) }

  # Update Readline's internal screen size by reading values from the kernel. 
  sub rl_resize_terminal ( )
    is native( LIB ) { ... }
  method resize-terminal( ) {
    rl_resize_terminal( ) }

  # Set Readline's idea of the terminal size to rows rows and cols columns. If either rows or columns is less than or equal to 0, Readline's idea of that terminal dimension is unchanged. 
  sub rl_set_screen_size ( Int $rows, Int $cols )
    is native( LIB ) { ... }
  method set-screen-size( Int $rows, Int $cols ) {
    rl_set_screen_size( $rows, $cols ) }

  # Return Readline's idea of the terminal's size in the variables pointed to by the arguments. 
  #sub void rl_get_screen_size (int *rows, int *cols)
  #  is native( LIB ) { ... }

  # Cause Readline to reobtain the screen size and recalculate its dimensions. 
  sub rl_reset_screen_size ( )
    is native( LIB ) { ... }
  method reset-screen-size( ) {
    rl_reset_screen_size( ) }

  # Install Readline's signal handler for SIGINT, SIGQUIT, SIGTERM, SIGHUP, SIGALRM, SIGTSTP, SIGTTIN, SIGTTOU, and SIGWINCH, depending on the values of rl_catch_signals and rl_catch_sigwinch. 
  sub rl_set_signals ( ) returns Int
    is native( LIB ) { ... }
  method set-signals( ) {
    rl_set_signals( ) }

  # Remove all of the Readline signal handlers installed by rl_set_signals(). 
  sub rl_clear_signals ( ) returns Int
    is native( LIB ) { ... }
  method clear-signals( ) {
    rl_clear_signals( ) }

  #
  # 2.6.1 How Completing Works
  #

  # Variable: rl_compentry_func_t * rl_completion_entry_function
  # This is a pointer to the generator function for rl_completion_matches(). If the value of rl_completion_entry_function is NULL then the default filename generator function, rl_filename_completion_function(), is used. An application-specific completion function is a function whose address is assigned to rl_completion_entry_function and whose return values are used to generate possible completions. 
  # Variable: rl_compentry_func_t * rl_completion_entry_function

  #
  # 2.6.2 Completion Functions
  #

  # Complete the word at or before point. what_to_do says what to do with the completion. A value of `?' means list the possible completions. `TAB' means do standard completion. `*' means insert all of the possible completions. `!' means to display all of the possible completions, if there is more than one, as well as performing partial completion. `@' is similar to `!', but possible completions are not listed if the possible completions share a common prefix. 
  #
  sub rl_complete_internal ( Int $what_to_do ) returns Int
    is native( LIB ) { ... }
  method complete-internal( Int $what-to-do ) {
    rl_complete_internal( $what-to-do ) }

  # Complete the word at or before point. You have supplied the function that does the initial simple matching selection algorithm (see rl_completion_matches() and rl_completion_entry_function). The default is to do filename completion. This calls rl_complete_internal() with an argument depending on invoking_key. 
  #
  sub rl_complete ( Int $ignore, Int $invoking_key ) returns Int
    is native( LIB ) { ... }
  method complete( Int $ignore, Int $invoking-key ) {
    rl_complete( $ignore, $invoking-key ) }

  # List the possible completions. See description of rl_complete (). This calls rl_complete_internal() with an argument of `?'. 
  #
  sub rl_possible_completions ( Int $count, Int $invoking_key ) returns Int
    is native( LIB ) { ... }
  method possible-completions( Int $count, Int $invoking-key ) {
    rl_possible_completions( $count, $invoking-key ) }

  # Insert the list of possible completions into the line, deleting the partially-completed word. See description of rl_complete(). This calls rl_complete_internal() with an argument of `*'. 
  #
  sub rl_insert_completions ( Int $count, Int $invoking_key ) returns Int
    is native( LIB ) { ... }
  method insert-completions( Int $count, Int $invoking-key ) {
    rl_insert_completions( $count, $invoking-key ) }

  # Returns the appropriate value to pass to rl_complete_internal() depending on whether cfunc was called twice in succession and the values of the show-all-if-ambiguous and show-all-if-unmodified variables. Application-specific completion functions may use this function to present the same interface as rl_complete(). 
  #
  #sub rl_completion_mode (rl_command_func_t *cfunc) returns Int
  #  is native( LIB ) { ... }

  # Returns an array of strings which is a list of completions for text. If there are no completions, returns NULL. The first entry in the returned array is the substitution for text. The remaining entries are the possible completions. The array is terminated with a NULL pointer.
  #
  #sub char ** rl_completion_matches ( Str $text, rl_compentry_func_t *entry_func)
  #  is native( LIB ) { ... }

  # A generator function for filename completion in the general case. text is a partial filename. The Bash source is a useful reference for writing application-specific completion functions (the Bash completion functions call this and other Readline functions). 
  #
  sub rl_filename_completion_function ( Str $text, Int $state ) returns Int
    is native( LIB ) { ... }
  method filename-completion-function( Str $text, Int $state ) {
    rl_filename_completion_function( $text, $state ) }

  # A completion generator for usernames. text contains a partial username preceded by a random character (usually `~'). As with all completion generators, state is zero on the first call and non-zero for subsequent calls. 
  #
  sub rl_username_completion_function ( Str $text, Int $state ) returns Str
    is native( LIB ) { ... }
  method username-completion-function( Str $text, Int $state ) {
    rl_username_completion_function( $text, $state ) }
}
