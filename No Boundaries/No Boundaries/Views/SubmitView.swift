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
    
    @ObservedObject var statesVM: StatesViewModel
    @Binding var time: Int
    @Binding var refreshScores: Bool
    @State var width: CGFloat
    @State var height: CGFloat
    @State var submitting: Bool
    @State var selection1: Int = UserDefaults.standard.integer(forKey: "initial1")
    @State var selection2: Int = UserDefaults.standard.integer(forKey: "initial2")
    @State var selection3: Int = UserDefaults.standard.integer(forKey: "initial3")
    var ref: DatabaseReference = Database.database().reference()
    
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        
        VStack {
            if self.submitting {
                GeometryReader { geometry in
                    VStack(spacing: 8) {
                        HStack {
                            Spacer()
                            Text("🌎")
                                .font(.system(size: 50))
                                .alignmentGuide(.bottom) { d in d[.bottom] + 60 }
                            Spacer()
                            Text("Time: \(self.time)")
                                .foregroundColor(.gray)
                                .font(.title)
                            Spacer()
                        }.padding(.top, 8.0)
                        
                        HStack(spacing: 0)  {
                            Text("Your initials:")
                                .font(.headline)
                                .padding(.horizontal, 8.0)
                            Picker(selection: self.$selection1, label: Text("Numbers")) {
                                ForEach(0 ..< self.letters.count) {
                                    Text("\(self.letters[$0])")
                                }
                            }.frame(maxWidth: geometry.size.width/6, maxHeight: geometry.size.height/2.3).clipped()
                            
                            Picker(selection: self.$selection2, label: Text("Numbers")) {
                                ForEach(0 ..< self.letters.count) {
                                    Text("\(self.letters[$0])")
                                }
                            }.frame(maxWidth: geometry.size.width/6, maxHeight: geometry.size.height/2.3).clipped()
                            
                            Picker(selection: self.$selection3, label: Text("Numbers")) {
                                ForEach(0 ..< self.letters.count) {
                                    Text("\(self.letters[$0])")
                                }
                            }.frame(maxWidth: geometry.size.width/6, maxHeight: geometry.size.height/2.3).clipped()
                        }.padding([.leading, .trailing]).compositingGroup()
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                self.statesVM.gameStatus = .before
                                self.statesVM.resetGameData()
                                self.time = 0
                            }) {
                                Text("Cancel")
                                    .font(.headline)
                                    .frame(width: 80, height: 40, alignment: .center)
                                
                            }.background(Color.white).cornerRadius(10)
                            Spacer()
                            Button(action: {
                                
                                //handle the submission
                                let name = (self.letters[self.selection1] + self.letters[self.selection2] + self.letters[self.selection3])
                                
                                let submission = USApost(time: self.time, name: name)
                                submission.submitToServer(reference: self.ref)
                                
                                //Saves users initials to UD
                                UserDefaults.standard.set(self.selection1, forKey: "initial1")
                                UserDefaults.standard.set(self.selection2, forKey: "initial2")
                                UserDefaults.standard.set(self.selection3, forKey: "initial3")
                                
                                //Saves users scores to UD
                                if let data = UserDefaults.standard.value(forKey:"scores") as? Data {
                                    var scores = try? PropertyListDecoder().decode(Array<UserScores>.self, from: data)
                                    scores?.append(UserScores(id: UUID().uuidString, time: self.time, name: name, date: Date()))
                                    UserDefaults.standard.set(try? PropertyListEncoder().encode(scores), forKey:"scores")
                                } else {
                                    let score = UserScores(id: UUID().uuidString, time: self.time, name: name, date: Date())
                                    UserDefaults.standard.set(try? PropertyListEncoder().encode([score]), forKey:"scores")
                                }
                                
                                if let data = UserDefaults.standard.value(forKey:"scores") as? Data {
                                    let scores = try? PropertyListDecoder().decode(Array<UserScores>.self, from: data)
                                    print("\(String(describing: scores?.count))")
                                }
                                
                                self.statesVM.gameStatus = .before
                                self.statesVM.resetGameData()
                                self.time = 0
                                self.refreshScores.toggle()
                            }) {
                                Text("Submit")
                                    .font(.headline)
                                    .frame(width: 80, height: 40, alignment: .center)
                                
                            }.background(Color.white).cornerRadius(10)
                            Spacer()
                        }
                    }
                }
            } else {
                VStack {
                    Text("Congrats! 🎉")
                        .padding([.top, .leading, .trailing])
                        .font(.title)
                    Text("Would you like to submit your score to the leaderboards?")
                        .multilineTextAlignment(.center)
                        .padding()
                    HStack {
                        Button(action: {
                            self.statesVM.gameStatus = .before
                            self.statesVM.resetGameData()
                            self.time = 0
                        }) {
                            Text("No")
                                .font(.headline)
                                .frame(width: 80, height: 40, alignment: .center)
                            
                        }.background(Color.white).cornerRadius(10)
                        Button(action: {
                            self.submitting = true
                            withAnimation {
                                self.height *= 1.3
                            }
                            
                        }) {
                            Text("Yes")
                                .font(.headline)
                                .frame(width: 80, height: 40, alignment: .center)
                            
                        }.background(Color.white).cornerRadius(10)
                    }
                }
            }
        }.frame(width: self.width, height: self.height).background(Color.white).cornerRadius(20)
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
