//
//  RouteList.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 3/3/22.
//

import SwiftUI

struct RouteList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Route.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: false)])
    private var routes: FetchedResults<Route>
    
    var body: some View {
        List {
            ForEach(routes) { route in
                RouteListSection(route: route)
            }
        }
        .listStyle(.plain)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                EditButton()
            }
        }
    }
    
}

struct RouteListSection: View {
    
    @ObservedObject var route: Route
    
    private var title: String {
        route.date?
            .formatted(date: .complete, time: .omitted) ?? String()
    }
    
    var body: some View {
        Section(title) {
            ForEach(route.stopsList) { stop in
                StopRow(route: route, stop: stop)
            }
            .onMove(perform: route.move(_:_:))
            .onDelete(perform: route.delete(_:))
            NewStopRow(route: route)
        }
    }
    
}
