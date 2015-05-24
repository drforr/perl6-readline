use v6;

use Readline;
use Test;

plan 2;

my $r = Readline.new;

sub bare-callback ( Int $a, Int $b ) returns Int {
}

subtest sub {
  lives-ok { $r.using-history },
           'using-history lives';
  lives-ok { my $bytes = $r.history-total-bytes },
           'history-total-bytes lives';
  is $r.history-total-bytes, 0,
     '0 bytes in history';

  my $HISTORY_STATE;
  lives-ok { $HISTORY_STATE = $r.history-get-history-state },
           'history-get-history-state lives';
  is $r.history-get-history-state.length, 0,
     'history length is 0 at the beginning';

  is $r.where-history, 0,
     'history starts at 0';
  lives-ok { my $HIST_ENTRY = $r.current-history( 0 ) },
           'current-history lives';
  lives-ok { my @HIST_ENTRY = $r.history-list },
           'history-list lives';

  subtest sub {
    lives-ok { $r.history-is-stifled },
             'history-is-stifled lives';
    nok $r.history-is-stifled,
        'History is not stifled at the beginning';
    lives-ok { $r.stifle-history( 0 ) },
             'stifle-history lives';
    ok $r.history-is-stifled,
       'History is now stifled';
    lives-ok { $r.add-history( 'foo' ) },
       'Add history while stifled';

    lives-ok { $r.unstifle-history },
             'unstifle-history lives';
    nok $r.history-is-stifled,
        'History is now unstifled at the beginning';
  }, 'Stifling';

  is $r.history-total-bytes, 0,
     'No history remains if set while stifled';

  $r.add-history( 'bar' );
  lives-ok { $r.add-history-time( '2015-01-01 00:00:01' ) },
           'add-history-time lives';

  my $HIST_ENTRY;
  lives-ok { $HIST_ENTRY = $r.history-get( 0 ) },
           'history-get lives';
  lives-ok { my $time = $r.history-get-time( $HIST_ENTRY ) },
           'history-get-time lives';
#say $HIST_ENTRY.perl;















###  my $HISTORY_STATE;
###  is $HISTORY_STATE.offset, 0, 'history_state has correct offset';
###  is $HISTORY_STATE.length, 50, 'history_state has correct length';
###  lives-ok { $r.history-set-history-state( $HISTORY_STATE ) },
###           'history-set-history-state lives';

###  my $HIST_ENTRY;
###  lives-ok { $HIST_ENTRY = $r.remove-history( 0 ) }, 'remove-history lives';
###  is $HIST_ENTRY.line, '1st',
###     'History entry had correct text';
###  is $HIST_ENTRY.timestamp, '2015-01-01 00:00:01',
###     'History entry had correct timestamp';

###  my $histdata_t;
###  lives-ok { $histdata_t = $r.free-history-entry( $HIST_ENTRY ) },
###           'free-history-entry';
}, 'History';

