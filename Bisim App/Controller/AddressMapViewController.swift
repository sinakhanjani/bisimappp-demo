
//
//  AddressMapViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 8/25/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps

class AddressMapViewController: UIViewController, HandleMapSearch, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var addAddressButton: RoundedButton!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var centerMapCoordinate = CLLocationCoordinate2D()
    
    var marker: Marker?
        
    func searchBarSelectedItem(_ prediction: Prediction) {
        searchByPlaceId(placeID: prediction.placeID) { (location) in
            DispatchQueue.main.async {
                let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15)
                self.centerMapCoordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                UIView.animate(withDuration: 2, animations: {
                    CATransaction.begin()
                    CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
                    self.mapView.animate(to: camera)
                    CATransaction.commit()
                })
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    // ACTION
    @IBAction func addMarkerButtonPressed(_ sender: Any) {
        self.addMarker()
    }
    

    @IBAction func addAddressButtonPressed(_ sender: Any) {
        if marker != nil {
            self.performSegue(withIdentifier: UNWIND_TO_ADDRESS_TABLE_VC_SEGUE, sender: nil)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteMarkerButtonPressed(_ sender: Any) {
        self.removeMarker()
    }
    
    // Method
    func updateUI() {
        self.addAddressButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        locationManagerDelegateSetting()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ADDRESS_TO_SEARCH_SEGUE {
            let destination = segue.destination as! UINavigationController
            let searchVC = destination.viewControllers.first as! MapSearchViewController
            searchVC.handleMapSearchDelegate = self
        }
    }
    
    func searchByPlaceId(placeID: String,completion: @escaping (_ selectedLocation: CLLocationCoordinate2D) -> Void)  {
        let url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(placeID)&key=AIzaSyAf0sKw2uMrV9n8r28Dz-AYc4T5-ctnQ8k&language=fa")
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
                let result = json["result"] as! [String:Any]
                let geometry = result["geometry"] as! [String:Any]
                let location = geometry["location"] as! [String:Any]
                let lat = location["lat"] as! Double
                let long = location["lng"] as! Double
                let selectedLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                completion(selectedLocation)
            }
            }.resume()
    }
    
    func addMarker() {
        let locationMarker = GMSMarker(position: self.centerMapCoordinate)
        let frame = CGRect.init(x: 0, y: 0, width: 50, height: 60)
        let customMarkerView = CustomMarkerView.init(frame: frame, markerType: .toLocation, imageName: "star_marker")
        locationMarker.iconView = customMarkerView
        locationMarker.map = self.mapView
        self.marker = Marker.init(markerType: .fromLocation, position: locationMarker.position, gmsMarker: locationMarker, name: self.addressLabel.text!)
        marker?.gmsMarker.map = mapView
        self.markerView.alpha = 0.0
        UIView.animate(withDuration: 0.5) {
            self.addAddressButton.transform = CGAffineTransform.identity
        }
    }
    
    func removeMarker() {
        guard marker != nil else { return }
        marker?.gmsMarker.map = mapView
        marker?.gmsMarker.map = nil
        marker = nil
        self.markerView.alpha = 1.0
        self.addressLabel.text = "آدرس منتخب ..."
        self.addAddressButton.transform = CGAffineTransform.init(scaleX: 0, y: 0)
    }
    
    func getAddressFromCLLocationCoordinate2D(center: CLLocationCoordinate2D, handler: @escaping (_ address: String) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation.init(latitude: center.latitude, longitude: center.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error != nil {
                return
            }
            guard let placeMarks = placeMarks else { return }
            guard placeMarks.count > 0 else { return }
            let placeMark = placeMarks[0]
            var address = ""
            if let name = placeMark.name {
                address += "\(name)"
            }
            if let name = placeMark.subLocality {
                // address += "\(name) "
            }
            if let name = placeMark.subThoroughfare {
                // address += "\(name) "
            }
            if let name = placeMark.thoroughfare {
                // address += "\(name) "
            }
            handler(address)
        }
    }
    
    // GOOGLE MAP
    func locationManagerDelegateSetting() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let geoLong = userLocation.coordinate.longitude
        let geoLat = userLocation.coordinate.latitude
        let camera = GMSCameraPosition.camera(withLatitude: geoLat, longitude: geoLong, zoom: 15)
        mapView.camera = camera
        self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        //
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getAddressFromCLLocationCoordinate2D(center: self.centerMapCoordinate) { (address) in
            DispatchQueue.main.async {
                self.addressLabel.text = address
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return true
    }

    
}
