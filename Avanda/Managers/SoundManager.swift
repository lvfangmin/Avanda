import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var correctPlayer: AVAudioPlayer?
    private var incorrectPlayer: AVAudioPlayer?
    private var audioSession: AVAudioSession?
    
    private init() {
        setupAudioSession()
        setupSounds()
    }
    
    private func setupAudioSession() {
        do {
            audioSession = AVAudioSession.sharedInstance()
            try audioSession?.setCategory(.playback, mode: .default)
            try audioSession?.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
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
            
            // Set volume
            correctPlayer?.volume = 1.0
            incorrectPlayer?.volume = 1.0
        } catch {
            print("Failed to load sounds: \(error.localizedDescription)")
        }
    }
    
    func playCorrectSound() {
        correctPlayer?.currentTime = 0
        correctPlayer?.play()
    }
    
    func playIncorrectSound() {
        incorrectPlayer?.currentTime = 0
        incorrectPlayer?.play()
    }
} 