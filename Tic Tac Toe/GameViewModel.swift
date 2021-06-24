//
//  GameViewModel.swift
//  Tic Tac Toe
//
//  Created by Abdul Rehman on 22/06/2021.
//

import SwiftUI

class GameViewModel: ObservableObject {
    
    // MARK: - PROPERTIES
    let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isBoardBlocked = false
    @Published var alertItem: AlertItem?
    
    // MARK: - METHODS
    func processPlayerMove(for position: Int) {
        
        if isPositionOccupied(in: moves, at: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        // Check win condition for human
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWins
            return
        }
        // Check draw condition after human move
        if checkDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        isBoardBlocked = true
        // Computer moves process
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let index = getComputerMovePosition(in: moves)
            moves[index] = Move(player: .computer, boardIndex: index)
            // Check win condition for computer
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWins
                return
            }
            // Check draw condition after computer move
            if checkDrawCondition(in: moves) {
                alertItem = AlertContext.draw
                return
            }
            isBoardBlocked = false
        }
        
    }
    
    func isPositionOccupied(in moves: [Move?], at index: Int) -> Bool {
        return moves.contains { $0?.boardIndex == index }
    }
    
    func getComputerMovePosition(in moves: [Move?]) -> Int {
        
        // Check if computer can win
        if let index = getAvailableMoveIndex(for: .computer) {
            return index
        }
        // If can't win, check for block user to win
        if let index = getAvailableMoveIndex(for: .human) {
            return index
        }
        // If can't win and block, take middle position
        let middlePosition = 4
        if !isPositionOccupied(in: moves, at: middlePosition) {
            return middlePosition
        }
        // If can't win, block and take middle position, then get random available position
        var movePosition = Int.random(in: 0..<9)
        while isPositionOccupied(in: moves, at: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
        
    }
    
    func getAvailableMoveIndex(for player: Player) -> Int? {
        
        // Get all the move objects for specific player
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        // Get all the indexes of player moves
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            // Compare each win pattern with moves
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
        
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        // Check if moves matche a win pattern
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) {
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
