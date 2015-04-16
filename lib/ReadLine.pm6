use v6;
use NativeCall;

class ReadLine {
  my constant LIB = 'libreadline.so.5';

  constant meta_character_threshold = 0x07f; # Larger than this is Meta.
  constant meta_character_bit       = 0x080; # x0000000, must be on.
  constant largest_char             = 255;   # Largest character value.

  sub META_CHAR( $c ) {
    ord( $c ) > meta_character_threshold && ord( $c ) <= largest_char
  }

  sub META( $c ) {
    ord( $c ) | meta_character_bit
  }

  sub UNMETA( $c ) {
    ord( $c ) & ~meta_character_bit
  }

  ############################################################################
  #
  # history.h -- the names of functions that you can call in history.
  #
  class histdata_t is repr('CPointer') { } # typedef char *histdata_t;

  # The structure used to store a history entry.
  #
  class _hist_entry is repr('CPointer') { } # is HIST_ENTRY
  class HIST_ENTRY is repr('CStruct') {
    has Str $.line;        # char *line;
    has Str $.timestamp;   # char *timestamp;
    has histdata_t $.data; # histdata_t data;
  }

  # Size of the history-library-managed space in history entry HS.
  #
  sub HISTENT_BYTES( $hs ) {
    $hs.line.length + $hs.timestamp.length
  }

  # A structure used to pass the current state of the history stuff around.
  #
  class HISTORY_STATE is repr('CStruct') {
    has Pointer $.entries; # Pointer to an array of HIST_ENTRY types.
    has int     $.offset;  # The location pointer within this array.
    has int     $.length;  # Number of elements within this array.
    has int     $.size;    # Number of slots allocated to this array.
    has int     $.flags;
  }

  # Flag values for the `flags' member of HISTORY_STATE.
  #
  constant HS_STIFLED = 0x01;

  # Initialization and state management.
  #
  # Begin a session in which the history functions might be used.  This
  # just initializes the interactive variables.
  #
  sub using_history( )
    is native( LIB ) { * }
  method using-history( ) {
    using_history() }

  # Return the current HISTORY_STATE of the history.
  #
  sub history_get_history_state( ) returns HISTORY_STATE
    is native( LIB ) { * }
  method history-get-history-state( ) returns HISTORY_STATE {
    history_get_history_state() }

  # Set the state of the current history array to STATE.
  #
  sub history_set_history_state( HISTORY_STATE $state )
    is native( LIB ) { * }
  method history-set-history-state( HISTORY_STATE $state ) {
    history_set_history_state( $state ) }

  # Manage the history list.
  #
  # Place STRING at the end of the history list.
  # The associated data field (if any) is set to NULL.
  #
  sub add_history( Str $history )
    is native( LIB ) { * }
  method add-history( Str $history ) {
    add_history( $history ) }

  # Change the timestamp associated with the most recent history entry to
  # STRING.
  #
  sub add_history_time( Str $timestamp )
    is native( LIB ) { * }
  method add-history-time( Str $timestamp ) {
    add_history_time( $timestamp ) }

  # A reasonably useless function, only here for completeness.  WHICH
  # is the magic number that tells us which element to delete.  The
  # elements are numbered from 0.
  #
  sub remove_history( Int $which ) returns HIST_ENTRY
    is native( LIB ) { * }
  method remove-history( Int $which ) returns HIST_ENTRY {
    remove_history( $which ) }

  # Free the history entry H and return any application-specific data
  # associated with it.
  #
  sub free_history_entry( HIST_ENTRY $entry ) returns histdata_t
    is native( LIB ) { * }
  method free-history-entry( HIST_ENTRY $entry ) returns histdata_t {
    free_history_entry( $entry ) }

  # Make the history entry at WHICH have LINE and DATA.  This returns
  # the old entry so you can dispose of the data.  In the case of an
  # invalid WHICH, a NULL pointer is returned.
  #
  sub replace_history_entry( Int $which, Str $line, histdata_t $data )
    returns HIST_ENTRY
    is native( LIB ) { * }
  method replace-history-entry( Int $which, Str $line, histdata_t $data )
    returns HIST_ENTRY {
      replace_history_entry( $which, $line, $data ) }

  # Clear the history list and start over.
  #
  sub clear_history( )
    is native( LIB ) { * }
  method clear-history( ) {
    clear_history() }

  # Stifle the history list, remembering only MAX number of entries.
  #
  sub stifle_history( Int $max )
    is native( LIB ) { * }
  method stifle-history( Int $max ) {
    stifle_history( $max ) }

  # Stop stifling the history.  This returns the previous amount the
  # history was stifled by.  The value is positive if the history was
  # stifled, negative if it wasn't.
  #
  sub unstifle_history( )
    is native( LIB ) { * }
  method unstifle-history( ) {
    unstifle_history() }

  # Return 1 if the history is stifled, 0 if it is not.
  #
  sub history_is_stifled( ) returns Int
    is native( LIB ) { * }
  method history-is-stifled( ) returns Bool {
    history_is_stifled() ?? True !! False }

  # Information about the history list.
  #
  # Return a NULL terminated array of HIST_ENTRY which is the current input
  # history.  Element 0 of this list is the beginning of time.  If there
  # is no history, return NULL.
  #extern HIST_ENTRY **history_list (void);

  # Returns the number which says what history element we are now
  # looking at.
  #  
  sub where_history( ) returns Int
    is native( LIB ) { * }
  method where-history( ) returns Int {
    where_history() }

  # Return the history entry at the current position, as determined by
  # history_offset.  If there is no entry there, return a NULL pointer.
  #
  sub current_history( Int $which ) returns HIST_ENTRY
    is native( LIB ) { * }
  method current-history( Int $which ) returns HIST_ENTRY {
    current_history( $which ) }

  # Return the history entry which is logically at OFFSET in the history
  # array.  OFFSET is relative to history_base.
  #
  sub history_get( Int $which ) returns HIST_ENTRY
    is native( LIB ) { * }
  method history-get( Int $which ) returns HIST_ENTRY {
    history_get( $which ) }

  class time_t is repr('CPointer') { } # XXX probably already a native type.

  # Return the timestamp associated with the HIST_ENTRY * passed as an
  # argument.
  #
  sub history_get_time( HIST_ENTRY ) returns time_t
    is native( LIB ) { * }
  method history-get-time( HIST_ENTRY $h ) returns time_t {
    history_get_time( $h ) }

  # Return the number of bytes that the primary history entries are using.
  # This just adds up the lengths of the_history->lines.
  #
  sub history_total_bytes( ) returns Int
    is native( LIB ) { * }
  method history-total-bytes( ) returns Int {
    history_total_bytes( ) }

  # Moving around the history list.
  #
  # Set the position in the history list to POS.
  #
  sub history_set_pos( Int $pos ) returns Int
    is native( LIB ) { * }
  method history-set-pos( Int $pos ) returns Int {
    history_set_pos( $pos ) }

  # Back up history_offset to the previous history entry, and return
  # a pointer to that entry.  If there is no previous entry, return
  # a NULL pointer.
  #
  sub previous_history( ) returns HIST_ENTRY
    is native( LIB ) { * }
  method previous-history( ) returns HIST_ENTRY {
    previous_history( ) }

  # Move history_offset forward to the next item in the input_history,
  # and return the a pointer to that entry.  If there is no next entry,
  # return a NULL pointer.
  #
  sub next_history( ) returns HIST_ENTRY
    is native( LIB ) { * }
  method next-history( ) returns HIST_ENTRY {
    next_history( ) }

