import SwiftUI

struct ContentView: View {
	var body: some View {
		VStack {
			Text("Thread Task")
		}
		.onAppear {
			Thread.detachNewThread {
				Thread.sleep(forTimeInterval: 1)
				print(Thread.current)
			}
			Thread.sleep(forTimeInterval: 1.1)
			print("!")
			
			let thread = Thread {
				let start = Date()
				defer { print("Finished in", Date().timeIntervalSince(start)) }
				
				Thread.sleep(forTimeInterval: 1)
				guard Thread.current.isCancelled == false else {
					print("Cancelled")
					return
				}
				print(Thread.current)
			}
			thread.threadPriority = 0.75
			thread.start()
			Thread.sleep(forTimeInterval: 0.01)
			thread.cancel()
		}
	}
}
