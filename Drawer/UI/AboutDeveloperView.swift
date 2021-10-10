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
                    Text("Task:").bold()
                    Text("Bresenham's algorithm realization")
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
                    Text("Open Bresenham_algo project and run it. Use buttons on the first page to select draw type, open draw window and watch an information about the developer. To draw a line click on the panel first time to set the beginning and second to set the end. To draw a circle or an ellipse click on the panel to set a center, then click again to set the radius.")
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
