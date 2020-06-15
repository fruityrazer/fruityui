//
//  DeviceConfigurationViewV2.swift
//  FruityUI
//
//  Created by Eduardo Almeida on 08/05/2020.
//  Copyright © 2020 Eduardo Almeida. All rights reserved.
//

import SwiftUI
import FruityKit

struct DeviceConfigurationViewV2: View {
    
    enum Synapse2ModeBasic: String, CaseIterable {
        case breath = "Breath"
        case reactive = "Reactive"
        case spectrum = "Spectrum"
        case starlight = "Starlight"
        case `static` = "Static"
        case wave = "Wave"
    }
    
    @ObservedObject var presenter: DeviceConfigurationViewV2.Presenter
    
    var body: some View {
        let selectedModeBinding = Binding<Synapse2ModeBasic>(
            get: { self.presenter.selectedMode },
            set: {
                self.presenter.perform(.setMode($0))
            }
        )
        
        let showingErrorBinding = Binding<Bool>(
            get: { self.presenter.showingError },
            set: { _ in self.presenter.perform(.dismissError) }
        )
        
        return ScrollView {
            VStack {
                Text("Device selected: \(presenter.device.fullName)")
                    .padding()
                GroupBox(label: Text("Mode")) {
                    Picker(selection: selectedModeBinding, label: EmptyView()) {
                        ForEach(presenter.availableModes, id: \.rawValue) {
                            Text($0.rawValue).tag($0)
                        }
                    }
                }
                .padding()
                modeSettings
                    .padding()
                Button(action: { self.presenter.perform(.commit) }) {
                    Text("Save")
                }
            }
            .padding()
            .frame(minWidth: 700)
        }.alert(isPresented: showingErrorBinding) {
            Alert(title: Text("Error!"), message: Text(self.presenter.error!), dismissButton: .default(Text("Ok")))
        }
    }
    
    var modeSettings: AnyView? {
        switch presenter.selectedMode {
        case .breath:
            return AnyView(Breath(mode: $presenter.synapseMode))
        case .reactive:
            return AnyView(Reactive(mode: $presenter.synapseMode))
        case .spectrum:
            return AnyView(Spectrum(mode: $presenter.synapseMode))
        case .starlight:
            return AnyView(Starlight(mode: $presenter.synapseMode))
        case .static:
            return AnyView(Static(mode: $presenter.synapseMode))
        case .wave:
            return AnyView(Wave(mode: $presenter.synapseMode))
        }
    }
}

struct DeviceConfigurationViewV2_Previews: PreviewProvider {
    
    static var previews: some View {
        DeviceConfigurationViewV2(presenter: .init(device: StubDevice.exampleDevices[0],
                                                   engine: Engine()))
    }
}
