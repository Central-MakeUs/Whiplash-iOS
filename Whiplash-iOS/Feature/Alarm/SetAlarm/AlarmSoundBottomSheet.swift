//
//  AlarmSoundBottomSheet.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/22/25.
//

import SwiftUI
import AVFoundation

final class TonePlayer: ObservableObject {
    private var player: AVAudioPlayer?
    @Published var isPlaying = false
    
    func play(sound: String) {
        stop()
        let name = sound
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3")
        else {
            // 파일이 없으면 진동(또는 무음)
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, options: [.duckOthers])
            try AVAudioSession.sharedInstance().setActive(true)
            let p = try AVAudioPlayer(contentsOf: url)
            p.prepareToPlay()
            p.play()
            self.player = p
            self.isPlaying = true
        } catch {
            print("play error:", error)
        }
    }
    
    func stop() {
        player?.stop()
        player = nil
        isPlaying = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
}

// MARK: - 라디오 표시
struct RadioDot: View {
    let selected: Bool
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(Color.gray.opacity(0.6), lineWidth: 2)
                .frame(width: 20, height: 20)
            if selected {
                Circle()
                    .fill(.lemon500)
                    .frame(width: 12, height: 12)
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - 바텀시트 뷰
struct AlarmToneSheet: View {
    @Binding var isPresented: Bool
    @Binding var selected: AlarmSound
    @StateObject private var player = TonePlayer()
    
    private let cornerRadius: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Dim
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture { withAnimation(.spring()) { isPresented = false } }
            
            // Sheet
            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.28))
                    .frame(width: 44, height: 6)
                    .padding(.top, 8)
                    .padding(.bottom, 10)
                
                // 카드형 섹션
                VStack(alignment: .leading, spacing: 12) {
                    AppText(text: "알람 소리",
                            style: .subtitle3_b_18,
                            color: .white)

                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                    
                    VStack(spacing: 0) {
                        ForEach(AlarmSound.sounds) { tone in
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                selected = tone
                            } label: {
                                HStack {
                                    RadioDot(selected: selected == tone)
                                    Text(tone.displayName)
                                        .foregroundColor(.white.opacity(selected == tone ? 1 : 0.7))
                                        .font(.system(size: 15, weight: selected == tone ? .semibold : .regular))
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .padding(.horizontal, 16)
                                .frame(height: 48)
                            }
                            .buttonStyle(.plain)
                            if tone != AlarmSound.sounds.last {
                                Divider().background(Color.white.opacity(0.06))
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.white.opacity(0.06))
                    )
                    .padding(.horizontal, 12)
                    .padding(.top, 4)
                    
                    // 미리듣기
                    HStack {
                        AppText(text: "미리듣기",
                                style: .body2_m_14,
                                color: .gray300)
                        Spacer()
                        Button {
                            if player.isPlaying {
                                player.stop()
                            } else {
                                if selected.id == "nonesound" { AudioServicesPlaySystemSound(kSystemSoundID_Vibrate) }
                                else { player.play(sound: selected.id) }
                            }
                        } label: {
                            Image(systemName: player.isPlaying ? "stop.fill" : "play.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Circle().fill(Color.white.opacity(0.12)))
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("미리듣기")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    
                    // 완료 버튼
                    Button {
                        player.stop()
                        withAnimation(.spring()) { isPresented = false }
                    } label: {
                        Text("완료")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.12))
                            .foregroundColor(.white.opacity(0.95))
                            .cornerRadius(12)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(Color(.sRGB, red: 0.09, green: 0.09, blue: 0.1, opacity: 1)) // 거의 #17171A 느낌
                )
            }
            .frame(maxWidth: .infinity)
            .frame(height: 420)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .transition(.move(edge: .bottom))
        }
        .onDisappear { player.stop() }
        .preferredColorScheme(.dark)
    }
}
