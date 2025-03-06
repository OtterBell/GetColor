//
//  ContentView.swift
//  Demo
//
//  Created by Mac11 on 2025/2/21.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var colors: [Color] = [.red, .green, .blue, .yellow, .black, .purple]
    @State private var targetColor: Color = .red
    @State private var score: Int = 0
    @State private var timeRemaining: Int = 5
    @State private var gameOver: Bool = false
    @State private var timer: Timer?
    @State private var isGameStarted: Bool = false
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            if !isGameStarted {
                VStack {
                    Text("Get Color")
                        .font(.custom("Chalkduster", size: 34))
                        .fontWeight(.bold)
                    Text("選擇與文字相同的顏色")
                        .font(.custom("ChenYuluoyan-2.0-Thin", size: 25))
                        .foregroundColor(.gray)
                    Text("時間為3秒")
                        .font(.custom("ChenYuluoyan-2.0-Thin", size: 20))
                        .foregroundColor(.gray)
                    Button("Start") {
                        isGameStarted = true
                        playSound(named: "Start sound")
                        startGame()
                    }
                    .font(.custom("Chalkduster", size: 22))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
                }
            } else if gameOver {
                Text("Game Over")
                    .font(.custom("Chalkduster", size: 34))
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                Text("Score: \(score)")
                    .font(.custom("Chalkduster", size: 28))
                    .fontWeight(.bold)
                Button("Restart") {
                    playSound(named: "Start sound")
                    restartGame()
                }
                .font(.custom("Chalkduster", size: 22))
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
            } else {
                Text(" \(colorName(color: targetColor)) ")
                    .font(.custom("ChenYuluoyan-2.0-Thin", size: 40))
                    .fontWeight(.bold)
                VStack {
                    HStack {
                        ForEach(colors.prefix(3), id: \.self) { color in
                            Rectangle()
                                .fill(color)
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    checkAnswer(color: color)
                                }
                        }
                    }
                    HStack {
                        ForEach(colors.suffix(3), id: \.self) { color in
                            Rectangle()
                                .fill(color)
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    checkAnswer(color: color)
                                }
                        }
                    }
                }
                Text("Time remaining: \(timeRemaining)")
                    .font(.custom("Chalkduster", size: 22))
                    .fontWeight(.bold)
                Text("Score: \(score)")
                    .font(.custom("Chalkduster", size: 22))
                    .fontWeight(.bold)
            }
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white, .gray.opacity(0.2)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onAppear {
            if isGameStarted {
                startGame()
            }
        }
    }

    func colorName(color: Color) -> String {
        switch color {
        case .red:
            return "紅"
        case .green:
            return "綠"
        case .blue:
            return "藍"
        case .yellow:
            return "黃"
        case .black:
            return "黑"
        case .purple:
            return "紫"
        default:
            return "Unknown"
        }
    }

    func startGame() {
        score = 0
        timeRemaining = 3
        gameOver = false
        nextQuestion()
        startTimer()
    }

    func restartGame() {
        startGame()
    }

    func nextQuestion() {
        colors.shuffle()
        targetColor = colors.randomElement()!
        timeRemaining = 3
    }

    func checkAnswer(color: Color) {
        if color == targetColor {
            score += 1
            playSound(named: "Right sound")
            nextQuestion()
        } else {
            gameOver = true
            timer?.invalidate()
            playSound(named: "Wrong sound")
        }
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                gameOver = true
                timer?.invalidate()
                playSound(named: "Wrong sound")
            }
        }
    }

    func playSound(named soundName: String) {
        if let path = Bundle.main.path(forResource: soundName, ofType: "mp3") {
            let url = URL(fileURLWithPath: path)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing sound")
            }
        }
    }
}

#Preview {
    ContentView()
}
