//
//  GameViewModel.swift
//  Towers
//
//  Created by Studend on 08/04/22.
//

import SwiftUI

struct NumberDisp {
    var num: Int = 0
    var color: Color = .black
}

class gameViewModel: ObservableObject {
    
    var size: Int    
    
    @Published var ans: [[NumberDisp]] = []
    @Published var dBoard: [[NumberDisp]] = []
    @Published var towerCount = Array(repeating: Array(repeating: NumberDisp(), count: 4 ), count: 4)
    
    @Published var selected: (row: Int, col: Int) = (0, 0)
    
    @Published var win = false
    
    init (size: Int) {
        self.size = size
    }
    
    func setBoard() {
        func uniquePer(visited: [[Int]], ind: Int, shuffArr: [[Int]]) {
            if visited.count == size {
                return tempBoard = visited
            }
            let condition = visited.first(where: { i in i.indices.first(where: {i[$0] == shuffArr[ind][$0]}) != nil }) == nil
            
            return uniquePer(visited: visited + (condition ? [shuffArr[ind]] : []), ind: ind + 1, shuffArr: shuffArr)
        }
        
        dBoard = Array(repeating: Array(repeating: NumberDisp(), count: size), count: size)
        
        
        var perArr: [[Int]] = []
        permute(arr: &perArr, a: Array(1...size), l: 0, r: size-1)
        
        let x = perArr.shuffled()
        
        var tempBoard: [[Int]] = []
        uniquePer(visited: [x[0]], ind: 1, shuffArr: x)
        ans = tempBoard.map{$0.map{NumberDisp(num: $0)}}
        
        if size == 6 {
            (0..<6).map { i in
                (0..<6).map {(i, $0)}
            }.reduce([], +).shuffled().prefix(5).forEach {
                dBoard[$0][$1].num = tempBoard[$0][$1]
            }
        }
        
        getTowerCount(board: tempBoard.map{$0.map{NumberDisp(num: $0)}}, cheakWin: false)
    }
    
    func getTowerCount(board: [[NumberDisp]], cheakWin: Bool) {
        
        func towerCountColor(a: Int, b: Int) {
            if cheakWin {
                if (max == possibleMax && tempTowerC[a][b] + empSpc < towerCount[a][b].num) ||
                    tempTowerC[a][b] > towerCount[a][b].num {
                    towerCount[a][b].color = .red
                    proper = false
                }
            }
        }
        
        
        if cheakWin {
            for i in towerCount.indices {
                for j in towerCount[i].indices {
                    towerCount[i][j].color = .black
                }
            }
        }
        
        let possibleMax = size
        
        var tempTowerC = Array(repeating: Array(repeating: 0, count: size), count: 4)
        var proper = true
        
        var max = 0
        var empSpc = 0
        for i in board.indices {
            max = 0
            empSpc = 0
            for j in board[i].indices {
                if board[i][j].num == 0 {
                    empSpc += 1
                }
                else if max < board[i][j].num {
                    max = board[i][j].num
                    tempTowerC[1][i] += 1
                    if max == possibleMax {break}
                }
            }
            towerCountColor(a: 1, b: i)
            
            max = 0
            empSpc = 0
            for j in board[i].indices.reversed() {
                if board[i][j].num == 0 {
                    empSpc += 1
                }
                else if max < board[i][j].num {
                    max = board[i][j].num
                    tempTowerC[3][i] += 1
                    if max == possibleMax {break}
                }
            }
            towerCountColor(a: 3, b: i)
            
            max = 0
            empSpc = 0
            for j in board[0].indices {
                if board[j][i].num == 0 {
                    empSpc += 1
                }
                else if max < board[j][i].num {
                    max = board[j][i].num
                    tempTowerC[0][i] += 1
                    if max == possibleMax {break}
                }
            }
            towerCountColor(a: 0, b: i)
            
            max = 0
            empSpc = 0
            for j in board[0].indices.reversed() {
                if board[j][i].num == 0 {
                    empSpc += 1
                }
                else if max < board[j][i].num {
                    max = board[j][i].num
                    tempTowerC[2][i] += 1
                    if max == possibleMax {break}
                }
            }
            towerCountColor(a: 1, b: i)
        }
        
        if !cheakWin {
            towerCount = tempTowerC.map{$0.map{NumberDisp(num: $0)}}
            return
        }
        
        win = boardColor() && proper
    }
    
    func boardColor()-> Bool {
        var proper = true
        for i in dBoard.indices {
            for j in dBoard[0].indices {
                dBoard[i][j].color = .black
            }
        }
                
        var dic: [Int: Int] = [:]
        
        for row in dBoard.indices {
            dic = [:]
            for i in dBoard[row] {
                dic[i.num, default: 0] += 1
            }
            if dic[0] != nil {
                proper = false
                dic[0] = nil
            }
            for i in dic.keys where dic[i]! > 1 {
                for j in dBoard[0].indices {
                    if dBoard[row][j].num == i {
                        dBoard[row][j].color = .red
                        proper = false
                    }
                }
            }
        }
        
        for col in dBoard[0].indices {
            dic = [:]
            for i in dBoard.indices where dBoard[i][col].num != 0 {
                dic[dBoard[i][col].num, default: 0] += 1
            }
            
            for i in dic.keys where dic[i]! > 1 {
                for j in dBoard.indices {
                    if dBoard[j][col].num == i {
                        dBoard[j][col].color = .red
                        proper = false
                    }
                }
            }
        }
        return proper
    }
    
    /// MARK :- Helper Functions
    
    func permute(arr: inout [[Int]] ,a: [Int], l: Int, r: Int){
        if l == r {
            arr.append(a)
        } else {
            var a = a
            for i in l...r {
                (a[l], a[i]) = (a[i], a[l])
                permute(arr: &arr, a: a, l: l+1, r: r)
            }
        }
    }
    
    
}
