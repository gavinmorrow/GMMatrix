import XCTest
@testable import GMMatrix

final class GMMatrixTests: XCTestCase {
	override func setUpWithError() throws {
		try super.setUpWithError()
	}
	
	func testMatrixInitWithoutInitialValue() {
		let matrix = GMMatrix<Int>(rows: 10, columns: 10)
		XCTAssert(matrix.matrix.allSatisfy({ $0 == nil }), "Inital value is not `nil`.")
	}
	
	func testMatrixInitWithInitialValue() {
		let matrix = GMMatrix(initalValue: "Hello, World!", rows: 5, columns: 10)
		XCTAssert(matrix.matrix.allSatisfy( { $0 == "Hello, World!" }), "Initial value wasn't set.")
	}
	
	func testMatrixInitWithInitialMatrix() throws {
		let matrix = try GMMatrix(matrix: [1, 2, 3, 4, 5, 6], columns: 3)
		XCTAssert(matrix.matrix == [1, 2, 3, 4, 5, 6], "Matrix wasn't set properly.")
		XCTAssert(matrix.rows == 2, "Matrix has an invalid amount of rows.")
		XCTAssert(matrix.columns == 3, "Matrix has an invalid amount of columns.")
		
		XCTAssertThrowsError(
			try GMMatrix(matrix: [1, 2, 3, 4, 5, 6, 7], columns: 3),
			"Matrix didn't throw for an invalid array."
		) { error in
			XCTAssert(type(of: error) == GMMatrixError.self, "Wrong error type.")
			XCTAssert(error as? GMMatrixError == GMMatrixError.invalidArray, "Wrong GMMatrixError.")
		}
	}
	
	func testAddingValue() throws {
		var matrix = GMMatrix<Int>(initalValue: 0, rows: 5, columns: 10)
		
		try matrix.setElement(newValue: 42, x: 0, y: 1)
		matrix[0, 0]! += 22
		
		XCTAssert(matrix[0, 1] == 42, "``GMMatrix/setElement(newValue:x:y:)` didn't work.")
		XCTAssert(matrix[0, 0] == 22, "Matrix subscript setter doesn't work.")
	}
	
	func testGettingSubscript() throws {
		let matrix = GMMatrix<Int>(initalValue: 42, rows: 10, columns: 5)
		
		XCTAssert((try matrix.getElement(x: 3, y: 8)) == 42, "``GMMatrix/getElement(x:y:)`` doesn't work.")
		XCTAssert(matrix[4, 9] == 42, "Matrix subscript getter doesn't work.")
	}
	
	func testChecks() {
		let matrix = GMMatrix<Any>(rows: 5, columns: 10)
		
		XCTAssertFalse(matrix.check(x: 10), "Matrix `x` check failed.")
		XCTAssertFalse(matrix.check(y: 7), "Matrix `y` check failed.")
		XCTAssertTrue(matrix.check(x: 4), "Matrix `x` check failed.")
		XCTAssertTrue(matrix.check(y: 4), "Matrix `y` check failed.")
	}
	
	func testMatrixSize() {
		let matrix0 = GMMatrix<Any>(rows: 10, columns: 9)
		XCTAssert(matrix0.matrix.count == 10 * 9, "Matrix size is wrong.")
		
		let matrix1 = GMMatrix<Any>(rows: 0, columns: 9)
		XCTAssert(matrix1.matrix.count == 0, "Matrix size is wrong.")
		
		let matrix2 = GMMatrix<Any>(rows: 10, columns: 0)
		XCTAssert(matrix2.matrix.count == 0, "Matrix size is wrong.")
	}
	
	func testMatrixIterator() {
		let matrix = GMMatrix(initalValue: 0, rows: 5, columns: 10)
		
		var currentX = 0
		var currentY = 0
		
		for (x, y, value) in matrix {
			let currentValue = matrix[currentX, currentY]
			
			XCTAssert(x == currentX, "`x` value is innacurate.")
			XCTAssert(y == currentY, "`y` value is innacurate.")
			XCTAssert(currentValue == value, "`value` value is innacurate.")
			
			currentX += 1
			
			if currentX >= matrix.columns {
				currentX = 0
				currentY += 1
			}
		}
	}
}
