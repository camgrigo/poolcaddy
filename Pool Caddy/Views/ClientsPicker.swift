//
//  ClientsPicker.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 1/13/22.
//

import SwiftUI

struct ClientsPicker: View {
    
    let clients: [Client]
    let onSelect: (Client) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 1) {
                ForEach(clients) { client in
                    Button { onSelect(client) } label: {
                        Text(client.name!)
                            .font(.subheadline)
                            .padding(0)
                            .padding(.horizontal, 10)
                    }
                    .frame(minWidth: 200, minHeight: 44)
                    .buttonStyle(.bordered)
                }
            }
        }
    }
    
}
