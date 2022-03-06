////
////  NewClientView.swift
////  Pool Caddy
////
////  Created by Cameron Grigoriadis on 1/5/22.
////
//
//import CoreData
//import SwiftUI
//import CoreLocation
//import MapKit
//
//struct NewClientView: View {
//    
//    @Environment(\.managedObjectContext) private var viewContext
//    @EnvironmentObject var locationManagerDelegate: LocationManagerDelegate
//
//    @Binding var isShowingNew: Bool
//    
//    @State private var name = String()
//    @State private var address = String()
//
//    var body: some View {
//        NavigationView {
//            Form {
//                TextField("Name", text: $name)
//                TextField("Address", text: $address)
//                    .onSubmit {
//                        if !name.isEmpty && !address.isEmpty {
//                            save()
//                        }
//                    }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Cancel") {
//                        isShowingNew = false
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done", action: save)
//                    .disabled(name.isEmpty)
//                }
//            }
//            .navigationTitle("New Client")
//        }
//    }
//    
//    private func save() {
//        isShowingNew = false
//        
//        let newItem = Client(context: viewContext)
//        
//        newItem.name = name
//        newItem.latitude = 0
//        newItem.longitude = 0
//        
//        PersistenceController.shared.saveContext()
//    }
//    
//}
