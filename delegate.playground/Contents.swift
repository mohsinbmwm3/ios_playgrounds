import UIKit

@MainActor
protocol DownloadDelegate: AnyObject {
    func downloadStarted()
    func downloadFailed()
    func downloadFinished()
}

@MainActor
protocol Downloading {
    var delegate: DownloadDelegate? { get set }
    func startDownload()
}

@MainActor
class Downloader: Downloading {
    weak var delegate: DownloadDelegate?
    
    func startDownload() {
        print("Download started!")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            print("Download finished!")
            
            DispatchQueue.main.async {
                self?.delegate?.downloadFinished()
            }
        }
    }
    
    deinit {
        print("Downloader deinitialized")
    }
}

@MainActor
class DownloaderViewController: UIViewController, DownloadDelegate {
    
    var downloader: Downloading
    
    init(downloader: Downloading) {
        self.downloader = downloader
        
        super.init(nibName: nil, bundle: nil)
        self.downloader.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ViewController deinitialized")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // DownloadDelegate implementation
    func downloadStarted() {
        
    }
    
    func downloadFailed() {
        
    }
    
    func downloadFinished() {
        
    }
}
