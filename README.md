# Valgrind client requests for Rust

[![Build Status](https://travis-ci.org/kmcallister/vgrs.svg?branch=master)](https://travis-ci.org/kmcallister/vgrs)

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

This library builds with [Cargo](http://crates.io/).  You can run the tests with `make check`.

[Valgrind]: http://valgrind.org
[Valgrind user manual]: http://valgrind.org/docs/manual/index.html
