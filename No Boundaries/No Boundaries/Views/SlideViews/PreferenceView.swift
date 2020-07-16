//
//  PreferenceView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/15/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI


import SwiftUI

struct PreferenceView: View {
    
    @Binding var currentMode: Int
    var mode = ["Test", "Practice", "Study"]
    
    init(currentMode: Binding<Int>) {
        self._currentMode = currentMode
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemBlue
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }
    
    var body: some View {
        Picker(selection: self.$currentMode, label: Text("Mode")) {
            ForEach(0..<self.mode.count) { index in
                Text(self.mode[index]).tag(index)
            }
        }.padding([.bottom], 30.0).padding([.leading, .trailing], 20.0).pickerStyle(SegmentedPickerStyle())
    }
}

