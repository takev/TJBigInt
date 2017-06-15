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

import Foundation

public protocol PowerOfTwo {
    // Count the number bits that are set to '1'.
    var popcount: Int { get }

    // Return the index + 1 of the least significant bit that is set to '1'.
    // Return zero when no bits are set.
    var ffs: Int { get }
}

public extension PowerOfTwo {
    public var isPowerOfTwo: Bool {
        return popcount == 1
    }

    public var exponentOfPowerOfTwo: Int {
        assert(isPowerOfTwo, "Must be a power of two to get the exponent.")
        return ffs - 1
    }
}

extension UInt64: PowerOfTwo {
    public var popcount: Int {
        let tmp1 = (self & 0x5555555555555555) &+ ((self >> 1) & 0x5555555555555555)
        let tmp2 = (tmp1 & 0x3333333333333333) &+ ((tmp1 >> 2) & 0x3333333333333333)
        let tmp3 = (tmp2 & 0x0F0F0F0F0F0F0F0F) &+ ((tmp2 >> 4) & 0x0F0F0F0F0F0F0F0F)
        return Int((tmp3 &* 0x0101010101010101) >> 56)
    }

    public var ffs: Int {
        if self == 0 {
            return 0

        } else {
            let b: [UInt64] = [0x2, 0xc, 0xf0, 0xff00, 0xffff0000, 0xffffffff00000000]
            let S: [UInt64] = [1, 2, 4, 8, 16, 32]

            var v = self
            var r = UInt64(0)

            for i in (0...5).reversed() {
                if (v & b[i]) > 0 {
                    v >>= S[i];
                    r |= S[i];
                }
            }

            return Int(r + 1)
        }
    }
}

public func shiftl_overflow(_ lhs: UInt64, _ rhs: UInt64, carry: UInt64) -> (UInt64, UInt64) {
    let result = (lhs << rhs) | carry
    let newCarry = lhs >> (UInt64(64) - rhs)
    return (result, newCarry)
}

public func shiftr_overflow(_ lhs: UInt64, _ rhs: UInt64, carry: UInt64) -> (UInt64, UInt64) {
    let result = (lhs >> rhs) | carry
    let newCarry = lhs << (UInt64(64) - rhs)
    return (result, newCarry)
}

public func shiftr_overflow_sign_extend(_ lhs: UInt64, _ rhs: UInt64) -> (UInt64, UInt64) {
    let lhsInt = Int64(bitPattern: lhs)

    let resultInt = lhsInt >> Int64(rhs)
    let result = UInt64(bitPattern: resultInt)
    let newCarry = lhs << (UInt64(64) - rhs)
    return (result, newCarry)
}

public func add_overflow(_ lhs: UInt64, _ rhs: UInt64) -> (partialValue: UInt64, carry: UInt64) {
    let tmp1 = lhs.addingReportingOverflow(rhs)
    let newCarry : UInt64 = tmp1.overflow == .overflow ? 1 : 0

    return (partialValue: tmp1.partialValue, carry: newCarry)
}

public func add_overflow(_ lhs: UInt64, _ rhs: UInt64, carry: UInt64) -> (partialValue: UInt64, carry: UInt64) {
    let tmp1 = lhs.addingReportingOverflow(rhs)
    let tmp2 = tmp1.partialValue.addingReportingOverflow(carry)
    let newCarry : UInt64 = (tmp1.overflow == .overflow || tmp2.overflow == .overflow) ? 1 : 0

    return (partialValue: tmp2.partialValue, carry: newCarry)
}

public func mul_overflow(_ lhs: UInt64, _ rhs: UInt64, carry: UInt64) -> (partialValue: UInt64, carry: UInt64) {
    // (lhs * rhs) + carry.
    // Result is save to fit in two 64 bit values, without overflow
    let tmp1 = lhs.multipliedFullWidth(by: rhs)
    let tmp2 = add_overflow(tmp1.low, carry)
    let high3 = tmp1.high.unsafeAdding(tmp2.carry)

    return (partialValue: tmp2.partialValue, carry: high3)
}

public func mul_overflow(_ lhs: UInt64, _ rhs: UInt64, carry: UInt64, accumulator: UInt64) -> (UInt64, UInt64) {
    // (lhs * rhs) + carry + accumulator.
    // Result is save to fit in two 64 bit values, without overflow
    let tmp1 = lhs.multipliedFullWidth(by: rhs)
    let tmp2 = add_overflow(tmp1.low, carry)
    let high3 = tmp1.high.unsafeAdding(tmp2.carry)
    let tmp4 = add_overflow(tmp2.partialValue, accumulator)
    let high5 = high3.unsafeAdding(tmp4.carry)

    return (partialValue: tmp4.partialValue, carry: high5)
}