subtest sub {
  my $keymap;
  lives-ok { $keymap = $r.rl-get-keymap },
           'rl-get-keymap lives';

  my $name;
  lives-ok { $name = $r.rl-get-keymap-name( $keymap ) },
           'rl-get-keymap-name lives';
  is $name, 'emacs',
     'Keymap default name is correct';

  my $emacs-keymap;
  lives-ok { $emacs-keymap = $r.rl-get-keymap-by-name( 'emacs' ) },
           'rl-get-keymap-by-name lives';
  is $r.rl-get-keymap-name( $emacs-keymap ), 'emacs',
     'Found the keymap by name "emacs"';

  lives-ok { $r.rl-set-keymap( $emacs-keymap ) },
           'rl-set-keymap lives';

  lives-ok { my $copy-keymap = $r.rl-copy-keymap( $emacs-keymap ) },
           'rl-copy-keymap lives';

  my $bare-keymap;
  lives-ok { $bare-keymap = $r.rl-make-bare-keymap },
           'rl-make-bare-keymap lives';
  lives-ok { $r.rl-discard-keymap( $bare-keymap ) },
           'rl-discard-keymap lives';

  subtest sub {
    lives-ok { my $rv = $r.rl-bind-keyseq-in-map(
                           'X', &bare-callback, $bare-keymap ) },
             'rl-bind-keyseq-in-map lives';
  }, 'Bind keyseq to keymap';

  subtest sub {
    lives-ok { my $rv = $r.rl-bind-key-if-unbound-in-map(
                          'X', &bare-callback, $keymap ) },
             'rl-bind-key-if-unbound-in-map lives';
    lives-ok { my $rv = $r.rl-bind-key-in-map(
                          'X', &bare-callback, $bare-keymap ) },
             'rl-bind-key-in-map lives';
#    lives-ok { my $rv = $r.rl-tty-set-default-bindings( $bare-keymap ) },
#             'rl-tty-set-default-bindings lives';
#    lives-ok { my $rv = $r.rl-tty-unset-default-bindings( $keymap ) },
#             'rl-tty-unset-default-bindings lives';
    lives-ok { my $rv = $r.rl-generic-bind( 0, 'X', 'XX', $bare-keymap ) },
             'rl-generic-bind lives';
    lives-ok { my $rv = $r.rl-macro-bind( 'X', 'XX', $bare-keymap ) },
             'rl-macro-bind lives';
    lives-ok { $r.rl-unbind-key-in-map( 'X', $bare-keymap ) },
             'rl-unbind-key-in-map lives';
  }, 'Bind key to keymap';

  subtest sub {
    lives-ok { $r.rl-bind-keyseq( 'X', &bare-callback ) },
             'rl-bind-keyseq lives';
  }, 'Bind keyseq to application';

  subtest sub {
    lives-ok { my $rv = $r.rl-bind-key-if-unbound( 'X', &bare-callback ) },
             'rl-bind-key-if-unbound lives';
    lives-ok { $r.rl-bind-key( 'X', &bare-callback ) },
             'rl-bind-key lives';
    lives-ok { $r.rl-unbind-key( 'X' ) },
             'rl-unbind-key lives';
  }, 'Bind key to application';

  my $new-keymap;
  lives-ok { $new-keymap = $r.rl-make-keymap },
           'rl-make-keymap lives';
  lives-ok { $r.rl-free-keymap( $new-keymap ) },
           'rl-free-keymap lives';
}, 'Keymap';

##############################################################################

#### subtest sub {
####   lives-ok { $HIST_ENTRY =
####                $r.replace-history-entry( 0, 'bar', $histdata-t ) },
####            'replace-history-entry';
####   lives-ok { $r.clear-history },
####            'clear-history lives';
####   lives-ok { my $time_t = $r.history-get-time( $HIST_ENTRY ) },
####            'history-get-time lives';
####   lives-ok { my $rv = $r.history-set-pos( 0 ) },
####            'history-set-pos lives';
####   lives-ok { my $HIST_ENTRY = $r.previous-history },
####            'previous-history lives';
####   lives-ok { my $HIST_ENTRY = $r.next-history },
####            'next-history lives';
####   lives-ok { my $pos = $r.history-search( 'foo', 0 ) },
####            'history-search lives';
####   lives-ok { my $pos = $r.history-search-prefix( 'foo', 0 ) },
####            'history-search-prefix lives';
####   lives-ok { my $pos = $r.history-search-pos( 'foo', 0, 0 ) },
####            'history-search-pos lives';
####   lives-ok { my $items = $r.read-history( 'foo' ) },
####            'read-history lives';
####   lives-ok { my $items = $r.read-history-range( 'foo', 0, 1 ) },
####            'read-history-range lives';
#### ##  lives-ok { my $result = $r.write-history( 'foo' ) }, # XXX test 'write'? No.
#### ##           'write-history lives';
#### ##  lives-ok { my $result = $r.append-history( 0, 'foo' ) }, # XXX test 'write'? No.
#### ##           'append-history lives';
#### ##  lives-ok { my $items = $r.history-truncate-file( 'foo', 0 ) }, # XXX test truncate? Not yet.
#### ##           'history-truncate-file lives';
#### ##  lives-ok { my $value; my $res = $r.history-expand( 'foo', \$value ) }, # XXX test truncate? Not yet. # XXX wrap it properly
#### ##           'history-expand lives';
####   lives-ok { my $str = $r.history-arg-extract( 0, 2, 'foo' ) },
####            'history-arg-extract lives';
#### #  lives-ok { my $index; my $str = $r.get-history-event( 'foo', \$index, "'" ) }, # XXX Wrap it properly
#### #           'get-history-event lives';
####   lives-ok { my @str = $r.history-tokenize( 'foo' ) },
####            'history-tokenize lives';
#### }, 'History';

