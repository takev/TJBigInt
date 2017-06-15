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
import TJRandom

public struct TJBigInt : CustomStringConvertible, Equatable, PowerOfTwo {
    // These digits are in little endian order (LSB at index 0).
    let digits: [UInt64]

    static func nrOfDigitsForBytes(_ nrBytes: Int) -> Int {
        return (nrBytes + 7) / 8
    }

    public init(digits: [UInt64]) {
        let numberOfDigits = TJBigInt.numberOfSignificantDigits(digits)
        self.digits = Array(digits[0 ..< numberOfDigits])
    }

    public init() {
        digits = []
    }

    public init(bytes: [UInt8]) {
        var tmp_digits = Array<UInt64>(repeating: UInt64(0), count: TJBigInt.nrOfDigitsForBytes(bytes.count))

        var tmp_digit: UInt64 = 0
        for (i, byte) in bytes.enumerated() {
            switch (i % MemoryLayout.size(ofValue: tmp_digit)) {
            case 0:
                tmp_digit = UInt64(byte)
            case 1:
                tmp_digit |= (UInt64(byte) << 8)
            case 2:
                tmp_digit |= (UInt64(byte) << 16)
            case 3:
                tmp_digit |= (UInt64(byte) << 24)
            case 4:
                tmp_digit |= (UInt64(byte) << 32)
            case 5:
                tmp_digit |= (UInt64(byte) << 40)
            case 6:
                tmp_digit |= (UInt64(byte) << 48)
            case 7:
                tmp_digit |= (UInt64(byte) << 56)
                tmp_digits[i / MemoryLayout.size(ofValue: tmp_digit)] = tmp_digit
            default:
                preconditionFailure()
            }
        }

        digits = tmp_digits
    }

    public init(_ value: Int) {
        let longValue = Int64(value)
        let unsignedLongValue = UInt64(bitPattern: longValue)
        let newDigits = [unsignedLongValue]

        self.init(digits: newDigits)
    }

    public init(_ text: String) throws {
        var text = text
        let base: Int
        let negative: Bool

        if text.hasPrefix("-") {
            negative = true
            text = text.substring(from: text.characters.index(text.startIndex, offsetBy:1))
        } else {
            negative = false
        }

        if text.hasPrefix("0x") {
            base = 16
            text = text.substring(from: text.characters.index(text.startIndex, offsetBy:2))
        } else if text.hasPrefix("0d") {
            base = 10
            text = text.substring(from: text.characters.index(text.startIndex, offsetBy:2))
        } else if text.hasPrefix("0o") {
            base = 8
            text = text.substring(from: text.characters.index(text.startIndex, offsetBy:2))
        } else if text.hasPrefix("0b") {
            base = 2
            text = text.substring(from: text.characters.index(text.startIndex, offsetBy:2))
        } else {
            base = 10
        }

        var tmp = TJBigInt()
        for c in text.characters {
            switch c {
            case "0"        : tmp = (tmp * base) + 0x0
            case "1"        : tmp = (tmp * base) + 0x1
            case "2"        : tmp = (tmp * base) + 0x2
            case "3"        : tmp = (tmp * base) + 0x3
            case "4"        : tmp = (tmp * base) + 0x4
            case "5"        : tmp = (tmp * base) + 0x5
            case "6"        : tmp = (tmp * base) + 0x6
            case "7"        : tmp = (tmp * base) + 0x7
            case "8"        : tmp = (tmp * base) + 0x8
            case "9"        : tmp = (tmp * base) + 0x9
            case "a", "A"   : tmp = (tmp * base) + 0xa
            case "b", "B"   : tmp = (tmp * base) + 0xb
            case "c", "C"   : tmp = (tmp * base) + 0xc
            case "d", "D"   : tmp = (tmp * base) + 0xd
            case "e", "E"   : tmp = (tmp * base) + 0xe
            case "f", "F"   : tmp = (tmp * base) + 0xf
            case "_" : break
            default:
                throw TJBigIntError.unknown_CHARACTER(c)
            }
        }

        if negative {
            tmp = -tmp
        }

        self.init(digits: tmp.digits)
    }

    // Create a positive random number of nrBits in size.
    // The number may be smaller than nrBits if the most significant bits are zero.
    public init(randomNrBits nrBits: Int) {
        let nrDigits = (nrBits + 63) / 64

        // Reserve an extra digit so that it is always unsigned.
        var tmp_digits = Array<UInt64>(repeating: UInt64(0), count: nrDigits + 1)

        TJRandom_getUInt64Array(UnsafeMutablePointer(mutating: tmp_digits), nrDigits)

        // Create the last random digit, masking only the bits that we want.
        let nrBitsInLastDigit = (nrDigits * 64) - nrBits
        if nrBitsInLastDigit > 0 {
            let maskOfLastDigit = ((UInt64(1) << UInt64(nrBitsInLastDigit)) - 1) as UInt64
            tmp_digits[nrDigits - 1] &= maskOfLastDigit
        }

        self.init(digits: tmp_digits)
    }

    // Return the digit at index.
    // When requesting digits beyond the internal size, then a sign extended digit is returned.
    subscript(i: Int) -> UInt64 {
        get {
            precondition(i >= 0)

            if i < digits.count {
                return digits[i]
            } else if (isPositive) {
                return 0
            } else {
                return 0xffffffff_ffffffff
            }
        }
    }

