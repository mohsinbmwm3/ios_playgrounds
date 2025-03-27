import UIKit

@MainActor
protocol Downloading: AnyObject {
    func startDownload(completion: @escaping () -> Void) -> Void
}

class DownloadOperation: Operation {
    private let completion: () -> Void
    
    init(completion: @escaping () -> Void) {
        self.completion = completion
    }
    
    override func main() {
        if isCancelled { return }
        
        Thread.sleep(forTimeInterval: 2)
        
        if isCancelled { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.completion()
        }
    }
}

@MainActor
class Downlaoder: Downloading {
    
    private let queue = OperationQueue()
    
    func startDownload(completion: @escaping () -> Void) {
        let operation = DownloadOperation(completion: completion)
        queue.addOperation(operation)
    }
}

@MainActor
class DownloadViewModel {
    private let downloader: Downloading
    
    var downloadFinished: (() -> Void)?
    
    init(downloader: Downloading) {
        self.downloader = downloader
    }
    
    func startDownload() {
        downloader.startDownload() { [weak self] in
            self?.downloadFinished?()
        }
    }
}

@MainActor
class DownloadViewController: UIViewController {
    
    private var viewModel: DownloadViewModel
    
    init(viewModel: DownloadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // bind our viewcontroller to listen to viewmodel's downloadFinished closure
        bindViewModle()
        
        viewModel.startDownload()
    }
    
    private func bindViewModle() -> Void {
        viewModel.downloadFinished = { [weak self] in
            self?.downloadFinished()
        }
    }
    
    // Ultimately when a download finishes this method will get invoke
    private func downloadFinished() {
        print("Download is finished!!!")
    }
    
}
