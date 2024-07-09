//
//  TicTacToeGameView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import SwiftUI

struct Tile: View {
    @Binding var marker: Character?
    @ObservedObject var viewModel: TicTacToeViewModel
    var row: Int
    var col: Int

    var body: some View {
        Button(action: {
            if marker == nil && viewModel.player == "X" {
                viewModel.handlePlayerMove(row: row, col: col)
            }
        }) {
            Text(String(marker ?? " "))
                .font(.system(size: 75))
                .fontWeight(.bold)
                .frame(width: 100, height: 100)
                .background(Color.gray.opacity(0.3))
                .foregroundColor(.black)
        }
    }
}

struct Row: View {
    @Binding var row: [Character?]
    @ObservedObject var viewModel: TicTacToeViewModel
    var rowIndex: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { colIndex in
                Tile(marker: $row[colIndex], viewModel: viewModel, row: rowIndex, col: colIndex)
            }
        }
    }
}

import SwiftUI

struct TicTacToeGameView: View {
    @ObservedObject var viewModel: TicTacToeViewModel

    var body: some View {
        VStack(spacing: 80) {
            VStack(spacing: 20) {
                Text("TicTacToe")
                    .font(.system(size: 60))
                    .fontWeight(.bold)

                Text("\(viewModel.username ?? "Player")'s turn")
                    .font(.system(size: 30))
            }

            VStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { rowIndex in
                    Row(row: self.$viewModel.board[rowIndex], viewModel: viewModel, rowIndex: rowIndex)
                }
            }
            .background(Color.gray.opacity(0.3))
            .aspectRatio(1.0, contentMode: .fill)
        }
        .alert(isPresented: $viewModel.isGameOver) {
            Alert(
                title: Text("Game Over"),
                message: {
                    if viewModel.winner == nil {
                        return Text("It's a draw. Try again or cancel.")
                    } else if viewModel.winner == "O" {
                        return Text("\(viewModel.username ?? "Player") didn't win. Try again or cancel.")
                    } else {
                        return Text("\(String(viewModel.winner!)) won")
                    }
                }(),
                primaryButton: .default(Text("Try Again"), action: viewModel.resetGame),
                secondaryButton: .cancel(Text("Cancel"), action: viewModel.onGameEnded)
            )
        }
        .alert(isPresented: $viewModel.showPromo) {
            Alert(
                title: Text("Congratulations!"),
                message: Text("You've won! Use promo code GET10."),
                primaryButton: .default(Text("Copy Code"), action: {
                    UIPasteboard.general.string = "GET10"
                    viewModel.onPromoDismissed?()
                }),
                secondaryButton: .default(Text("OK"), action: viewModel.onPromoDismissed)
            )
        }
    }
}
