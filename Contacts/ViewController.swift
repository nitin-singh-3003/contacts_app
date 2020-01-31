import UIKit
import Contacts

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func settingBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    var contactStore = CNContactStore()
    var contacts = [ContactStruct]()
    var name : String?
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        contactStore.requestAccess(for: .contacts) { (success, error) in
            if success {
                print("Authorization Successful")
            }
        }
        if UserDefaults.standard.string(forKey: "Sorted") == SortBy.name.rawValue {
        fetchContacts(sortOrder: CNContactSortOrder.givenName)
        } else {
          fetchContacts(sortOrder: CNContactSortOrder.userDefault)
        }
        
        func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    func fetchContacts(sortOrder: CNContactSortOrder) {
        var newArray : [ContactStruct] = []
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keys)
        request.sortOrder = sortOrder
        let store = CNContactStore()
        do {
            try store.enumerateContacts(with: request, usingBlock: { (contact, stop) -> Void in
                //  print(contact.phoneNumbers.first?.value ?? "not found")
                })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        try? contactStore.enumerateContacts(with: request) { (contact, stoppingPointer) in
            
            let name = contact.givenName
            let number = contact.phoneNumbers.first?.value.stringValue
            let contactToAppend = ContactStruct(name: name, number: number!)
            
            newArray.append(contactToAppend)
        }
        self.contacts.removeAll()
        self.contacts = newArray
        tableView.reloadData()
        print(contacts.first?.name ?? "contacts first name not found")
    }
    
    func saveContact(){
        do{
            let contact = CNMutableContact()
            contact.givenName = name ?? "Nil"
            contact.phoneNumbers = [CNLabeledValue(
                label:CNLabelPhoneNumberiPhone,
                value:CNPhoneNumber(stringValue:phoneNumber ?? "NILL")),
                                    CNLabeledValue(
                                        label:CNLabelPhoneNumberiPhone,
                                        value:CNPhoneNumber(stringValue:phoneNumber ?? "NILL"))]
            let saveRequest = CNSaveRequest()
            saveRequest.add(contact, toContainerWithIdentifier:nil)
            try contactStore.execute(saveRequest)
            print("saved")
            }
            
        catch{
            print("error")
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let contactToDisplay = contacts[indexPath.row]
        
        cell.textLabel?.text = contactToDisplay.name
        cell.detailTextLabel?.text = contactToDisplay.number
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = setupVC()
        (detailVc as! showDetailViewController).contact = contacts[indexPath.row]
    }
    
    func setupVC()-> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "showDetailViewController") as! showDetailViewController
        self.navigationController?.pushViewController(controller, animated: true)
        return controller
    }

}

extension ViewController : SettingsProviderProtocol {
    
    func sortBy(_ sortBy: String) {
        
        UserDefaults.standard.set(sortBy, forKey: "Sorted")
        switch sortBy {
        case "name":
            fetchContacts(sortOrder: CNContactSortOrder.givenName)
            
            self.tableView.reloadData()
        case "number":
            break
            
        default: fetchContacts(sortOrder: CNContactSortOrder.userDefault)
        }
    }
    
    @IBAction func unwindToContactList(segue: UIStoryboardSegue){
        guard let viewController = segue.source as? addContactViewController
            else { return }
        if(!(viewController.nameTextField.text ?? "").isEmpty && (viewController.numberTextField.text ?? "").count == 10){
            name = viewController.nameTextField.text
            phoneNumber = viewController.numberTextField.text
            self.saveContact()
            //let contact = ContactStruct(name: (name ?? ""), number: (phoneNumber ?? ""))
            //contacts.append(contact)
            self.fetchContacts(sortOrder: .givenName)
        
        }else{
            print("Invalid Data")
        }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "contactDetailSegue" {
            guard let viewController = segue.destination as? showDetailViewController else {return}
            guard let indexPath = tableView.indexPathForSelectedRow else{return}
            let contact = contacts[indexPath.row]
            viewController.contact = contact
            
        }
    }
}


