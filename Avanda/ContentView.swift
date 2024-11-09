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
    @State private var showFireworks = false
    
    var owlMascot: some View {
        VStack {
            ZStack {
                // Owl body
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .shadow(color: .gray.opacity(0.3), radius: 5)
                
                // Owl ears
                HStack(spacing: 45) {
                    Circle()
                        .fill(Color.pink.opacity(0.3))
                        .frame(width: 30, height: 30)
                    Circle()
                        .fill(Color.pink.opacity(0.3))
                        .frame(width: 30, height: 30)
                }
                .offset(y: -35)
                
                // Eyes
                HStack(spacing: 25) {
                    // Left eye
                    ZStack {
                        Circle()
                            .fill(.purple.opacity(0.3))
                            .frame(width: 35, height: 35)
                        Circle()
                            .fill(isAnswerCorrect ? Color.pink.opacity(0.7) : Color.black)
                            .frame(width: 20, height: 20)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                            .offset(x: 3, y: -3)
                    }
                    
                    // Right eye
                    ZStack {
                        Circle()
                            .fill(.purple.opacity(0.3))
                            .frame(width: 35, height: 35)
                        Circle()
                            .fill(isAnswerCorrect ? Color.pink.opacity(0.7) : Color.black)
                            .frame(width: 20, height: 20)
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                            .offset(x: 3, y: -3)
                    }
                }
                
                // Beak
                Triangle()
                    .fill(.orange)
                    .frame(width: 12, height: 10)
                    .rotationEffect(.degrees(180))
                    .offset(y: 12)
                
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
                
                // Owl mascot
                owlMascot
                    .padding(.bottom, 30)
                
                // Math problem card
                VStack(spacing: 20) {
                    Text(viewModel.currentProblem.question)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.purple)
                    
                    // Updated Answer input field with fixed keyboard type
                    TextField("", text: $viewModel.userAnswer)
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
            
            // Add FireworkView here, conditionally
            if showFireworks {
                FireworkView()
            }
        }
        .sheet(isPresented: $viewModel.showYouTubeReward) {
            YouTubeRewardView()
        }
        .onChange(of: viewModel.showReward) { newValue in
            if newValue {
                showFireworks = true
                // Schedule the fireworks to disappear
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    showFireworks = false
                    viewModel.showReward = false  // Reset the view model state
                }
            }
        }
    }
}

// Helper shape for owl beak
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
