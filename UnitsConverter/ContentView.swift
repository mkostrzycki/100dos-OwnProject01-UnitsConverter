//
//  ContentView.swift
//  UnitsConverter
//
//  Created by MaćKo on 25/03/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var temperature = 0.0
    @State private var tempFromUnit = "°C"
    @State private var tempToUnit = "°F"

    @FocusState private var temperatureIsFocused: Bool

    let unitCelsius = "°C"
    let unitFahrenheit = "°F"
    let unitKelvin = "K"

    // convert input temperature to Celsius
    func normalizeInputTemp() -> Double {
        switch tempFromUnit {
        case unitFahrenheit:
            return (temperature - 32) * 5/9
        case unitKelvin:
            return temperature - 273.15
        default:
            return temperature
        }
    }

    var convertedTemp: Double {
        let normalizedInputTemp = normalizeInputTemp()
        switch true {
        case tempFromUnit == tempToUnit:
            return temperature
        case tempToUnit == unitFahrenheit:
            return 9/5 * normalizedInputTemp + 32
        case tempToUnit == unitKelvin:
            return normalizedInputTemp + 273.15
        default:
            return 0.0
        }
    }

    var displayEasterEgg: Bool {
        return tempFromUnit == unitFahrenheit && temperature == 451
    }

    var body: some View {
        NavigationStack {
            Form {
                let temperatureUnits = [unitCelsius, unitFahrenheit, unitKelvin]

                Section("Temperature") {
                    TextField("Temperature", value: $temperature, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($temperatureIsFocused)
                }

                Section("Convert from") {
                    Picker("Source temperature unit", selection: $tempFromUnit) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("Convert to") {
                    Picker("Target temperature unit", selection: $tempToUnit) {
                        ForEach(temperatureUnits, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }

                Section("\(temperature.formatted()) \(tempFromUnit) in \(tempToUnit)") {
                    // round to two decimal places
                    Text("\(((convertedTemp * 100).rounded() / 100).formatted())")
                }

                if displayEasterEgg {
                    Section("Fahrenheit 451") {
                        Text("There must be something in books, things we can’t imagine, to make a woman stay in a burning house; there must be something there. You don’t stay for nothing.")
                    }
                }
            }
            .toolbar {
                if temperatureIsFocused {
                    Button("Done") {
                        temperatureIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
