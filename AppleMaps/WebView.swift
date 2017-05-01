import UIKit

class WebView: ViewController {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var urlString = String()
    
    override func viewDidLoad() {
        
        self.goToWeb(urlString: urlString)
    }
    
    func goToWeb(urlString: String) {
        let url = URL(string: urlString)
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
    
    @IBAction func backAction(_ sender: Any) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func forwardAction(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    @IBAction func refreshAction(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func stopAction(_ sender: Any) {
        webView.stopLoading()
    }
    
    @IBAction func backToMap(_ sender: Any) {
        let goBackToMap = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! ViewController
        self.show(goBackToMap, sender: self)
    }
    
}
