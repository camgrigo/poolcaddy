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
        .tint(isOn ? .accentColor : Color(.systemGray4))
        .buttonStyle(.borderless)
    }
}

struct StopRow: View {
    
    @ObservedObject var route: Route
    @ObservedObject var stop: RouteStop
    @FocusState var isFocused: Bool
    @State private var isShowingDetail = false
    
    var body: some View {
        HStack {
            CheckToggle(isOn: stop.isComplete, action: toggleIsComplete)
                .padding(.trailing, 6)
                .disabled(route.isLocked)
            VStack {
                TextField("Add Stop", text: Binding { stop.client?.name ?? "" } set: {
                    guard !$0.isEmpty else {
                        route.delete(stop)
                        return
                    }
                    stop.client!.name = $0
                })
                    .focused($isFocused)
            }
            
            if isFocused {
                detailButton
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isFocused {
                    Button("Done") { isFocused = false }
                }
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
            
        }
    }
    
    func toggleIsComplete() {
        stop.isComplete.toggle()
        PersistenceController.shared.saveContext()
        
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }
    
}

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

struct DashboardView: View {
    
    @State private var isShowingClients = false
    
    private var clientsLabel: some View {
        Label("Clients", systemImage: "person.2")
            .symbolVariant(.fill)
            .symbolRenderingMode(.hierarchical)
    }
    
    var body: some View {
        NavigationView {
            RouteList()
                .navigationTitle("Route")
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button { isShowingClients = true } label: { clientsLabel }
                        .sheet(isPresented: $isShowingClients) {
                            ClientsView(isShowing: $isShowingClients)
                        }
                    }
                }
        }
    }
    
}
