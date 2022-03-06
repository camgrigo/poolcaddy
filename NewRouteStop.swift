//
//  NewRouteStop.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 3/1/22.
//

import SwiftUI

struct NewStopRow: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var route: Route
    @State private var name = String()
    @FocusState var isFocused: Bool
    
    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)])
    private var clients: FetchedResults<Client>
    private var searchClients: [Client] {
        clients.filter { $0.name?.contains(name) ?? false }
    }
    private let title = "New Stop"
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "circle")
                    .foregroundColor(Color(.systemGray4))
                    .padding(.trailing, 6)
                TextField(title, text: $name) {
                    nameFieldOnCommit()
                    isFocused = true
                }
                .focused($isFocused)
                .frame(minHeight: 44)
            }
                
                if isFocused && !searchClients.isEmpty {
                    ClientsPicker(clients: searchClients, onSelect: addRouteStop(client:))
                        .padding(.top, 8)
                }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isFocused {
                    Button("Done") {
                        nameFieldOnCommit()
                        isFocused = false
                    }
                }
            }
        }
    }
    
    func nameFieldOnCommit() {
        guard !name.isEmpty else { return }
        
        if let client = clients.first(where: { $0.name == name }) {
            addRouteStop(client: client)
            
        } else {
            let client = Client(context: viewContext)
            client.name = name
            
            addRouteStop(client: client)
        }
    }
    
    func addRouteStop(client: Client) {
        let routeStop = RouteStop(context: viewContext)
        routeStop.id = UUID()
        routeStop.client = client
        route.add(routeStop)
        
        do {
            try viewContext.save()
            name = String()
        } catch {
            print("Error")
        }
    }
    
}
