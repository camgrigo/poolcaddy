////
////  RouteView.swift
////  Pool Caddy
////
////  Created by Cameron Grigoriadis on 1/10/22.
////
//
//import SwiftUI
//
//struct RouteView: View {
//    
//    @Environment(\.managedObjectContext) private var viewContext
//    
//    @ObservedObject var route: Route
//    
//    @State private var isAddingRoute = false
//    
//    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)], predicate: nil, animation: .default)
//    private var clients: FetchedResults<Client>
//    
//    @State private var isShowingNew = false
//    
//    var body: some View {
//        VStack {
//            List {
//                if route.isLocked {
//                    ForEach(route.stopsList, content: row)
//                } else {
//                    ForEach(route.stopsList, content: row)
//                        .onDelete(perform: removeStops(at:))
//                        .onMove(perform: move(from:to:))
//                }
//                if !route.isLocked && route.stopsList.count < 100 {
//                    if isAddingRoute {
//                        LazyVGrid(columns: [GridItem()]) {
//                            ForEach(clients) { client in
//                                Text(client.name ?? "")
//                                    .padding(4)
//                                    .padding(.horizontal, 8)
//                                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color(.secondarySystemBackground)))
//                            }
//                            Button {
//                                isShowingNew = true
//                            } label: {
//                                Label("New", systemImage: "plus")
//                                    .padding(4)
//                                    .padding(.horizontal, 8)
//                                    .background(RoundedRectangle(cornerRadius: 8, style: .continuous).fill(Color(.secondarySystemBackground)))
//                            }
//                            .buttonStyle(.borderless)
//                            .sheet(isPresented: $isShowingNew) {
//                                NewClientView(isShowingNew: $isShowingNew)
//                            }
//                        }
//                    } else {
//                        Button { isAddingRoute = true } label: {
//                            HStack {
//                                HStack(spacing: 0) {
//                                    Image(systemName: "mappin.and.ellipse")
//                                }
//                                Text("Add to Route")
//                            }
//                            .foregroundColor(.accentColor)
//                        }
//                    }
//                }
//            }
//            .listStyle(.plain)
//        }
//    }
//    
//    private func row(_ stop: RouteStop) -> some View {
//        NavigationLink(destination: RouteStopView(stop: stop, isLocked: route.isLocked)) {
//            RouteStopSummary(stop: stop, isLocked: route.isLocked)
//        }
//    }
//    
//    private func move(from source: IndexSet, to destination: Int) {
//        var copy = route.stopsList//.map { $0.objectID }
//        copy.move(fromOffsets: source, toOffset: destination)
//        
//        route.stops = NSSet(array: copy)
//        
//        #warning("Update linked list")
////
////        let destinationLastStop: RouteStop?
////
////        if destination > route.stopsList.startIndex {
////            destinationLastStop = route.stopsList[destination]
////        } else {
////            destinationLastStop = nil
////        }
////
////        var lastStop: RouteStop? = destinationLastStop
////
////        source
////            .map { route.stopsList[$0] }
////            .forEach { stop in
////                stop.lastStopID = lastStop?.objectID.uriRepresentation()
////                lastStop?.nextStopID = stop.objectID.uriRepresentation()
////                lastStop = stop
////            }
////
//        PersistenceController.shared.saveContext()
//    }
//    
//    private func removeStops(at offsets: IndexSet) {
//        offsets.forEach {
//            viewContext.delete(route.stopsList[$0])
//        }
//        
//        PersistenceController.shared.saveContext()
//    }
//    
//}
