import UIKit

@objc
class ReaderCoordinator: NSObject {
    let readerNavigationController: UINavigationController
    let readerMenuViewController: ReaderMenuViewController

    @objc
    init(readerNavigationController: UINavigationController,
         readerMenuViewController: ReaderMenuViewController) {
        self.readerNavigationController = readerNavigationController
        self.readerMenuViewController = readerMenuViewController

        super.init()
    }

    func showReaderTab() {
        WPTabBarController.sharedInstance().showReaderTab()
    }

    func showDiscover() {
        WPTabBarController.sharedInstance().showReaderTab()

        readerNavigationController.popToRootViewController(animated: false)
        readerMenuViewController.showSectionForDefaultMenuItem(withOrder: .discover,
                                                               animated: false)
    }

    func showSearch() {
        WPTabBarController.sharedInstance().showReaderTab()

    }
}
