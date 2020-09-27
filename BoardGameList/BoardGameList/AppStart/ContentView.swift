//
//  ContentView.swift
//  BoardGameList
//
//  Created by Phetsana PHOMMARINH on 24/09/2020.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GamesListView()
            .environmentObject(GamesListViewModel())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
