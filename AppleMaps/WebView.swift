import UIKit
import WebKit

class WebView: UIViewController, WKNavigationDelegate {
    
    var theWeb : WKWebView!
    
    @IBOutlet weak var mapButton: UIButton!
    
    var urlString = String()
    
    override func viewDidLoad() {
        let configuration = WKWebViewConfiguration()
        theWeb = WKWebView(frame: UIScreen.main.bounds, configuration: configuration)
        theWeb.navigationDelegate = self
        goToWeb(urlString: urlString)
        self.view.addSubview(theWeb)
        theWeb.addSubview(mapButton)
        theWeb.allowsBackForwardNavigationGestures = true
    }
    
    func goToWeb(urlString: String) {
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        theWeb.load(urlRequest)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        mapButton.isHidden = false
    }
    
    @IBAction func backToMap(_ sender: Any) {
        let goBackToMap = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        self.show(goBackToMap, sender: self)
    }
    
}
