//
//  WKWebViewViewController.swift
//  SwiftUIKitLabs
//
//  Created by johnny on 6/18/24.
//

import UIKit
import WebKit

class WKWebViewViewController: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    
    private var observation: NSKeyValueObservation? = nil

    private func setWebView() {
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        webView.allowsBackForwardNavigationGestures = true // 앞,뒤로가기 제스처 허용
        webView.navigationDelegate = self
        observation = webView.observe(\.estimatedProgress, options: [.new]) { webView, _ in
            self.progressView.progress = Float(webView.estimatedProgress)

            // 진행률이 100%에 도달하면 프로그레스 뷰를 숨김
            if webView.estimatedProgress == 1.0 {
                self.progressView.isHidden = true
            } else {
                self.progressView.isHidden = false
            }
        }
    }
    
    private func loadURL() {
        let urlString = "https://www.apple.com"
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        loadURL()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    @IBAction func touchBack(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func touchForward(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func touchShare(_ sender: Any) {
        let activityItems: [Any] = [webView.title ?? "", webView.url ?? ""]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        self.present(activityViewController, animated: true)
    }
    
    @IBAction func touchRefresh(_ sender: Any) {
        webView.reload()
    }
    
    @IBAction func touchClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func touchMore(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        actionSheet.addAction(UIAlertAction(title: "외부 브라우저에서 열기", style: .default, handler: { [weak self] action in
            guard let self = self, let url = webView.url else { return }
            openInExternalBrowser(url: url)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "링크 복사", style: .default, handler: { [weak self] action in
            guard let self = self, let url = webView.url else { return }
            UIPasteboard.general.url = url
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }
    
    private func openInExternalBrowser(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension WKWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let title = webView.title else { return }
        urlLabel.text = title
        backButton.isEnabled = webView.canGoBack
        forwardButton.isEnabled = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

    }
}
