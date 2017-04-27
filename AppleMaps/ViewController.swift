import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var locationManager:CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var logo: UIImageView!
    
    let tttLocationPin:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70859189999999, -74.01492050000002)
    let tttLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.70859189999999, longitude: -74.01492050000002)
    
    var locationImages: [String : String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.delegate = self
        mapView.showsUserLocation = false
        
        mapView.region = MKCoordinateRegion()
        
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
        }

        mapView.addAnnotations(annotations)
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(tttLocation, 300, 300), animated: true)
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
    
//    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//        mapView.setRegion(MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 250, 250), animated: true)
//    }
    
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
//        
//        pinView?.leftCalloutAccessoryView = nil
//        pinView?.rightCalloutAccessoryView = nil
//        configureDetialView(annotationView: pinView!)
        
        
        
        if let title = annotation.title,
            let actualTitle = title,
            let imageURLString = locationImages[actualTitle] {
            
            //
            DispatchQueue.global().async {
                if let imageURL = URL(string: imageURLString),
                    let imageData = try? Data.init(contentsOf: imageURL),
                    let image = UIImage(data: imageData) {
                    
                    DispatchQueue.main.async {
                        pinView?.leftCalloutAccessoryView?.frame.size = CGSize(width: 50, height: 50)
                        pinView?.leftCalloutAccessoryView = UIImageView(image: image)
                        pinView?.leftCalloutAccessoryView?.contentMode = .scaleAspectFit
                        pinView?.leftCalloutAccessoryView?.clipsToBounds = true
                    }
                }

            }
            
//            let imageData = try? Data.init(contentsOf: URL()
            
        }
//            imageURLString = locationImages[annotation.title] as? String {
//        
//        }
        
//        let imageData = try? Data.init(contentsOf: <#T##URL#>)
//        if let image = UIImage
//        
//        
//        guard let image = UIImage(data: Data(contentsOf: URL(fileURLWithPath: locationImages[annotation.title]!)))
//            else {return}
        
        return pinView
    }

//    func configureDetialView(annotationView: MKAnnotationView) {
//        let width = 200
//        let height = 200
//        
//        let snapshotView = UIView()
//        let views = ["snapshotView": snapshotView]
//        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[snapshotView(200)]", options: [], metrics: nil, views: views))
//        snapshotView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[snapshotView(200)]", options: [], metrics: nil, views: views))
//        
//        let options = MKMapSnapshotOptions()
//        options.size = CGSize(width: width, height: height)
//        options.camera = MKMapCamera(lookingAtCenter: annotationView.annotation!.coordinate, fromDistance: 250, pitch: 65, heading: 0)
//        
//        let snapshotter = MKMapSnapshotter(options: options)
//        snapshotter.start { snapshot, error in
//            if snapshot != nil {
//                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//                imageView.image = snapshot!.image
//                snapshotView.addSubview(imageView)
//            }
//        }
//        
//        annotationView.detailCalloutAccessoryView = snapshotView
//    }
}

