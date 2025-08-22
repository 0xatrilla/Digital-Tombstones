// This feature module targets iOS only; wrap SwiftUI usage to avoid macOS availability checks during indexing.
#if os(iOS)
import SwiftUI

public struct ContentView: View {
    @StateObject private var vm = KilledViewModel()
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ZStack {
                LiquidBackground()
                content
            }
            .navigationTitle("Killed by Google")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if vm.isLoading {
                        ProgressView()
                            .tint(.primary)
                    } else {
                        Button {
                            Task { await vm.load() }
                        } label: {
                            Image(systemName: "arrow.clockwise")
                        }
                    }
                }
            }
        }
        .task { await vm.load() }
    }
    
    @ViewBuilder
    private var content: some View {
        if let error = vm.error {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                Text(error)
                    .multilineTextAlignment(.center)
                Button("Retry") { Task { await vm.load() } }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding()
        } else {
            List {
                ForEach(vm.items) { item in
                    NavigationLink {
                        KilledDetailView(item: item)
                    } label: {
                        KilledRowView(item: item)
                            .listRowSeparator(.hidden)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .refreshable {
                await vm.load()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#endif
