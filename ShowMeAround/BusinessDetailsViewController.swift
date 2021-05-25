//
//  BusinessDetailsViewController.swift
//  ShowMeAround
//
//  Created by Behzad Dogahe on 5/24/21.
//

import UIKit
import MapKit

class BusinessDetailsViewController: UIViewController {

    var business: YelpBusiness? 
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    let metersToMile = 0.000621371192
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let business = business {
            nameLabel.text = "🏢 \(business.name)"
            ratingsLabel.text = "⭐️ \(business.rating)/5 (\(business.review_count) reviews)"
            addressLabel.text = business.location.display_address.joined(separator: "\n")
            distanceLabel.text = "\(String(format: "%.1f", business.distance * metersToMile)) mi"
            mapView.mapType = MKMapType.standard
            mapView.userTrackingMode = .follow
            
            let location = CLLocationCoordinate2D(latitude: business.coordinates.latitude,longitude: business.coordinates.longitude)
            
            
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = business.name
            mapView.addAnnotation(annotation)
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
