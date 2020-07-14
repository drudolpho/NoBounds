//
//  GuideView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/14/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct GuideView: View {
    var body: some View {
        VStack {
            HStack {
                Image("walk")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30.0, height: 30)
                    .padding(.horizontal)
                Text("Tap Start to begin the game")
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 0.9))
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            Divider()
                .frame(width: 300, height: 2)
            HStack {
                Image("bus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30.0, height: 30)
                    .padding(.horizontal)
                Text("Touch within the boundaries of the prompted state")
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 0.9))
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            Divider()
                .frame(width: 300, height: 2)
            HStack {
                Image("plane")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30.0, height: 30)
                    .padding(.horizontal)
                Text("Complete all states within record time!")
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2, opacity: 0.9))
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            Spacer()
        }
    }
}

struct GuideView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            GuideView()
                .frame(width: geometry.size.width, height: geometry.size.height / 3)
                .background(Color(red: 0.97, green: 0.97, blue: 0.95, opacity: 1))
        }
    }
}
