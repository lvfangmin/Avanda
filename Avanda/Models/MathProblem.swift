import Foundation

struct MathProblem: Equatable {
    var num1: Int
    var num2: Int
    var operation: String
    
    init(num1: Int = 1, num2: Int = 1, operation: String = "+") {
        self.num1 = num1
        self.num2 = num2
        self.operation = operation
    }
    
    var question: String {
        "\(num1) \(operation) \(num2) = ?"
    }
    
    var answer: Int {
        switch operation {
        case "+": return num1 + num2
        case "-": return num1 - num2
        default: return 0
        }
    }
    
    // Implement Equatable
    static func == (lhs: MathProblem, rhs: MathProblem) -> Bool {
        return lhs.num1 == rhs.num1 && 
               lhs.num2 == rhs.num2 && 
               lhs.operation == rhs.operation
    }
} 