    // Return the bit at index.
    // When requesting bits beyond the internal size, then a sign extended bit is returned.
    public func getBit(_ i: Int) -> Bool {
        let digit = self[i / 64]
        let bit = (digit >> UInt64(i % 64)) & (1 as UInt64)
        return (bit > 0) ? true : false
    }

    public func setBit(_ i: Int, _ value: Bool = true) -> TJBigInt {
        let digitPosition = i / 64
        let bitPosition = i % 64

        let nrDigits = digitPosition + 1
        let nrDigitsToAdd = max(0, nrDigits - self.digits.count)
        var newDigits = self.digits + Array<UInt64>(repeating: 0, count: nrDigitsToAdd)

        let digitToModify = newDigits[digitPosition]
        let mask = (0xffffffff_fffffffe as UInt64) << UInt64(bitPosition)
        let shiftedValue = value ? (UInt64(1) << UInt64(bitPosition)) : UInt64(0)
        let modifiedDigit = (digitToModify & mask) | shiftedValue
        newDigits[digitPosition] = modifiedDigit

        return TJBigInt(digits: newDigits)
    }

    public func digitIsPositive(_ i: Int) -> Bool {
        assert(i >= 0 && i < digits.count)
        return digits[i] < 0x80000000_00000000
    }

    public var isPositive: Bool {
        return digits.count == 0 || digits.last! < 0x80000000_00000000
    }

    public var isNegative: Bool {
        return !isPositive
    }

    public var isOdd: Bool {
        return (digits.count > 0) && ((digits[0] & 1) == 1)
    }

    public var isEven: Bool {
        return (digits.count == 0) || ((digits[0] & 1) == 0)
    }

    public var popcount: Int {
        precondition(isPositive, "Popcount can only be done on positive numbers.")
        return digits.reduce(0) {$0 + $1.popcount}
    }

    public var ffs: Int {
        for (i, digit) in digits.enumerated() {
            if digit > 0 {
                return i * 64 + digit.ffs
            }
        }
        return 0
    }

    //public var clz: Int {
    //    preconditionFailure("Leading zeros make no sence on variable sized integers.")
    //}

    public var abs: TJBigInt {
        return isNegative ? -self : self
    }

    public var description: String {
        let BCDNumber = doubleDabble(abs.digits)
        let decimalString = BCDToStringWithoutLeadingZeros(BCDNumber)

        if isNegative {
            return "-" + decimalString
        } else {
            return decimalString
        }
    }

    public var hexDescription: String {
        if self.digits.count == 0 {
            return "0x0"
            
        } else {
            var hex_values = Array<String>()
            for var digit in self.digits {
                for _ in 0 ..< (MemoryLayout<UInt64>.size * 2) {
                    switch (digit & 0xf) {
                    case 0x0:     hex_values.append("0")
                    case 0x1:     hex_values.append("1")
                    case 0x2:     hex_values.append("2")
                    case 0x3:     hex_values.append("3")
                    case 0x4:     hex_values.append("4")
                    case 0x5:     hex_values.append("5")
                    case 0x6:     hex_values.append("6")
                    case 0x7:     hex_values.append("7")
                    case 0x8:     hex_values.append("8")
                    case 0x9:     hex_values.append("9")
                    case 0xa:     hex_values.append("a")
                    case 0xb:     hex_values.append("b")
                    case 0xc:     hex_values.append("c")
                    case 0xd:     hex_values.append("d")
                    case 0xe:     hex_values.append("e")
                    case 0xf:     hex_values.append("f")
                    default:      preconditionFailure("unreachable")
                    }
                    digit >>= 4
                }
                hex_values.append("_")
            }
            hex_values.removeLast()

            return "0x" + hex_values.reversed().reduce("", { $0 + $1 })
        }
    }

    public var intValue: Int {
        precondition(isPositive, "Not implemented")

        switch (digits.count) {
        case 0:
            return 0
        case 1:
            return Int(Int64(bitPattern:digits[0]))
        default:
            preconditionFailure("Overflow")
        }
    }

    // Count the number of significant digits.
    static func numberOfSignificantDigits(_ digits: [UInt64]) -> Int {
        var i = digits.count - 1;
        while i >= 1 {
            switch (digits[i], digits[i - 1] < 0x80000000_00000000) {
            case (0, true):
                // If this digit is leading zeros and the next digit has a leading zero, then we can skip this digit.
                break
            case (0xffffffff_ffffffff, false):
                // If this digit is leading ones and the next digit has a leading one, then we can skip this digit.
                break
            default:
                // This digit can not be excluded.
                return i + 1
            }

            i -= 1
        }

        if digits.count == 0 || digits[0] == 0 {
            return 0
        } else {
            return 1
        }
    }

    static func decimalToTJBigInt(_ text: String, negative: Bool) -> TJBigInt {
        var tmp = TJBigInt()

        for c in text.characters.reversed() {
            switch c {
            case "0" : tmp = (tmp * 10) + 0
            case "1" : tmp = (tmp * 10) + 1
            case "2" : tmp = (tmp * 10) + 2
            case "3" : tmp = (tmp * 10) + 3
            case "4" : tmp = (tmp * 10) + 4
            case "5" : tmp = (tmp * 10) + 5
            case "6" : tmp = (tmp * 10) + 6
            case "7" : tmp = (tmp * 10) + 7
            case "8" : tmp = (tmp * 10) + 8
            case "9" : tmp = (tmp * 10) + 9
            case "_" : break
            default:
                break
            }
        }

        if negative {
            return -tmp
        } else {
            return tmp
        }
    }
}

extension Int {
    init(_ value: TJBigInt) {
        self = value.intValue
    }
}





