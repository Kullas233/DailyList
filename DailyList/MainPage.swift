import SwiftUI
import Foundation

struct MainPage: View {
    @State private var categories: [String] = ["All", "Movies", "TV Shows"] // List of items
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Daily Lists")
                    .font(.custom("Helvetica-Bold", size: 35)) // Apply font directly
            }
//            .task {
//                await loadMovieList()
//            }
            
            VStack {
                // List of items with swipe-to-delete functionality
                List {
                    ForEach(categories, id: \.self) { category in
                        NavigationLink(destination: ListView()) {
                            Text(category)
                        }
                    }
                }
                // Add "+" button to start adding a new item
//                NavigationLink(destination: AddMediaPage(sharedMovies:sharedMovies)) {
//                    HStack {
//                        Image(systemName: "plus")
//                        Text("Add Item")
//                    }
//                    .font(.title2)
//                }
//                .buttonStyle(.bordered)
//                .padding()
            }
        }
        .frame(minWidth: 400, minHeight: 300) // Default size for macOS
    
    }
}

// Preview for both platforms
struct MainPage_Previews: PreviewProvider {
    static var previews: some View {
        MainPage()
            .previewDevice("iPhone 16 Pro")
        MainPage()
            .frame(width: 500, height: 400) // macOS preview
    }
}
