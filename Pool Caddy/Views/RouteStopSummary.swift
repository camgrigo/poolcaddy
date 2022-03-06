////
////  RouteStopSummary.swift
////  Pool Caddy
////
////  Created by Cameron Grigoriadis on 1/19/22.
////
//
//import SwiftUI
//
//struct RouteStopSummary: View {
//    
//    @ObservedObject var stop: RouteStop
//    
//    let isLocked: Bool
//    
//    @FocusState private var isSearching: Bool
//    @State private var searchText = String()
//    
//    var body: some View {
//        HStack {
//            Button {
//                stop.toggleIsComplete()
//                
//                let generator = UINotificationFeedbackGenerator()
//                generator.notificationOccurred(.success)
//            } label: {
//                Image(systemName: stop.isComplete ? "checkmark.circle.fill" : "circle")
//            }
//            .tint(stop.isComplete ? .accentColor : .primary)
//            .buttonStyle(.borderless)
//            .disabled(isLocked)
//            if isSearching {
//                VStack {
//                    TextField("", text: $searchText)
//                        .focused($isSearching)
//                    ClientsSearchView { client in
//                        stop.client = client
//                        PersistenceController.shared.saveContext()
//                        isSearching = false
//                    }
//                }
//            } else {
//                Button {
//                    isSearching = true
//                } label: {
//                    Text(stop.client?.name ?? "")
//                }
//            }
//        }
//    }
//    
//}
