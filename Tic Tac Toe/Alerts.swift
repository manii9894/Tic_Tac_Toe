//
//  Alerts.swift
//  Tic Tac Toe
//
//  Created by Abdul Rehman on 22/06/2021.
//

import SwiftUI

struct AlertItem: Identifiable {
    
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
    
}

struct AlertContext {
    
    static let humanWins = AlertItem(title: Text("You win!"), message: Text("You have won the game. Press the button to play again"), buttonTitle: Text("Play Again"))
    static let computerWins = AlertItem(title: Text("Computer wins!"), message: Text("Hard luck. Computer has won the game. Press the button to play again"), buttonTitle: Text("Play Again"))
    static let draw = AlertItem(title: Text("Draw!"), message: Text("It's a draw. Press the button to play again"), buttonTitle: Text("Play Again"))
    
}
