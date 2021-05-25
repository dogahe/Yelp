//
//  ViewController.swift
//  ShowMeAround
//
//  Created by Behzad Dogahe on 5/24/21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.placeholder = "Search"
        }
    }
    
    let locationManager = CLLocationManager()
    
    var userLocation: CLLocation?
    
    var businesses: [YelpBusiness]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        performYelpSearch()
    }
    
    private func performYelpSearch() {
        textField.resignFirstResponder()
        if let term = textField.text {
            getCurrentLocationIfPossible()
            var lat: Double = 39.750561
            var lon: Double = -105.000891
            
            if let userLocation = userLocation {
                lat = userLocation.coordinate.latitude
                lon = userLocation.coordinate.longitude
            }
            
            guard let path = Bundle.main.path(forResource: "YelpAPI", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path), let token = dict["API_KEY"] as? String else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: AppError.missingAPiKeyInPlist.description, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                return
            }
            
            
            YelpService.shared.getBusiness(term, lat, lon, token) { result in
                switch result {
                case let .failure(error):
                    print("Error getting businesses: \(error)")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                case let .success(businesses):
                    self.businesses = businesses.businesses
                }
            }
        }
    }
    
    func getCurrentLocationIfPossible() {
        let status = locationManager.authorizationStatus
        print(status.rawValue)
        if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
            let alert = UIAlertController(title: "Location Service", message: "In order to find businesses around you, you need to enable location services for this app in Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Business Details", let business = sender as? YelpBusiness {
            if let bdvc = segue.destination as? BusinessDetailsViewController {
                bdvc.business = business
            }
        }
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = businesses {
            return businesses.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as? BusinessTableViewCell {
            guard let businesses = businesses else { return UITableViewCell() }
            let business = businesses[indexPath.row]
            cell.nameLabel.text = business.name
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let businesses = businesses else {
            return
        }
        let business = businesses[indexPath.row]
        performSegue(withIdentifier: "Show Business Details", sender: business)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            if location.horizontalAccuracy < 100 {
                //print(location)
                userLocation = location
            }
        }
    }
    /*
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        print("📍 \(status.rawValue)")
     }
     */
}

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        performYelpSearch()
        return true
    }
}
