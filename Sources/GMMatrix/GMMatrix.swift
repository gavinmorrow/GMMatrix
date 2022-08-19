public struct GMMatrix<T> {
	
	// MARK: Inits
	
	/// - Parameters:
	///   - value: The initial value to fill the matrix with.
	///   - rows: The amount of rows in the matrix.
	///   - columns: The amount of columns in the matrix.
	public init(initalValue value: T? = nil, rows: Int, columns: Int) {
		self.matrix = Array(
			repeating: value,
			count: rows * columns
		)
		
		self.rows = rows
		self.columns = columns
	}
	
	// MARK: - Properties
	
	/// The data being stored.
	public private(set) var matrix: [T?]
	
	/// The amount of rows in the matrix.
	public let rows: Int
	
	/// The amount of columns in the matrix.
	public let columns: Int
	
	// MARK: - Functions
	
	/// Get an element from the matrix.
	///
	/// - Parameters:
	///   - x: The `x` value of the element.
	///   - y: The `y` value of the element.
	///
	/// - Returns: The element from the matrix.
	///
	/// - Throws: ``GMMatrixError/xValueOutOfBounds``
	/// if the `x` value is too low or too high.
	///
	/// ``GMMatrixError/yValueOutOfBounds``
	/// if the `y` value is too low or too high.
	public func getElement(x: Int, y: Int) throws -> T? {
		guard check(x: x) else {
			throw GMMatrixError.xValueOutOfBounds
		}
		
		guard check(y: y) else {
			throw GMMatrixError.yValueOutOfBounds
		}
		
		return matrix[y * columns + x]
	}
	
	/// Set an element in the matrix.
	/// - Parameters:
	///   - newValue: The value to put into the matrix.
	///   - x: The `x` coordinate of the element.
	///   - y: The `y` coordinate of the element.
	///
	mutating public func setElement(newValue: T?, x: Int, y: Int) throws {
		guard check(x: x) else {
			throw GMMatrixError.xValueOutOfBounds
		}
		
		guard check(y: y) else {
			throw GMMatrixError.yValueOutOfBounds
		}
		
		matrix[y * columns + x] = newValue
	}
	
	/// Check to see if an `x` value is in bounds.
	/// - Parameter x: The `x` value to check.
	/// - Returns: `true` if the `x` value is valid, `false` if it is not.
	public func check(x: Int) -> Bool {
		x >= 0 && x < columns
	}
	
	/// Check to see if an `y` value is in bounds.
	/// - Parameter y: The `y` value to check.
	/// - Returns: `true` if the `y` value is valid, `false` if it is not.
	public func check(y: Int) -> Bool {
		y >= 0 && y < rows
	}
	
	// MARK: - Subscripts
	
	/// A subscript wrapper for ``getElement(x:y:)``.
	///
	/// If the `x` or `y` value of out of bounds, it will return `nil`.
	public subscript(x: Int, y: Int) -> T? {
		get {
			return try? getElement(x: x, y: y)
		} set {
			try? setElement(newValue: newValue, x: x, y: y)
		}
	}

	// MARK: - Sequence & IteratorProtocol Conformance
	private var currentIndex = 0
	public mutating func next() -> (x: Int, y: Int, value: T?)? {
		guard currentIndex < matrix.count else {
			return nil
		}
		
		defer {
			currentIndex += 1
		}
		
		let x = currentIndex % columns
		let y = Int(currentIndex / columns)
		
		return (x: x, y: y, value: matrix[currentIndex])
	}
}

extension GMMatrix: Codable where T: Codable {}
extension GMMatrix: Equatable where T: Equatable {}
extension GMMatrix: Sequence, IteratorProtocol {}
