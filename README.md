ReadLine
=======

ReadLine provides a Perl 6 interface to libreadline.

XXX This will probably be a frontend to ReadLine::Gnu when that's factored out.
XXX For the moment keep all the code here in the ReadLine module.

Installation
============

* Since ReadLine uses libreadline, libreadline.so.5 must be found in /usr/lib.
To install libreadline5 on Debian for example, please use the following command:

```
	sudo apt-get install libreadline5
```

* Using panda (a module management tool bundled with Rakudo Star):

```
    panda update && panda install ReadLine
```

* Using ufo (a project Makefile creation script bundled with Rakudo Star) and make:

```
    ufo                    
    make
    make test
    make install
```

## Testing

To run tests:

```
    prove -e perl6
```

## Author

Jeffrey Goff, DrFOrr on #perl6, https://github.com/drforr/

## License

Artistic License 2.0
