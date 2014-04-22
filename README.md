# Valgrind client requests for Rust

This library lets Rust programs running inside [Valgrind][] make various
requests of Valgrind and its tools.  For example:

~~~ .rs
extern crate vgrs;

use vgrs::valgrind;

fn main() {
    unsafe {
        assert!(valgrind::count_errors() == 0);
        let x: u8 = std::intrinsics::uninit();
        println!("{:u}", x);
        assert!(valgrind::count_errors() > 0);
    }
}
~~~

For now this only works on Linux or MacOS, and only on AMD64, but support for
other platforms should be easy (see `src/arch/`).

This library is sparsely documented.  You will probably want to look at the
[Valgrind user manual][] and the C headers in `/usr/include/valgrind` to learn
what all these requests do.

`make` will put the library in `build/` and documentation in `build/doc/`.
`make check` will run some test programs under Valgrind.

[Valgrind]: http://valgrind.org
[Valgrind user manual]: http://valgrind.org/docs/manual/index.html
