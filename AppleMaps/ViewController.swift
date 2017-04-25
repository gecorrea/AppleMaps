//
//  ViewController.swift
//  AppleMaps
//
//  Created by Aditya Narayan on 4/25/17.
//  Copyright © 2017 George Correa. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logo: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectMapView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.mapType = MKMapType.standard
            break
        case 1:
            mapView.mapType = MKMapType.hybrid
            break
        case 2:
            mapView.mapType = MKMapType.satellite
            break
        default:
            break
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 200, 200), animated: true)
    }

}

