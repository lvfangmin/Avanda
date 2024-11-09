import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var correctPlayer: AVAudioPlayer?
    private var incorrectPlayer: AVAudioPlayer?
    
    private init() {
        setupSounds()
    }
    
    private func setupSounds() {
        guard let correctURL = Bundle.main.url(forResource: "correct_sound", withExtension: "mp3"),
              let incorrectURL = Bundle.main.url(forResource: "incorrect_sound", withExtension: "mp3") else {
            print("Could not find sound files")
            return
        }
        
        do {
            correctPlayer = try AVAudioPlayer(contentsOf: correctURL)
            incorrectPlayer = try AVAudioPlayer(contentsOf: incorrectURL)
            
            correctPlayer?.prepareToPlay()
            incorrectPlayer?.prepareToPlay()
        } catch {
            print("Failed to load sounds: \(error.localizedDescription)")
        }
    }
    
    func playCorrectSound() {
        correctPlayer?.play()
    }
    
    func playIncorrectSound() {
        incorrectPlayer?.play()
    }
} 