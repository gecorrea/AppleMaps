import MapKit

class Annotation: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    var imageURL: String?
    var url: String?
    
    init(title:String, subtitle:String, coordinate:CLLocationCoordinate2D, imageURL:String, url:String) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.imageURL = imageURL
        self.url = url
    }
}