#### ### =item readline( Str $prompt ) returns Str
#### 
#### ### =item rl-initialize( ) returns Int
#### 
#### ### =item rl-ding( ) returns Int
#### 
#### 
#### subtest sub {
#### #  lives-ok { $r.rl-callback-handler-install( 'readline-test$ ', &call-me ) },
#### #           'rl-callback-handler-install lives';
#### #  lives-ok { $r.rl-callback-read-char }, # XXX Blocks, of course.
#### #           'rl-callback-read-char lives';
####   lives-ok { $r.rl-callback-handler-remove },
####            'rl-callback-handler-remove lives';
#### }, 'Callback';
#### 
#### subtest sub {
####   lives-ok { $r.rl-set-prompt( 'readline-test$ ' ) },
####            'rl-set-prompt lives';
####   lives-ok { my $rv = $r.rl-expand-prompt( 'readline-test$ ' ) },
####            'rl-expand-prompt lives';
#### }, 'Prompt';
#### 
#### subtest sub {
#### #  lives-ok { my $rv = $r.rl-unbind-function-in-map( &callback, $keymap ) },
#### #           'rl-unbind-function-in-map lives';
#### #  lives-ok { my $rv = $r.rl-bind-keyseq-in-map( 'X', &callback, $keymap ) },
#### #           'rl-bind-keyseq-in-map lives';
#### #  lives-ok { my $rv = $r.rl-bind-keyseq-if-unbound( 'X', &callback ) },
#### #           'rl-bind-keyseq-if-unbound lives';
#### #  lives-ok { my $rv = $r.rl-bind-keyseq-if-unbound-in-map( 'X', &callback, $keymap ) },
#### #           'rl-bind-keyseq-if-unbound-in-map lives';
#### }, 'Binding';
#### 
#### #lives-ok { my $rv = $r.rl-add-defun( 'XX', &callback, 'X' ) },
#### #         'rl-add-defun lives';
#### lives-ok { my $rv = $r.rl-variable-value( 'visible-bell' ) },
####          'rl-variable-value lives';
#### lives-ok { my $rv = $r.rl-variable-bind( 'visible-bell', 'on' ) },
####          'rl-variable-bind lives';
#### #lives-ok { my $rv = $r.rl-set-key( 'X', &callback, $keymap ) },
#### #         'rl-set-key lives';
#### #lives-ok { my $rv = $r.rl-named-function( 'XX' ) },
#### #         'rl-named-function lives';
#### #lives-ok { my $rv = $r.rl-function-of-keymap( 'XX', $keymap, \$type ) },
#### #         'rl-function-of-keymap lives';
#### #lives-ok { $r.rl-list-funmap-names( ) },
#### #         'rl-list-funmap-names lives';
#### #lives-ok { my $cmd;
#### #           my @rv = $r.rl-invoking-keyseqs-in-map( &callback, \$cmd, $keymap ) },
#### #         'rl-invoking-keyseqs-in-map lives';
#### #lives-ok { my $cmd;
#### #           my @rv = $r.rl-invoking-keyseqs( &callback, \$cmd ) },
#### #         'rl-invoking-keyseqs lives';
#### #lives-ok { my $rv = $r.rl-function-dumper( True ) },
#### #         'rl-function-dumper lives';
#### lives-ok { my $rv = $r.rl-macro-dumper( True ) },
####          'rl-macro-dumper lives';
#### #lives-ok { $r.rl-variable-dumper( True ) },
#### #         'rl-variable-dumper lives';
#### lives-ok { my $rv = $r.rl-read-init-file( 'filename' ) },
####          'rl-read-init-file lives';
#### lives-ok { my $rv = $r.rl-parse-and-bind( 'XX' ) },
####          'rl-parse-and-bind lives';
#### #lives-ok { my $rv = $r.rl-add-funmap-entry( 'X', &callback ) },
#### #         'rl-add-funmap-entry lives';
#### lives-ok { my $rv = $r.rl-funmap-names },
####          'rl-funmap-names lives';
#### lives-ok { my $rv = $r.rl-push-macro-input( 'macro' ) },
####          'rl-push-macro-input lives';
#### lives-ok { my $rv = $r.rl-free-undo-list },
####          'rl-free-undo-list lives';
#### lives-ok { my $rv = $r.rl-do-undo },
####          'rl-do-undo lives';
#### lives-ok { my $rv = $r.rl-begin-undo-group },
####          'rl-begin-undo-group lives';
#### lives-ok { my $rv = $r.rl-end-undo-group },
####          'rl-end-undo-group lives';
#### #lives-ok { my $rv = $r.rl-modifying( 0, 1 ) },
#### #         'rl-modifying lives';
#### lives-ok { my $rv = $r.rl-redisplay },
####          'rl-redisplay lives';
#### lives-ok { my $rv = $r.rl-on-new-line },
####          'rl-on-new-line lives';
#### #lives-ok { my $rv = $r.rl-on-new-line-with-prompt },
#### #         'rl-on-new-line-with-prompt lives';
#### lives-ok { my $rv = $r.rl-forced-update-display },
####          'rl-forced-update-display lives';
#### lives-ok { my $rv = $r.rl-clear-message },
####          'rl-clear-message lives';
#### lives-ok { my $rv = $r.rl-reset-line-state },
####          'rl-reset-line-state lives';
#### #lives-ok { my $rv = $r.rl-crlf },
#### #         'rl-crlf lives';
#### #lives-ok { my $rv = $r.rl-show-char( 'X' ) },
#### #         'rl-show-char lives';
#### lives-ok { my $rv = $r.rl-save-prompt },
####          'rl-save-prompt lives';
#### lives-ok { my $rv = $r.rl-restore-prompt },
####          'rl-restore-prompt lives';
#### lives-ok { my $rv = $r.rl-replace-line( 'foo', 0 ) },
####          'rl-replace-line lives';
#### lives-ok { my $rv = $r.rl-insert-text( 'foo' ) },
####          'rl-insert-text lives';
#### lives-ok { my $rv = $r.rl-delete-text( 0, 1 ) },
####          'rl-delete-text lives';
#### lives-ok { my $rv = $r.rl-kill-text( 0, 1 ) },
####          'rl-kill-text lives';
#### lives-ok { my $rv = $r.rl-copy-text( 0, 1 ) },
####          'rl-copy-text lives';
#### lives-ok { my $rv = $r.rl-prep-terminal( 1 ) },
####          'rl-prep-terminal lives';
#### lives-ok { my $rv = $r.rl-deprep-terminal },
####          'rl-deprep-terminal lives';
#### lives-ok { my $rv = $r.rl-reset-terminal( 'vt100' ) },
####          'rl-reset-terminal lives';
#### #lives-ok { my $rv = $r.rl-foo( $keymap ) },
#### #         'rl-foo lives';
#### #lives-ok { my $rv = $r.rl-resize-terminal },
#### #         'rl-resize-terminal lives';
#### lives-ok { my $rv = $r.rl-set-screen-size( 80, 24 ) },
####          'rl-set-screen-size lives';
#### #lives-ok { my ( $rows, $cols );
#### #           my $rv = $r.rl-get-screen-size( \$rows, \$cols ) },
#### #         'rl-get-screen-size lives';
#### #lives-ok { my $rv = $r.rl-reset-screen-size },
#### #         'rl-reset-screen-size lives';
#### lives-ok { my $rv = $r.rl-get-termcap( 'vt100' ) },
####          'rl-get-termcap lives';
#### lives-ok { my $rv = $r.rl-extend-line-buffer( 0 ) },
####          'rl-extend-line-buffer lives';
#### lives-ok { my $rv = $r.rl-alphabetic( 'x' ) },
####          'rl-alphabetic lives';
#### #lives-ok { my $rv = $r.rl-free( $mem ) },
#### #         'rl-free lives';
#### lives-ok { my $rv = $r.rl-set-signals },
####          'rl-set-signals lives';
#### lives-ok { my $rv = $r.rl-clear-signals },
####          'rl-clear-signals lives';
#### #lives-ok { my $rv = $r.rl-cleanup-after-signal },
#### #         'rl-cleanup-after-signal lives';
#### lives-ok { my $rv = $r.rl-reset-after-signal },
####          'rl-reset-after-signal lives';
#### #lives-ok { my $rv = $r.rl-free-line-state }, # XXX Can't run standalone?
#### #         'rl-free-line-state lives';
#### ##lives-ok { $r.rl-echo-signal( 0 ) }, # XXX doesn't exist?
#### ##         'rl-echo-signal lives';
#### lives-ok { my $rv = $r.rl-set-paren-blink-timeout( 1 ) },
####          'rl-set-paren-blink-timeout lives';
#### #lives-ok { my $rv = $r.rl-complete-internal( 1 ) },
#### #         'rl-complete-internal lives';
#### #lives-ok { my $rv = $r.rl-username-completion-function( 'jgoff', 1 ) },
#### #         'rl-username-completion-function lives';
#### #lives-ok { my $rv = $r.rl-filename-completion-function( 'file.txt', 1 ) },
#### #         'rl-filename-completion-function lives';
#### #lives-ok { my $rv = $r.rl-completion-mode( \&callback ) },
#### #         'rl-completion-mode lives';
#### #lives-ok { my $rv = $r.rl-save-state( $readline-state ) },
#### #         'rl-save-state lives';
#### #lives-ok { my $rv = $r.tilde-expand( '~jgoff' ) },
#### #         'tilde-expand lives';
#### lives-ok { my $rv = $r.tilde-expand-word( 'foo' ) },
####          'tilde-expand-word lives';
#### #lives-ok { my $offset;
#### #           my $rv = $r.tilde-find-word( 'foo', 1, \$offset ) },
#### #         'tilde-find-word lives';
#### #lives-ok { my $rv = $r.rl-restore-state( $readline-state ) },
#### #         'rl-restore-state lives';

