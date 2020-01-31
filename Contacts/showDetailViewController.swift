
import UIKit

class showDetailViewController: UIViewController {
    var contact: ContactStruct? = nil

    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = contact!.name
        self.phoneLabel.text = contact!.number
}
    
    func setData(contact : ContactStruct) {
       
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
}

