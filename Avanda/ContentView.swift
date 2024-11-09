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
                
                // Mouth
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
    
    var body: some View {
        ZStack {
            // Background
            BubbleBackground()
                .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 30) {
                // Top bar with score and hearts
                HStack {
                    // Score display
                    HStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .scaleEffect(scale)
                        Text("Score: \(viewModel.score)")
                            .font(.title2.bold())
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    
                    Spacer()
                    
                    // Hearts display
                    HStack(spacing: 8) {
                        ForEach(0..<viewModel.remainingAttempts, id: \.self) { _ in
                            Image(systemName: "heart.fill")
                                .foregroundColor(.pink)
                                .scaleEffect(scale)
                        }
                    }
                    .font(.title2)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Cat mascot
                catMascot
                    .padding(.bottom, 30)
                
                // Math problem card
                VStack(spacing: 20) {
                    Text(viewModel.currentProblem.question)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.purple)
                    
                    // Answer input field
                    TextField("Type your answer", text: $viewModel.userAnswer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .frame(width: 150)
                        .padding()
                    
                    // Check button
                    Button(action: {
                        withAnimation {
                            scale = 1.2
                            mascotY = -20
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                scale = 1.0
                                mascotY = 0
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
                            .shadow(radius: 5)
                    }
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .shadow(radius: 10)
                
                // Feedback message
                if !viewModel.feedbackMessage.isEmpty {
                    Text(viewModel.feedbackMessage)
                        .font(.title3)
                        .foregroundColor(.purple)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
            }
            .padding()
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
