//
//  BottomView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/7/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let content: Content

    @GestureState private var translation: CGFloat = 0

    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.secondary)
            .frame(
                width: 60,
                height: 3
        ).onTapGesture {
            self.isOpen.toggle()
        }
    }

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * 0.30
        self.maxHeight = maxHeight
        self.content = content()
        self._isOpen = isOpen
    }

    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(spacing: 0) {
                self.indicator.padding([.top, .leading, .trailing])
                self.content
            }
            
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.white))
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())

            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * 0.20
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                }
            )
        }
    }
}

//struct BottomSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BottomSheetView(isOpen: .constant(false), maxHeight: 600) {
//            Rectangle().fill(Color(.systemFill))
//        }.edgesIgnoringSafeArea(.all)
//    }
//}
