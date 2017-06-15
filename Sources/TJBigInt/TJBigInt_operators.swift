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

public func +(lhs: TJBigInt, rhs: TJBigInt) -> TJBigInt {
    return additionGeneric(lhs, rhs)
}

public func +(lhs: TJBigInt, rhs: Int) -> TJBigInt {
    if rhs == 0 {
        return lhs
    } else if rhs > 0 {
        return additionGeneric(lhs, nil, carry: UInt64(rhs))
    } else {
        return lhs + TJBigInt(rhs)
    }
}

public func -(lhs: TJBigInt, rhs: TJBigInt) -> TJBigInt {
    return additionGeneric(lhs, rhs, carry: 1, invert: true, handleOverflow: false)
}

public func -(lhs: TJBigInt, rhs: Int) -> TJBigInt {
    return additionGeneric(lhs, TJBigInt(rhs), carry: 1, invert: true, handleOverflow: false)
}

public prefix func -(lhs: TJBigInt) -> TJBigInt {
    return additionGeneric(lhs, nil, carry: 1, invert: true, handleOverflow: false)
}

public prefix func ~(lhs: TJBigInt) -> TJBigInt {
    let newDigits = lhs.digits.map{return ~$0}
    return TJBigInt(digits: newDigits)
}

public func >>(lhs: TJBigInt, rhs: Int) -> TJBigInt {
    switch rhs {
    case 0:
        return lhs
    case 1 ..< 64:
        return shiftRightByAtMostOneDigit(lhs, rhs)
    case let rhs where (rhs % 64) == 0:
        return shiftRightByDigits(lhs, rhs / 64)
    case let rhs where rhs < 0:
        return lhs << -rhs
    default:
        return shiftRightByBits(lhs, rhs)
    }
}

public func <<(lhs: TJBigInt, rhs: Int) -> TJBigInt {
    switch rhs {
    case 0:
        return lhs
    case 1 ..< 64:
        return shiftLeftByAtMostOneDigit(lhs, rhs)
    case let rhs where (rhs % 64) == 0:
        return shiftLeftByDigits(lhs, rhs / 64)
    case let rhs where rhs < 0:
        return lhs >> -rhs
    default:
        return shiftLeftByBits(lhs, rhs)
    }
}

public func *(lhs: TJBigInt, rhs: Int) -> TJBigInt {
    switch rhs {
    case 0:
        return TJBigInt()
    case 1:
        return lhs
    case let rhs where rhs > 0 && UInt64(rhs).isPowerOfTwo:
        return lhs << UInt64(rhs).exponentOfPowerOfTwo
    case let rhs where rhs >= 1:
        return multiplyByDigit(lhs, UInt64(rhs))
    default:
        return lhs * TJBigInt(rhs)
    }
}

public func *(lhs: TJBigInt, rhs: TJBigInt) -> TJBigInt {
    switch rhs {
    case let rhs where rhs.digits.count == 0:
        return TJBigInt()
    case let rhs where rhs > 0 && rhs.digits.count == 1:
        return lhs * Int(rhs.digits[0])
    case let rhs where rhs >= 0 && rhs.isPowerOfTwo:
        return lhs << rhs.exponentOfPowerOfTwo
    default:
        return multiplySchoolAlgorithm(lhs, rhs)
    }
}

public func /(lhs: TJBigInt, rhs: TJBigInt) -> TJBigInt {
    let (quotient, _) = divisionSchoolAlgorithm(lhs, rhs)
    return quotient
}

public func %(lhs: TJBigInt, rhs: TJBigInt) -> TJBigInt {
    let (_, remainder) = divisionSchoolAlgorithm(lhs, rhs)
    return remainder
}

public func >=(lhs: TJBigInt, rhs: TJBigInt) -> Bool {
    switch compare(lhs, rhs) {
    case .leftEqualToRight:         return true
    case .leftGreaterThanRight:     return true
    case .leftLessThanRight:        return false
    }
}

public func <=(lhs: TJBigInt, rhs: TJBigInt) -> Bool {
    switch compare(lhs, rhs) {
    case .leftEqualToRight:         return true
    case .leftGreaterThanRight:     return false
    case .leftLessThanRight:        return true
    }
}

public func <(lhs: TJBigInt, rhs: TJBigInt) -> Bool {
    switch compare(lhs, rhs) {
    case .leftEqualToRight:         return false
    case .leftGreaterThanRight:     return false
    case .leftLessThanRight:        return true
    }
}

public func >(lhs: TJBigInt, rhs: TJBigInt) -> Bool {
    switch compare(lhs, rhs) {
    case .leftEqualToRight:         return false
    case .leftGreaterThanRight:     return true
    case .leftLessThanRight:        return false
    }
}

public func ==(lhs: TJBigInt, rhs: TJBigInt) -> Bool {
    switch compare(lhs, rhs) {
    case .leftEqualToRight:         return true
    case .leftGreaterThanRight:     return false
    case .leftLessThanRight:        return false
    }
}

public func !=(lhs: TJBigInt, rhs: TJBigInt) -> Bool {
    switch compare(lhs, rhs) {
    case .leftEqualToRight:         return false
    case .leftGreaterThanRight:     return true
    case .leftLessThanRight:        return true
    }
}

public func %(lhs: TJBigInt, rhs: Int) -> TJBigInt {
    if lhs.digits.count == 0 {
        return TJBigInt()
    } else if rhs == 2 {
        return TJBigInt(Int(lhs.digits[0] & 1))
    } else if rhs > 0 && rhs <= 9223372036854775807 && UInt64(rhs).isPowerOfTwo {
        return TJBigInt(Int(lhs.digits[0] % UInt64(rhs)))
    } else {
        return lhs % TJBigInt(rhs)
    }
}

public func ==(lhs: TJBigInt, rhs: Int) -> Bool {
    if rhs == 0 {
        return lhs.digits.count == 0
    } else if rhs > 0 && rhs <= 9223372036854775807 {
        return (lhs.digits.count == 1) && (lhs.digits[0] == UInt64(rhs))
    } else {
        return lhs == TJBigInt(rhs)
    }
}

public func !=(lhs: TJBigInt, rhs: Int) -> Bool {
    if rhs == 0 {
        return lhs.digits.count != 0
    } else {
        return lhs != TJBigInt(rhs)
    }
}

public func >=(lhs: TJBigInt, rhs: Int) -> Bool {
    if rhs == 0 {
        return lhs.isPositive
    } else {
        return lhs >= TJBigInt(rhs)
    }
}

public func <(lhs: TJBigInt, rhs: Int) -> Bool {
    if rhs == 0 {
        return lhs.isNegative
    } else {
        return lhs < TJBigInt(rhs)
    }
}

public func >(lhs: TJBigInt, rhs: Int) -> Bool {
    if rhs == 0 {
        return lhs.isPositive && (lhs.digits.count > 0)
    } else {
        return lhs < TJBigInt(rhs)
    }
}

public func abs(_ lhs: TJBigInt) -> TJBigInt {
    return lhs.abs
}

