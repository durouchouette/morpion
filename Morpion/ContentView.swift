//
//  ContentView.swift
//  Morpion
//
//  Created by Elodie Cari on 2/16/23.
//

import SwiftUI

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @State private var plays: [Play?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn = true
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                LazyVGrid(columns: columns) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Rectangle()
                                .foregroundColor(.blue).opacity(0.6)
                                .frame(width: geometry.size.width/3 - 15, height:geometry.size.width/3 - 15)
                            
                            Image(systemName: plays[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                        }
                        .onTapGesture {
                            plays[i] = Play(player: isHumanTurn ? .human : .computer, boardIndex: i)
                            isHumanTurn.toggle()
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }

    }
}

enum Player {
    case human, computer
}

struct Play {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
