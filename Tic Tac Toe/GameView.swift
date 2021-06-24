//
//  GameView.swift
//  Tic Tac Toe
//
//  Created by Abdul Rehman on 21/06/2021.
//

import SwiftUI

struct GameView: View {
    
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        
        GeometryReader(content: { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: viewModel.columns, spacing: 5, content: {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle().foregroundColor(.black).opacity(0.9).frame(width: (geometry.size.width / 3) - 15, height: (geometry.size.width / 3) - 15)
                            Image(systemName: viewModel.moves[i]?.indicator ?? "").resizable().frame(width: 30, height: 30).foregroundColor(.white)
                        }
                        .onTapGesture {
                            viewModel.processPlayerMove(for: i)
                        }
                    }
                })
                Spacer()
            }.disabled(viewModel.isBoardBlocked)
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title, message: alertItem.message, dismissButton: .default(alertItem.buttonTitle, action: {
                    viewModel.resetGame()
                }))
            }
        }).padding()
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
