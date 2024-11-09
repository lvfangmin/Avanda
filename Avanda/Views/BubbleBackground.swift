import SwiftUI

struct Bubble: Identifiable {
    let id = UUID()
    var position: CGPoint
    var size: CGFloat
    var color: Color
    var speed: Double
}

struct BubbleBackground: View {
    @State private var bubbles: [Bubble] = []
    @State private var timer: Timer?
    
    let colors: [Color] = [
        .pink.opacity(0.3),
        .purple.opacity(0.2),
        .blue.opacity(0.2),
        .mint.opacity(0.2)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base gradient
                LinearGradient(
                    colors: [.white, .pink.opacity(0.1)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // Animated bubbles
                ForEach(bubbles) { bubble in
                    Circle()
                        .fill(bubble.color)
                        .frame(width: bubble.size, height: bubble.size)
                        .position(bubble.position)
                        .blur(radius: 2)
                }
            }
            .onAppear {
                // Initialize bubbles
                for _ in 0..<15 {
                    addBubble(in: geometry.size)
                }
                
                // Start animation timer
                timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
                    updateBubbles(in: geometry.size)
                }
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    private func addBubble(in size: CGSize) {
        let bubble = Bubble(
            position: CGPoint(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height)
            ),
            size: CGFloat.random(in: 40...120),
            color: colors.randomElement() ?? .pink.opacity(0.3),
            speed: Double.random(in: 0.5...2)
        )
        bubbles.append(bubble)
    }
    
    private func updateBubbles(in size: CGSize) {
        for index in bubbles.indices {
            var bubble = bubbles[index]
            bubble.position.y -= bubble.speed
            if bubble.position.y + bubble.size < 0 {
                bubble.position.y = size.height + bubble.size
                bubble.position.x = CGFloat.random(in: 0...size.width)
            }
            bubbles[index] = bubble
        }
    }
} 