  # Searching the history list.
  #
  # Search the history for STRING, starting at history_offset.
  # If DIRECTION < 0, then the search is through previous entries,
  # else through subsequent.  If the string is found, then
  # current_history () is the history entry, and the value of this function
  # is the offset in the line of that history entry that the string was
  # found in.  Otherwise, nothing is changed, and a -1 is returned.
  #
  sub history_search( Str $text, Int $pos ) returns Int
    is native( LIB ) { * }
  method history-search( Str $text, Int $pos ) returns Int {
    history_search( $text, $pos ) }

  # Search the history for STRING, starting at history_offset.
  # The search is anchored: matching lines must begin with string.
  # DIRECTION is as in history_search().
  #
  sub history_search_prefix( Str $text, Int $pos ) returns Int
    is native( LIB ) { * }
  method history-search-prefix( Str $text, Int $pos ) returns Int {
    history_search_prefix( $text, $pos ) }

  # Search for STRING in the history list, starting at POS, an
  # absolute index into the list.  DIR, if negative, says to search
  # backwards from POS, else forwards.
  # Returns the absolute index of the history element where STRING
  # was found, or -1 otherwise.
  #
  sub history_search_pos( Str $text, Int $pos, Int $dir ) returns Int
    is native( LIB ) { * }
  method history-search-pos( Str $text, Int $pos, Int $dir ) returns Int {
    history_search_pos( $text, $pos, $dir ) }

  # Managing the history file.
  #
  # Add the contents of FILENAME to the history list, a line at a time.
  # If FILENAME is NULL, then read from ~/.history.  Returns 0 if
  # successful, or errno if not.
  #
  sub read_history( Str $text ) returns Int
    is native( LIB ) { * }
  method read-history( Str $text ) returns Int {
    my $rv = read_history( $text );
    $rv == 0 ?? True !! $rv }

  # Read a range of lines from FILENAME, adding them to the history list.
  # Start reading at the FROM'th line and end at the TO'th.  If FROM
  # is zero, start at the beginning.  If TO is less than FROM, read
  # until the end of the file.  If FILENAME is NULL, then read from
  # ~/.history.  Returns 0 if successful, or errno if not.
  #
  sub read_history_range( Str $text, Int $from, Int $to ) returns Int
    is native( LIB ) { * }
  method read-history-range( Str $text, Int $from, Int $to ) returns Int {
    read_history_range( $text, $from, $to ) }

  # Write the current history to FILENAME.  If FILENAME is NULL,
  # then write the history list to ~/.history.  Values returned
  # are as in read_history ().
  #
  sub write_history( Str $filename ) returns Int
    is native( LIB ) { * }
  method write-history( Str $filename ) returns Int {
    my $rv = write_history( $filename );
    $rv == 0 ?? True !! $rv }

  # Append NELEMENT entries to FILENAME.  The entries appended are from
  # the end of the list minus NELEMENTs up to the end of the list.
  #
  sub append_history( Int $offset, Str $filename ) returns Int
    is native( LIB ) { * }
  method append-history( Int $offset, Str $filename ) returns Int {
    append_history( $offset, $filename ) }

  # Truncate the history file, leaving only the last NLINES lines.
  #
  sub history_truncate_file( Str $filename, Int $lines ) returns Int
    is native( LIB ) { * }
  method history-truncate-file( Str $filename, Int $lines ) returns Int {
    my $rv = history_truncate_file( $filename, $lines );
    $rv == 0 ?? True !! $rv }

  # History expansion.
  #
  # Expand the string STRING, placing the result into OUTPUT, a pointer
  # to a string.  Returns:
  #
  # 0) If no expansions took place (or, if the only change in
  #    the text was the de-slashifying of the history expansion
  #    character)
  # 1) If expansions did take place
  #-1) If there was an error in expansion.
  # 2) If the returned line should just be printed.
  #
  # If an error occurred in expansion, then OUTPUT contains a descriptive
  # error message.
  #
  #extern int history_expand (char *, char **);

  # Extract a string segment consisting of the FIRST through LAST
  # arguments present in STRING.  Arguments are broken up as in
  # the shell.
  #
  sub history_arg_extract( Int $first, Int $last, Str $string ) returns Str
    is native( LIB ) { * }
  method history-arg-extract( Int $first, Int $last, Str $string ) returns Str {
    history_arg_extract( $first, $last, $string ) }

  # Return the text of the history event beginning at the current
  # offset into STRING.  Pass STRING with *INDEX equal to the
  # history_expansion_char that begins this specification.
  # DELIMITING_QUOTE is a character that is allowed to end the string
  # specification for what to search for in addition to the normal
  # characters `:', ` ', `\t', `\n', and sometimes `?'.
  #
  #extern char *get_history_event (const char *, int *, int);

  # Return an array of tokens, much as the shell might.  The tokens are
  # parsed out of STRING.
  #
  #extern char **history_tokenize (const char *);

  # Exported history variables.
  #extern int history_base;
  #extern int history_length;
  #extern int history_max_entries;
  #extern char history_expansion_char;
  #extern char history_subst_char;
  #extern char *history_word_delimiters;
  #extern char history_comment_char;
  #extern char *history_no_expand_chars;
  #extern char *history_search_delimiter_chars;
  #extern int history_quotes_inhibit_expansion;

  #extern int history_write_timestamps;

  # Backwards compatibility 
  #
  #extern int max_input_history;

  # If set, this function is called to decide whether or not a particular
  # history expansion should be treated as a special case for the calling
  # application and not expanded.
  #
  #extern rl_linebuf_func_t *history_inhibit_expansion_function;

  #############################################################################
  #
  # keymaps.h -- Manipulation of readline keymaps.
  #
  # A keymap contains one entry for each key in the ASCII set.
  # Each entry consists of a type and a pointer.
  # FUNCTION is the address of a function to run, or the
  # address of a keymap to indirect through.
  # TYPE says which kind of thing FUNCTION is.
  #
  class rl_command_func_t is repr('CPointer') { } #typedef int rl_command_func_t (int, int);

  class _keymap_entry is repr('CPointer') { } # is KEYMAP_ENTRY
  class KEYMAP_ENTRY is repr('CStruct') {
    has byte              $.type;     # char type;
    has rl_command_func_t $.function; # rl_command_func_t *function
  }

  # This must be large enough to hold bindings for all of the characters
  # in a desired character set (e.g, 128 for ASCII, 256 for ISO Latin-x,
  # and so on) plus one for subsequence matching.
  #
  constant KEYMAP_SIZE = 257;
  constant ANYOTHERKEY = KEYMAP_SIZE - 1;

  #typedef KEYMAP_ENTRY KEYMAP_ENTRY_ARRAY[KEYMAP_SIZE];
  class Keymap is repr('CPointer') { } #typedef KEYMAP_ENTRY *Keymap;
  #
  # The values that TYPE can have in a keymap entry.
  #
  constant ISFUNC = 0;
  constant ISKMAP = 1;
  constant ISMACR = 2;

  #extern KEYMAP_ENTRY_ARRAY emacs_standard_keymap, emacs_meta_keymap;
  #extern KEYMAP_ENTRY emacs_ctlx_keymap;
  #extern KEYMAP_ENTRY_ARRAY vi_insertion_keymap, vi_movement_keymap;

  # Return a new, empty keymap.
  # Free it with free() when you are done.
  #
  sub rl_make_bare_keymap( ) returns Keymap
    is native( LIB ) { * }
  method rl-make-bare-keymap( ) returns Keymap {
    rl_make_bare_keymap( ) }

  # Return a new keymap which is a copy of MAP.
  #
  sub rl_copy_keymap( Keymap ) returns Keymap
    is native( LIB ) { * }
  method rl-copy-keymap( Keymap $k ) returns Keymap {
    rl_copy_keymap( $k ) }

