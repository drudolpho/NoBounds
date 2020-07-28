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
    
    @ObservedObject var regionVM = RegionViewModel()
    @ObservedObject var networkController = NetworkController()
    @State private var bottomSheetShowing = false
    @State private var instructionsShowing = false
    @State private var navBarHidden = true
    @State private var refreshScores = Bool()
    @State var time = 0
    @State private var currentMode = 0
    @State var animateControlButton = false
    
        
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        NavigationView {
                
            GeometryReader { geometry in
                ZStack {
                    GoogleMapsView(regionVM: self.regionVM, currentMode: self.$currentMode)
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
                                ControlView(regionVM: self.regionVM, time: self.$time, bottomSheetShown: self.$bottomSheetShowing, gameMode: self.$currentMode, animateControlButton: self.$animateControlButton)
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
                                        NavigationLink(destination: ScoresView(regionVM: self.regionVM, networkController: self.networkController, navBarHidden: self.$navBarHidden, refreshScores: self.$refreshScores).onAppear {
                                            self.networkController.fetchPostsof(challenge: self.regionVM.challenge)
                                        }) {
                                            Text("View Highscores")
                                        }.padding(.horizontal)
                                    }
                                    Divider()
                                }
                                MyScoresView(regionVM: self.regionVM, refreshScores: self.$refreshScores)
                                    .frame(width: geometry.size.width * 0.9)
                                Spacer()
                            }
                        }
                    }.edgesIgnoringSafeArea(.all).zIndex(2)
                    
                    
                    
                    if self.regionVM.gameStatus == .win {
                        SubmitView(regionVM: self.regionVM, time: self.$time, refreshScores: self.$refreshScores, currentMode: self.$currentMode, animateControlButton: self.$animateControlButton)
                            .frame(width: geometry.size.width * 0.85, height: geometry.size.height * 0.8)
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
        
        let statesvm = RegionViewModel()
        statesvm.gameStatus = .win
        statesvm.promptedRegion = Region(name: "Kansas", iso: "KS", center: CoordData(lat: 0, lon: 0), borders: [])
        view.regionVM = statesvm
        return view
    }
}

