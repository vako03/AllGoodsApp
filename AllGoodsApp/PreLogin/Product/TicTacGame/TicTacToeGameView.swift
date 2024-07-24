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
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)
                .foregroundColor(.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
        }
    }
}

// MARK: - Row
struct Row: View {
    @Binding var row: [Character?]
    @ObservedObject var viewModel: TicTacToeViewModel
    var rowIndex: Int

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<3, id: \.self) { colIndex in
                Tile(marker: $row[colIndex], viewModel: viewModel, row: rowIndex, col: colIndex)
            }
        }
    }
}

// MARK: - TicTacToeGameView
struct TicTacToeGameView: View {
    @ObservedObject var viewModel: TicTacToeViewModel

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 10) {
                Text("TicTacToe")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()

                Text("Play and get promocode -10% up to $300")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity)
            }
            .padding(.top, 40)
            
            VStack(spacing: 10) {
                ForEach(0..<3, id: \.self) { rowIndex in
                    Row(row: self.$viewModel.board[rowIndex], viewModel: viewModel, rowIndex: rowIndex)
                }
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .padding()
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(
                title: Text(alertItem.title),
                message: Text(alertItem.message),
                primaryButton: alertItem.primaryButton,
                secondaryButton: alertItem.secondaryButton
            )
        }
    }
}
