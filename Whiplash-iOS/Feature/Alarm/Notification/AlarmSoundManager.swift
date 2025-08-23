//
//  AlarmSoundManager.swift
//  Whiplash-iOS
//
//  Created by 남경민 on 8/22/25.
//

import ComposableArchitecture
import AVFAudio
import SwiftUI
import CoreHaptics

@MainActor
final class AlarmSoundManager: ObservableObject {
    private var player: AVAudioPlayer?
    @Published var isPlaying = false

    init() {
        // 오디오 인터럽션/라우트 변경 대응
        NotificationCenter.default.addObserver(
            forName: AVAudioSession.interruptionNotification, object: nil, queue: .main
        ) { [weak self] note in self?.handleInterruption(note) }

        NotificationCenter.default.addObserver(
            forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main
        ) { [weak self] _ in
            // 라우트(스피커/이어폰) 변경 시 가능한 한 재생 유지
            if self?.isPlaying == true { self?.player?.play() }
        }
    }

    private func configureSession() throws {
        let s = AVAudioSession.sharedInstance()

        do {
            try s.setActive(false, options: .notifyOthersOnDeactivation)
            print("🔊 deactivated")
        } catch {
            print("❌ setActive(false) failed:", (error as NSError).code); throw error
        }

        do {
            // 최소 옵션부터 적용 (문제 원인 좁히기)
            try s.setCategory(.playback, mode: .default, options: [.duckOthers])
            print("🔊 setCategory OK")
        } catch {
            print("❌ setCategory failed:", (error as NSError).code)  // -50 이면 여기서 주로 납니다
            throw error
        }

        do {
            try s.setActive(true)
            print("🔊 setActive(true) OK")
        } catch {
            print("❌ setActive(true) failed:", (error as NSError).code)
            throw error
        }
    }

    func playAlarmSound(_ name: String) {
        stopAlarmSound()

        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            // 파일 없으면 짧은 시스템 사운드 (백그라운드 지속 X)
            AudioServicesPlaySystemSound(1005)
            return
        }

        do {
            try configureSession()
            let p = try AVAudioPlayer(contentsOf: url)
            p.numberOfLoops = -1               // 무한 반복
            p.volume = 1.0
            p.prepareToPlay()
            p.play()
            self.player = p
            self.isPlaying = true
        } catch {
            print("Audio start failed:", error)
        }
    }

    func stopAlarmSound() {
        player?.stop()
        player = nil
        isPlaying = false
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func handleInterruption(_ note: Notification) {
        guard let info = note.userInfo,
              let typeVal = info[AVAudioSessionInterruptionTypeKey] as? UInt,
              let type = AVAudioSession.InterruptionType(rawValue: typeVal) else { return }

        switch type {
        case .began:
            // 전화 등 인터럽션 시작 → 일시정지 상태
            player?.pause()
        case .ended:
            // 인터럽션 종료 → 세션 재활성화 후 재생 재개
            try? AVAudioSession.sharedInstance().setActive(true)
            if let optVal = info[AVAudioSessionInterruptionOptionKey] as? UInt,
               AVAudioSession.InterruptionOptions(rawValue: optVal).contains(.shouldResume),
               isPlaying {
                player?.play()
            }
        @unknown default:
            break
        }
    }
}

enum AlarmSoundHolder {
    @MainActor static var shared = AlarmSoundManager()
}

struct AlarmSoundClient {
    var play: @Sendable (_ soundName: String) async -> Void
    var stop: @Sendable () async -> Void
}

extension AlarmSoundClient: DependencyKey {
    static let liveValue: AlarmSoundClient = {
        AlarmSoundClient(
            play: { sound in
                // 메인 액터에서 안전하게 접근
                await MainActor.run {
                    AlarmSoundHolder.shared.playAlarmSound(sound)
                }
            },
            stop: {
                await MainActor.run {
                    AlarmSoundHolder.shared.stopAlarmSound()
                }
            }
        )
    }()
}

extension DependencyValues {
    var alarmSound: AlarmSoundClient {
        get { self[AlarmSoundClient.self] }
        set { self[AlarmSoundClient.self] = newValue }
    }
}

@MainActor
final class ContinuousVibrator {
    private var engine: CHHapticEngine?
    private var player: CHHapticAdvancedPatternPlayer?
    private(set) var isRunning = false

    init?() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }
        do {
            let e = try CHHapticEngine()
            e.playsHapticsOnly = true
            e.isAutoShutdownEnabled = false
            e.stoppedHandler = { [weak self] _ in self?.isRunning = false }
            self.engine = e
            try e.start()
        } catch { return nil }
    }

    func startLoop(intensity: Float = 1.0, sharpness: Float = 0.5, segment: TimeInterval = 4.0) {
        guard let engine, !isRunning else { return }
        isRunning = true

        func makeAndPlay() {
            guard self.isRunning else { return }
            do {
                let events = [
                    CHHapticEvent(eventType: .hapticContinuous,
                                  parameters: [
                                    CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity),
                                    CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
                                  ],
                                  relativeTime: 0, duration: segment)
                ]
                let pattern = try CHHapticPattern(events: events, parameters: [])
                let p = try engine.makeAdvancedPlayer(with: pattern)
                self.player = p
                p.completionHandler = { [weak self] _ in
                    guard let self, self.isRunning else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { makeAndPlay() }
                }
                try engine.start()
                try p.start(atTime: 0)
            } catch {
                try? engine.start()
                if self.isRunning { makeAndPlay() }
            }
        }
        makeAndPlay()
    }

    func stop() {
        isRunning = false
        _ = try? player?.stop(atTime: 0)
        player = nil
        engine?.stop(completionHandler: nil)
    }
}
