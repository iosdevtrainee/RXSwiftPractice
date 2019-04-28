import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    IPifyAPIClient().getDeviceIPAdress(apiKey: "at_DbgbtPCaJCc9XQI8CGmFiEXSvxaXS").subscribe { (event) in
      switch event {
        case .completed: return
        case .error(let error): print(error)
        case .next(let ipAddress): print(ipAddress)
      }
    }
  }


}

