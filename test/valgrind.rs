/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#![crate_id="vgrs-valgrind-test"]
#![crate_type="bin"]

extern crate vgrs;

use vgrs::valgrind;

fn main() {
    unsafe {
        assert_eq!(valgrind::running_on_valgrind(), 1);
        assert_eq!(valgrind::count_errors(), 0);
    }
}
