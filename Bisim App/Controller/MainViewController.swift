//  MainViewController.swift
//  Bisim App
//  Created by Sinakhanjani on 8/7/1397 AP.
//  Copyright © 1397 iPersianDeveloper. All rights reserved.
//

import UIKit
import SideMenu
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView

class MainViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, HandleMapSearch {
    
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

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerView: UIView!
    @IBOutlet weak var markerButton: UIButton!
    @IBOutlet weak var detailAddressView: DetailAddressView!
    @IBOutlet weak var undoBarButton: UIBarButtonItem!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var serviceTypeLabel: UILabel!
    @IBOutlet weak var serviceTypeImageView: UIImageView!
    
    var rightBarButton: UIButton!
    var activityIndicatorView: NVActivityIndicatorView!
    
    var locationManager = CLLocationManager()
    var centerMapCoordinate = CLLocationCoordinate2D()
    
    override func viewWillAppear(_ animated: Bool) {
        self.getTravelStatus()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        guard let travelInfo = LoginService.instance.travelInfo else { return }
        if let _ = travelInfo.travel {
            LoginService.instance.getBackCustomerData()
            self.presentDriverViewController()
        }
        self.realtimeUpdateUI()
    }
    
    // Objc
    @objc func rightBarButtonItemPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: OPEN_SIDE_MENU_SEGUE, sender: nil)
    }
    
    @objc func changedServiceType(_ notification: Notification) {
        self.realtimeUpdateUI()
    }
    
    @objc func addSecendPlace(_ notification: Notification) {
        let markers = Customer.shared.markers
        guard markers.count <= 2 else {
            self.undoAnimateAndCalculate()
            Customer.shared.markers.removeLast()
            self.markerView.alpha = 1.0
            self.markerButton.setImage(UIImage.init(named: MarkerType.secendLocation.rawValue), for: .normal)
            return
        }
        self.markerButton.setImage(UIImage.init(named: MarkerType.secendLocation.rawValue), for: .normal)
        self.markerView.alpha = 1.0
        if let lastPosition = markers.last {
            let camera = GMSCameraPosition.camera(withLatitude: lastPosition.position.latitude, longitude: lastPosition.position.longitude, zoom: 15)
            CATransaction.begin()
            CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: camera)
            CATransaction.commit()
        }
    }
    
    @objc func openSettingButtonPressed() {
        self.presentOptionDriveViewController()
    }
    
    @objc func resetCustomerAndMapConfiguration(_ notify: NSNotification) {
        self.resetAnimateAndCalculate()
    }
    
    @objc func searchForDriver() {
        self.presentRequestViewController()
    }
    
    @objc func addressShowInMap() {
        if let address = DataManager.shared.address {
            let lat = CLLocationDegrees.init(address.lat)!
            let long = CLLocationDegrees.init(address.long)!
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
            CATransaction.begin()
            CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: camera)
            CATransaction.commit()
            DataManager.shared.address = nil
        } else {
            guard let city = DataManager.shared.myCity else { return }
            let lat = CLLocationDegrees.init(city.cityLatitude)
            let long = CLLocationDegrees.init(city.cityLongitude)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 15)
            CATransaction.begin()
            CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
            self.mapView.animate(to: camera)
            CATransaction.commit()
            DataManager.shared.address = nil
        }
    }
    
    @objc func driverAccept() {
        if !Customer.shared.activeSetting {
            DispatchQueue.main.async {
                self.presentDriverViewController()
            }
        }
    }
    
    // Action
    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        //
    }
    
    @IBAction func unwindOptionToMainSegue(_ segue: UIStoryboardSegue) {
        if Customer.shared.optionDrive.secendPlace == .none {
            Customer.shared.optionDrive.stopWay = .none
            Customer.shared.optionDrive.goAndBack = .none
            CATransaction.begin()
            CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
            let path = GMSMutablePath()
            for marker in Customer.shared.markers {
                path.add(marker.position)
            }
            let bounds = GMSCoordinateBounds.init(path: path)
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90))
            CATransaction.commit()
        } else {
            removeLastMarkerLocationOnMap()
        }
        let optionDriveMoney = Customer.shared.optionDriveMoney
        Customer.shared.optionDriveMoney = (secendPlace: 0, goAndBack: 0, stopWay: 0)
        if let totalPrice = Customer.shared.totalPrice {
            Customer.shared.totalPrice = totalPrice - optionDriveMoney.stopWay - optionDriveMoney.secendPlace - optionDriveMoney.goAndBack
        }
        Customer.shared.secendPlaceId = nil
    }
    
    @IBAction func unwindOrderAndPassengerToMain(_ segue: UIStoryboardSegue) {
        if Customer.shared.optionDrive.secendPlace == .none {
            Customer.shared.optionDrive.stopWay = .none
            Customer.shared.optionDrive.goAndBack = .none
            CATransaction.begin()
            CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
            let path = GMSMutablePath()
            for marker in Customer.shared.markers {
                path.add(marker.position)
            }
            let bounds = GMSCoordinateBounds.init(path: path)
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90))
            CATransaction.commit()
        } else {
            removeLastMarkerLocationOnMap()
            self.markerButton.setImage(UIImage.init(named: MarkerType.toLocation.rawValue), for: .normal)
            self.markerView.alpha = 0.0
        }
        let optionDriveMoney = Customer.shared.optionDriveMoney
        Customer.shared.optionDriveMoney = (secendPlace: 0, goAndBack: 0, stopWay: 0)
        if let totalPrice = Customer.shared.totalPrice {
            Customer.shared.totalPrice = totalPrice - optionDriveMoney.stopWay - optionDriveMoney.secendPlace - optionDriveMoney.goAndBack
        }
        Customer.shared.secendPlaceId = nil
    }
    
    @IBAction func unwindToMainReset(_ segue: UIStoryboardSegue) {
        self.resetAnimateAndCalculate()
    }
    
    @IBAction func markerButtonTapped(_ sender: UIButton) {
        switch Customer.shared.markers.count {
        case 0:
            guard self.fromLabel.text != "" && self.fromLabel.text != FROM_LABEL else { return }
            self.addMarkerLocationOnMap(markerType: .fromLocation)
        case 1:
            guard self.toLabel.text != "" && self.toLabel.text != TO_LABEL else { return }
            self.addMarkerLocationOnMap(markerType: .toLocation)
        default:
            self.addMarkerLocationOnMap(markerType: .secendLocation)
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        //
    }
    
    @IBAction func undoBarButtonPressed(_ sender: UIBarButtonItem) {
        self.removeLastMarkerLocationOnMap()
    }
    
    @IBAction func serviceTypeButtonTapped(_ sender: UIButton) {
        self.presentServiceTypeViewController()
    }
    
    @IBAction func topAdrressButtonTapped(_ sender: UIButton) {
        if !UserDefaults.standard.bool(forKey: SHOW_ADDRESS_VC_KEY) {
            self.presentTopAdrressWarningViewController()
        } else {
            self.presentAddressTableViewController()
        }
    }
    
    @IBAction func activeCityButtonTapped(_ sender: Any) {
        self.presentCityViewController()
    }
    
    // Method
    func updateUI() {
        self.fromLabel.text = FROM_LABEL
        self.toLabel.text = TO_LABEL
        self.configureSideBar()
        locationManagerDelegateSetting()
        configureRightBarbuttonItem()
        undoBarButton.isEnabled = false
        NotificationCenter.default.addObserver(self, selector: #selector(changedServiceType), name: CHANGE_SERVICE_TYPE_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addSecendPlace(_:)), name: ADD_SECEND_PLACE_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openSettingButtonPressed), name: OPEN_SETTING_BUTTON_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetCustomerAndMapConfiguration(_:)), name: RESET_CUSTOMER_AND_MAP_DATA, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchForDriver), name: SEARCH_DRIVER_REQUEST_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(addressShowInMap), name: GO_MARKER_FOR_ADDRESS_NOTIFY, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(driverAccept), name: DRIVER_ACCEPT_NOTIFT, object: nil)
    }
    
    func configureRightBarbuttonItem() {
        let rightView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightBarButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        rightBarButton.setImage(UIImage.init(named: "menu_icon"), for: .normal)
        rightBarButton.setImage(UIImage.init(named: "menu_icon"), for: .selected)
        rightBarButton.setImage(UIImage.init(named: "menu_icon"), for: .highlighted)
        rightBarButton.addTarget(self, action: #selector(rightBarButtonItemPressed(_:)), for: .touchUpInside)
        let padding: CGFloat = 38.0
        let frame = CGRect(x: 0, y: 0, width: padding, height: padding)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin, color: .darkGray, padding: padding)
        rightView.addSubview(rightBarButton)
        rightView.addSubview(activityIndicatorView)
        let rightBarButtonItem = UIBarButtonItem.init(customView: rightView)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func showDriverMarkerOnMap() {
//        let drivers = SocketConnection.instance.drivers
//        for driver in drivers {
//            driver.gmsMarker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
//            driver.gmsMarker.rotation = CLLocationDegrees.init(driver.bearing)
//            driver.gmsMarker.isFlat = true
//            driver.gmsMarker.map = self.mapView
//        }
        self.locationManager.startUpdatingHeading()

    }
    
    func addMarkerLocationOnMap(markerType: MarkerType) {
        let locationMarker = GMSMarker(position: self.centerMapCoordinate)
        let frame = CGRect.init(x: 0, y: 0, width: 50, height: 60)
        let customMarkerView = CustomMarkerView.init(frame: frame, markerType: .toLocation, imageName: markerType.rawValue)
        switch markerType {
        case .fromLocation:
            locationMarker.iconView = customMarkerView
            locationMarker.map = self.mapView
            let newMarker = Marker.init(markerType: .fromLocation, position: locationMarker.position, gmsMarker: locationMarker, name: self.fromLabel.text!)
            self.markerButton.setImage(UIImage.init(named: MarkerType.toLocation.rawValue), for: .normal)
            Customer.shared.markers.append(newMarker)
        case .toLocation:
            locationMarker.iconView = customMarkerView
            locationMarker.map = self.mapView
            let newMarker = Marker.init(markerType: .toLocation, position: locationMarker.position, gmsMarker: locationMarker, name: self.toLabel.text!)
            // **
            Customer.shared.markers.append(newMarker)
            self.animateAndCalculate()
            break
        case .secendLocation:
            locationMarker.iconView = customMarkerView
            let newMarker = Marker.init(markerType: .secendLocation, position: locationMarker.position, gmsMarker: locationMarker, name: "")
            Customer.shared.markers.append(newMarker)
            locationMarker.map = self.mapView
            self.animateAndCalculate()
            break
        default:
            break
        }
    }
    
    func removeLastMarkerLocationOnMap() {
        let count = Customer.shared.markers.count
        guard count > 0 else { return }
        self.undoAnimateAndCalculate()
        Customer.shared.markers.removeLast()
        Customer.shared.secendPlaceName = SECEND_LABEL
        Customer.shared.optionDrive.secendPlace = .none
        Customer.shared.optionDrive.stopWay = .none
        Customer.shared.optionDrive.goAndBack = .none
    }
    
    func animateAndCalculate() {
        Customer.shared.preOrder = true
        self.markerView.alpha = 0.0
        CATransaction.begin()
        CATransaction.setValue(Int(2), forKey: kCATransactionAnimationDuration)
        let path = GMSMutablePath()
        for marker in Customer.shared.markers {
            path.add(marker.position)
        }
        let bounds = GMSCoordinateBounds.init(path: path)
        self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90))
        CATransaction.commit()
        if Customer.shared.markers.count == 2 {
            self.presentOrderMenuViewController()
        }
        if Customer.shared.markers.count == 3 {
            Customer.shared.optionDrive.secendPlace = .secendPlace
            self.presentOptionDriveViewController()
        }
    }
    
    func undoAnimateAndCalculate() {
        let markers = Customer.shared.markers
        switch markers.count {
        case 0:
            break
        case 1:
            let gsmMaker = markers[0].gmsMarker
            gsmMaker.map = mapView
            gsmMaker.map = nil
            self.markerButton.setImage(UIImage.init(named: MarkerType.fromLocation.rawValue), for: .normal)
            Customer.shared.preOrder = false
            self.fromLabel.text = FROM_LABEL
            self.toLabel.text = TO_LABEL
            break
        case 2:
            let gsmMaker = markers[1].gmsMarker
            gsmMaker.map = mapView
            gsmMaker.map = nil
            self.markerButton.setImage(UIImage.init(named: MarkerType.toLocation.rawValue), for: .normal)
            //self.presentedViewController?.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: REMOVE_ORDER_MENU_NOTIFY, object: nil)
            Customer.shared.preOrder = false
            OrderService.instance.travelPrice = nil
            self.toLabel.text = TO_LABEL
        default:
            guard let gsmMaker = markers.last?.gmsMarker else { return }
            gsmMaker.map = mapView
            gsmMaker.map = nil
            self.markerButton.setImage(UIImage.init(named: MarkerType.secendLocation.rawValue), for: .normal)
            Customer.shared.preOrder = true
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.markerView.alpha = 1
            if let lastPosition = markers.last {
                let position = (markers.count <= 2) ? lastPosition.position: markers[markers.count - 2].position
                let camera = GMSCameraPosition.camera(withLatitude: position.latitude, longitude: position.longitude, zoom: 15)
                CATransaction.begin()
                CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
                self.mapView.animate(to: camera)
                CATransaction.commit()
            }
        }) { (complete) in
            //
        }
        
    }
    
    func resetAnimateAndCalculate() {
        for maker in Customer.shared.markers {
            maker.gmsMarker.map = mapView
            maker.gmsMarker.map = nil
        }
        self.markerButton.setImage(UIImage.init(named: MarkerType.fromLocation.rawValue), for: .normal)
        self.markerView.alpha = 1
        let camera = GMSCameraPosition.camera(withLatitude: centerMapCoordinate.latitude, longitude: centerMapCoordinate.longitude, zoom: 15)
        CATransaction.begin()
        CATransaction.setValue(Int(1), forKey: kCATransactionAnimationDuration)
        self.mapView.animate(to: camera)
        CATransaction.commit()
        Customer.shared.resetCustomerData()
        OrderService.instance.travelPrice = nil
        NotificationCenter.default.post(name: REMOVE_ORDER_MENU_NOTIFY, object: nil)
        self.fromLabel.text = FROM_LABEL
        self.toLabel.text = TO_LABEL
    }
    
    func getAddressFromCLLocationCoordinate2D(center: CLLocationCoordinate2D, handler: @escaping (_ address: String) -> Void) {
        self.activityIndicatorView.startAnimating()
        let geoCoder = CLGeocoder()
        let location = CLLocation.init(latitude: center.latitude, longitude: center.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placeMarks, error) in
            if error != nil {
                self.activityIndicatorView.stopAnimating()
                return
            }
            guard let placeMarks = placeMarks else { self.activityIndicatorView.stopAnimating() ; return }
            guard placeMarks.count > 0 else { self.activityIndicatorView.stopAnimating() ; return }
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.activityIndicatorView.stopAnimating()
            })
            handler(address)
        }
    }
    
    func realtimeUpdateUI() {
        let markerCount = Customer.shared.markers.count
        let visibleRegion = mapView.projection.visibleRegion()
        let nearLeft = visibleRegion.nearLeft
        let farRight = visibleRegion.farRight
        for driver in SocketConnection.instance.drivers {
            driver.gmsMarker.map = self.mapView
            driver.gmsMarker.map = nil
        }
        SocketConnection.instance.drivers.removeAll()
        SocketConnection.instance.sendonCameraIdleLocation(northEastLat: "\(farRight.latitude)", northLeastLong: "\(farRight.longitude)", southWestLat: "\(nearLeft.latitude)", southWestLong: "\(nearLeft.longitude)", gender: Customer.shared.gender) { status in
            if status == .success {
                DispatchQueue.main.async {
                    self.showDriverMarkerOnMap()
                }
            }
        }
        getAddressFromCLLocationCoordinate2D(center: self.centerMapCoordinate) { (address) in
            switch markerCount {
            case 0:
                self.fromLabel.text = address
            case 1:
                guard !Customer.shared.preOrder else { return }
                self.toLabel.text = address
            case 2:
                break
            default:
                Customer.shared.secendPlaceName = address
            }
        }
        if markerCount > 0 {
            self.undoBarButton.isEnabled = true
        } else {
            self.undoBarButton.isEnabled = false
        }
        let name = (Customer.shared.gender == .male) ? "معمولی":"بانوان"
        self.serviceTypeLabel.text = name
        let image = (Customer.shared.gender == .male) ? UIImage.init(named: "taxi_man"): UIImage.init(named: "taxi_woman")
        self.serviceTypeImageView.image = image
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainVCToSearchVC" {
            let destination = segue.destination as! UINavigationController
            let searchMapVC = destination.viewControllers.first as! MapSearchViewController
            searchMapVC.handleMapSearchDelegate = self
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
    
    func getTravelStatus() {
        LoginService.instance.travelInfoRequest { (_) in
            //
        }
    }
    
    // Google Maps
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let drivers = SocketConnection.instance.drivers
        for driver in drivers {
            driver.gmsMarker.groundAnchor = CGPoint.init(x: 0.5, y: 0.5)
            driver.gmsMarker.rotation = CLLocationDegrees.init(driver.bearing)
            driver.gmsMarker.isFlat = true
            driver.gmsMarker.map = self.mapView
        }
        self.locationManager.startUpdatingHeading()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let city = DataManager.shared.myCity {
            let geoLong = city.cityLongitude
            let geoLat = city.cityLatitude
            let camera = GMSCameraPosition.camera(withLatitude: geoLat, longitude: geoLong, zoom: 15)
            mapView.camera = camera
            self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
        } else {
            let userLocation: CLLocation = locations[0]
            let geoLong = userLocation.coordinate.longitude
            let geoLat = userLocation.coordinate.latitude
            let camera = GMSCameraPosition.camera(withLatitude: geoLat, longitude: geoLong, zoom: 15)
            mapView.camera = camera
            self.centerMapCoordinate = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLong)
        }
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        centerMapCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        guard !Customer.shared.preOrder else { return }
        let count = Customer.shared.markers.count
        if count == 0 {
            self.fromLabel.text = FROM_LABEL
            self.toLabel.text = TO_LABEL
        } else if count == 1 {
            self.toLabel.text = TO_LABEL
        }
    }

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        realtimeUpdateUI()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        //
        return true
    }

    
    
}

extension MainViewController: UISideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appearing! (animated: \(animated))")
    }
    
    func sideMenuDidAppear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Appeared! (animated: \(animated))")
    }
    
    func sideMenuWillDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappearing! (animated: \(animated))")
    }
    
    func sideMenuDidDisappear(menu: UISideMenuNavigationController, animated: Bool) {
        print("SideMenu Disappeared! (animated: \(animated))")
    }
    
}