######################## Original order ########################################

#### ### 
#### ### =item readline( Str $prompt ) returns Str
#### ### 
#### 
#### ### 
#### ### =item rl-initialize( ) returns Int
#### ### 
#### 
#### ### 
#### ### =item rl-ding( ) returns Int
#### ### 
#### 
#### subtest sub {
####   lives-ok { $histdata-t = $r.free-history-entry( $history-entry ) },
####            'free-history-entry';
####   lives-ok { $history-state =
####                $r.replace-history-entry( 0, 'bar', $histdata-t ) },
####            'replace-history-entry';
####   lives-ok { $r.clear-history },
####            'clear-history lives';
####   lives-ok { $r.history-list },
####            'history-list lives'; # XXX We can check this further.
####   lives-ok { my $time-t = $r.history-get-time( $history-entry ) },
####            'history-get-time lives';
####   lives-ok { my $pos = $r.history-set-pos( 0 ) },
####            'history-set-pos lives';
####   lives-ok { my $history-entry = $r.previous-history },
####            'previous-history lives';
####   lives-ok { my $history-entry = $r.next-history },
####            'next-history lives';
####   lives-ok { my $pos = $r.history-search( 'foo', 0 ) },
####            'history-search lives';
####   lives-ok { my $pos = $r.history-search-prefix( 'foo', 0 ) },
####            'history-search-prefix lives';
####   lives-ok { my $pos = $r.history-search-pos( 'foo', 0, 0 ) },
####            'history-search-pos lives';
####   lives-ok { my $items = $r.read-history( 'foo' ) },
####            'read-history lives';
####   lives-ok { my $items = $r.read-history-range( 'foo', 0, 1 ) },
####            'read-history-range lives';
#### ##  lives-ok { my $result = $r.write-history( 'foo' ) }, # XXX test 'write'? No.
#### ##           'write-history lives';
#### ##  lives-ok { my $result = $r.append-history( 0, 'foo' ) }, # XXX test 'write'? No.
#### ##           'append-history lives';
#### ##  lives-ok { my $items = $r.history-truncate-file( 'foo', 0 ) }, # XXX test truncate? Not yet.
#### ##           'history-truncate-file lives';
#### ##  lives-ok { my $value; my $res = $r.history-expand( 'foo', \$value ) }, # XXX test truncate? Not yet. # XXX wrap it properly
#### ##           'history-expand lives';
####   lives-ok { my $res = $r.history-arg-extract( 0, 2, 'foo' ) },
####            'history-arg-extract lives';
#### #  lives-ok { my $index; my $res = $r.get-history-event( 'foo', \$index, "'" ) }, # XXX Wrap it properly
#### #           'get-history-event lives';
####   lives-ok { my @str = $r.history-tokenize( 'foo' ) },
####            'history-tokenize lives';
#### }, 'History';
#### 
#### subtest sub {
#### #  lives-ok { $r.rl-callback-handler-install( 'readline-test$ ', &call-me ) },
#### #           'rl-callback-handler-install lives';
#### #  lives-ok { $r.rl-callback-read-char }, # XXX Blocks, of course.
#### #           'rl-callback-read-char lives';
####   lives-ok { $r.rl-callback-handler-remove },
####            'rl-callback-handler-remove lives';
#### }, 'Callback';
#### 
#### subtest sub {
####   lives-ok { $r.rl-set-prompt( 'readline-test$ ' ) },
####            'rl-set-prompt lives';
####   lives-ok { my $rv = $r.rl-expand-prompt( 'readline-test$ ' ) },
####            'rl-expand-prompt lives';
#### }, 'Prompt';
#### 
#### subtest sub {
#### #  lives-ok { my $rv = $r.rl-unbind-function-in-map( &callback, $keymap ) },
#### #           'rl-unbind-function-in-map lives';
#### #  lives-ok { my $rv = $r.rl-bind-keyseq-in-map( 'X', &callback, $keymap ) },
#### #           'rl-bind-keyseq-in-map lives';
#### #  lives-ok { my $rv = $r.rl-bind-keyseq-if-unbound( 'X', &callback ) },
#### #           'rl-bind-keyseq-if-unbound lives';
#### #  lives-ok { my $rv = $r.rl-bind-keyseq-if-unbound-in-map( 'X', &callback, $keymap ) },
#### #           'rl-bind-keyseq-if-unbound-in-map lives';
#### }, 'Binding';
#### 
#### #lives-ok { my $rv = $r.rl-add-defun( 'XX', &callback, 'X' ) },
#### #         'rl-add-defun lives';
#### lives-ok { my $rv = $r.rl-variable-value( 'visible-bell' ) },
####          'rl-variable-value lives';
#### lives-ok { my $rv = $r.rl-variable-bind( 'visible-bell', 'on' ) },
####          'rl-variable-bind lives';
#### #lives-ok { my $rv = $r.rl-set-key( 'X', &callback, $keymap ) },
#### #         'rl-set-key lives';
#### #lives-ok { my $rv = $r.rl-named-function( 'XX' ) },
#### #         'rl-named-function lives';
#### #lives-ok { my $rv = $r.rl-function-of-keymap( 'XX', $keymap, \$type ) },
#### #         'rl-function-of-keymap lives';
#### #lives-ok { $r.rl-list-funmap-names( ) },
#### #         'rl-list-funmap-names lives';
#### #lives-ok { my $cmd;
#### #           my @rv = $r.rl-invoking-keyseqs-in-map( &callback, \$cmd, $keymap ) },
#### #         'rl-invoking-keyseqs-in-map lives';
#### #lives-ok { my $cmd;
#### #           my @rv = $r.rl-invoking-keyseqs( &callback, \$cmd ) },
#### #         'rl-invoking-keyseqs lives';
#### #lives-ok { my $rv = $r.rl-function-dumper( True ) },
#### #         'rl-function-dumper lives';
#### lives-ok { my $rv = $r.rl-macro-dumper( True ) },
####          'rl-macro-dumper lives';
#### #lives-ok { $r.rl-variable-dumper( True ) },
#### #         'rl-variable-dumper lives';
#### lives-ok { my $rv = $r.rl-read-init-file( 'filename' ) },
####          'rl-read-init-file lives';
#### lives-ok { my $rv = $r.rl-parse-and-bind( 'XX' ) },
####          'rl-parse-and-bind lives';
#### #lives-ok { my $rv = $r.rl-add-funmap-entry( 'X', &callback ) },
#### #         'rl-add-funmap-entry lives';
#### lives-ok { my $rv = $r.rl-funmap-names },
####          'rl-funmap-names lives';
#### lives-ok { my $rv = $r.rl-push-macro-input( 'macro' ) },
####          'rl-push-macro-input lives';
#### lives-ok { my $rv = $r.rl-free-undo-list },
####          'rl-free-undo-list lives';
#### lives-ok { my $rv = $r.rl-do-undo },
####          'rl-do-undo lives';
#### lives-ok { my $rv = $r.rl-begin-undo-group },
####          'rl-begin-undo-group lives';
#### lives-ok { my $rv = $r.rl-end-undo-group },
####          'rl-end-undo-group lives';
#### #lives-ok { my $rv = $r.rl-modifying( 0, 1 ) },
#### #         'rl-modifying lives';
#### lives-ok { my $rv = $r.rl-redisplay },
####          'rl-redisplay lives';
#### lives-ok { my $rv = $r.rl-on-new-line },
####          'rl-on-new-line lives';
#### #lives-ok { my $rv = $r.rl-on-new-line-with-prompt },
#### #         'rl-on-new-line-with-prompt lives';
#### lives-ok { my $rv = $r.rl-forced-update-display },
####          'rl-forced-update-display lives';
#### lives-ok { my $rv = $r.rl-clear-message },
####          'rl-clear-message lives';
#### lives-ok { my $rv = $r.rl-reset-line-state },
####          'rl-reset-line-state lives';
#### #lives-ok { my $rv = $r.rl-crlf },
#### #         'rl-crlf lives';
#### #lives-ok { my $rv = $r.rl-show-char( 'X' ) },
#### #         'rl-show-char lives';
#### lives-ok { my $rv = $r.rl-save-prompt },
####          'rl-save-prompt lives';
#### lives-ok { my $rv = $r.rl-restore-prompt },
####          'rl-restore-prompt lives';
#### lives-ok { my $rv = $r.rl-replace-line( 'foo', 0 ) },
####          'rl-replace-line lives';
#### lives-ok { my $rv = $r.rl-insert-text( 'foo' ) },
####          'rl-insert-text lives';
#### lives-ok { my $rv = $r.rl-delete-text( 0, 1 ) },
####          'rl-delete-text lives';
#### lives-ok { my $rv = $r.rl-kill-text( 0, 1 ) },
####          'rl-kill-text lives';
#### lives-ok { my $rv = $r.rl-copy-text( 0, 1 ) },
####          'rl-copy-text lives';
#### lives-ok { my $rv = $r.rl-prep-terminal( 1 ) },
####          'rl-prep-terminal lives';
#### lives-ok { my $rv = $r.rl-deprep-terminal },
####          'rl-deprep-terminal lives';
#### lives-ok { my $rv = $r.rl-reset-terminal( 'vt100' ) },
####          'rl-reset-terminal lives';
#### #lives-ok { my $rv = $r.rl-resize-terminal },
#### #         'rl-resize-terminal lives';
#### lives-ok { my $rv = $r.rl-set-screen-size( 80, 24 ) },
####          'rl-set-screen-size lives';
#### #lives-ok { my ( $rows, $cols );
#### #           my $rv = $r.rl-get-screen-size( \$rows, \$cols ) },
#### #         'rl-get-screen-size lives';
#### #lives-ok { my $rv = $r.rl-reset-screen-size },
#### #         'rl-reset-screen-size lives';
#### lives-ok { my $rv = $r.rl-get-termcap( 'vt100' ) },
####          'rl-get-termcap lives';
#### lives-ok { my $rv = $r.rl-extend-line-buffer( 0 ) },
####          'rl-extend-line-buffer lives';
#### lives-ok { my $rv = $r.rl-alphabetic( 'x' ) },
####          'rl-alphabetic lives';
#### #lives-ok { my $rv = $r.rl-free( $mem ) },
#### #         'rl-free lives';
#### lives-ok { my $rv = $r.rl-set-signals },
####          'rl-set-signals lives';
#### lives-ok { my $rv = $r.rl-clear-signals },
####          'rl-clear-signals lives';
#### #lives-ok { my $rv = $r.rl-cleanup-after-signal },
#### #         'rl-cleanup-after-signal lives';
#### lives-ok { my $rv = $r.rl-reset-after-signal },
####          'rl-reset-after-signal lives';
#### #lives-ok { my $rv = $r.rl-free-line-state }, # XXX Can't run standalone?
#### #         'rl-free-line-state lives';
#### ##lives-ok { $r.rl-echo-signal( 0 ) }, # XXX doesn't exist?
#### ##         'rl-echo-signal lives';
#### lives-ok { my $rv = $r.rl-set-paren-blink-timeout( 1 ) },
####          'rl-set-paren-blink-timeout lives';
#### #lives-ok { my $rv = $r.rl-complete-internal( 1 ) },
#### #         'rl-complete-internal lives';
#### #lives-ok { my $rv = $r.rl-username-completion-function( 'jgoff', 1 ) },
#### #         'rl-username-completion-function lives';
#### #lives-ok { my $rv = $r.rl-filename-completion-function( 'file.txt', 1 ) },
#### #         'rl-filename-completion-function lives';
#### #lives-ok { my $rv = $r.rl-completion-mode( \&callback ) },
#### #         'rl-completion-mode lives';
#### #lives-ok { my $rv = $r.rl-save-state( $readline-state ) },
#### #         'rl-save-state lives';
#### #lives-ok { my $rv = $r.tilde-expand( '~jgoff' ) },
#### #         'tilde-expand lives';
#### lives-ok { my $rv = $r.tilde-expand-word( 'foo' ) },
####          'tilde-expand-word lives';
#### #lives-ok { my $offset;
#### #           my $rv = $r.tilde-find-word( 'foo', 1, \$offset ) },
#### #         'tilde-find-word lives';
#### #lives-ok { my $rv = $r.rl-restore-state( $readline-state ) },
#### #         'rl-restore-state lives';
