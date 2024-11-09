import SwiftUI

struct FireworkParticle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var scale: CGFloat
    var opacity: Double
}

struct FireworkView: View {
    @Environment(\.dismiss) var dismiss
    @State private var particles: [FireworkParticle] = []
    @State private var timer: Timer?
    @State private var screenSize: CGSize = CGSize(width: 800, height: 600)
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .pink]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dark background
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                // Firework particles
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: 8, height: 8)
                        .scaleEffect(particle.scale)
                        .opacity(particle.opacity)
                        .position(particle.position)
                }
                
                // Celebration text
                VStack(spacing: 20) {
                    Text("🎉 Great Job! 🎉")
                        .font(.title.bold())
                        .foregroundColor(.white)
                    
                    Text("You got 3 in a row!")
                        .font(.title2)
                        .foregroundColor(.white)
                    
                    Button("Continue Learning") {
                        dismiss()
                    }
                    .font(.title3.bold())
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.purple)
                    .cornerRadius(25)
                }
                .padding()
            }
            .onAppear {
                screenSize = geometry.size
                startFireworks()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private func startFireworks() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            createFirework()
        }
    }
    
    private func createFirework() {
        let startX = CGFloat.random(in: 100...screenSize.width-100)
        let startY = CGFloat.random(in: 100...screenSize.height-100)
        let startPoint = CGPoint(x: startX, y: startY)
        
        // Create explosion particles
        for _ in 0..<20 {
            let angle = Double.random(in: 0...2 * .pi)
            let distance = CGFloat.random(in: 50...100)
            let endX = startX + cos(angle) * distance
            let endY = startY + sin(angle) * distance
            
            let particle = FireworkParticle(
                position: startPoint,
                color: colors.randomElement() ?? .white,
                scale: 0,
                opacity: 1
            )
            particles.append(particle)
            
            // Animate particle
            withAnimation(.easeOut(duration: 1.0)) {
                let index = particles.count - 1
                particles[index].position = CGPoint(x: endX, y: endY)
                particles[index].scale = 1.0
                particles[index].opacity = 0
            }
            
            // Remove particle after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                if !particles.isEmpty {
                    particles.removeFirst()
                }
            }
        }
    }
}

#Preview {
    FireworkView()
} 