//
//  RouteList.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 3/3/22.
//

import SwiftUI

extension Route {
    
    var _date: Binding<Date> {
        Binding {
            self.date ?? Date()
        } set: {
            self.date = $0
            PersistenceController.shared.saveContext()
        }
    }
    
}

struct RouteDetailsView: View {
    
    @ObservedObject var route: Route
    
    var body: some View {
        DatePicker(.datePickerLabel, selection: route._date, displayedComponents: .date)
        Toggle(isOn: route.isLockedBinding) {
            Label(.viewOnlyLabel, systemImage: "eye")
        }
        Button(role: .destructive) {
            
        } label: {
            Label(.deleteLabel, systemImage: "trash")
        }
    }
    
}

struct RouteStopsList: View {
    
    enum Field: Hashable {
        case none
        case new
        case row(id: UUID)
    }
    
    @ObservedObject var route: Route
    
    @FocusState var focusedField: Field?
    
    var body: some View {
        ForEach(route.stopsList) { stop in
            StopRow(route: route, stop: stop)
                .focused($focusedField, equals: .row(id: stop.id!))
        }
        .onMove(perform: route.move(_:_:))
        .onDelete(perform: route.delete(_:))
    }
    
}
