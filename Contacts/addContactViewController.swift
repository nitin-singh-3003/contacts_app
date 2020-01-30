
import UIKit

class addContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var numberTextField: UITextField!
    
    @IBAction func saveAndClose(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    
    @IBAction func close(_ sender: UIButton) {
        
        performSegue(withIdentifier: "unwindToContactList", sender: self)
    }
    
    
}



