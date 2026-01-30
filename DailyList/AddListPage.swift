//
//  AddListPage.swift
//  DailyList
//
//  Created by Dylan Kullas on 1/29/26.
//

import SwiftUI
import Foundation

struct AddListPage: View {
    @State private var newItemName: String = "" // Holds the input for the new item
    @State private var showPopup: Bool = false
    @State private var popupText: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack(alignment: .center) {
                    Text("Add")
                        .font(.custom("Helvetica-Bold", size: 35)) // Apply font directly
                    
                    // Show text field
                    HStack {
                        TextField("Enter item name", text: $newItemName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    
                    if(showPopup)
                    {
                        VStack {
                            Text(popupText)
                                .multilineTextAlignment(.center)
                                .padding()
                            Button("Dismiss") {
                                showPopup = false
                            }
                            .padding()
                        }
                        .border(Color.black, width: 2)
                        .presentationCompactAdaptation(.none) // Forces popover style in compact size classes
                    }
                }
            }
        }
    }

    // Function to add a new item
//    private func addItem(sharedMovies: SharedMovieList, movieToAdd: Movie) {
//        let filename = "myMovieList.txt"
//            
//        // Get the document directory path
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            let fileURL = dir.appendingPathComponent(filename)
//
//            guard let data = movieToAdd.getData().data(using: .utf8) else {
//                popupText = "Internal Error"
//                showPopup = true
//                print("Failed to convert string to data")
//                return
//            }
//            
//            //reading
//            do {
//                let text = try String(contentsOf: fileURL, encoding: .utf8)
//                let find = "*$*@*" + movieToAdd.id + "*$*@*"
//                if(text.contains(find)) {
//                    popupText = "This item is already in your list!"
//                    showPopup = true
//                    return
//                }
//            }
//            catch { popupText = "Internal Error" ; showPopup = true ; print("warning: file read failed!") }
//            
//            // differnt writing
//            if FileManager.default.fileExists(atPath: fileURL.path) {
//                if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
//                    defer {
//                        fileHandle.closeFile()
//                    }
//                    fileHandle.seekToEndOfFile() // Move the file pointer to the end
//                    fileHandle.write(data) // Write the new data
//                } else {
//                    popupText = "Internal Error"
//                    showPopup = true
//                    print("Failed to open file handle for writing")
//                }
//            } else {
//                // If the file does not exist, create it with the initial content
//                do {
//                    try data.write(to: fileURL, options: .atomic)
//                } catch {
//                    popupText = "Internal Error"
//                    showPopup = true
//                    print("Failed to create file: \(error.localizedDescription)")
//                }
//            }
//        }
//        sharedMovies.allMovies.append(movieToAdd)
//        popupText = movieToAdd.title+" was added to your list!"
//        showPopup = true
//    }
}

// Preview for both platforms
struct AddListPage_Previews: PreviewProvider {
    static var previews: some View {
        AddListPage()
            .previewDevice("iPhone 16 Pro")
        AddListPage()
            .frame(width: 500, height: 400) // macOS preview
    }
}
