import UIKit
import WebKit

class WebView: UIViewController, WKNavigationDelegate {
    

    @IBOutlet weak var mapButton: UIButton!

    @IBOutlet weak var webView: WKWebView!
    
    var urlString = String()
    
    override func viewDidLoad() {
        webView.navigationDelegate = self
        goToWeb(urlString: urlString)
    }
    
    func goToWeb(urlString: String) {
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
    }
    
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//    }
//    
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        mapButton.isHidden = false
//    }
    
    @IBAction func backToMap(_ sender: Any) {
        let goBackToMap = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        self.show(goBackToMap, sender: self)
    }
    
}
