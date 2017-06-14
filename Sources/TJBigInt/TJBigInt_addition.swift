// Bronze - A standard library for Swift.
// Copyright (C) 2015-2016  Tjienta Vara
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

func additionGeneric(_ lhs: TJBigInt, _ optionalRhs: TJBigInt?, carry: UInt64 = 0, invert: Bool = false, handleOverflow: Bool = true) -> TJBigInt {
    var carry = carry;

    let nrNewDigits: Int
    switch (optionalRhs, handleOverflow) {
    case (.none, false):                nrNewDigits = lhs.digits.count
    case (.none, true):                 nrNewDigits = lhs.digits.count + 1
    case (.some(let rhs), false):       nrNewDigits = max(lhs.digits.count, rhs.digits.count)
    case (.some(let rhs), true):        nrNewDigits = max(lhs.digits.count, rhs.digits.count) + 1
    }

    var newDigits = Array<UInt64>(repeating: 0, count: nrNewDigits)

    for i in 0 ..< nrNewDigits {
        let result: UInt64
        switch (optionalRhs, invert) {
        case (.none, false):
            (result, carry) = add_overflow(lhs[i], 0, carry: carry)
        case (.none, true):
            (result, carry) = add_overflow(~lhs[i], 0, carry: carry)
        case (.some(let rhs), false):
            (result, carry) = add_overflow(lhs[i], rhs[i], carry: carry)
        case (.some(let rhs), true):
            (result, carry) = add_overflow(lhs[i], ~rhs[i], carry: carry)
        }

        newDigits[i] = result
    }

    return TJBigInt(digits: newDigits)
}
