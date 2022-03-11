//
//  ClientsView.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 12/27/21.
//

import SwiftUI

struct ClientsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isShowing: Bool
    
    @State private var isShowingDeleteAlert = false
    @State private var deleteOffsets = IndexSet()
    
    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)])
    private var clients: FetchedResults<Client>
    
    private var footer: some View {
        Group {
            clients.isEmpty ? Text(.clientsListDefault) : Text("\(clients.count)")
        }
        .foregroundColor(.secondary)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(footer: footer) {
                    ForEach(clients) { Text($0.name!) }
                        .onDelete(perform: requestDelete(at:))
                }
            }
            .navigationTitle(.clientsTitle)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Spacer()
                    Button { isShowing = false } label: {
                        Text(.doneTitle).bold()
                    }
                    Spacer()
                }
            }
        }
        .alert(.confirmDelete, isPresented: $isShowingDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                delete(deleteOffsets)
                deleteOffsets = []
            }
        }
    }
    
    private func requestDelete(at offsets: IndexSet) {
        deleteOffsets = offsets
        isShowingDeleteAlert = true
    }
    
    func delete(_ offsets: IndexSet) {
        offsets.forEach { index in
            let item = clients[index]
            (item.stops as! Set<RouteStop>).forEach { $0.route!.delete($0) }
            viewContext.delete(item)
        }
        
        PersistenceController.shared.saveContext()
    }
    
}

//                        .onDelete(perform: isEditable ? requestDelete(at:) : { _ in })

//            .toolbar {
//                    Button(role: .cancel) {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Text("Cancel")
//                    }
//            }
//        }
//    }
