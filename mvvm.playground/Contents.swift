import UIKit
import XCTest


@MainActor
protocol DownloadDelegate: AnyObject {
    func downloadFinished() -> Void
}

@MainActor
protocol Downloading: AnyObject {
    func startDownload(completion: @escaping () -> Void) -> Void
}

@MainActor
class Downlaoder: Downloading {
    func startDownload(completion: @escaping () -> Void) {
        print("Starting download...")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("Downlaod finished!")
            DispatchQueue.main.async {
                completion()
            }
        }
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
        downloader.startDownload { [weak self] in
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
    
    private func downloadFinished() {
        print("Download is finished!!!")
    }
    
}

// Unit Testing
class MockDownloader: Downloading {
    var didDownloadStart = false
    func startDownload(completion: @escaping () -> Void) {
        didDownloadStart = true
        completion()
    }
}

@MainActor
class DownloadViewModelTest: XCTestCase {
    func testDownloadTriggersCallback() {
        // Arrange
        let mockDownloader = MockDownloader()
        let viewModel = DownloadViewModel(downloader: mockDownloader)
        
        var callbackCalled = false
        viewModel.downloadFinished = {
            callbackCalled = true
        }
        
        // Test
        viewModel.startDownload()
        
        // Assert
        XCTAssertTrue(mockDownloader.didDownloadStart, "Downloader should be used.")
        XCTAssertTrue(callbackCalled, "Callback should be triggered after download.")
    }
}
