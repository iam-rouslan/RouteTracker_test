//
//  ViewController.swift
//  RouteTracker_test
//
//  Created by Руслан Баянов on 20.10.2022.
//

//test1

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: GMSMapView!
    
    
    let coordinate = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
    var marker: GMSMarker?
    var geoCoder: CLGeocoder? // для показа названия улицы
    var route: GMSPolyline?
    var locationManager: CLLocationManager?
    var routePath: GMSMutablePath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        configureLocationManager()
    }
    
    private func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = true
        mapView.isMyLocationEnabled = true
    }
    
    private func configureMap() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 15)
        mapView.camera = camera
        mapView.delegate = self
    }
    
    private func addMarker() {
        marker = GMSMarker(position: coordinate)
        marker?.map = mapView
        //        marker?.icon = UIImage(systemName: "star.fill")
        marker?.title = "Маркер"
        marker?.snippet = "Мой первый маркер"
    }
    
    private func removeMarker() {
        marker?.map = nil
        marker = nil
    }
    
    @IBAction func addMarkerDidTap(_ sender: UIButton) {
        if marker == nil {
            mapView.animate(toLocation: coordinate)
            addMarker()
        } else {
            removeMarker()
        }
    }
    
    @IBAction func updateLocationDidTap(_ sender: Any) {
        locationManager?.requestLocation()
        route?.map = nil
        routePath = GMSMutablePath()
        route = GMSPolyline()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
        locationManager?.requestLocation()
    }
    
}

//MARK: - Extensions

// маркеры по тапу на произвольном месте карты

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate)
        let byTapMarker = GMSMarker(position: coordinate)
        byTapMarker.map = mapView
        
        if geoCoder == nil {
            geoCoder = CLGeocoder()
        }
        
        geoCoder = CLGeocoder()
       
        geoCoder?.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude), completionHandler: { places, error in
            print(places?.last as Any)
        })
    }
}

// для работы с движением

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        mapView.animate(to: position)
        
        print(location.coordinate)
        
    }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
        
    }