  # Return a new keymap with the printing characters bound to rl_insert,
  # the lowercase Meta characters bound to run their equivalents, and
  # the Meta digits bound to produce numeric arguments.
  #
  sub rl_make_keymap( ) returns Keymap
    is native( LIB ) { * }
  method rl-make-keymap( ) returns Keymap {
    rl_make_keymap( ) }

  # Free the storage associated with a keymap.
  #
  sub rl_discard_keymap( Keymap )
    is native( LIB ) { * }
  method rl-discard-keymap( Keymap $k ) {
    rl_discard_keymap( $k ) }

  sub rl_free_keymap( Keymap )
    is native( LIB ) { * }
  method rl-free-keymap( Keymap $k ) {
    rl_free_keymap( $k ) }

  # These functions actually appear in bind.c
  #
  # Return the keymap corresponding to a given name.  Names look like
  # `emacs' or `emacs-meta' or `vi-insert'.
  #
  sub rl_get_keymap_by_name( Str ) returns Keymap
    is native( LIB ) { * }
  method rl-get-keymap-by-name( Str $name ) returns Keymap {
    rl_get_keymap_by_name( $name ) }

  # Return the current keymap.
  #
  sub rl_get_keymap( ) returns Keymap
    is native( LIB ) { * }
  method rl-get-keymap( ) returns Keymap {
    rl_get_keymap( ) }

  # Get the name of an existing keymap
  #
  sub rl_get_keymap_name( Keymap ) returns Str
    is native( LIB ) { * }
  method rl-get-keymap-name( Keymap $k ) returns Str {
    rl_get_keymap_name( $k ) }

  # Set the current keymap to MAP.
  #
  sub rl_set_keymap( Keymap )
    is native( LIB ) { * }
  method rl-set-keymap( Keymap $k ) {
    rl_set_keymap( $k ) }

  #############################################################################
  #
  # Readline.h -- the names of functions callable from within readline.
  #
  # Readline data structures.
  #
  # Maintaining the state of undo.  We remember individual deletes and inserts
  # on a chain of things to do.
  #
  # The actions that undo knows how to undo.  Notice that UNDO_DELETE means
  # to insert some text, and UNDO_INSERT means to delete some text.   I.e.,
  # the code tells undo what to undo, not how to undo it.
  #
  #enum undo_code { UNDO_DELETE, UNDO_INSERT, UNDO_BEGIN, UNDO_END };

  constant UNDO_DELETE = 0;
  constant UNDO_INSERT = 1;
  constant UNDO_BEGIN  = 2;
  constant UNDO_END    = 3;

  # What an element of THE_UNDO_LIST looks like.
  #
  class undo_list is repr('CPointer') { } # is a UNDO_LIST
  class UNDO_LIST is repr('CStruct') {
    has Pointer $.next; # struct undo_list *next;
    has int $.start;    # int start; # Where the change took place.
    has int $.end;      # int end;
    has Str $.text;     # char *text; # The text to insert, if undoing a delete
    has byte $.what;    # enum undo_code what; # Delete, Insert, Begin, End.
  }

  # The current undo list for RL_LINE_BUFFER.
  #
  #extern UNDO_LIST *rl_undo_list;

  # The data structure for mapping textual names to code addresses.
  #
  class _funmap is repr('CPointer') { } # is a FUNMAP
  class FUNMAP is repr('CStruct') {
    has Str     $.name;     # const char *name;
    has Pointer $.function; # rl_command_func_t *function;
  }

  #extern FUNMAP **funmap;

