import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let tttLocationPin:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
    let tttLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.70859189999999, longitude: -74.01492050000002)
    
    var locationImages: [String : String] = [:]
    var locationsURLs: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
        mapView.region = MKCoordinateRegion()
        
//        searchRequest()
        
        let tttPin = Annotation(title: "Turn To Tech", subtitle: "Learn, Build Apps, Get Hired", coordinate: tttLocation, imageURL: "http://turntotech.io/wp-content/uploads/2015/12/kaushik-biswas.jpg", url: "http://turntotech.io")
        
        let clintonHallLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70803125891289, -74.01487112045288)
        let clintonHallPin = Annotation(title: "Clinton Hall", subtitle: "American Restaurant & Bar", coordinate: clintonHallLocation, imageURL:"http://clintonhallny.com/common/upload/gallery/thumbs/f0a60c8b1c8a004ce7adb9f85801cef3.jpg", url:"http://clintonhallny.com")
        
        let sauceAndBarrelLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.7081175, -74.01436209999997)
        let sauceAndBarrelPin = Annotation(title: "Sauce & Barrel", subtitle: "Pizzaria & Bar", coordinate: sauceAndBarrelLocation, imageURL:"https://resizer.otstatic.com/v2/photos/large/24865769.jpg", url:"http://sauceandbarrel.com")
        
        let planetGyrosLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70806020000001, -74.01382289999998)
        let planetGyrosPin = Annotation(title: "Planet Gyro", subtitle: "Gyros", coordinate: planetGyrosLocation, imageURL:"https://s3-media2.fl.yelpcdn.com/bphoto/D-AgUP3bpEcRsveW7MHDFw/348s.jpg", url:"https://www.google.com/#q=planet+gyro+rector+street")
        
        let cafeBravoLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70812100000001, -74.013824)
        let cafeBravoPin = Annotation(title: "Cafe Bravo", subtitle: "Deli", coordinate: cafeBravoLocation, imageURL:"https://s-media-cache-ak0.pinimg.com/236x/6f/d3/92/6fd39270b4d0c3156f8df5385a5f29c1.jpg", url:"https://www.google.com/#q=cafe+bravo+greenwich+street")
        
        let annotations = [tttPin, clintonHallPin, sauceAndBarrelPin, planetGyrosPin, cafeBravoPin]
        
        for location in annotations {
            locationImages[location.title!] = location.imageURL
            locationsURLs[location.title!] = location.url
        }
        
        mapView.addAnnotations(annotations)
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
                
               if let imageURLString = locationImages[title] {

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
        self.locationManager.stopUpdatingLocation()
        if control == view.leftCalloutAccessoryView {
            if let pin = view.annotation{
                if let titleOptional = pin.title,
                    let title = titleOptional {
                    if let urlString = locationsURLs[title] {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let webViewVC = storyboard.instantiateViewController(withIdentifier: "WebView") as! WebView
                        _ = webViewVC.view
                        webViewVC.urlString = urlString
                        self.navigationController?.pushViewController(webViewVC, animated: true)
//                        present(webViewVC, animated: true, completion: nil)
//                        self.performSegue(withIdentifier: "showweb", sender: self)
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, 250, 250), animated: true)
    }
    
    
    
//    func searchRequest() {
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = "Restaurants"
//        request.region = mapView.region
//        
//        let search = MKLocalSearch(request: request)
//        search.start(completionHandler:  { (response, error) in
//            guard let response = response else {
//                print("Search error: \(String(describing: error))")
//                return
//            }
//            
//            for item in response.mapItems {
//                let name = item.placemark.name
//                let coor = item.placemark.coordinate
//                let url = item.url
//                
//                print("\(name)\n\(coor)\n\(url)")
//            }
//        })
//    }

}

