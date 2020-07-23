//
//  ContentView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 6/24/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI
import GoogleMaps


struct ContentView: View {
    
    @ObservedObject var statesVM = StatesViewModel()
    @ObservedObject var networkController = NetworkController()
    @State private var bottomSheetShowing = false
    @State private var instructionsShowing = false
    @State private var navBarHidden = true
    @State private var refreshScores = Bool()
    @State var time = 0
    @State private var currentMode = 0
    
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        NavigationView {
                
            GeometryReader { geometry in
                ZStack {
                    GoogleMapsView(statesVM: self.statesVM, currentMode: self.$currentMode)
                        .edgesIgnoringSafeArea(.all)
                        .zIndex(0)
                    
                    VStack {
                        HStack{
                            Spacer()
                            Button(action: {
                                self.instructionsShowing.toggle()
                            }) {
                                Text("?")
                                    .font(.title)
                                    .foregroundColor(Color.gray)
                                }.frame(width: 30, height: 30).background(Color.white).cornerRadius(10)
                        }
                        Spacer()
                    }.padding(.top, 50.0).padding(.trailing, 20.0).zIndex(1).edgesIgnoringSafeArea(.all)
                    
                    VStack {
                        Spacer()
                        
                        BottomSheetView(
                            isOpen: self.$bottomSheetShowing,
                            maxHeight: geometry.size.height * 0.70
                        ) {
                            VStack(spacing: 0){
                                ControlView(statesVM: self.statesVM, time: self.$time, bottomSheetShown: self.$bottomSheetShowing, gameMode: self.$currentMode)
                                    .frame(width: geometry.size.width, height: geometry.size.height * 0.18)
                                
                                VStack {
                                    HStack {
                                        Text("Mode")
                                            .foregroundColor(Color.gray)
                                            .padding(.horizontal)
                                        Spacer()
                                    }
                                    Divider()
                                }
                                
                                PreferenceView(currentMode: self.$currentMode)
                                
                                VStack(spacing: 8) {
                                    HStack {
                                        Text("Scores")
                                            .foregroundColor(Color.gray)
                                            .padding(.horizontal)
                                        Spacer()
                                        NavigationLink(destination: ScoresView(networkController: self.networkController, navBarHidden: self.$navBarHidden, refreshScores: self.$refreshScores).onAppear {
                                            self.networkController.fetchUSA()
                                        }) {
                                            Text("View Highscores")
                                        }.padding(.horizontal)
                                    }
                                    Divider()
                                }
                                MyScoresView(refreshScores: self.$refreshScores)
                                    .frame(width: geometry.size.width * 0.9)
                                Spacer()
                            }
                        }
                    }.edgesIgnoringSafeArea(.all).zIndex(2)
                    
                    
                    
                    if self.statesVM.gameStatus == .win {
                        SubmitView(statesVM: self.statesVM, time: self.$time, refreshScores: self.$refreshScores, width: geometry.size.width * 0.85 , height: geometry.size.height * 0.3, submitting: false)
                            .transition(AnyTransition.scale.animation(.spring()))
                            .zIndex(3)
                    }
                    
                    if self.instructionsShowing {
                        VStack {
                            Text("Help ⁉️")
                                .bold()
                                .font(.title)
                                .padding([.top, .leading, .trailing])
                         
                            GuideView()
                            
                            Button(action: {
                                self.instructionsShowing = false
                            }) {
                                Text("Got it")
                                    .font(.headline)
                            }.padding()
                            
                        }.frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.45)
                            .background(Color.white)
                            .cornerRadius(20)
                            .transition(AnyTransition.scale.animation(.spring()))
                            .zIndex(4)
                    }
                }
            }.navigationBarTitle("")
            .navigationBarHidden(self.navBarHidden)
            .onAppear(perform: {
                self.navBarHidden = true
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var view = ContentView()
        
        let statesvm = StatesViewModel()
        statesvm.gameStatus = .win
        statesvm.promptedState = USState(name: "Kansas", borders: [])
        view.statesVM = statesvm
        return view
    }
}

