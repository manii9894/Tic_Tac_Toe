//
//  Moves.swift
//  Tic Tac Toe
//
//  Created by Abdul Rehman on 22/06/2021.
//

import Foundation

struct Move {
    
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "checkmark" : "xmark"
    }
    
}
