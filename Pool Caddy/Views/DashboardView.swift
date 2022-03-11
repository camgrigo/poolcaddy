//
//  DashboardView.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 12/21/21.
//

import SwiftUI
import MapKit
import CoreData

struct CheckToggle: View {
    let isOn: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
        }
        .symbolRenderingMode(.multicolor)
        .foregroundStyle(isOn ? .accentColor : Color(.systemGray4))
        .buttonStyle(.borderless)
    }
}

struct StopRow: View {
    
    @ObservedObject var route: Route
    @ObservedObject var stop: RouteStop
    
    @FocusState var isFocused: Bool
    @State private var isShowingDetail = false
    
    @ScaledMetric private var checkButtonTrailingMargin: CGFloat = 6
    
    var body: some View {
        HStack {
            CheckToggle(isOn: stop.isComplete, action: toggleIsComplete)
                .padding(.trailing, checkButtonTrailingMargin)
                .disabled(route.isLocked)
            VStack {
                TextField(String(), text: Binding { stop.client?.name ?? "" } set: {
                    guard !$0.isEmpty else {
                        route.delete(stop)
                        return
                    }
                    stop.client!.name = $0
                })
                .focused($isFocused)
                //                    .accessibilityLabel(<#T##label: Text##Text#>)
            }
            
            if isFocused {
                detailButton
            }
        }
    }
    
    private var detailButton: some View {
        Button {
            isShowingDetail = true
        } label: {
            Image(systemName: "info")
                .symbolVariant(.circle)
                .symbolVariant(.fill)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(Color.accentColor)
        }
        .sheet(isPresented: $isShowingDetail) {
            RouteStopDetailView(stop: stop)
        }
    }
    
    func toggleIsComplete() {
        stop.isComplete.toggle()
        PersistenceController.shared.saveContext()
        
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }
    
}

/*
 struct StopDetailSummary: View {
 
 var body: some View {
 HStack(spacing: 20) {
 HStack {
 Image(systemName: "takeoutbag.and.cup.and.straw")
 .foregroundColor(Color(hue: 186 / 360, saturation: 100 / 100, brightness: 100 / 100))
 Text("2")
 .font(.system(.subheadline, design: .rounded).weight(.heavy))
 .foregroundColor(.secondary)
 }
 HStack {
 Image(systemName: "exclamationmark.circle")
 .symbolRenderingMode(.palette)
 .foregroundStyle(.primary, .yellow)
 Text("1")
 .font(.system(.subheadline, design: .rounded).weight(.heavy))
 .foregroundColor(.secondary)
 }
 }
 .symbolVariant(.fill)
 }
 
 }
 */

struct DashboardView: View {
    @ObservedObject var route: Route
    @State private var isShowingRoutePicker = false
    
    @FocusState var focusedField: RouteStopsList.Field?
    @State private var isShowingClients = false
    @State private var isShowingRouteDetails = false
    
    @State private var name = String()
    @FetchRequest(entity: Client.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)])
    private var clients: FetchedResults<Client>
    private var searchClients: [Client] {
        clients.filter { $0.name?.contains(name) ?? false }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                List {
                    RouteStopsList(route: route, focusedField: _focusedField)
                }
                .toolbar {
                    NavigationToolbar(route: route, isShowingRoutePicker: $isShowingRoutePicker, isShowingRouteDetails: $isShowingRouteDetails)
                    Toolbar(route: route, isShowingClients: $isShowingClients, isShowingRouteDetails: $isShowingRouteDetails, focusedField: _focusedField)
                }
                
                VStack {
                    HStack {
                        NewStopRowIcon { focusedField = .new }
                        TextField(.newStopFieldTitle, text: $name) {
                            nameFieldOnCommit()
                            focusedField = .new
                        }
                        .focused($focusedField, equals: .new)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom, 2)
                        ClientsPicker(clients: searchClients) { client in
                            Task {
                                await PersistenceController.shared.addRouteStop(client: client, route: route)
                                name = String()
                            }
                        }
                        .frame(minHeight: 44)
                }
                .background(Color(.systemBackground))
                .ignoresSafeArea(.keyboard)
            }
        }
    }
    
    func nameFieldOnCommit() {
        guard !name.isEmpty else { return }
        
        Task {
            await PersistenceController.shared.addRouteStop(client: {
                if let client = clients.first(where: { $0.name == name }) {
                    return client
                } else {
                    let client = Client(context: PersistenceController.shared.container.viewContext)
                    client.name = name
                    
                    return client
                }
            }(), route: route)
        }
    }
    
    struct NavigationToolbar: ToolbarContent {
        @ObservedObject var route: Route
        @Binding var isShowingRoutePicker: Bool
        @Binding var isShowingRouteDetails: Bool
        
        private var navigationTitle: String {
            route.date?
                .formatted(date: .long, time: .omitted) ?? ""
        }
        
        var body: some ToolbarContent {
            ToolbarItem(placement: .navigation) {
                EditButton()
                Button {
                    isShowingRoutePicker.toggle()
                } label: {
                    Label(navigationTitle, systemImage: "calendar")
                        .labelStyle(.titleAndIcon)
                }
                Button {
                } label: {
                    Image(systemName: "info")
                        .symbolVariant(.circle.fill)
                        .symbolRenderingMode(.hierarchical)
                }
                .sheet(isPresented: $isShowingRouteDetails) {
                    RouteDetailsView(route: route)
                }
            }
        }
    }
    
    struct Toolbar: ToolbarContent {
        @ObservedObject var route: Route
        @Binding var isShowingClients: Bool
        @Binding var isShowingRouteDetails: Bool
        @FocusState var focusedField: RouteStopsList.Field?
        
        private var clientsLabel: some View {
            Label(.clientsLabel, systemImage: "person.2")
                .symbolVariant(.fill)
                .symbolRenderingMode(.hierarchical)
        }
        
        var body: some ToolbarContent {
            ToolbarItem {
                Button {
                } label: {
                    Image(systemName: "info")
                        .symbolVariant(.circle.fill)
                        .symbolRenderingMode(.hierarchical)
                }
                .sheet(isPresented: $isShowingRouteDetails) {
                    RouteDetailsView(route: route)
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button { isShowingClients = true } label: { clientsLabel }
                    .sheet(isPresented: $isShowingClients) {
                        ClientsView(isShowing: $isShowingClients)
                    }
            }
            ToolbarItemGroup(placement: .keyboard) {
                Button {
                    focusedField = nil
                } label: {
                    Image(systemName: "keyboard.chevron.compact.down")
                }
            }
        }
    }
    
}
