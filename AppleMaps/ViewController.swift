import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, RefreshMapDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var dataManager = DAO.sharedInstance
    var hasSetUserLocation = false
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        mapView.showsUserLocation = true
        searchBar.delegate = self
        dataManager.delegate = self
        
        mapView.region = MKCoordinateRegion()
        dataManager.startUp()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.animatesDrop = true
        }
        else {
            pinView!.annotation = annotation
        }
       
        pinView?.leftCalloutAccessoryView = nil
        pinView?.leftCalloutAccessoryView = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let pin = view.annotation {
            if let titleOptional = pin.title,
                let title = titleOptional {
                
               if let imageURLString = DAO.sharedInstance.locationImages[title] {

                DispatchQueue.global().async {
                    if let imageURL = URL(string: imageURLString),
                        let imageData = try? Data.init(contentsOf: imageURL),
                        let image = UIImage(data: imageData) {
                        
                        DispatchQueue.main.async {
                            let theImageButton = view.leftCalloutAccessoryView as? UIButton
                            theImageButton?.setImage(image, for: .normal)
                        }
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let pin = view.annotation{
            if let titleOptional = pin.title,
                let title = titleOptional {
                if let urlString = dataManager.locationsURLs[title] {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let webViewVC = storyboard.instantiateViewController(withIdentifier: "WebView") as! WebView
                    webViewVC.urlString = urlString
                    present(webViewVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !hasSetUserLocation {
            mapView.setRegion(MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 3000, 3000), animated: true)
            hasSetUserLocation = true
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapView.removeAnnotations(dataManager.annotations)
        dataManager.annotations.removeAll()
        searchRequest()
    }
    
    func searchRequest() {
        dataManager.getResults(searchString: searchBar.text!, region: mapView.region)
    }
    
    func refreshMap() {
        mapView.addAnnotations(dataManager.annotations)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

