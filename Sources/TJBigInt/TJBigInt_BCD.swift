// TJBigInt - A Swift package for working with large integers.
// Copyright (C) 2015-2017  Tjienta Vara
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

import Foundation

func BCDToDigits(_ BCDDigits: UInt64) -> [UInt64] {
    return [
        ((BCDDigits >>  0) & 0xf) as UInt64,
        ((BCDDigits >>  4) & 0xf) as UInt64,
        ((BCDDigits >>  8) & 0xf) as UInt64,
        ((BCDDigits >> 12) & 0xf) as UInt64,
        ((BCDDigits >> 16) & 0xf) as UInt64,
        ((BCDDigits >> 20) & 0xf) as UInt64,
        ((BCDDigits >> 24) & 0xf) as UInt64,
        ((BCDDigits >> 28) & 0xf) as UInt64,
        ((BCDDigits >> 32) & 0xf) as UInt64,
        ((BCDDigits >> 36) & 0xf) as UInt64,
        ((BCDDigits >> 40) & 0xf) as UInt64,
        ((BCDDigits >> 44) & 0xf) as UInt64,
        ((BCDDigits >> 48) & 0xf) as UInt64,
        ((BCDDigits >> 52) & 0xf) as UInt64,
        ((BCDDigits >> 56) & 0xf) as UInt64,
        ((BCDDigits >> 60) & 0xf) as UInt64
    ]
}

func digitsToBCD(_ digits: [UInt64]) -> UInt64 {
    var tmp: UInt64 = 0

    for i in 0 ..< digits.count {
        let digit = digits[i]
        //assert(digit < 10, "BCD digits must be smaller than 10.")
        tmp |= digit << UInt64(i * 4)
    }

    return tmp
}

func dabble(_ BCDDigits: UInt64) -> UInt64 {
    let digits = BCDToDigits(BCDDigits)
    var carried_digits = Array<UInt64>(repeating: 0, count: digits.count)

    for i in 0 ..< digits.count {
        let digit = digits[i]

        carried_digits[i] = (digit > 4) ? (digit + 3) : digit;
    }
    return digitsToBCD(carried_digits)
}

/// Convert a big integer number into BCD.
func doubleDabble(_ number: [UInt64]) -> [UInt64] {
    let number_nr_bits = number.count * 64
    let bcd_nr_bits = ((Int(ceil(Double(number_nr_bits) / 3.0) * 4) + 63) / 64) * 64

    var buffer = number + Array<UInt64>(repeating: 0, count: bcd_nr_bits / 64)

    for _ in 0 ..< number_nr_bits {
        // For each nible that is higher than 4, add 3.
        for i in number.count ..< buffer.count {
            buffer[i] = dabble(buffer[i])
        }

        // Shift left by 1.
        var overflow: UInt64 = 0
        for i in 0 ..< buffer.count {
            (buffer[i], overflow) = shiftl_overflow(buffer[i], 1, carry: overflow)
        }
    }

    return Array<UInt64>(buffer[number.count ..< buffer.count])
}

func ShortBCDToString(_ BCDDigits: UInt64) -> [String] {
    var digitsString: [String] = []

    let digits = BCDToDigits(BCDDigits)
    for digit in digits {
        switch digit {
        case 0: digitsString.append("0")
        case 1: digitsString.append("1")
        case 2: digitsString.append("2")
        case 3: digitsString.append("3")
        case 4: digitsString.append("4")
        case 5: digitsString.append("5")
        case 6: digitsString.append("6")
        case 7: digitsString.append("7")
        case 8: digitsString.append("8")
        case 9: digitsString.append("9")
        case 10: digitsString.append("a")
        case 11: digitsString.append("b")
        case 12: digitsString.append("c")
        case 13: digitsString.append("d")
        case 14: digitsString.append("e")
        case 15: digitsString.append("f")
        default: preconditionFailure("Unreachable")
        }
    }
    return digitsString
}

func BCDToString(_ BCDNumber: [UInt64]) -> String {
    let characters = BCDNumber.reduce(Array<String>()) { $0 + ShortBCDToString($1) }.reversed()
    return characters.joined(separator: "")
}

func DecimalStripLeadingZeros(_ number: String) -> String {
    if number.characters.count == 0 {
        return "0"

    } else {
        for (i, c) in number.characters.enumerated() {
            // Stop when we find a non "0" or if there is only one digit left.
            if (c != "0") || (i == (number.characters.count - 1)) {
                return number.substring(from: number.characters.index(number.startIndex, offsetBy:i))
            }
        }
    }
    preconditionFailure("Unreachable, unless the string is zero size")
}

func BCDToStringWithoutLeadingZeros(_ BCDNumber: [UInt64]) -> String {
    let decimalString = BCDToString(BCDNumber)
    return DecimalStripLeadingZeros(decimalString)
}

