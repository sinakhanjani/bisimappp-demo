//
//  DriverViewController.swift
//  Bisim App
//
//  Created by Sinakhanjani on 9/5/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications
import SDWebImage

class DriverViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {
    
    var markers = [GMSMarker]()
    var driver: Driver?
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var carTypeLabel: UILabel!
    @IBOutlet weak var plateSmallLabel: UILabel!
    @IBOutlet weak var plateLargeLabel: UILabel!
    @IBOutlet weak var carModelLabel: UILabel!
    @IBOutlet weak var carColorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var largeImageView: RoundedImageView!
    @IBOutlet weak var smallImageView: RoundedImageView!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    var centerMapCoordinate = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    //OBJC
    @objc func startTravel() {
        self.removeMarker()
        for i in 1..<Customer.shared.markers.count {
            let imageName = (i == 1) ? MarkerType.toLocation.rawValue: MarkerType.secendLocation.rawValue
            self.addMarker(location: Customer.shared.markers[i].position, imgName: imageName)
        }
    }
    
    @objc func travelInfoRecieved() {
        self.locationManager.startUpdatingHeading()
    }
    
    @objc func finishedTravel() {
        if let finishedTaxi = Customer.shared.finishedTaxi {
            let paid = finishedTaxi.paid!
            DispatchQueue.main.async {
                if paid {
                    self.presentPaymentMethodViewController(method: .bank)
                } else {
                    self.presentPaymentMethodViewController(method: .cash)
                }
            }
        }
    }
    
    @objc func cancelTravel() {
        DispatchQueue.main.async {
            self.presentDissRouteViewController()
        }
    }
    
    // Action
    @IBAction func creditUpButtonPressed(_ sender: RoundedButton) {
        self.presentCreditUpViewController()
    }
    
    @IBAction func callButtonPressed(_ sender: RoundedButton) {
        if let phone = Customer.shared.submitDriver?.mobileNumber {
            let number = "0\(phone)"
            let telURL = "tel://\(number)"
            if let url = URL(string: telURL) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    // Method
    func updateUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(travelInfoRecieved), name: TRAVEL_INFO_RECIEVED_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(startTravel), name: START_TRAVEL_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishedTravel), name: FINISHED_TRAVEL_NOTIFIY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelTravel), name: CANCEL_TRAVEL_NOTIFY, object: nil)
        NotificationCenter.default.post(name: TRAVEL_INFO_RECIEVED_NOTIFY, object: nil)
        UNUserNotificationCenter.current().delegate = self
        locationManagerDelegateSetting()
        self.configureUI()
    }
    
    func configureUI() {
        if let driverDetails = Customer.shared.submitDriver {
            if let price = Customer.shared.totalPrice {
                self.priceLabel.text = price.seperateByCama
            }
            self.carTypeLabel.text = driverDetails.carName
            if let carPlateCityCode = driverDetails.carPlateCityCode {
                self.plateSmallLabel.text = String(carPlateCityCode)
            }
            self.plateLargeLabel.text = driverDetails.carPlate
            if let productionYear = driverDetails.carProductionYear {
                self.carModelLabel.text = String(productionYear)
            }
            if let carColor = driverDetails.carColor {
                self.carColorLabel.text = carColor
            }
            if let name = driverDetails.firstName, let last = driverDetails.lastName {
                self.nameLabel.text = name + " " + last
            }
            if let largeImg = driverDetails.carImage {
                let url = URL.init(string: BASE_URL + largeImg)!
                SDWebImageManager.shared().loadImage(with: url, options: .highPriority, progress: nil) { (image, data, error, cache, success, url) in
                    self.largeImageView.image = image
                }
            }
            if let smallImg = driverDetails.driverImage {
                let url = URL.init(string: BASE_URL + smallImg)!
                print(url)
                SDWebImageManager.shared().loadImage(with: url, options: .highPriority, progress: nil) { (image, data, error, cache, success, url) in
                    self.smallImageView.image = image
                }
            }
            // add first marker
            if Customer.shared.markers.count > 0 {
                self.addMarker(location: Customer.shared.markers[0].position, imgName: MarkerType.fromLocation.rawValue)
            }
        } else {
            configureTravelInfo()
        }
    }
    
    func configureTravelInfo() {
        guard LoginService.instance.travelInfo?.travel != nil else { return }
        if let status = LoginService.instance.travelInfo?.travel?.status {
            if status == 6 {
                guard Customer.shared.markers.count > 0 else { return }
                self.addMarker(location: Customer.shared.markers[0].position, imgName: MarkerType.fromLocation.rawValue)
            }
            if status == 9 {
                guard Customer.shared.markers.count > 1 else { return }
                for i in 1..<Customer.shared.markers.count {
                    let imageName = (i == 1) ? MarkerType.toLocation.rawValue: MarkerType.secendLocation.rawValue
                    self.addMarker(location: Customer.shared.markers[i].position, imgName: imageName)
                }
            }
        }
    }
    
    func addMarker(location: CLLocationCoordinate2D, imgName: String) {
        let locationMarker = GMSMarker(position: location)
        let frame = CGRect.init(x: 0, y: 0, width: 50, height: 60)
        let customMarkerView = CustomMarkerView.init(frame: frame, markerType: .toLocation, imageName: imgName)
        locationMarker.iconView = customMarkerView
        locationMarker.map = self.mapView
        self.markers.append(locationMarker)
        let camera = GMSCameraPosition.camera(withLatitude: locationMarker.position.latitude, longitude: locationMarker.position.longitude, zoom: 14)
        CATransaction.begin()
        CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
        self.mapView.animate(to: camera)
        CATransaction.commit()
    }
    
    func removeMarker() {
        guard !markers.isEmpty else { return }
        for marker in markers {
            marker.map = mapView
            marker.map = nil
        }
        markers.removeAll()
    }
    
    // Notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
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
        let fromLocation = Customer.shared.markers[0].position
        let camera = GMSCameraPosition.camera(withLatitude: fromLocation.latitude, longitude: fromLocation.longitude, zoom: 15)
        mapView.camera = camera
        self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if let driver = driver {
            driver.gmsMarker.map = self.mapView
            driver.gmsMarker.map = nil
        }
        self.driver = nil
        if let driver = Customer.shared.travelInfoReceived {
            driver.gmsMarker.rotation = CLLocationDegrees.init(driver.bearing)
            driver.gmsMarker.isFlat = true
            driver.gmsMarker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
            let image = (Customer.shared.gender == .male) ? "car_men":"car_women"
            let frame = CGRect.init(x: 0, y: 0, width: 24, height: 50)
            let customMarkerView = CustomMarkerView.init(frame: frame, markerType: .car, imageName: image)
            driver.gmsMarker.iconView = customMarkerView
            driver.gmsMarker.map = self.mapView
            self.driver = driver
        }
        self.locationManager.startUpdatingHeading()
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
        //
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        return true
    }

    
    
}
