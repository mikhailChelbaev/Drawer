//
//  AboutDeveloperView.swift
//  Drawer
//
//  Created by Mikhail on 05.10.2021.
//

import SwiftUI

struct AboutDeveloperView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                HStack {
                    Text("Developer:").bold()
                    Text("Chelbaev Mikhail")
                    Spacer()
                }.padding(.leading, 20).padding(.top, 20)
                HStack {
                    Text("Task 1:").bold()
                    Text("Bresenham's algorithm realization")
                    Spacer()
                }.padding(.leading, 20)
                HStack {
                    Text("Task 2:").bold()
                    Text("Clipping and shape filling")
                    Spacer()
                }.padding(.leading, 20)
                HStack {
                    Text("Task 3:").bold()
                    Text("Bezier and B-Spline curves")
                    Spacer()
                }.padding(.leading, 20)
                HStack {
                    Text("Task 4:").bold()
                    Text("3D objects")
                    Spacer()
                }.padding(.leading, 20)
                HStack {
                    Text("Task 5:").bold()
                    Text("Roberts algorithm for removing invisible edges")
                    Spacer()
                }.padding(.leading, 20)
                HStack {
                    Text("IDE:").bold()
                    Text("XCode 13")
                    Spacer()
                }.padding(.leading, 20)
                HStack {
                    Text("Programming language:").bold()
                    Text("Swift 5.5")
                    Spacer()
                }.padding(.leading, 20)
                HStack(alignment: .top) {
                    Text("Program execution:").bold()
                    Text("Select the tool from the left panel then draw or interact with objects on the right panel.")
                    Spacer()
                }.padding(.leading, 20)
                Spacer()
            }
            .navigationTitle("About developer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct AboutDeveloperView_Previews: PreviewProvider {
    static var previews: some View {
        AboutDeveloperView()
    }
}
