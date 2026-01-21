//
//  MainPage.swift
//  DailyList
//
//  Created by Dylan Kullas on 1/18/26.
//

import SwiftUI
import Foundation
import UserNotifications

@Observable
class SharedMovieList {
    var allMovies: [String] = []
}

struct MainPage: View {
    @State private var categories: [String] = ["All"] // List of items
    @State private var sharedMovies = SharedMovieList()
    @State private var tr: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Movie Lists")
                    .font(.custom("Helvetica-Bold", size: 35)) // Apply font directly
            }
            .task {
                await loadMovieList()
            }
            
            VStack {
                // List of items with swipe-to-delete functionality
                List {
                    ForEach(categories, id: \.self) { category in
                        Toggle("Enable Feature X", isOn: $tr)
//                                    .toggleStyle(.checkbox) // Uses the native macOS checkbox style
                                    .padding()
                        
//                        NavigationLink(destination: ContentView()) {
//                            Text(category)
//
//                        }
                    }
                    Button("Request Permission") {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error {
                                print(error.localizedDescription)
                            }
                        }
                    }

                    Button("Schedule Notification") {
                        print("HERE")
                        let content = UNMutableNotificationContent()
                        content.title = "Feed the cat"
                        content.subtitle = "It looks hungry"
                        content.sound = UNNotificationSound.default

                        // show this notification five seconds from now
                        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)

                        // choose a random identifier
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                        // add our notification request
                        UNUserNotificationCenter.current().add(request)
                        print("HERE")
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
    
    private func loadMovieList() async {
        let _ = print("LOSD")
//        sharedMovies.allMovies = []
//        
//        let file = "myMovieList.txt"
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//            let fileURL = dir.appendingPathComponent(file)
//            
////            do {
////                try "".write(to: fileURL, atomically: false, encoding: .utf8)
////            }
////            catch { print("warning: file write failed!") }
//
//            //reading
//            do {
//                let text = try String(contentsOf: fileURL, encoding: .utf8)
//                let allMoviesFromFile = text.components(separatedBy: "\n")
//                
//                for movieFromFile in allMoviesFromFile {
//                    if(movieFromFile == "") {
//                        continue
//                    }
//                    
//                    let movieFromFile = movieFromFile.components(separatedBy: "*$*@*")
//                    print(movieFromFile)
//                    
//                    let newMovie = ""
////                    let newMovie = Movie()
//                    sharedMovies.allMovies.append(newMovie)
//                }
//            }
//            catch { print("warning: file read failed!") }
//        }
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
