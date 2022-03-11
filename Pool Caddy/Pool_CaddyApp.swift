//
//  Pool_CaddyApp.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 12/21/21.
//

import SwiftUI
import CoreLocation

@main
struct Pool_CaddyApp: App {
    
    let persistenceController = PersistenceController.shared
    let locationManagerDelegate = LocationManagerDelegate()
    
    enum Tab: Hashable {
        case clients, dashboard, logs
    }
    
    @State private var selectedTab = Tab.dashboard
    
    
    
    
    @FetchRequest(entity: Route.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: false)])
    private var routes: FetchedResults<Route>
    
    @State private var route: Route?
    @State private var isShowingRoutePicker = false
    
    var body: some Scene {
        WindowGroup {
            DashboardView(route: route  ?? PersistenceController.shared.createRoute(date: Date())!)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .sheet(isPresented: $isShowingRoutePicker) {
                    List(routes) { route in
                        Text(route.date?.formatted(date: .complete, time: .omitted) ?? "Route")
                            .onTapGesture {
                                self.route = route
                            }
                    }
                }
                .onAppear {
                    route = (routes.first {
                        guard let date = $0.date else { return false }
                        return Calendar.current.isDate(date, inSameDayAs: Date())
                    })
                }
        }
    }
    
    //    private func startRequestingLocation() {
    //        let locationManager = CLLocationManager()
    //        locationManager.requestAlwaysAuthorization()
    //        locationManager.startMonitoringVisits()
    //        locationManager.delegate = locationManagerDelegate
    //    }
    
    //    private func lockPastRoutes() {
    //        let fetchRequest = Route.fetchRequest()
    //        _ = try? persistenceController.container.viewContext.fetch(fetchRequest)
    //            .filter {
    //                guard let date = $0.date else { return false }
    //                return Calendar.current.compare(Date(), to: date, toGranularity: .day) != .orderedSame
    //            }
    //            .forEach {
    //                $0.isLockedBinding.wrappedValue = true
    //            }
    //    }
    //
    //    private func checkStoreForErrors() {
    //        let fetchRequest = Route.fetchRequest()
    //        guard let results = try? persistenceController.container.viewContext.fetch(fetchRequest) else { return }
    //
    //        //        let duplicates = results.map { $0.date }
    //#warning("Finish")
    //    }
    
}

actor LocationManagerDelegate: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var userLocation: CLLocation?
    
    private func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) async {
        userLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
    }
    
}
