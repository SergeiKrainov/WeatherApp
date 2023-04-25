//
//  ViewController.swift
//  WeatherApp
//
//  Created by Сергей Крайнов on 24.04.2023.
//

import UIKit
import MapKit
import SafariServices
import CoreLocation
import SwiftSVG

final class WeatherViewController: UIViewController {
    
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var middleStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var presureLabel: UILabel!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    private let locationManager = CLLocationManager()
    
    private var userLat: Double = 0
    private var userLon: Double = 0
    
    private var url = ""

    private let presenter = WeatherPesenter()
    
    private var isLoaded = false {
        didSet {
            presenter.fetchWeather(logitude: userLon, latitude: userLat)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        presenter.setUpDelegate(delegate: self)
        button.layer.cornerRadius = 51
        detailButton.layer.cornerRadius = CGFloat(detailButton.frame.size.height / 2)
    }
    
    private func setUpUI(weather: Weather) {
        url = weather.url
        let urlString = "https://yastatic.net/weather/i/icons/funky/dark/\(weather.conditionCode).svg"
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.main.async {
            self.tempMinLabel.text = "\(weather.tempMin) °C"
            self.tempMaxLabel.text = "\(weather.tempMax) °C"
            self.windLabel.text = "\(weather.windSpeed) м/с"
            self.presureLabel.text = "\(weather.presureMm) мм.рт.ст."
            self.temperatureLabel.text = "\(weather.tempeature) °C"
            self.conditionLabel.text = weather.conditionString
            let weatherImage = UIView(SVGURL: url) { image in
                image.resizeToFit(self.iconView.bounds)
            }
            self.iconView.addSubview(weatherImage)
            self.cityNameLabel.isHidden = false
            self.middleStack.isHidden = false
            self.bottomStack.isHidden = false
            self.indicator.stopAnimating()
            self.detailButton.isHidden = false
        }
    }
    
    
    @IBAction func takeLocation(_ sender: UIButton) {
        button.isHidden = true
        indicator.startAnimating()
        indicator.isHidden = false
        locationManager.requestLocation()
    }
    
    @IBAction func detailButtonPressed(_ sender: UIButton) {
        guard let url = URL(string: self.url) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            userLat = Double(latitude)
            userLon = Double(longitude)
            isLoaded = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(String(describing: error))
    }
}

extension WeatherViewController: WeatherPesenterDelegate {
    func presentWeather(weather: Weather) {
        setUpUI(weather: weather)
    }
    
    func presentCityName(cityName: String, countreName: String) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = cityName + " / " + countreName
        }
    }
}

