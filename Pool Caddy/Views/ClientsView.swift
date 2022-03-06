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
    
    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)])
    private var clients: FetchedResults<Client>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(clients) {
                    Text($0.name!)
                }
                .onDelete(perform: delete)
                
                footerText
            }
            .navigationTitle("Clients")
            .toolbar { DoneToolbar(isShowing: $isShowing, title: "Done") }
        }
    }
    
    private var footerText: some View {
        Group {
            if clients.isEmpty {
                Text("No clients").foregroundColor(.secondary)
            } else {
                Text("\(clients.count)").foregroundColor(.secondary)
            }
        }
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

struct DoneToolbar: ToolbarContent {
    
    @Binding var isShowing: Bool
    
    let title: String
    
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Spacer()
            Button { isShowing = false } label: {
                Text(title).bold()
            }
            Spacer()
        }
    }
    
}

//struct ClientsList: View {
//
//    @Environment(\.presentationMode) var presentationMode
//
//    @Environment(\.managedObjectContext) private var viewContext
//    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)], predicate: nil, animation: .default)
//    private var clients: FetchedResults<Client>
//
//    let isEditable: Bool
//    let onSelect: ((Client) -> Void)?
//
//    init(isEditable: Bool = false, onSelect: ((Client) -> Void)? = nil) {
//        self.onSelect = onSelect
//        self.isEditable = isEditable
//    }
//
//    @State private var isShowingNew = false
//    @State private var isShowingDeleteAlert = false
//
//    @State private var deleteOffsets = IndexSet()
//
//    var body: some View {
//        NavigationView {
//            List {
//                if isEditable {
//                    ForEach(clients) { Row(client: $0, onSelect: onSelect) }
//                        .onDelete(perform: isEditable ? requestDelete(at:) : { _ in })
//
//                } else {
//                    ForEach(clients) { Row(client: $0, onSelect: onSelect) }
//                }
//
//                NewItemButton(isShowingNew: $isShowingNew, title: "New Client")
//            }
//            .sheet(isPresented: $isShowingNew) {
//                NewClientView(isShowingNew: $isShowingNew)
//            }
//            .alert("Confirm Delete", isPresented: $isShowingDeleteAlert) {
//                Button("Cancel", role: .cancel) {}
//                Button("Delete", role: .destructive) {
//                    removeClients(at: deleteOffsets)
//                }
//            }
//            .navigationTitle("Clients")
//            .toolbar {
//                    Button(role: .cancel) {
//                        presentationMode.wrappedValue.dismiss()
//                    } label: {
//                        Text("Cancel")
//                    }
//            }
//        }
//    }
//
//    struct Row: View {
//        let client: Client
//        let onSelect: ((Client) -> Void)?
//        var body: some View {
//            if let onSelect = onSelect {
//                Button { onSelect(client) } label: {
//                    Label(client.name ?? "", systemImage: "person")
//                }
//                .buttonStyle(.plain)
//            } else {
//                Label(client.name ?? "", systemImage: "person")
//            }
//        }
//    }
//
//    private func requestDelete(at offsets: IndexSet) {
//        deleteOffsets = offsets
//        isShowingDeleteAlert = true
//    }
//
//    private func removeClients(at offsets: IndexSet) {
//        offsets.forEach {
//            viewContext.delete(clients[$0])
//        }
//
//        do {
//            try viewContext.save()
//            deleteOffsets = []
//        } catch {
//            // Replace this implementation with code to handle the error appropriately.
//            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
//
//}
//
//struct NewItemButton: View {
//
//    @Binding var isShowingNew: Bool
//
//    let title: String
//
//    var body: some View {
//        Button {
//            isShowingNew = true
//        } label: {
//            Label(title, systemImage: "plus")
//        }
//    }
//
//}
