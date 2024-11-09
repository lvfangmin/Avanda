//
//  ContentView.swift
//  Avanda
//
//  Created by Fangmin on 11/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MathGameViewModel()
    @State private var isAnswerCorrect = false
    @State private var scale: CGFloat = 1.0
    @State private var mascotRotation: Double = 0
    @State private var mascotY: CGFloat = 0
    
    var catMascot: some View {
        VStack {
            ZStack {
                // Cat head
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .shadow(color: .gray.opacity(0.3), radius: 5)
                
                // Cat ears
                HStack(spacing: 55) {
                    // Left ear
                    Triangle()
                        .fill(Color.pink.opacity(0.3))
                        .frame(width: 25, height: 25)
                        .rotationEffect(.degrees(30))
                    
                    // Right ear
                    Triangle()
                        .fill(Color.pink.opacity(0.3))
                        .frame(width: 25, height: 25)
                        .rotationEffect(.degrees(-30))
                }
                .offset(y: -35)
                
                // Eyes
                HStack(spacing: 25) {
                    // Left eye
                    ZStack {
                        Circle()
                            .fill(isAnswerCorrect ? Color.green.opacity(0.7) : Color.black)
                            .frame(width: 15, height: 15)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 5, height: 5)
                            .offset(x: 2, y: -2)
                    }
                    
                    // Right eye
                    ZStack {
                        Circle()
                            .fill(isAnswerCorrect ? Color.green.opacity(0.7) : Color.black)
                            .frame(width: 15, height: 15)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 5, height: 5)
                            .offset(x: 2, y: -2)
                    }
                }
                
                // Nose
                Triangle()
                    .fill(Color.pink)
                    .frame(width: 8, height: 6)
                    .rotationEffect(.degrees(180))
                    .offset(y: 12)
                
                // Whiskers
                ForEach(-1...1, id: \.self) { i in
                    HStack(spacing: 45) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 15, height: 1)
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 15, height: 1)
                    }
                    .offset(y: CGFloat(i * 4) + 12)
                }
                
                // Mouth - Updated position with x offset
                Group {
                    if isAnswerCorrect {
                        // Happy mouth
                        Path { path in
                            path.move(to: CGPoint(x: -10, y: 0))
                            path.addQuadCurve(
                                to: CGPoint(x: 10, y: 0),
                                control: CGPoint(x: 0, y: 8)
                            )
                        }
                        .stroke(Color.black, lineWidth: 1.5)
                        .frame(width: 20, height: 10)
                        .offset(x: 10, y: 30)
                    } else {
                        // Regular mouth
                        Path { path in
                            path.move(to: CGPoint(x: -7, y: 0))
                            path.addLine(to: CGPoint(x: 7, y: 0))
                        }
                        .stroke(Color.black, lineWidth: 1.5)
                        .frame(width: 14, height: 1)
                        .offset(x: 7, y: 30)
                    }
                }
            }
            .offset(y: mascotY)
            .rotationEffect(.degrees(mascotRotation))
            .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isAnswerCorrect)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: mascotY)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: mascotRotation)
        }
    }
    
    // Button tap animation
    func animateMascot() {
        // Bounce animation
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            mascotY = -10
        }
        
        // Reset bounce
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                mascotY = 0
            }
        }
        
        // Rotate on correct answer
        if isAnswerCorrect {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                mascotRotation = 360
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                mascotRotation = 0
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Cute animated bubble background
            BubbleBackground()
                .ignoresSafeArea()
            
            // Content overlay with blur
            ScrollView {
                VStack(spacing: 25) {
                    // Score display with cute star
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .scaleEffect(scale)
                            .animation(.spring(response: 0.3, dampingFraction: 0.3), value: scale)
                        Text("Score: \(viewModel.score)")
                            .font(.title2.bold())
                            .foregroundColor(.purple)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    
                    // Attempts remaining
                    HStack {
                        ForEach(0..<viewModel.remainingAttempts, id: \.self) { index in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                                .scaleEffect(scale)
                                .animation(
                                    .spring(response: 0.3, dampingFraction: 0.3)
                                    .delay(Double(index) * 0.1),
                                    value: scale
                                )
                        }
                    }
                    .font(.title2)
                    
                    // Cute mascot
                    catMascot
                    
                    // Math problem display
                    Text(viewModel.currentProblem.question)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.purple)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                    
                    // Feedback message
                    if !viewModel.feedbackMessage.isEmpty {
                        Text(viewModel.feedbackMessage)
                            .font(.title3)
                            .foregroundColor(.purple)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                    }
                    
                    // Number input
                    TextField("Your answer", text: $viewModel.userAnswer)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.oneTimeCode)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .frame(width: 150)
                        .background(.ultraThinMaterial)
                    
                    // Check button
                    Button(action: {
                        withAnimation {
                            scale = 1.2
                            // Bounce mascot
                            mascotY = -20
                            mascotRotation = isAnswerCorrect ? 360 : -10
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                scale = 1.0
                                mascotY = 0
                                mascotRotation = 0
                            }
                            viewModel.checkAnswer()
                            isAnswerCorrect = viewModel.consecutiveCorrect > 0
                        }
                    }) {
                        Text("Check!")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.purple)
                            .cornerRadius(25)
                    }
                }
                .padding()
            }
        }
        .sheet(isPresented: $viewModel.showReward) {
            RewardView()
        }
        .sheet(isPresented: $viewModel.showYouTubeReward) {
            YouTubeRewardView()
        }
    }
}

struct RewardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var scale: CGFloat = 0.5
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 Great Job! 🎉")
                .font(.title.bold())
                .foregroundColor(.purple)
                .scaleEffect(scale)
            
            Text("You got 3 in a row!")
                .font(.title2)
                .opacity(scale)
            
            Button("Continue Learning") {
                withAnimation {
                    scale = 0.5
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        dismiss()
                    }
                }
            }
            .font(.title3.bold())
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.purple)
            .cornerRadius(25)
            .scaleEffect(scale)
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
    }
}

// Helper shape for cat ears
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ContentView()
}
