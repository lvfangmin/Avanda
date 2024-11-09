import Foundation
import SwiftUI

class MathGameViewModel: ObservableObject {
    @Published var score = 0
    @Published var currentProblem: MathProblem
    @Published var userAnswer = ""
    @Published var showReward = false
    @Published var consecutiveCorrect = 0
    @Published var remainingAttempts = 3
    @Published var feedbackMessage = ""
    
    private var difficulty = 1
    private let soundManager = SoundManager.shared
    
    init() {
        self.currentProblem = MathProblem()
        self.currentProblem = generateProblem()
    }
    
    func checkAnswer() {
        guard let answer = Int(userAnswer) else { return }
        
        if answer == currentProblem.answer {
            // Correct answer
            soundManager.playCorrectSound()
            score += remainingAttempts * 5 // More points for getting it right with fewer attempts
            consecutiveCorrect += 1
            feedbackMessage = "Great job! 🌟"
            
            withAnimation {
                showReward = consecutiveCorrect >= 3
            }
            if consecutiveCorrect >= 3 {
                consecutiveCorrect = 0
            }
            
            updateDifficulty()
            userAnswer = ""
            currentProblem = generateProblem()
            remainingAttempts = 3 // Reset attempts for next question
            
        } else {
            // Wrong answer
            remainingAttempts -= 1
            soundManager.playIncorrectSound()
            
            if remainingAttempts > 0 {
                // Still has attempts left
                feedbackMessage = "Try again! You have \(remainingAttempts) tries left 💪"
                userAnswer = ""
            } else {
                // No more attempts, show correct answer and move to next problem
                feedbackMessage = "The correct answer was \(currentProblem.answer). Let's try another one!"
                consecutiveCorrect = 0
                userAnswer = ""
                currentProblem = generateProblem()
                remainingAttempts = 3 // Reset attempts for next question
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