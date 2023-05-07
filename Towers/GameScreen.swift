//
//  GameScreen.swift
//  Towers
//
//  Created by home on 29/03/22.
//

import SwiftUI

struct GameScreen: View {
    @ObservedObject var vm: gameViewModel
    
    let size: Int
    
    @Environment(\.presentationMode) var presentationMode
    
    init(size: Int) {
        self.size = size
        vm = gameViewModel(size: size)
    }
    
    var body: some View {
        VStack {
            Spacer()
            HLine(vm.towerCount[0])
            HStack {
                VLine(vm.towerCount[1])
                boardView
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.trailing)
                VLine(vm.towerCount[3])
            }
            .aspectRatio(1, contentMode: .fit)
            HLine(vm.towerCount[2])
            Spacer()
            buttonsView
            Spacer()
        }
        .padding()
        .onAppear {
            vm.setBoard()
        }
        .alert(isPresented: $vm.win, content: {
            Alert(title: Text("won"),
                  primaryButton: .default(Text("Home screen"), action: {
                    presentationMode.wrappedValue.dismiss()
                  }),
                  secondaryButton: .default(Text("play again"), action: {
                    vm.setBoard()
                  }))
        })
    }
    
    var boardView: some View {
        VStack(spacing: 5) {
            ForEach(vm.dBoard.indices, id: \.self) { row in
                rowView(row: row)
            }
        }
    }
    
    func rowView(row: Int)-> some View {
        HStack(spacing: 5) {
            ForEach(vm.dBoard[row].indices, id: \.self) { col in
                let data = vm.dBoard[row][col]
                cell(data: data, isSelected: vm.selected == (row, col))
                    .zIndex(Double(4 - col))
                    .onTapGesture(count: 2) {
                        vm.dBoard[row][col].num = 0
                        vm.getTowerCount(board: vm.dBoard, cheakWin: true)
                    }
                    .onTapGesture {
                        vm.selected = (row, col)
                    }
            }
        }
    }
    
    func cell(data: NumberDisp, isSelected: Bool) -> some View {
        let o = CGFloat(data.num*4)
        return Text(data.num == 0 ? " " : "\(data.num)")
            .foregroundColor(data.color)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(isSelected ? Color.green : Color.black, width: isSelected ? 5 : 2)
            .background(Color.white
                            .shadow(color: .black, radius: 1, x: -o, y: o)
            )
            .offset(x: o, y: -o)
    }
    
    func HLine(_ arr: [NumberDisp]) -> some View {
        HStack {
            ForEach(arr.indices, id: \.self) { i in
                Text("\(arr[i].num)")
                    .foregroundColor(arr[i].color)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal)
        .padding(.trailing)
    }
    
    func VLine(_ arr: [NumberDisp]) -> some View {
        VStack {
            ForEach(arr.indices, id: \.self) { i in
                Text("\(arr[i].num)")
                    .foregroundColor(arr[i].color)
                    .frame(maxHeight: .infinity)
            }
        }
    }
    
    var buttonsView: some View {
        HStack {
            ForEach(0...size, id: \.self) { i in
                Button(action: {
                    vm.dBoard[vm.selected.row][vm.selected.col].num = i
                    vm.getTowerCount(board: vm.dBoard, cheakWin: true)
                }, label: {
                    Text("\(i)")
                        .foregroundColor(.black)
                        .bold()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .aspectRatio(1, contentMode: .fit)
                        .background(Color.green)
                })
            }
        }
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen(size: 9)
    }
}
