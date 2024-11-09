import Foundation
import SwiftUI

class MathGameViewModel: ObservableObject {
    @Published var score = 0
    @Published var currentProblem: MathProblem
    @Published var userAnswer = ""
    @Published var showReward = false
    @Published var showYouTubeReward = false
    @Published var consecutiveCorrect = 0
    @Published var remainingAttempts = 3
    @Published var feedbackMessage = ""
    
    private var difficulty = 1
    
    init() {
        self.currentProblem = MathProblem()
        self.currentProblem = generateProblem()
    }
    
    func checkAnswer() {
        guard let answer = Int(userAnswer) else { return }
        
        if answer == currentProblem.answer {
            score += remainingAttempts * 5
            consecutiveCorrect += 1
            feedbackMessage = "Great job! 🌟"
            
            if score >= 10 {
                showYouTubeReward = true
                score = 0
            } else if consecutiveCorrect >= 3 {
                showReward = true
                consecutiveCorrect = 0
            }
            
            updateDifficulty()
            userAnswer = ""
            currentProblem = generateProblem()
            remainingAttempts = 3
            
        } else {
            remainingAttempts -= 1
            
            if remainingAttempts > 0 {
                feedbackMessage = "Try again! You have \(remainingAttempts) tries left 💪"
                userAnswer = ""
            } else {
                feedbackMessage = "The correct answer was \(currentProblem.answer). Let's try another one!"
                consecutiveCorrect = 0
                userAnswer = ""
                currentProblem = generateProblem()
                remainingAttempts = 3
            }
        }
    }
    
    private func updateDifficulty() {
        if score >= difficulty * 50 {
            difficulty += 1
        }
    }
    
    private func generateProblem() -> MathProblem {
        let operations: [String] = difficulty < 3 ? ["+"] : ["+", "-"]
        let operation = operations.randomElement()!
        
        let maxNumber = 5 * difficulty
        var num1 = Int.random(in: 1...maxNumber)
        var num2 = Int.random(in: 1...maxNumber)
        
        if operation == "-" && num1 < num2 {
            swap(&num1, &num2)
        }
        
        return MathProblem(num1: num1, num2: num2, operation: operation)
    }
} 