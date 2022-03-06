//
//  Model.Extensions.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 1/11/22.
//

import CoreData
import SwiftUI
import CoreLocation

extension Client {
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
    }
    
}

extension Route {
    
    var isLockedBinding: Binding<Bool> {
        Binding {
            self.isLocked
        } set: {
            self.isLocked = $0
            
            PersistenceController.shared.saveContext()
        }
    }
    
    func toggleIsLocked() {
        isLockedBinding.wrappedValue.toggle()
    }
    
}

extension Route {
    
    private struct StopsData: Codable {
        let list: [UUID]
    }
    
    var stopsList: [RouteStop] {
        try! JSONDecoder()
            .decode(StopsData.self, from: stopsOrder!)
            .list
            .map { id in
                (stops! as! Set<RouteStop>)
                    .first { $0.id == id }!
            }
    }
    
    func setStopsOrder(_ newValue: [RouteStop]) {
        stopsOrder = try! JSONEncoder().encode(StopsData(list: (newValue).map { $0.id! }))
    }
    
    func stop(_ id: UUID) -> RouteStop? {
        (stops as? Set<RouteStop>)?
            .first { $0.id == id }
    }
    
    func add(_ stop: RouteStop) {
        addToStops(stop)
        setStopsOrder(stopsList + [stop])
    }
    
    func move(_ source: IndexSet, _ destination: Int) {
        var copy = stopsList
        copy.move(fromOffsets: source, toOffset: destination)
        setStopsOrder(copy)
    }
    
    func delete(_ offset: IndexSet) {
        offset.forEach { managedObjectContext?.delete(stopsList[$0]) }
        var copy = stopsList
        copy.remove(atOffsets: offset)
        setStopsOrder(copy)
    }
    
    func delete(_ stop: RouteStop) {
        var copy = stopsList
        copy.remove(at: copy.firstIndex(of: stop)!)
        setStopsOrder(copy)
        managedObjectContext?.delete(stop)
    }
    
}


extension RouteStop {
    
    var clientBinding: Binding<Client?> {
        Binding {
            self.client
        } set: {
            self.client = $0
            
            PersistenceController.shared.saveContext()
        }
    }
    
    var isCompleteBinding: Binding<Bool> {
        Binding {
            self.isComplete
        } set: {
            self.isComplete = $0
            
            PersistenceController.shared.saveContext()
        }
    }
    
    func toggleIsComplete() {
        isCompleteBinding.wrappedValue.toggle()
    }
    
}
