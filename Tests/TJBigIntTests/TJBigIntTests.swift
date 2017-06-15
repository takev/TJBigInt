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


import XCTest
@testable import TJBigInt

class TJBigInt_tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func TJBigIntStringFactor(_ text: String) -> TJBigInt {
        return try! TJBigInt(text)
    }

    func testIntInitialization() {
        XCTAssertEqual(TJBigInt(0).hexDescription, "0x0")
        XCTAssertEqual(TJBigInt(1).hexDescription, "0x0000000000000001")
        XCTAssertEqual(TJBigInt(-1).hexDescription, "0xffffffffffffffff")
        XCTAssertEqual(TJBigInt(0xffffffff).hexDescription, "0x00000000ffffffff")
        XCTAssertEqual(TJBigInt(0x1_ffffffff).hexDescription, "0x00000001ffffffff")
        XCTAssertEqual(TJBigInt(-0x1_ffffffff).hexDescription, "0xfffffffe00000001")
        XCTAssertEqual(TJBigInt(-0x80000000_00000000).hexDescription, "0x8000000000000000")
        XCTAssertEqual(TJBigInt(0x7fffffff_ffffffff).hexDescription, "0x7fffffffffffffff")
    }

    func testStringInitialization() {
        XCTAssertEqual(try! TJBigInt("0").hexDescription, "0x0")
        XCTAssertEqual(try! TJBigInt("1").hexDescription, "0x0000000000000001")
        XCTAssertEqual(try! TJBigInt("-1").hexDescription, "0xffffffffffffffff")
        XCTAssertEqual(try! TJBigInt("0xffffffff").hexDescription, "0x00000000ffffffff")
        XCTAssertEqual(try! TJBigInt("0x1_23456789").hexDescription, "0x0000000123456789")
        XCTAssertEqual(try! TJBigInt("0x1_ffffffff").hexDescription, "0x00000001ffffffff")
        XCTAssertEqual(try! TJBigInt("-0x1_ffffffff").hexDescription, "0xfffffffe00000001")
        XCTAssertEqual(try! TJBigInt("-0x80000000_00000000").hexDescription, "0x8000000000000000")
        XCTAssertEqual(try! TJBigInt("0x7fffffff_ffffffff").hexDescription, "0x7fffffffffffffff")
        XCTAssertEqual(try! TJBigInt("0x00000000_7fffffff_ffffffff").hexDescription, "0x7fffffffffffffff")
        XCTAssertEqual(try! TJBigInt("0x00000000_00000000_7fffffff_ffffffff").hexDescription, "0x7fffffffffffffff")
    }

    func testDecimalInitializationAndDecimalDescription() {
        XCTAssertEqual(try! TJBigInt("0").description, "0")
        XCTAssertEqual(try! TJBigInt("-0").description, "0")

        XCTAssertEqual(try! TJBigInt("1").description, "1")
        XCTAssertEqual(try! TJBigInt("10").description, "10")
        XCTAssertEqual(try! TJBigInt("100").description, "100")
        XCTAssertEqual(try! TJBigInt("1000").description, "1000")
        XCTAssertEqual(try! TJBigInt("10000").description, "10000")
        XCTAssertEqual(try! TJBigInt("100000").description, "100000")
        XCTAssertEqual(try! TJBigInt("1000000").description, "1000000")
        XCTAssertEqual(try! TJBigInt("10000000").description, "10000000")
        XCTAssertEqual(try! TJBigInt("100000000").description, "100000000")
        XCTAssertEqual(try! TJBigInt("1000000000").description, "1000000000")
        XCTAssertEqual(try! TJBigInt("10000000000").description, "10000000000")
        XCTAssertEqual(try! TJBigInt("100000000000").description, "100000000000")
        XCTAssertEqual(try! TJBigInt("1000000000000").description, "1000000000000")
        XCTAssertEqual(try! TJBigInt("10000000000000").description, "10000000000000")
        XCTAssertEqual(try! TJBigInt("100000000000000").description, "100000000000000")
        XCTAssertEqual(try! TJBigInt("1000000000000000").description, "1000000000000000")
        XCTAssertEqual(try! TJBigInt("10000000000000000").description, "10000000000000000")
        XCTAssertEqual(try! TJBigInt("100000000000000000").description, "100000000000000000")
        XCTAssertEqual(try! TJBigInt("1000000000000000000").description, "1000000000000000000")
        XCTAssertEqual(try! TJBigInt("10000000000000000000").description, "10000000000000000000")
        XCTAssertEqual(try! TJBigInt("100000000000000000000").description, "100000000000000000000")
        XCTAssertEqual(try! TJBigInt("1000000000000000000000").description, "1000000000000000000000")
        XCTAssertEqual(try! TJBigInt("10000000000000000000000").description, "10000000000000000000000")
        XCTAssertEqual(try! TJBigInt("100000000000000000000000").description, "100000000000000000000000")
        XCTAssertEqual(try! TJBigInt("1000000000000000000000000").description, "1000000000000000000000000")
        XCTAssertEqual(try! TJBigInt("10000000000000000000000000").description, "10000000000000000000000000")

        XCTAssertEqual(try! TJBigInt("12").description, "12")
        XCTAssertEqual(try! TJBigInt("123").description, "123")
        XCTAssertEqual(try! TJBigInt("1234").description, "1234")
        XCTAssertEqual(try! TJBigInt("12345").description, "12345")
        XCTAssertEqual(try! TJBigInt("123456").description, "123456")
        XCTAssertEqual(try! TJBigInt("1234567").description, "1234567")
        XCTAssertEqual(try! TJBigInt("12345678").description, "12345678")
        XCTAssertEqual(try! TJBigInt("123456789").description, "123456789")
        XCTAssertEqual(try! TJBigInt("1234567890").description, "1234567890")
        XCTAssertEqual(try! TJBigInt("12345678901").description, "12345678901")
        XCTAssertEqual(try! TJBigInt("123456789012").description, "123456789012")
        XCTAssertEqual(try! TJBigInt("1234567890123").description, "1234567890123")
        XCTAssertEqual(try! TJBigInt("12345678901234").description, "12345678901234")
        XCTAssertEqual(try! TJBigInt("123456789012345").description, "123456789012345")
        XCTAssertEqual(try! TJBigInt("1234567890123456").description, "1234567890123456")
        XCTAssertEqual(try! TJBigInt("12345678901234567").description, "12345678901234567")
        XCTAssertEqual(try! TJBigInt("123456789012345678").description, "123456789012345678")
        XCTAssertEqual(try! TJBigInt("1234567890123456789").description, "1234567890123456789")
        XCTAssertEqual(try! TJBigInt("12345678901234567890").description, "12345678901234567890")
        XCTAssertEqual(try! TJBigInt("123456789012345678901").description, "123456789012345678901")
        XCTAssertEqual(try! TJBigInt("1234567890123456789012").description, "1234567890123456789012")
        XCTAssertEqual(try! TJBigInt("12345678901234567890123").description, "12345678901234567890123")
        XCTAssertEqual(try! TJBigInt("123456789012345678901234").description, "123456789012345678901234")
        XCTAssertEqual(try! TJBigInt("1234567890123456789012345").description, "1234567890123456789012345")
        XCTAssertEqual(try! TJBigInt("12345678901234567890123456").description, "12345678901234567890123456")
        XCTAssertEqual(try! TJBigInt("123456789012345678901234567").description, "123456789012345678901234567")
        XCTAssertEqual(try! TJBigInt("1234567890123456789012345678").description, "1234567890123456789012345678")
        XCTAssertEqual(try! TJBigInt("12345678901234567890123456789").description, "12345678901234567890123456789")
        XCTAssertEqual(try! TJBigInt("123456789012345678901234567890").description, "123456789012345678901234567890")

        XCTAssertEqual(try! TJBigInt("-12").description, "-12")
        XCTAssertEqual(try! TJBigInt("-123").description, "-123")
        XCTAssertEqual(try! TJBigInt("-1234").description, "-1234")
        XCTAssertEqual(try! TJBigInt("-12345").description, "-12345")
        XCTAssertEqual(try! TJBigInt("-123456").description, "-123456")
        XCTAssertEqual(try! TJBigInt("-1234567").description, "-1234567")
        XCTAssertEqual(try! TJBigInt("-12345678").description, "-12345678")
        XCTAssertEqual(try! TJBigInt("-123456789").description, "-123456789")
        XCTAssertEqual(try! TJBigInt("-1234567890").description, "-1234567890")
        XCTAssertEqual(try! TJBigInt("-12345678901").description, "-12345678901")
        XCTAssertEqual(try! TJBigInt("-123456789012").description, "-123456789012")
        XCTAssertEqual(try! TJBigInt("-1234567890123").description, "-1234567890123")
        XCTAssertEqual(try! TJBigInt("-12345678901234").description, "-12345678901234")
        XCTAssertEqual(try! TJBigInt("-123456789012345").description, "-123456789012345")
        XCTAssertEqual(try! TJBigInt("-1234567890123456").description, "-1234567890123456")
        XCTAssertEqual(try! TJBigInt("-12345678901234567").description, "-12345678901234567")
        XCTAssertEqual(try! TJBigInt("-123456789012345678").description, "-123456789012345678")
        XCTAssertEqual(try! TJBigInt("-1234567890123456789").description, "-1234567890123456789")
        XCTAssertEqual(try! TJBigInt("-12345678901234567890").description, "-12345678901234567890")
        XCTAssertEqual(try! TJBigInt("-123456789012345678901").description, "-123456789012345678901")
        XCTAssertEqual(try! TJBigInt("-1234567890123456789012").description, "-1234567890123456789012")
        XCTAssertEqual(try! TJBigInt("-12345678901234567890123").description, "-12345678901234567890123")
        XCTAssertEqual(try! TJBigInt("-123456789012345678901234").description, "-123456789012345678901234")
        XCTAssertEqual(try! TJBigInt("-1234567890123456789012345").description, "-1234567890123456789012345")
        XCTAssertEqual(try! TJBigInt("-12345678901234567890123456").description, "-12345678901234567890123456")
        XCTAssertEqual(try! TJBigInt("-123456789012345678901234567").description, "-123456789012345678901234567")
        XCTAssertEqual(try! TJBigInt("-1234567890123456789012345678").description, "-1234567890123456789012345678")
        XCTAssertEqual(try! TJBigInt("-12345678901234567890123456789").description, "-12345678901234567890123456789")
        XCTAssertEqual(try! TJBigInt("-123456789012345678901234567890").description, "-123456789012345678901234567890")

        XCTAssertEqual(try! TJBigInt("-1").description, "-1")
    }

    func testRandomInitialization() {
        // This is a non-deterministic random test.
        // We do a lot of tests and see if on average each bit toggles.
        let NR_BITS = 4096
        let NR_TESTS = 1000
        let BIT_COUNT_MIN = Int(Double(NR_TESTS) * 0.1)
        let BIT_COUNT_MAX = Int(Double(NR_TESTS) * 0.9)

        // Create a set of random numbers.
        var results: [TJBigInt] = []
        for _ in 0 ..< NR_TESTS {
            let result = TJBigInt(randomNrBits: NR_BITS)
            results.append(result)
            if result < 0 {
                XCTFail("A random number should always be unsigned")
                return
            }
        }

        // Now count each '1' bit lsb to msb.
        for bitNr in 0 ..< NR_BITS {
            var bitCount = 0
            for result in results {
                if result.getBit(bitNr) {
                    bitCount += 1
                }
            }
            if !(bitCount >= BIT_COUNT_MIN && bitCount <= BIT_COUNT_MAX) {
                XCTFail("Bit \(bitNr) was set \(bitCount * 100 / NR_TESTS)% of the time, expecting between 10% and 90%.")
            }
        }
    }

    func testShiftLeft() {
        XCTAssertEqual((TJBigInt(0) << 4).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(1) << 4).hexDescription, "0x0000000000000010")
        XCTAssertEqual((TJBigInt(-1) << 4).hexDescription, "0xfffffffffffffff0")
        XCTAssertEqual((TJBigInt(0xffffffff) << 4).hexDescription, "0x0000000ffffffff0")
        XCTAssertEqual((TJBigInt(0x1_ffffffff) << 4).hexDescription, "0x0000001ffffffff0")
        XCTAssertEqual((TJBigInt(-0x1_ffffffff) << 4).hexDescription, "0xffffffe000000010")
        XCTAssertEqual((TJBigInt(-0x80000000_00000000) << 4).hexDescription, "0xfffffffffffffff8_0000000000000000")
        XCTAssertEqual((TJBigInt(0x7fffffff_ffffffff) << 4).hexDescription, "0x0000000000000007_fffffffffffffff0")

        XCTAssertEqual((TJBigInt(0) << 36).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(1) << 36).hexDescription, "0x0000001000000000")
        XCTAssertEqual((TJBigInt(-1) << 36).hexDescription, "0xfffffff000000000")
        XCTAssertEqual((TJBigInt(0xffffffff) << 36).hexDescription, "0x000000000000000f_fffffff000000000")
        XCTAssertEqual((TJBigInt(0x1_ffffffff) << 36).hexDescription, "0x000000000000001f_fffffff000000000")
        XCTAssertEqual((TJBigInt(-0x1_ffffffff) << 36).hexDescription, "0xffffffffffffffe0_0000001000000000")
        XCTAssertEqual((TJBigInt(-0x80000000_00000000) << 36).hexDescription, "0xfffffff800000000_0000000000000000")
        XCTAssertEqual((TJBigInt(0x7fffffff_ffffffff) << 36).hexDescription, "0x00000007ffffffff_fffffff000000000")
    }

    func testShiftRight() {
        XCTAssertEqual((TJBigInt(0) >> 1).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(1) >> 1).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(-1) >> 1).hexDescription, "0xffffffffffffffff")
        XCTAssertEqual((TJBigInt(0xffffffff) >> 1).hexDescription, "0x000000007fffffff")
        XCTAssertEqual((TJBigInt(0x1_ffffffff) >> 1).hexDescription, "0x00000000ffffffff")
        XCTAssertEqual((TJBigInt(-0x1_ffffffff) >> 1).hexDescription, "0xffffffff00000000")
        XCTAssertEqual((TJBigInt(-0x80000000_00000000) >> 1).hexDescription, "0xc000000000000000")
        XCTAssertEqual((TJBigInt(0x7fffffff_ffffffff) >> 1).hexDescription, "0x3fffffffffffffff")
        XCTAssertEqual((try! TJBigInt("0x1_00000000_00000000") >> 1).hexDescription, "0x0000000000000000_8000000000000000")

        XCTAssertEqual((TJBigInt(0) >> 4).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(1) >> 4).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(-1) >> 4).hexDescription, "0xffffffffffffffff")
        XCTAssertEqual((TJBigInt(0xffffffff) >> 4).hexDescription, "0x000000000fffffff")
        XCTAssertEqual((TJBigInt(0x1_ffffffff) >> 4).hexDescription, "0x000000001fffffff")
        XCTAssertEqual((TJBigInt(-0x1_ffffffff) >> 4).hexDescription, "0xffffffffe0000000")
        XCTAssertEqual((TJBigInt(-0x80000000_00000000) >> 4).hexDescription, "0xf800000000000000")
        XCTAssertEqual((TJBigInt(0x7fffffff_ffffffff) >> 4).hexDescription, "0x07ffffffffffffff")

        XCTAssertEqual((TJBigInt(0) >> 36).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(1) >> 36).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(-1) >> 36).hexDescription, "0xffffffffffffffff")
        XCTAssertEqual((TJBigInt(0xffffffff) >> 36).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(0x1_ffffffff) >> 36).hexDescription, "0x0")
        XCTAssertEqual((TJBigInt(-0x1_ffffffff) >> 36).hexDescription, "0xffffffffffffffff")
        XCTAssertEqual((TJBigInt(-0x80000000_00000000) >> 36).hexDescription, "0xfffffffff8000000")
        XCTAssertEqual((TJBigInt(0x7fffffff_ffffffff) >> 36).hexDescription, "0x0000000007ffffff")
    }

    func testMultiplication() {
        XCTAssertEqual((TJBigInt(0) * 0).description, "0")
        XCTAssertEqual((TJBigInt(0) * 1).description, "0")
        XCTAssertEqual((TJBigInt(1) * 1).description, "1")

        XCTAssertEqual((TJBigInt(1) * 10).description, "10")
        XCTAssertEqual((TJBigInt(10) * 1).description, "10")
        XCTAssertEqual((TJBigInt(-1) * 10).description, "-10")
        XCTAssertEqual((TJBigInt(-10) * 1).description, "-10")
        XCTAssertEqual((TJBigInt(1) * -10).description, "-10")
        XCTAssertEqual((TJBigInt(10) * -1).description, "-10")
        XCTAssertEqual((TJBigInt(-1) * -10).description, "10")
        XCTAssertEqual((TJBigInt(-10) * -1).description, "10")

        XCTAssertEqual((TJBigInt(1) * TJBigInt(10)).description, "10")
        XCTAssertEqual((TJBigInt(10) * TJBigInt(1)).description, "10")
        XCTAssertEqual((TJBigInt(-1) * TJBigInt(10)).description, "-10")
        XCTAssertEqual((TJBigInt(-10) * TJBigInt(1)).description, "-10")
        XCTAssertEqual((TJBigInt(1) * TJBigInt(-10)).description, "-10")
        XCTAssertEqual((TJBigInt(10) * TJBigInt(-1)).description, "-10")
        XCTAssertEqual((TJBigInt(-1) * TJBigInt(-10)).description, "10")
        XCTAssertEqual((TJBigInt(-10) * TJBigInt(-1)).description, "10")

        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 2).description, "24691357802469135780")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 4).description, "49382715604938271560")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 8).description, "98765431209876543120")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 16).description, "197530862419753086240")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 32).description, "395061724839506172480")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 64).description, "790123449679012344960")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 128).description, "1580246899358024689920")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 256).description, "3160493798716049379840")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 2147483648).description, "26512143563859841556120862720")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 4294967296).description, "53024287127719683112241725440")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 8589934592).description, "106048574255439366224483450880")

        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 2).description, "-24691357802469135780")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 4).description, "-49382715604938271560")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 8).description, "-98765431209876543120")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 16).description, "-197530862419753086240")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 32).description, "-395061724839506172480")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 64).description, "-790123449679012344960")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 128).description, "-1580246899358024689920")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 256).description, "-3160493798716049379840")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 2147483648).description, "-26512143563859841556120862720")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 4294967296).description, "-53024287127719683112241725440")
        XCTAssertEqual((try! TJBigInt("-12345678901234567890") * 8589934592).description, "-106048574255439366224483450880")

        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 3).description, "37037036703703703670")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 5).description, "61728394506172839450")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 9).description, "111111110111111111010")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 17).description, "209876541320987654130")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 33).description, "407407403740740740370")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 65).description, "802469128580246912850")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 129).description, "1592592578259259257810")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 257).description, "3172839477617283947730")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 2147483649).description, "26512143576205520457355430610")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 4294967297).description, "53024287140065362013476293330")
        XCTAssertEqual((try! TJBigInt("12345678901234567890") * 8589934593).description, "106048574267785045125718018770")

        XCTAssertEqual((try! TJBigInt("1") * TJBigInt(0x100000000)).description, "4294967296")
    }

    func testDivision() {
        XCTAssertEqual((try! TJBigInt("4") / TJBigInt(2)).description, "2")
        XCTAssertEqual((try! TJBigInt("18446744073709551616") / TJBigInt(10)).description, "1844674407370955161")
    }

    func testModularPower() {
        XCTAssertEqual(modularPower(TJBigInt(3), exponent: TJBigInt(2), modulus: TJBigInt(10)).description, "9")
        XCTAssertEqual(modularPower(TJBigInt(3), exponent: TJBigInt(12345), modulus: TJBigInt(10)).description, "3")
        XCTAssertEqual(try! modularPower(TJBigInt(3), exponent: TJBigInt(12345), modulus: TJBigInt("36893488147422849766")).description, "24918863617337492911")

        XCTAssertEqual(try! modularPower(TJBigInt(2), exponent: TJBigInt("0x1f"), modulus: TJBigInt("0xFFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD129024E088A67CC74020BBEA63B139B22514A08798E3404DDEF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7EDEE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3DC2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F83655D23DCA3AD961C62F356208552BB9ED529077096966D670C354E4ABC9804F1746C08CA237327FFFFFFFFFFFFFFFF")).description, "2147483648")

        XCTAssertEqual(try! modularPower(TJBigInt(2), exponent: TJBigInt("0x20"), modulus: TJBigInt("0xFFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD129024E088A67CC74020BBEA63B139B22514A08798E3404DDEF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7EDEE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3DC2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F83655D23DCA3AD961C62F356208552BB9ED529077096966D670C354E4ABC9804F1746C08CA237327FFFFFFFFFFFFFFFF")).description, "4294967296")

        XCTAssertEqual(try! modularPower(TJBigInt(2), exponent: TJBigInt("0x123456789012345678901234567890"), modulus: TJBigInt("0xFFFFFFFFFFFFFFFFC90FDAA22168C234C4C6628B80DC1CD129024E088A67CC74020BBEA63B139B22514A08798E3404DDEF9519B3CD3A431B302B0A6DF25F14374FE1356D6D51C245E485B576625E7EC6F44C42E9A637ED6B0BFF5CB6F406B7EDEE386BFB5A899FA5AE9F24117C4B1FE649286651ECE45B3DC2007CB8A163BF0598DA48361C55D39A69163FA8FD24CF5F83655D23DCA3AD961C62F356208552BB9ED529077096966D670C354E4ABC9804F1746C08CA237327FFFFFFFFFFFFFFFF")).description, "2382520222103352709584526687930278051980125211999568276620527245391841002237103086655717377687700745979171468319836038597443166132103939456403029009374802199945677756130982355791093110688942270938705836413315505760592354754675109112626127150587584957323254460826287667114675972002665167638553362673525224719774242685840588531712489534896367548449286614815342560610539209463769667137569348715043966309599053088006556616133052662019451592674047544491011840110002437")
    }

}

