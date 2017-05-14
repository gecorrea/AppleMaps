import Foundation
import CoreLocation
import MapKit

protocol RefreshMapDelegate {
    func refreshMap()
}


class DAO {
    static let sharedInstance = DAO()
    var annotations = [Annotation]()
    var locationImages: [String : String] = [:]
    var locationsURLs: [String : String] = [:]
    var delegate : RefreshMapDelegate?
    var searchBarText = String()
    
    func startUp() {
        let tttLocation:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.70859189999999, longitude: -74.01492050000002)
        let tttPin = Annotation(title: "Turn To Tech", subtitle: "Learn, Build Apps, Get Hired", coordinate: tttLocation, imageURL: "http://turntotech.io/wp-content/uploads/2015/12/kaushik-biswas.jpg", url: "http://turntotech.io")
        
        let clintonHallLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70803125891289, -74.01487112045288)
        let clintonHallPin = Annotation(title: "Clinton Hall", subtitle: "American Restaurant & Bar", coordinate: clintonHallLocation, imageURL:"http://clintonhallny.com/common/upload/gallery/thumbs/f0a60c8b1c8a004ce7adb9f85801cef3.jpg", url:"http://clintonhallny.com")
        
        let sauceAndBarrelLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.7081175, -74.01436209999997)
        let sauceAndBarrelPin = Annotation(title: "Sauce & Barrel", subtitle: "Pizzaria & Bar", coordinate: sauceAndBarrelLocation, imageURL:"https://resizer.otstatic.com/v2/photos/large/24865769.jpg", url:"http://sauceandbarrel.com")
        
        let planetGyrosLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70806020000001, -74.01382289999998)
        let planetGyrosPin = Annotation(title: "Planet Gyro", subtitle: "Gyros", coordinate: planetGyrosLocation, imageURL:"https://s3-media2.fl.yelpcdn.com/bphoto/D-AgUP3bpEcRsveW7MHDFw/348s.jpg", url:"https://www.google.com/#q=planet+gyro+rector+street")
        
        let cafeBravoLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(40.70812100000001, -74.013824)
        let cafeBravoPin = Annotation(title: "Cafe Bravo", subtitle: "Deli", coordinate: cafeBravoLocation, imageURL:"https://s-media-cache-ak0.pinimg.com/236x/6f/d3/92/6fd39270b4d0c3156f8df5385a5f29c1.jpg", url:"https://www.google.com/#q=cafe+bravo+greenwich+street")
        
        annotations = [tttPin, clintonHallPin, sauceAndBarrelPin, planetGyrosPin, cafeBravoPin]
        
        for location in annotations {
            locationImages[location.title!] = location.imageURL
            locationsURLs[location.title!] = location.url
        }
        delegate?.refreshMap()
    }
    
    func getResults(searchString: String, region: MKCoordinateRegion) {
        annotations.removeAll()

        let request = MKLocalSearchRequest()
        searchBarText = searchString
        request.naturalLanguageQuery = searchString
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start (completionHandler: { (response, error) in
            guard let response = response
                else {return}
            if error != nil {
                print("There was an error searching for: \(String(describing: request.naturalLanguageQuery)) error: \(String(describing: error))")
            }
            else {
                for item in response.mapItems {
                    guard let name = item.name
                        else {
                            print("name error")
                            continue
                    }
                    let subtitle = item.phoneNumber
                    let coor = item.placemark.coordinate
                    guard let url = item.url
                        else {
                            print("url error")
                            continue
                    }
                    
                    print("\(String(describing: name))\n\(coor)\n\(String(describing: url))")
                    
                    let newAnnotation = Annotation(title: name, subtitle: subtitle!, coordinate: coor, imageURL: "https://cdn2.iconfinder.com/data/icons/mobile-and-internet-business/501/mobile_website-128.png", url: String(describing: url))
                    
                    self.locationImages[newAnnotation.title!] = newAnnotation.imageURL
                    self.locationsURLs[newAnnotation.title!] = newAnnotation.url
                    self.annotations.append(newAnnotation)
                }
                print("Print Something....")
                self.delegate?.refreshMap()
            }
        })
    }
}
