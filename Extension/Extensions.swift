//
//  Extensions.swift
//  WeatherApp
//
//  Created by Сергей Крайнов on 24.04.2023.
//

import MapKit

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
