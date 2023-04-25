//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Сергей Крайнов on 24.04.2023.
//

import Foundation

struct WeatherData: Codable {
    let info: Info
    let fact: Fact
    let forecast: Forecast
}

// MARK: - Info
struct Info: Codable {
    let url: String
}

// MARK: - Fact
struct Fact: Codable {
    let temp: Int
    let icon, condition: String
    let windSpeed: Double
    let pressureMm: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case icon, condition
        case windSpeed = "wind_speed"
        case pressureMm = "pressure_mm"
    }
}

// MARK: - Forecast
struct Forecast: Codable {
    let parts: [Part]
}

// MARK: - Part
struct Part: Codable {
    let partName: String
    let tempMin, tempAvg, tempMax: Int?
    
    enum CodingKeys: String, CodingKey {
        case partName = "part_name"
        case tempMin = "temp_min"
        case tempAvg = "temp_avg"
        case tempMax = "temp_max"
    }
}
