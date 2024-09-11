import SwiftUI

struct ContentView: View {
    var body: some View {
		NavigationView {
			List {
				NavigationLink(destination: CounterView(state: AppState())) {
					Text("Counter demo")
				}
				NavigationLink(destination: EmptyView()) {
					Text("Favorite primes")
				}
			}
			.navigationBarTitle("State management")
		}
    }
}
