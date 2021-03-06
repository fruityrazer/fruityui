//
//  Wave.swift
//  FruityUI
//
//  Created by Eduardo Almeida on 08/05/2020.
//  Copyright © 2020 Eduardo Almeida. All rights reserved.
//

import FruityKit
import SwiftUI

enum WaveMode: String, CaseIterable {
    
    case left = "Left"
    case right = "Right"
    
    var direction: Direction {
        switch self {
        case .left:
            return .left
        case .right:
            return .right
        }
    }
}

struct Wave: View {
    
    @State var direction: WaveMode
    
    @Binding var mode: Synapse2Handle.Mode?
    
    init(mode: Binding<Synapse2Handle.Mode?>) {
        self._mode = mode
        
        if let unwrappedMode = mode.wrappedValue, case let Synapse2Handle.Mode.wave(direction) = unwrappedMode {
            self._direction = State(initialValue: direction == .right ? .right : .left)
        } else {
            self._direction = State(initialValue: .right)
        }
    }
    
    var body: some View {
        let waveModeBinding = Binding<WaveMode>(
            get: { self.direction },
            set: {
                self.direction = $0
                self.mode = .wave(direction: $0.direction)
            }
        )
        
        return GroupBox(label: Text("Direction")) {
            Picker(selection: waveModeBinding, label: EmptyView()) {
                ForEach(WaveMode.allCases, id: \.rawValue) {
                    Text($0.rawValue).tag($0)
                }
            }
        }
    }
}

struct Wave_Previews: PreviewProvider {
    
    static var previews: some View {
        Wave(mode: .constant(nil))
    }
}