  # Bindable commands for numeric arguments.
  #
  # These should only be passed as callbacks, I believe.
  #
  sub rl_digit_argument( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_universal_argument( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for moving the cursor.
  #
  sub rl_forward_byte( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward_char( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_byte( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_char( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_beg_of_line( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_end_of_line( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_refresh_line( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_clear_screen( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_skip_csi_sequence( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_arrow_keys( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for inserting and deleting text.
  #
  sub rl_insert( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_quoted_insert( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_tab_insert( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_newline( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_do_lowercase_version( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_rubout( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_delete( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_rubout_or_delete( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_delete_horizontal_space( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_delete_or_show_completions( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_insert_comment( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for changing case.
  #
  sub rl_upcase_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_downcase_word( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_capitalize_word( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for transposing characters and words.
  #
  sub rl_transpose_words( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_transpose_chars( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for searching within a line.
  #
  sub rl_char_search( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_char_search( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for readline's interface to the command history.
  #
  sub rl_beginning_of_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_end_of_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_get_next_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_get_previous_history ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for managing the mark and region.
  #
  sub rl_set_mark ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_exchange_point_and_mark ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands to set the editing mode (emacs or vi).
  #
  sub rl_vi_editing_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_emacs_editing_mode ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands to change the insert mode (insert or overwrite)
  #
  sub rl_overwrite_mode ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for managing key bindings.
  #
  sub rl_re_read_init_file ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_dump_functions ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_dump_macros ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_dump_variables ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for word completion.
  #
  sub rl_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_possible_completions ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_insert_completions ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_old_menu_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_menu_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_menu_complete ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for killing and yanking text, and managing the kill ring.
  #
  sub rl_kill_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_kill_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_kill_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_backward_kill_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_kill_full_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_unix_word_rubout ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_unix_filename_rubout ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_unix_line_discard ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_copy_region_to_kill ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_kill_region ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_copy_forward_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_copy_backward_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank_pop ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank_nth_arg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_yank_last_arg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_paste_from_clipboard ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for incremental searching.
  #
  sub rl_reverse_search_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_forward_search_history ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable keyboard macro commands.
  #
  sub rl_start_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_end_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_call_last_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_print_last_kbd_macro ( Int, Int ) returns Int is native( LIB ) { * }
  #
  # Bindable undo commands.
  #
  sub rl_revert_line ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_undo_command ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable tilde expansion commands.
  #
  sub rl_tilde_expand ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable terminal control commands.
  #
  sub rl_restart_output ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_stop_output ( Int, Int ) returns Int is native( LIB ) { * }

  # Miscellaneous bindable commands.
  #
  sub rl_abort ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_tty_status ( Int, Int ) returns Int is native( LIB ) { * }

  # Bindable commands for incremental and non-incremental history searching.
  #
  sub rl_history_search_forward ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_history_search_backward ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_history_substr_search_forward ( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_history_substr_search_backward ( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_noninc_forward_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_noninc_reverse_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_noninc_forward_search_again ( Int, Int ) returns Int
    is native( LIB ) { * }
  sub rl_noninc_reverse_search_again ( Int, Int ) returns Int
    is native( LIB ) { * }

  # Bindable command used when inserting a matching close character.
  #
  sub rl_insert_close ( Int, Int ) returns Int is native( LIB ) { * }

  # Not available unless READLINE_CALLBACKS is defined.
  #
  class rl_vcpfunc_t is repr('CPointer') { } #typedef void rl_vcpfunc_t (char *);

  sub rl_callback_handler_install( Str, rl_vcpfunc_t )
    is native( LIB ) { * }
  method rl-callback-handler-install( Str $s, rl_vcpfunc_t $cb ) {
    rl_callback_handler_install( $s, $cb ) }

  sub rl_callback_read_char( )
    is native( LIB ) { * }
  method rl-callback-read-char( ) {
    rl_callback_read_char( ) }
 
  sub rl_callback_handler_remove( )
    is native( LIB ) { * }
  method rl-callback-handler-remove( ) {
    rl_callback_handler_remove( ) }

  # Things for vi mode. Not available unless readline is compiled -DVI_MODE.
  #
  # VI-mode bindable commands.
  #
  sub rl_vi_redo ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_undo ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_yank_arg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_fetch_history ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_search_again ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_complete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_tilde_expand ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_prev_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_next_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_end_word ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_insert_beg ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_append_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_append_eol ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_eof_maybe ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_insertion_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_insert_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_movement_mode ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_arg_digit ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_change_case ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_put ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_column ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_delete_to ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_change_to ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_yank_to ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_rubout ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_delete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_back_to_indent ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_first_print ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_char_search ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_match ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_change_char ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_subst ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_overstrike ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_overstrike_delete ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_replace ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_set_mark ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_goto_mark ( Int, Int ) returns Int is native( LIB ) { * }

  # VI-mode utility functions.
  #
  sub rl_vi_check( ) returns Int
    is native( LIB ) { * }
  method rl-vi-check( ) returns Int {
    rl_vi_check() }

  #extern int rl_vi_domove (int, int *);

  sub rl_vi_bracktype( Int $t ) returns Int
    is native( LIB ) { * }
  method rl-vi-bracktype( Int $t ) returns Int {
    rl_vi_bracktype( $t ) }

  sub rl_vi_start_inserting( Int $t, Int $u, Int $v ) returns Int
    is native( LIB ) { * }
  method rl-vi-start-inserting( Int $t, Int $u, Int $v ) returns Int {
    rl_vi_start_inserting( $t, $u, $v ) }

  # VI-mode pseudo-bindable commands, used as utility functions.
  #
  sub rl_vi_fWord ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_bWord ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_eWord ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_fword ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_bword ( Int, Int ) returns Int is native( LIB ) { * }
  sub rl_vi_eword ( Int, Int ) returns Int is native( LIB ) { * }

  ###################################################################
  #								    #
  #			Well Published Functions		    #
  #								    #
  ###################################################################
  #
  # Readline functions.
  #
  # Read a line of input.  Prompt with PROMPT.  A NULL PROMPT means none.
  #
  sub readline( Str $prompt ) returns Str
    is native( LIB ) { * }
  method readline( Str $prompt ) returns Str {
    readline( $prompt ) }

  sub rl_set_prompt( Str $prompt ) returns Int
    is native( LIB ) { * }
  method rl-set-prompt( Str $prompt ) returns Int {
    rl_set_prompt( $prompt ) }

  sub rl_expand_prompt( Str $prompt ) returns Int
    is native( LIB ) { * }
  method rl-expand-prompt( Str $prompt ) returns Int {
    rl_expand_prompt( $prompt ) }

  sub rl_initialize( ) returns Int
    is native( LIB ) { * }
  method rl-initialize( ) returns Int {
    rl_initialize( ) }

  # Utility functions to bind keys to readline commands.
  #
  sub rl_bind_key( Int, rl_command_func_t ) returns Int
    is native( LIB ) { * }
  method rl-bind-key( Int $i, rl_command_func_t $cb ) returns Int {
    rl_bind_key( $i, $cb ) }

  sub rl_bind_key_in_map( Int, rl_command_func_t, Keymap ) returns Int
    is native( LIB ) { * }
  method rl-bind-key-in-map( Int $i, rl_command_func_t $cb, Keymap $k )
    returns Int {
    rl_bind_key_in_map( $i, $cb, $k ) }

  sub rl_unbind_key( Int ) returns Int
    is native( LIB ) { * }
  method rl-unbind-key( Int $i ) returns Int {
    rl_unbind_key( $i ) }

  sub rl_unbind_key_in_map( Int, Keymap ) returns Int
    is native( LIB ) { * }
  method rl-unbind-key-in-map( Int $i, Keymap $k ) returns Int {
    rl_unbind_key_in_map( $i, $k ) }

  sub rl_bind_key_if_unbound( Int, rl_command_func_t ) returns Int
    is native( LIB ) { * }
  method rl-bind-key-if-unbound( Int $i, rl_command_func_t $cb ) returns Int {
    rl_bind_key_if_unbound( $i, $cb ) }

  sub rl_bind_key_if_unbound_in_map( Int, rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-bind-key-if-unbound-in-map
    ( Int $i, rl_command_func_t $cb, Keymap $k ) returns Int {
      rl_bind_key_if_unbound_in_map( $i, $cb, $k ) }

  sub rl_unbind_function_in_map( rl_command_func_t, Keymap ) returns Int
    is native( LIB ) { * }
  method rl-unbind-function-in-map ( rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_unbind_function_in_map( $cb, $k ) }

  sub rl_bind_keyseq( Str, rl_command_func_t ) returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq( Str $str, rl_command_func_t $cb )
    returns Int {
      rl_bind_keyseq( $str, $cb ) }

  sub rl_bind_keyseq_in_map( Str, rl_command_func_t, Keymap ) returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq-in-map( Str $str, rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_bind_keyseq_in_map( $str, $cb, $k ) }

  sub rl_bind_keyseq_if_unbound( Str, rl_command_func_t ) returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq-if-unbound( Str $str, rl_command_func_t $cb )
   returns Int {
    rl_bind_keyseq_if_unbound( $str, $cb ) }

  sub rl_bind_keyseq_if_unbound_in_map( Str, rl_command_func_t, Keymap )
    returns Int
    is native( LIB ) { * }
  method rl-bind-keyseq-if-unbound-in-map
    ( Str $str, rl_command_func_t $cb, Keymap $k ) returns Int {
      rl_bind_keyseq_if_unbound_in_map( $str, $cb, $k ) }

  sub rl_generic_bind( Int, Str, Str, Keymap ) returns Int
    is native( LIB ) { * }
  method rl-generic-bind( Int $i, Str $s, Str $t, Keymap $k ) returns Int {
    rl_generic_bind( $i, $s, $t, $k ) }


  sub rl_add_defun( Str, rl_command_func_t, Int ) returns Int
    is native( LIB ) { * }
  method rl-add-defun( Str $str, rl_command_func_t $cb, Int $i ) returns Int {
    rl_add_defun( $str, $cb, $i ) }

  sub rl_variable_value( Str $s ) returns Str
    is native( LIB ) { * }
  method rl-variable-value( Str $s ) returns Str {
    rl_variable_value( $s ) }

  sub rl_variable_bind( Str $s, Str $t ) returns Int
    is native( LIB ) { * }
  method rl-variable-bind( Str $s, Str $t ) returns Int {
    rl_variable_bind( $s, $t ) }

  # Backwards compatibility, use rl_bind_keyseq_in_map instead.
  #
  sub rl_set_key( Str, rl_command_func_t, Keymap ) returns Int
    is native( LIB ) { * }
  method rl-set-key( Str $str, rl_command_func_t $cb, Keymap $k )
    returns Int {
      rl_set_key( $str, $cb, $k ) }

  # Backwards compatibility, use rl_generic_bind instead.
  #
  sub rl_macro_bind( Str, Str, Keymap ) returns Int
    is native( LIB ) { * }
  method rl-macro-bind( Str $str, Str $b, Keymap $k ) returns Int {
    rl_macro_bind( $str, $b, $k ) }

  # Undocumented in the texinfo manual; not really useful to programs.
  #
  #extern int rl_translate_keyseq (const char *, char *, int *);
  #extern char *rl_untranslate_keyseq (int);

  #extern rl_command_func_t *rl_named_function (const char *);
  #extern rl_command_func_t *rl_function_of_keyseq (const char *, Keymap, int *);

  #extern void rl_list_funmap_names (void);
  #extern char **rl_invoking_keyseqs_in_map (rl_command_func_t *, Keymap);
  #extern char **rl_invoking_keyseqs (rl_command_func_t *);

  sub rl_function_dumper( Int $i )
    is native( LIB ) { * }
  method rl-function-dumper( Int $i ) {
    rl_function_dumper( $i ) }

  sub rl_macro_dumper( Int $i )
    is native( LIB ) { * }
  method rl-macro-dumper( Int $i ) {
    rl_macro_dumper( $i ) }

  sub rl_variable_dumper( Int $i )
    is native( LIB ) { * }
  method rl-variable-dumper( Int $i ) {
    rl_variable_dumper( $i ) }

  sub rl_read_init_file( Str $name )
    is native( LIB ) { * }
  method rl-read-init-file( Str $name ) {
    rl_read_init_file( $name ) }

  sub rl_parse_and_bind( Str $name ) returns Int
    is native( LIB ) { * }
  method rl-parse-and-bind( Str $name ) returns Int {
    rl_parse_and_bind( $name ) }

  # Functions for manipulating the funmap, which maps command names
  # to functions.
  #
  #extern int rl_add_funmap_entry (const char *, rl_command_func_t *);
  #extern const char **rl_funmap_names (void);

  # Utility functions for managing keyboard macros.
  #
  sub rl_push_macro_input( Str $name )
    is native( LIB ) { * }
  method rl-push-macro-input( Str $name ) {
    rl_push_macro_input( $name ) }

  # Functions for undoing, from undo.c
  #
  #extern void rl_add_undo (enum undo_code, int, int, char *);

  sub rl_free_undo_list( )
    is native( LIB ) { * }
  method rl-free-undo-list( ) {
    rl_free_undo_list( ) }

  sub rl_do_undo( ) returns Int
    is native( LIB ) { * }
  method rl-do-undo( ) returns Int {
    rl_do_undo( ) }

  sub rl_begin_undo_group( ) returns Int
    is native( LIB ) { * }
  method rl-begin-undo-group( ) returns Int {
    rl_begin_undo_group( ) }

  sub rl_end_undo_group( ) returns Int
    is native( LIB ) { * }
  method rl-end-undo-group( ) returns Int {
    rl_end_undo_group( ) }

  sub rl_modifying( Int $i, Int $j ) returns Int
    is native( LIB ) { * }
  method rl-modifying( Int $i, Int $j ) returns Int {
    rl_modifying( $i, $j ) }

  # Functions for redisplay.
  #
  sub rl_redisplay( )
    is native( LIB ) { * }
  method rl-redisplay( ) {
    rl_redisplay( ) }

  sub rl_on_new_line( ) returns Int
    is native( LIB ) { * }
  method rl-on-new-line( ) returns Int {
    rl_on_new_line( ) }

  sub rl_on_new_line_with_prompt( ) returns Int
    is native( LIB ) { * }
  method rl-on-new-line-with-prompt( ) returns Int {
    rl_on_new_line_with_prompt( ) }

  sub rl_forced_update_display( ) returns Int
    is native( LIB ) { * }
  method rl-forced-update-display( ) returns Int {
    rl_forced_update_display( ) }

  sub rl_clear_message( ) returns Int
    is native( LIB ) { * }
  method rl-clear-message( ) returns Int {
    rl_clear_message( ) }

  sub rl_reset_line_state( ) returns Int
    is native( LIB ) { * }
  method reset_line_state( ) returns Int {
    rl_reset_line_state( ) }

  sub rl_crlf( ) returns Int
    is native( LIB ) { * }
  method rl-crlf( ) returns Int {
    rl_crlf( ) }

  #extern int rl_message (const char *, ...)  __rl_attribute__((__format__ (printf, 1, 2));

  sub rl_show_char( Int $c ) returns Int
    is native( LIB ) { * }
  method rl-show-char( Int $c ) returns Int {
    rl_show_char( $c ) }

  # Undocumented in texinfo manual.
  #
  sub rl_character_len( Int $c, Int $d ) returns Int
    is native( LIB ) { * }
  method rl-character-len( Int $c, Int $d ) returns Int {
    rl_character_len( $c, $d ) }

  # Save and restore internal prompt redisplay information.
  #
  sub rl_save_prompt( )
    is native( LIB ) { * }
  method rl-save-prompt( ) {
    rl_save_prompt( ) }

  sub rl_restore_prompt( )
    is native( LIB ) { * }
  method rl-restore-prompt( ) {
    rl_restore_prompt( ) }

  # Modifying text.
  #
  sub rl_replace_line( Str $text, Int $i )
    is native( LIB ) { * }
  method rl-replace-line( Str $text, Int $i ) {
    rl_replace_line( $text, $i ) }

  sub rl_insert_text( Str $text ) returns Int
    is native( LIB ) { * }
  method rl-insert-text( Str $text ) returns Int {
    rl_insert_text( $text ) }

  sub rl_delete_text( Int $a, Int $b ) returns Int
    is native( LIB ) { * }
  method rl-delete-text( Int $a, Int $b ) returns Int {
    rl_delete_text( $a, $b ) }

  sub rl_kill_text( Int $a, Int $b ) returns Int
    is native( LIB ) { * }
  method rl-kill-text( Int $a, Int $b ) returns Int {
    rl_kill_text( $a, $b ) }

  sub rl_copy_text( Int $a, Int $b ) returns Str
    is native( LIB ) { * }
  method rl-copy-text( Int $a, Int $b ) returns Str {
    rl_copy_text( $a, $b ) }

  # Terminal and tty mode management.
  #
  sub rl_prep_terminal( Int )
    is native( LIB ) { * }
  method rl-prep-terminal( Int $i ) {
    rl_prep_terminal( $i ) }

  sub rl_deprep_terminal( )
    is native( LIB ) { * }
  method rl-deprep-terminal( ) {
    rl_deprep_terminal( ) }

  sub rl_tty_set_default_bindings( Keymap )
    is native( LIB ) { * }
  method rl-tty-set-default-bindings( Keymap $k ) {
    rl_tty_set_default_bindings ( $k ) }

  sub rl_tty_unset_default_bindings ( Keymap )
    is native( LIB ) { * }
  method rl-tty-unset-default-bindings( Keymap $k ) {
    rl_tty_unset_default_bindings ( $k ) }

  #extern int rl_reset_terminal (const char *);
  #extern void rl_resize_terminal (void);
  #extern void rl_set_screen_size (int, int);
  #extern void rl_get_screen_size (int *, int *);
  #extern void rl_reset_screen_size (void);

  sub rl_get_termcap( Str $c ) returns Str
    is native( LIB ) { * }
  method rl-get-termcap( Str $c ) returns Str {
    rl_get_termcap( $c ) }

  # Functions for character input.
  #
  #extern int rl_stuff_char (int);
  #extern int rl_execute_next (int);
  #extern int rl_clear_pending_input (void);
  #extern int rl_read_key (void);
  #extern int rl_getc (FILE *);
  #extern int rl_set_keyboard_input_timeout (int);

  # `Public' utility functions.
  #
  sub rl_extend_line_buffer( Int $c )
    is native( LIB ) { * }
  method rl-extend-line-buffer( Int $c ) {
    rl_extend_line_buffer( $c ) }

  sub rl_ding( ) returns Int
    is native( LIB ) { * }
  method rl-ding( ) returns Int {
    rl_ding( ) }

  sub rl_alphabetic( Int $c ) returns Int
    is native( LIB ) { * }
  method rl-alphabetic( Int $c ) returns Int {
    rl_alphabetic( $c ) }

  sub rl_free( Pointer $p )
    is native( LIB ) { * }
  method rl-free( Pointer $p ) {
    rl_free( $p ) }

  # Readline signal handling, from signals.c
  #
  sub rl_set_signals( ) returns Int
    is native( LIB ) { * }
  method rl-set-signals( ) returns Int {
    rl_set_signals( ) }

  sub rl_clear_signals( ) returns Int
    is native( LIB ) { * }
  method rl-clear-signals( ) returns Int {
    rl_clear_signals( ) }

  sub rl_cleanup_after_signal( )
    is native( LIB ) { * }
  method rl-cleanup-after-signal( ) {
    rl_cleanup_after_signal( ) }

  sub rl_reset_after_signal( )
    is native( LIB ) { * }
  method rl-reset-after-signal( ) {
    rl_reset_after_signal( ) }

  sub rl_free_line_state( )
    is native( LIB ) { * }
  method rl-free-line-state( ) {
    rl_free_line_state( ) }

  sub rl_echo_signal( Int $c )
    is native( LIB ) { * }
  method rl-echo-signal( Int $c ) {
    rl_echo_signal( $c ) }

  sub rl_set_paren_blink_timeout( Int $c ) returns Int
    is native( LIB ) { * }
  method rl-set-paren-blink-timeout( Int $c ) returns Int {
    rl_set_paren_blink_timeout( $c ) }

  # Completion functions.
  #
  #extern int rl_complete_internal (int);
  #extern void rl_display_match_list (char **, int, int);

  #extern char **rl_completion_matches (const char *, rl_compentry_func_t *);
  #extern char *rl_username_completion_function (const char *, int);
  #extern char *rl_filename_completion_function (const char *, int);

  #extern int rl_completion_mode (rl_command_func_t *);

  ############################################################
  #  							     #
  #  		Well Published Variables		     #
  #  							     #
  ############################################################
  #
  # The version of this incarnation of the readline library.
  #
  #extern const char *rl_library_version;	/* e.g., "4.2" */
  #extern int rl_readline_version;		/* e.g., 0x0402 */

  # True if this is real GNU readline.
  #
  #extern int rl_gnu_readline_p;

  # Flags word encapsulating the current readline state.
  #
  #extern int rl_readline_state;

  # Says which editing mode readline is currently using.  1 means emacs mode;
  # 0 means vi mode.
  #
  #extern int rl_editing_mode;

  # Insert or overwrite mode for emacs mode.  1 means insert mode; 0 means
  # overwrite mode.  Reset to insert mode on each input line.
  #
  #extern int rl_insert_mode;

  # The name of the calling program.  You should initialize this to
  # whatever was in argv[0].  It is used when parsing conditionals.
  #
  #extern const char *rl_readline_name;

  # The prompt readline uses.  This is set from the argument to
  # readline (), and should not be assigned to directly.
  #
  #extern char *rl_prompt;

  # The prompt string that is actually displayed by rl_redisplay.  Public so
  # applications can more easily supply their own redisplay functions.
  #
  #extern char *rl_display_prompt;

  # The line buffer that is in use.
  #
  #extern char *rl_line_buffer;

  # The location of point, and end.
  #
  #extern int rl_point;
  #extern int rl_end;

  # The mark, or saved cursor position.
  #
  #extern int rl_mark;

  # Flag to indicate that readline has finished with the current input
  # line and should return it.
  #
  #extern int rl_done;

  # If set to a character value, that will be the next keystroke read.
  #
  #extern int rl_pending_input;

  # Non-zero if we called this function from _rl_dispatch().  It's present
  # so functions can find out whether they were called from a key binding
  # or directly from an application.
  #
  #extern int rl_dispatching;

  # Non-zero if the user typed a numeric argument before executing the
  # current function.
  #
  #extern int rl_explicit_arg;

  # The current value of the numeric argument specified by the user.
  #
  #extern int rl_numeric_arg;

  # The address of the last command function Readline executed.
  #
  #extern rl_command_func_t *rl_last_func;

  # The name of the terminal to use.
  #
  #extern const char *rl_terminal_name;

  # The input and output streams.
  #
  #extern FILE *rl_instream;
  #extern FILE *rl_outstream;

  # If non-zero, Readline gives values of LINES and COLUMNS from the environment
  # greater precedence than values fetched from the kernel when computing the
  # screen dimensions.
  #
  #extern int rl_prefer_env_winsize;

  # If non-zero, then this is the address of a function to call just
  # before readline_internal () prints the first prompt.
  #
  #extern rl_hook_func_t *rl_startup_hook;

  # If non-zero, this is the address of a function to call just before
  # readline_internal_setup () returns and readline_internal starts
  # reading input characters.
  #
  #extern rl_hook_func_t *rl_pre_input_hook;

  # The address of a function to call periodically while Readline is
  # awaiting character input, or NULL, for no event handling.
  #
  #extern rl_hook_func_t *rl_event_hook;

  # The address of a function to call if a read is interrupted by a signal.
  #
  #extern rl_hook_func_t *rl_signal_event_hook;

  # The address of a function to call if Readline needs to know whether or not
  # there is data available from the current input source.
  #
  #extern rl_hook_func_t *rl_input_available_hook;

  # The address of the function to call to fetch a character from the current
  # Readline input stream.
  #
  #extern rl_getc_func_t *rl_getc_function;

  #extern rl_voidfunc_t *rl_redisplay_function;

  #extern rl_vintfunc_t *rl_prep_term_function;
  #extern rl_voidfunc_t *rl_deprep_term_function;

  # Dispatch variables.
  #
  #extern Keymap rl_executing_keymap;
  #extern Keymap rl_binding_keymap;

  #extern int rl_executing_key;
  #extern char *rl_executing_keyseq;
  #extern int rl_key_sequence_length;

  # Display variables.
  #
  # If non-zero, readline will erase the entire line, including any prompt,
  # if the only thing typed on an otherwise-blank line is something bound to
  # rl_newline.
  #
  #extern int rl_erase_empty_line;

  # If non-zero, the application has already printed the prompt (rl_prompt)
  # before calling readline, so readline should not output it the first time
  # redisplay is done.
  #
  #extern int rl_already_prompted;

  # A non-zero value means to read only this many characters rather than
  # up to a character bound to accept-line.
  #
  #extern int rl_num_chars_to_read;

  # The text of a currently-executing keyboard macro.
  #
  #extern char *rl_executing_macro;

  # Variables to control readline signal handling.
  #
  # If non-zero, readline will install its own signal handlers for
  # SIGINT, SIGTERM, SIGQUIT, SIGALRM, SIGTSTP, SIGTTIN, and SIGTTOU.
  #
  #extern int rl_catch_signals;

  # If non-zero, readline will install a signal handler for SIGWINCH
  # that also attempts to call any calling application's SIGWINCH signal
  # handler.  Note that the terminal is not cleaned up before the
  # application's signal handler is called; use rl_cleanup_after_signal()
  # to do that.
  #
  #extern int rl_catch_sigwinch;

  # If non-zero, the readline SIGWINCH handler will modify LINES and
  # COLUMNS in the environment.
  #
  #extern int rl_change_environment;

  # Completion variables.
  #
  # Pointer to the generator function for completion_matches ().
  # NULL means to use rl_filename_completion_function (), the default
  # filename completer.
  #
  #extern rl_compentry_func_t *rl_completion_entry_function;

  # Optional generator for menu completion.  Default is
  # rl_completion_entry_function (rl_filename_completion_function).
  #
  # extern rl_compentry_func_t *rl_menu_completion_entry_function;

  # If rl_ignore_some_completions_function is non-NULL it is the address
  # of a function to call after all of the possible matches have been
  # generated, but before the actual completion is done to the input line.
  # The function is called with one argument; a NULL terminated array
  # of (char *).  If your function removes any of the elements, they
  # must be free()'ed.
  #
  #extern rl_compignore_func_t *rl_ignore_some_completions_function;

  # Pointer to alternative function to create matches.
  # Function is called with TEXT, START, and END.
  # START and END are indices in RL_LINE_BUFFER saying what the boundaries
  # of TEXT are.
  # If this function exists and returns NULL then call the value of
  # rl_completion_entry_function to try to match, otherwise use the
  # array of strings returned.
  #
  #extern rl_completion_func_t *rl_attempted_completion_function;

  # The basic list of characters that signal a break between words for the
  # completer routine.  The initial contents of this variable is what
  # breaks words in the shell, i.e. "n\"\\'`@$>".
  #
  #extern const char *rl_basic_word_break_characters;

  # The list of characters that signal a break between words for
  # rl_complete_internal.  The default list is the contents of
  # rl_basic_word_break_characters.
  #
  #extern char *rl_completer_word_break_characters;

  # Hook function to allow an application to set the completion word
  # break characters before readline breaks up the line.  Allows
  # position-dependent word break characters.
  #
  #extern rl_cpvfunc_t *rl_completion_word_break_hook;

  # List of characters which can be used to quote a substring of the line.
  # Completion occurs on the entire substring, and within the substring   
  # rl_completer_word_break_characters are treated as any other character,
  # unless they also appear within this list.
  #
  #extern const char *rl_completer_quote_characters;

  # List of quote characters which cause a word break.
  #
  #extern const char *rl_basic_quote_characters;

  # List of characters that need to be quoted in filenames by the completer.
  #
  #extern const char *rl_filename_quote_characters;

  # List of characters that are word break characters, but should be left
  # in TEXT when it is passed to the completion function.  The shell uses
  # this to help determine what kind of completing to do.
  #
  #extern const char *rl_special_prefixes;

  # If non-zero, then this is the address of a function to call when
  # completing on a directory name.  The function is called with
  # the address of a string (the current directory name) as an arg.  It
  # changes what is displayed when the possible completions are printed
  # or inserted.  The directory completion hook should perform
  # any necessary dequoting.  This function should return 1 if it modifies
  # the directory name pointer passed as an argument.  If the directory
  # completion hook returns 0, it should not modify the directory name
  # pointer passed as an argument.
  #
  #extern rl_icppfunc_t *rl_directory_completion_hook;

  # If non-zero, this is the address of a function to call when completing
  # a directory name.  This function takes the address of the directory name
  # to be modified as an argument.  Unlike rl_directory_completion_hook, it
  # only modifies the directory name used in opendir(2), not what is displayed
  # when the possible completions are printed or inserted.  If set, it takes
  # precedence over rl_directory_completion_hook.  The directory rewrite
  # hook should perform any necessary dequoting.  This function has the same
  # return value properties as the directory_completion_hook.
  #
  # I'm not happy with how this works yet, so it's undocumented.  I'm trying
  # it in bash to see how well it goes.
  #
  #extern rl_icppfunc_t *rl_directory_rewrite_hook;

  # If non-zero, this is the address of a function for the completer to call
  # before deciding which character to append to a completed name.  It should
  # modify the directory name passed as an argument if appropriate, and return
  # non-zero if it modifies the name.  This should not worry about dequoting
  # the filename; that has already happened by the time it gets here. */
  #
  #extern rl_icppfunc_t *rl_filename_stat_hook;

  # If non-zero, this is the address of a function to call when reading
  # directory entries from the filesystem for completion and comparing
  # them to the partial word to be completed.  The function should
  # either return its first argument (if no conversion takes place) or
  # newly-allocated memory.  This can, for instance, convert filenames
  # between character sets for comparison against what's typed at the
  # keyboard.  The returned value is what is added to the list of
  # matches.  The second argument is the length of the filename to be
  # converted.
  #
  #extern rl_dequote_func_t *rl_filename_rewrite_hook;

  # If non-zero, then this is the address of a function to call when
  # completing a word would normally display the list of possible matches.
  # This function is called instead of actually doing the display.
  # It takes three arguments: (char **matches, int num_matches, int max_length)
  # where MATCHES is the array of strings that matched, NUM_MATCHES is the
  # number of strings in that array, and MAX_LENGTH is the length of the
  # longest string in that array.
  #
  #extern rl_compdisp_func_t *rl_completion_display_matches_hook;

  # Non-zero means that the results of the matches are to be treated
  # as filenames.  This is ALWAYS zero on entry, and can only be changed
  # within a completion entry finder function.
  #
  #extern int rl_filename_completion_desired;

  # Non-zero means that the results of the matches are to be quoted using
  # double quotes (or an application-specific quoting mechanism) if the
  # filename contains any characters in rl_word_break_chars.  This is
  # ALWAYS non-zero on entry, and can only be changed within a completion
  # entry finder function.
  #
  #extern int rl_filename_quoting_desired;

  # Set to a function to quote a filename in an application-specific fashion.
  # Called with the text to quote, the type of match found (single or multiple)
  # and a pointer to the quoting character to be used, which the function can
  # reset if desired.
  #
  #extern rl_quote_func_t *rl_filename_quoting_function;

  # Function to call to remove quoting characters from a filename.  Called
  # before completion is attempted, so the embedded quotes do not interfere
  # with matching names in the file system.
  #
  #extern rl_dequote_func_t *rl_filename_dequoting_function;

  # Function to call to decide whether or not a word break character is
  # quoted.  If a character is quoted, it does not break words for the
  # completer.
  #
  #extern rl_linebuf_func_t *rl_char_is_quoted_p;

  # Non-zero means to suppress normal filename completion after the
  # user-specified completion function has been called.
  #
  #extern int rl_attempted_completion_over;

  # Set to a character describing the type of completion being attempted by
  # rl_complete_internal; available for use by application completion
  # functions.
  #
  #extern int rl_completion_type;

  # Set to the last key used to invoke one of the completion functions.
  #
  #extern int rl_completion_invoking_key;

  # Up to this many items will be displayed in response to a
  # possible-completions call.  After that, we ask the user if she
  # is sure she wants to see them all.  The default value is 100.
  #
  #extern int rl_completion_query_items;

  # Character appended to completed words when at the end of the line.  The
  # default is a space.  Nothing is added if this is '\0'.
  #
  #extern int rl_completion_append_character;

  # If set to non-zero by an application completion function,
  # rl_completion_append_character will not be appended.
  #
  #extern int rl_completion_suppress_append;

  # Set to any quote character readline thinks it finds before any application
  # completion function is called.
  #
  #extern int rl_completion_quote_character;

  # Set to a non-zero value if readline found quoting anywhere in the word to
  # be completed; set before any application completion function is called.
  #
  #extern int rl_completion_found_quote;

  # If non-zero, the completion functions don't append any closing quote.
  # This is set to 0 by rl_complete_internal and may be changed by an
  # application-specific completion function.
  #
  #extern int rl_completion_suppress_quote;

  # If non-zero, readline will sort the completion matches.  On by default.
  #
  #extern int rl_sort_completion_matches;

  # If non-zero, a slash will be appended to completed filenames that are
  # symbolic links to directory names, subject to the value of the
  # mark-directories variable (which is user-settable).  This exists so
  # that application completion functions can override the user's preference
  # (set via the mark-symlinked-directories variable) if appropriate.
  # It's set to the value of _rl_complete_mark_symlink_dirs in
  # rl_complete_internal before any application-specific completion
  # function is called, so without that function doing anything, the user's
  # preferences are honored.
  #
  #extern int rl_completion_mark_symlink_dirs;

  # If non-zero, then disallow duplicates in the matches.
  #
  #extern int rl_ignore_completion_duplicates;

  # If this is non-zero, completion is (temporarily) inhibited, and the
  # completion character will be inserted as any other.
  #
  #extern int rl_inhibit_completion;

  # Input error; can be returned by (*rl_getc_function) if readline is reading
  # a top-level command (RL_ISSTATE (RL_STATE_READCMD)).

  constant READERR = -2;

  # Definitions available for use by readline clients.
  #
  constant RL_PROMPT_START_IGNORE = '\001';
  constant RL_PROMPT_END_IGNORE   = '\002';

  # Possible values for do_replace argument to rl_filename_quoting_function,
  # called by rl_complete_internal.
  #
  constant NO_MATCH     = 0;
  constant SINGLE_MATCH = 1;
  constant MULT_MATCH   = 2;

  # Possible state values for rl_readline_state
  #
  constant RL_STATE_NONE	 = 0x0000000; # no state; before first call 

  constant RL_STATE_INITIALIZING = 0x0000001; # initializing
  constant RL_STATE_INITIALIZED	 = 0x0000002; # initialization done
  constant RL_STATE_TERMPREPPED	 = 0x0000004; # terminal is prepped
  constant RL_STATE_READCMD	 = 0x0000008; # reading a command key
  constant RL_STATE_METANEXT	 = 0x0000010; # reading input after ESC
  constant RL_STATE_DISPATCHING	 = 0x0000020; # dispatching to a command
  constant RL_STATE_MOREINPUT	 = 0x0000040; # reading more input in a command function
  constant RL_STATE_ISEARCH	 = 0x0000080; # doing incremental search
  constant RL_STATE_NSEARCH	 = 0x0000100; # doing non-inc search
  constant RL_STATE_SEARCH	 = 0x0000200; # doing a history search
  constant RL_STATE_NUMERICARG	 = 0x0000400; # reading numeric argument
  constant RL_STATE_MACROINPUT	 = 0x0000800; # getting input from a macro
  constant RL_STATE_MACRODEF	 = 0x0001000; # defining keyboard macro
  constant RL_STATE_OVERWRITE	 = 0x0002000; # overwrite mode
  constant RL_STATE_COMPLETING	 = 0x0004000; # doing completion
  constant RL_STATE_SIGHANDLER	 = 0x0008000; # in readline sighandler
  constant RL_STATE_UNDOING	 = 0x0010000; # doing an undo
  constant RL_STATE_INPUTPENDING = 0x0020000; # rl_execute_next called 
  constant RL_STATE_TTYCSAVED	 = 0x0040000; # tty special chars saved
  constant RL_STATE_CALLBACK	 = 0x0080000; # using the callback interface
  constant RL_STATE_VIMOTION	 = 0x0100000; # reading vi motion arg
  constant RL_STATE_MULTIKEY	 = 0x0200000; # reading multiple-key command
  constant RL_STATE_VICMDONCE	 = 0x0400000; # entered vi command mode at least once
  constant RL_STATE_REDISPLAYING = 0x0800000; # updating terminal display

  constant RL_STATE_DONE	 = 0x1000000; # done; accepted line

  #define RL_SETSTATE(x)	(rl_readline_state |= (x))
  #define#RL_UNSETSTATE(x)	(rl_readline_state &= ~(x))
  #define RL_ISSTATE(x)		(rl_readline_state & (x))

  class readline_state is repr('CStruct') {
    # line state
    has int $.point;  # int point;
    has int $.end;    # int end;
    has int $.mark;   # int mark;
    has Str $.buffer; # char *buffer;
    has int $.buflen; # int buflen;
    has Pointer $.ul; # UNDO_LIST *ul;
    has Str $.prompt; # char *prompt;

    # global state
    has int $.rlstate; # int rlstate;
    has int $.done; # int done;
    has Pointer $.keymap; # Keymap kmap;

    # input state
    has Pointer $.lastfunc; # rl_command_func_t *lastfunc;
    has int $.insmode;      # int insmode;
    has int $.edmode;       # int edmode;
    has int $.kseqlen;      # int kseqlen;
    has Pointer $.inf;      # FILE *inf;
    has Pointer $.outf;     # FILE *outf;
    has int $.pendingin;    # int pendingin;
    has Str $.macro;        # char *macro;

    # signal state
    has int $.catchsigs;     # int catchsigs;
    has int $.catchsigwinch; # int catchsigwinch;

    # search state

    # completion state

    # options state

    # reserved for future expansion, so the struct size doesn't change
    has int $.reserved; # char reserved[64]; # XXX
  }

  sub rl_save_state( readline_state $state ) returns Int
    is native( LIB ) { * }
  method rl-save-state( readline_state $state ) returns Int {
    rl_save_state( $state ) }

  sub rl_restore_state( readline_state $state ) returns Int
    is native( LIB ) { * }
  method rl-restore-state( readline_state $state ) returns Int {
    rl_restore_state( $state ) }

  ############################################################################
  #
  # rltypedefs.h -- Type declarations for readline functions. */
  #
  # Bindable functions
  #
  #typedef int rl_command_func_t (int, int);

  # Typedefs for the completion system
  #
  #typedef char *rl_compentry_func_t (const char *, int);
  #typedef char **rl_completion_func_t (const char *, int, int);

  #typedef char *rl_quote_func_t (char *, int, char *);
  #typedef char *rl_dequote_func_t (char *, int);

  #typedef int rl_compignore_func_t (char **);

  #typedef void rl_compdisp_func_t (char **, int, int);

  # Type for input and pre-read hook functions like rl_event_hook
  #
  #typedef int rl_hook_func_t (void);

  # Input function type
  #
  #typedef int rl_getc_func_t (FILE *);

  # Generic function that takes a character buffer (which could be the readline
  # line buffer) and an index into it (which could be rl_point) and returns
  # an int.
  #
  #typedef int rl_linebuf_func_t (char *, int);

  # `Generic' function pointer typedefs
  #
  #typedef int rl_intfunc_t (int);
  ##define rl_ivoidfunc_t rl_hook_func_t
  #typedef int rl_icpfunc_t (char *);
  #typedef int rl_icppfunc_t (char **);

  #typedef void rl_voidfunc_t (void);
  #typedef void rl_vintfunc_t (int);
  #typedef void rl_vcpfunc_t (char *);
  #typedef void rl_vcppfunc_t (char **);
  #
  #typedef char *rl_cpvfunc_t (void);
  #typedef char *rl_cpifunc_t (int);
  #typedef char *rl_cpcpfunc_t (char  *);
  #typedef char *rl_cpcppfunc_t (char  **);

  #############################################################################
  #
  # tilde.h: Externally available variables and function in libtilde.a.
  #
  #typedef char *tilde_hook_func_t (char *);

  # If non-null, this contains the address of a function that the application
  # wants called before trying the standard tilde expansions.  The function
  # is called with the text sans tilde, and returns a malloc()'ed string
  # which is the expansion, or a NULL pointer if the expansion fails.
  #
  #extern tilde_hook_func_t *tilde_expansion_preexpansion_hook;

  # If non-null, this contains the address of a function to call if the
  # standard meaning for expanding a tilde fails.  The function is called
  # with the text (sans tilde, as in "foo"), and returns a malloc()'ed string
  # which is the expansion, or a NULL pointer if there is no expansion.
  #
  #extern tilde_hook_func_t *tilde_expansion_failure_hook;

  # When non-null, this is a NULL terminated array of strings which
  # are duplicates for a tilde prefix.  Bash uses this to expand
  # `=~' and `:~'.
  #
  #extern char **tilde_additional_prefixes;

  # When non-null, this is a NULL terminated array of strings which match
  # the end of a username, instead of just "/".  Bash sets this to
  # `:' and `=~'.
  #
  #extern char **tilde_additional_suffixes;

  # Return a new string which is the result of tilde expanding STRING.
  #
  sub tilde_expand( Str $filename ) returns Str
    is native( LIB ) { * }
  method tilde-expand( Str $filename ) returns Str {
    tilde_expand( $filename ) }

  # Do the work of tilde expansion on FILENAME.  FILENAME starts with a
  # tilde.  If there is no expansion, call tilde_expansion_failure_hook.
  #
  sub tilde_expand_word( Str $filename ) returns Str
    is native( LIB ) { * }
  method tilde-expand-word( Str $filename ) returns Str {
    tilde_expand_word( $filename ) }

  # Find the portion of the string beginning with ~ that should be expanded.
  #
  #extern char *tilde_find_word (const char *, int, int *);
  #
  #############################################################################

}
