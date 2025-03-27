import UIKit

@MainActor
protocol Downloading: AnyObject {
    func startDownload() async -> Void
}

@MainActor
class Downlaoder: Downloading {
    func startDownload() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
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
        Task {
            await downloader.startDownload()
            downloadFinished?()
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
    
    private func downloadFinished() {
        print("Download is finished!!!")
    }
    
}
