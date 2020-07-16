//
//  SubmitView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/16/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct SubmitView: View {
    
//    @Binding var showingSubmitView: Bool
    @ObservedObject var statesVM: StatesViewModel
    @Binding var time: Int
    @State var submitting: Bool
    @State var selection1: Int = 0
    @State var selection2: Int = 0
    @State var selection3: Int = 0
    var letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        
        VStack {
            if self.submitting {
                GeometryReader { geometry in
                    VStack {
                        HStack(spacing: 0) {
                            Picker(selection: self.$selection1, label: Text("Numbers")) {
                               ForEach(0 ..< self.letters.count) {
                                    Text("\(self.letters[$0])")
                                }
                            }.frame(maxWidth: geometry.size.width / 6, maxHeight: geometry.size.width / 4).clipped()
                            
                            Picker(selection: self.$selection2, label: Text("Numbers")) {
                                ForEach(0 ..< self.letters.count) {
                                    Text("\(self.letters[$0])")
                                }
                            }.frame(maxWidth: geometry.size.width / 6, maxHeight: geometry.size.width / 4).clipped()
                            
                            Picker(selection: self.$selection3, label: Text("Numbers")) {
                                ForEach(0 ..< self.letters.count) {
                                    Text("\(self.letters[$0])")
                                }
                            }.frame(maxWidth: geometry.size.width / 6, maxHeight: geometry.size.width / 4).clipped()
                        }.padding()
                        
                        HStack {
                            Button(action: {
                                self.statesVM.gameStatus = .before
                                self.statesVM.resetGameData()
                                self.time = 0
                            }) {
                                Text("Cancel")
                                    .font(.headline)
                                    .frame(width: 80, height: 40, alignment: .center)
                                
                            }.background(Color.white).cornerRadius(10)
                            Button(action: {
                                
                                //handle the submission
                                print(self.letters[self.selection1] + self.letters[self.selection2] + self.letters[self.selection3])
                                
                                self.statesVM.gameStatus = .before
                                self.statesVM.resetGameData()
                                self.time = 0
                            }) {
                                Text("Submit")
                                    .font(.headline)
                                    .frame(width: 80, height: 40, alignment: .center)
                                
                            }.background(Color.white).cornerRadius(10)
                        }
                    }
                }
            } else {
                Text("Congratulations!")
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
                    }) {
                        Text("Yes")
                            .font(.headline)
                            .frame(width: 80, height: 40, alignment: .center)
                        
                    }.background(Color.white).cornerRadius(10)
                }
                Spacer()
            }
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
