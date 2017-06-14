//
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

func shiftLeftByBits(_ lhs: TJBigInt, _ rhs: Int, carry: UInt64 = 0) -> TJBigInt {
    var carry = carry;
    let shiftNrDigits = rhs >> 6
    let shiftNrBits = rhs & 0x3f

    var newDigits = Array<UInt64>(repeating: 0, count: lhs.digits.count + shiftNrDigits + 1)

    for i in 0 ..< newDigits.count {
        if (i < shiftNrDigits) {
            newDigits[i] = 0
        } else {
            let j = i - shiftNrDigits

            // lhs-subscript automaticaly sign extends, so no need to worry about that.
            (newDigits[i], carry) = shiftl_overflow(lhs[j], UInt64(shiftNrBits), carry: carry)
        }
    }

    return TJBigInt(digits: newDigits)
}

func shiftLeftByDigits(_ lhs: TJBigInt, _ rhs: Int) -> TJBigInt {
    return TJBigInt(digits: Array<UInt64>(repeating: 0, count: rhs) + lhs.digits)
}

func shiftLeftByAtMostOneDigit(_ lhs: TJBigInt, _ rhs: Int, carry: UInt64 = 0) -> TJBigInt {
    var carry = carry;

    // Sign extend with one extra digit to handle to potential overflow.
    var newDigits = lhs.digits + [lhs[lhs.digits.count]]

    for i in 0 ..< newDigits.count {
        (newDigits[i], carry) = shiftl_overflow(lhs[i], UInt64(rhs), carry: carry)
    }

    return TJBigInt(digits: newDigits)
}

func shiftLeftByOneBit(_ lhs: TJBigInt, newBit: Bool = false) -> TJBigInt {
    return shiftLeftByAtMostOneDigit(lhs, 1, carry: newBit ? 1 : 0)
}

func shiftRightByBits(_ lhs: TJBigInt, _ rhs: Int) -> TJBigInt {
    let shiftNrDigits = rhs >> 6
    let shiftNrBits = rhs & 0x3f

    var newDigits = Array<UInt64>(repeating: 0, count: lhs.digits.count - shiftNrDigits + 1)

    // Fill in the carry by the sign of the lhs (take a digit beyond the number of digits available).
    var carry: UInt64 = lhs[lhs.digits.count]

    // Handle the first digit by sign extending.
    var i = newDigits.count - 1
    let j = i + shiftNrDigits
    (newDigits[i], carry) = shiftr_overflow_sign_extend(lhs[j], UInt64(shiftNrBits))
    i -= 1

    while i >= 0 {
        let j = i + shiftNrDigits

        (newDigits[i], carry) = shiftr_overflow(lhs[j], UInt64(shiftNrBits), carry: carry)

        i -= 1
    }

    return TJBigInt(digits: newDigits)
}

func shiftRightByDigits(_ lhs: TJBigInt, _ rhs: Int) -> TJBigInt {
    let nrDigitsToShift = min(rhs, lhs.digits.count)
    let newDigits = Array<UInt64>(lhs.digits[nrDigitsToShift ..< lhs.digits.count])

    if lhs.isPositive || newDigits.count > 0 {
        // If it is positive can simply discard digits.
        return TJBigInt(digits: newDigits)

    } else {
        // Return -1 if we shifted maximum to the right on a negative number.
        return TJBigInt(digits: [0xffffffff_ffffffff])
    }
}

func shiftRightByAtMostOneDigit(_ lhs: TJBigInt, _ rhs: Int) -> TJBigInt {
    if lhs.digits.count == 0 {
        return TJBigInt()

    } else {
        var newDigits = Array<UInt64>(repeating: 0, count: lhs.digits.count)

        // Fill in the carry by the sign of the lhs (take a digit beyond the number of digits available).
        var carry: UInt64
        (newDigits[newDigits.count - 1], carry) = shiftr_overflow_sign_extend(lhs[newDigits.count - 1], UInt64(rhs))
        for i in (0 ..< newDigits.count - 1).reversed() {
            (newDigits[i], carry) = shiftr_overflow(lhs[i], UInt64(rhs), carry: carry)
        }

        return TJBigInt(digits: newDigits)
    }
}

func shiftRightByOneBit(_ lhs: TJBigInt) -> TJBigInt {
    return shiftRightByAtMostOneDigit(lhs, 1)
}

