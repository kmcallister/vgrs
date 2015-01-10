/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#[inline(always)]
pub unsafe fn request(
        default: usize,
        request: usize,
        arg1: usize,
        arg2: usize,
        arg3: usize,
        arg4: usize,
        arg5: usize) -> usize {

    let args: [usize; 6] = [request, arg1, arg2, arg3, arg4, arg5];
    let mut result: usize;

    // Valgrind notices this magic instruction sequence and interprets
    // it as a kind of hypercall.  When not running under Valgrind,
    // the instructions do nothing and `default` is returned.
    asm!("
        rolq $$3,  %rdi
        rolq $$13, %rdi
        rolq $$61, %rdi
        rolq $$51, %rdi
        xchgq %rbx, %rbx"

        : "={rdx}"(result)
        : "{rax}"(args.as_ptr()), "0"(default)
        : "cc", "memory"
        : "volatile");

    result
}
