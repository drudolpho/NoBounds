//
//  SubmitView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/16/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct SubmitView: View {
    
    @ObservedObject var regionVM: RegionViewModel
    @Binding var time: Int
    @Binding var refreshScores: Bool
    @Binding var currentMode: Int
    @Binding var animateControlButton: Bool
    @State var selection1: Int = UserDefaults.standard.integer(forKey: "initial1")
    @State var selection2: Int = UserDefaults.standard.integer(forKey: "initial2")
    @State var selection3: Int = UserDefaults.standard.integer(forKey: "initial3")
    var ref: DatabaseReference = Database.database().reference()
    
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                HStack {
                    Spacer()
                    Text("Congrats! 🎉")
                        .font(.title)
                        .bold()
                    Spacer()
                    Text("Time: \(self.time)")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                }.padding(.top, 12.0)
                
                HStack(spacing: 0)  {
                    Text("Your initials:")
                        .font(.headline)
                        .padding(.horizontal, 8.0)
                    Picker(selection: self.$selection1, label: Text("Numbers")) {
                        ForEach(0 ..< self.letters.count) {
                            Text("\(self.letters[$0])")
                        }
                    }.frame(maxWidth: geometry.size.width/6, maxHeight: geometry.size.height/6).clipped()
                    
                    Picker(selection: self.$selection2, label: Text("Numbers")) {
                        ForEach(0 ..< self.letters.count) {
                            Text("\(self.letters[$0])")
                        }
                    }.frame(maxWidth: geometry.size.width/6, maxHeight: geometry.size.height/6).clipped()
                    
                    Picker(selection: self.$selection3, label: Text("Numbers")) {
                        ForEach(0 ..< self.letters.count) {
                            Text("\(self.letters[$0])")
                        }
                    }.frame(maxWidth: geometry.size.width/6, maxHeight: geometry.size.height/6).clipped()
                }.padding([.leading, .trailing]).compositingGroup()
                
                HStack {
                    Spacer()
                    Button(action: {
                        let name = (self.letters[self.selection1] + self.letters[self.selection2] + self.letters[self.selection3])
                        
                        self.saveToUD(name: name)
                        self.regionVM.gameStatus = .before
                        self.regionVM.resetGameData()
                        self.time = 0
                        self.refreshScores.toggle()
                        self.animateControlButton.toggle()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .frame(width: 100, height: 40, alignment: .center)
                        
                    }.background(Color.white).cornerRadius(10).padding()
                    Spacer()
                    Button(action: {
                        
                        //handle the submission
                        let name = (self.letters[self.selection1] + self.letters[self.selection2] + self.letters[self.selection3])
                        
                        let submission = Post(time: self.time, name: name)
                        submission.submitToServer(reference: self.ref, challenge: self.regionVM.challenge)
                        
                        self.saveToUD(name: name)
                        
                        self.regionVM.gameStatus = .before
                        self.regionVM.resetGameData()
                        self.time = 0
                        self.refreshScores.toggle()
                        self.animateControlButton.toggle()
                    }) {
                        Text("Submit 🌎")
                            .font(.headline)
                            .frame(width: 100, height: 40, alignment: .center)
                        
                    }.background(Color.white).cornerRadius(10).padding().disabled(self.currentMode != 0)
                    Spacer()
                }
            }.background(Color.white).cornerRadius(20)
        }
    }
    
    func saveToUD(name: String) {
        //Saves users initials to UD
        UserDefaults.standard.set(self.selection1, forKey: "initial1")
        UserDefaults.standard.set(self.selection2, forKey: "initial2")
        UserDefaults.standard.set(self.selection3, forKey: "initial3")
        
        guard self.currentMode == 0 else { return }

        //Saves users scores to UD
        if let data = UserDefaults.standard.value(forKey:"scores\(self.regionVM.challenge.rawValue)") as? Data {
            var scores = try? PropertyListDecoder().decode(Array<UserScores>.self, from: data)
            scores?.append(UserScores(id: UUID().uuidString, time: self.time, name: name, date: Date()))
            UserDefaults.standard.set(try? PropertyListEncoder().encode(scores), forKey:"scores\(self.regionVM.challenge.rawValue)")
        } else {
            let score = UserScores(id: UUID().uuidString, time: self.time, name: name, date: Date())
            UserDefaults.standard.set(try? PropertyListEncoder().encode([score]), forKey:"scores\(self.regionVM.challenge.rawValue)")
        }
    }
}

//
//struct SubmitView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubmitView(showingSubmitView: true, submitting: true)
//
//            .frame(width: 300, height: 200, alignment: .center)
//
//            .background(Color.red)
//            .cornerRadius(20)
//    }
//}
