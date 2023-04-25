//
//  Presenter.swift
//  WeatherApp
//
//  Created by Сергей Крайнов on 24.04.2023.
//

import UIKit
import MapKit

enum Constants: String {
    case apiKey = "b52e2b9a-375d-472b-94a2-f738f7172345"
    case header = "X-Yandex-API-Key"
    case httpMehod = "GET"
}

protocol WeatherPesenterDelegate: AnyObject {
    func presentWeather(weather: Weather)
    func presentCityName(cityName: String, countreName: String)
}

typealias PresenterDelegate = WeatherPesenterDelegate & UIViewController

final class WeatherPesenter: NSObject {
    
    weak var delegate: PresenterDelegate?
    
    public func setUpDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    public func fetchWeather(logitude: Double, latitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: logitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            self.delegate?.presentCityName(cityName: city, countreName: country)
        }
        
        let urlString = "https://api.weather.yandex.ru/v2/informers?lat=\(latitude)&lon=\(logitude)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue(Constants.apiKey.rawValue, forHTTPHeaderField: Constants.header.rawValue)
        request.httpMethod = Constants.httpMehod.rawValue
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            if let weather = self.parseJSON(with: data) {
                self.delegate?.presentWeather(weather: weather)
            }
        }
        task.resume()
    }
    
    func parseJSON(with data: Data) -> Weather? {
        let decoder = JSONDecoder()
        
        do {
            let weatherData = try decoder.decode(WeatherData.self, from: data)
            guard let weather = Weather(weatherData: weatherData) else { return nil}
            return weather
        } catch let error as NSError {
            print(String(describing: error))
        }
        return nil
    }
}
