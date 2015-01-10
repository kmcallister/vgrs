/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#[inline(always)]
pub unsafe fn request(
        default: uint,
        request: uint,
        arg1: uint,
        arg2: uint,
        arg3: uint,
        arg4: uint,
        arg5: uint) -> usize {

    let args: [uint; 6] = [request, arg1, arg2, arg3, arg4, arg5];
    let mut result: uint;

    // Valgrind notices this magic instruction sequence and interprets
    // it as a kind of hypercall.  When not running under Valgrind,
    // the instructions do nothing and `default` is returned.
    asm!("
        roll $$3,  %edi
        roll $$13, %edi
        roll $$29, %edi
        roll $$19, %edi
        xchgl %ebx, %ebx"

        : "={edx}"(result)
        : "{eax}"(args.as_ptr()), "0"(default)
        : "cc", "memory"
        : "volatile");

    result
}
