//
//  GameView.swift
//  Tic Tac Toe
//
//  Created by Abdul Rehman on 21/06/2021.
//

import SwiftUI

struct GameView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isBoardBlocked = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns, spacing: 5, content: {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle().foregroundColor(.black).opacity(0.85).frame(width: (geometry.size.width / 3) - 15, height: (geometry.size.width / 3) - 15)
                            Image(systemName: moves[i]?.indicator ?? "").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                        }
                        .onTapGesture {
                            if isPositionOccupied(in: moves, at: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            if checkWinCondition(for: .human, in: moves) {
                                alertItem = AlertContext.humanWins
                                return
                            }
                            
                            if checkDrawCondition(in: moves) {
                                alertItem = AlertContext.draw
                                return
                            }
                            isBoardBlocked = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let index = getComputerMovePosition(in: moves)
                                moves[index] = Move(player: .computer, boardIndex: index)
                                if checkWinCondition(for: .computer, in: moves) {
                                    alertItem = AlertContext.computerWins
                                    return
                                }
                                if checkDrawCondition(in: moves) {
                                    alertItem = AlertContext.draw
                                    return
                                }
                                isBoardBlocked = false
                            }
                        }
                    }
                })
                Spacer()
            }.disabled(isBoardBlocked)
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    resetGame()
                }))
            }
        }).padding()
        
    }
    
    func isPositionOccupied(in moves: [Move?], at index: Int) -> Bool {
        return moves.contains { $0?.boardIndex == index }
    }
    
    func getComputerMovePosition(in moves: [Move?]) -> Int {
        
        if let index = getAvailableMoveIndex(for: .computer) {
            return index
        }
        if let index = getAvailableMoveIndex(for: .human) {
            return index
        }
        
        if !isPositionOccupied(in: moves, at: 4) {
            return 4
        }
        
        var movePosition = Int.random(in: 0..<9)
        while isPositionOccupied(in: moves, at: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
        
    }
    
    func getAvailableMoveIndex(for player: Player) -> Int? {
        
        let winPatters: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatters {
            let winPositions = pattern.subtracting(playerPositions)
            if winPositions.count == 1 {
                if !isPositionOccupied(in: moves, at: winPositions.first!) {
                    return winPositions.first!
                }
            }
        }
        return nil
        
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        
        let winPatters: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatters where pattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
        
    }
    
    func checkDrawCondition(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isBoardBlocked = false
    }
    
}

enum Player {
    case human, computer
}

struct Move {
    
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "checkmark" : "xmark"
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
