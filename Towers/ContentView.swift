//
//  ContentView.swift
//  Towers
//
//  Created by home on 08/04/22.
//

import SwiftUI

struct ContentView: View {
    let width = UIScreen.main.bounds.width/3
    @State var nav = false
    @State var size: Int = 3
    
    var body: some View {
        VStack {
            NavigationLink(destination: GameScreen(size: size),isActive: $nav){
                Text("Play")
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .frame(width: width, height: (width/3)*2)
                    .background(RadialGradient(gradient: Gradient(colors: [Color.white, Color.blue]), center: .init(x: 0.4, y: 0.4), startRadius: 5, endRadius: 70))
                    .cornerRadius(10)
            }
            
            Stepper("size:- \(size)") {
                size += 1
                if size > 6 {size = 3}
            } onDecrement: {
                size -= 1
                if size < 3 {size = 6}
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
