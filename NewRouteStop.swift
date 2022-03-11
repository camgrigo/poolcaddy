//
//  NewRouteStop.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 3/1/22.
//

import SwiftUI

struct NewStopRowIcon: View {
    let action: () -> Void
    
    var body: some View {
        Image(systemName: "plus")
            .foregroundColor(Color(.systemGray4))
            .padding(.trailing, 6)
            .onTapGesture(perform: action)
    }
}
