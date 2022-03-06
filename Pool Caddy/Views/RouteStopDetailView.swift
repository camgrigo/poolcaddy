//
//  RouteStopDetailView.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 1/13/22.
//

import SwiftUI

struct RouteStopDetailView: View {
    
    @ObservedObject var stop: RouteStop
    
    private var title: String { stop.client!.name! }
    private var detail: String { stop.route!.date?.formatted(date: .complete, time: .omitted) ?? "" }
    
    var body: some View {
        Text(title).font(.largeTitle)
        Text(detail).font(.headline)
    }
    
}

//struct RouteStopView: View {
//    
//    @ObservedObject var stop: RouteStop
//    
//    let isLocked: Bool
//    
//    var body: some View {
//        List {
//            Section {
//                RouteStopSummary(stop: stop, isLocked: isLocked)
//                Label("1 gal chlorine", systemImage: "placeholdertext")
//                    .foregroundColor(.teal)
//            }
//            
//            Section("Details") {
//                TextField("Notes", text: .constant("Test notes"))
//            }
//        }
//    }
//    
//}
//
//struct ClientsSearchView: View {
//    
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)], predicate: nil, animation: .default)
//    private var clients: FetchedResults<Client>
//    
//    let onCommit: (Client) -> Void
//    
//    var body: some View {
//        List {
//            ForEach(clients) { client in
//                Text(client.name ?? "Client")
//                    .contentShape(Rectangle())
//                    .onTapGesture {
//                        onCommit(client)
//                    }
//            }
//        }
//    }
//    
//}
//
