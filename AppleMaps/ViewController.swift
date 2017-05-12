import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate, RefreshMapDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    var dataManager = DAO.sharedInstance
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let tttLocationPin:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
    let tttLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.70859189999999, longitude: -74.01492050000002)
    
    var currentAnnotations = [Annotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        mapView.showsUserLocation = true
        searchBar.delegate = self
        dataManager.delegate = self
        locationManager.startUpdatingLocation()
        
        mapView.region = MKCoordinateRegion()
        dataManager.startUp()
    }

    override func viewWillAppear(_ animated: Bool) {
        if dataManager.searchIndex == 0 {
            dataManager.startUp()
        }
        else {
        searchBar.text = dataManager.searchBarText
        dataManager.getResults(searchString: searchBar.text!, region: mapView.region)
        }
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
            //return nil so map view draws "blue dot" for standard user location
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
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 250, 250), animated: true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //view.endEditing(true)
        
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

