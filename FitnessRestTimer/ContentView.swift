import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var seconds = 60
    @State private var remaining = 60
    @State private var isRunning = false
    @State private var isFinished = false

    var body: some View {
        VStack(spacing: 12) {
            Text("REST TIMER")
                .font(.headline)

            Text(String(format: "%02d:%02d",
                        remaining / 60,
                        remaining % 60))
                .font(.system(size: 38, weight: .bold))
                .monospacedDigit()

            if isFinished {
                Text("休息結束！")
                    .foregroundColor(.red)

                Button("停止提醒") {
                    stopAlarm()
                }
            } else {
                Button(isRunning ? "計時中" : "開始") {
                    startTimer()
                }
                .disabled(isRunning)
            }

            Button("重置") {
                resetTimer()
            }
        }
        .padding()
    }

    private func startTimer() {
        isRunning = true
        isFinished = false
        remaining = seconds

        Task {
            while remaining > 0 && isRunning {
                try? await Task.sleep(for: .seconds(1))
                if isRunning {
                    remaining -= 1
                }
            }

            if remaining == 0 && isRunning {
                isFinished = true
                isRunning = false
                WKInterfaceDevice.current().play(.notification)
            }
        }
    }

    private func stopAlarm() {
        isFinished = false
    }

    private func resetTimer() {
        isRunning = false
        isFinished = false
        remaining = seconds
    }
}
