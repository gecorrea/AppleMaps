import UIKit

class WebView: UIWebView {
    
    @IBOutlet weak var webView: UIWebView!
    
    func goToWeb(urlString: String) {
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
}
