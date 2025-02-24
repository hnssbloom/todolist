import UIKit
import CoreData

class TasksViewController: UIViewController {
    //MARK: - Properties
    //UI Elements
    let tableView = UITableView(frame: .zero, style: .insetGrouped)
    let titleView = UIView()
    let titleLabel = UILabel()
    let captionLabel = UILabel()
    let newTaskButton = UIButton(type: .system)
    let searchField = UITextField()
    
    //Other
    let networkManger = NetworkManager()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    var todos: [TaskMO] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        titleViewConfig()
        searchFieldConfig()
        tableViewConfig()
        if !UserDefaults.standard.bool(forKey: "didLoadInitialData") {
            loadInitialDataIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let context = appDelegate.persistentContainer.viewContext
        context.perform {
            do {
                let fetchedTodos = try context.fetch(TaskMO.fetchRequest())
                DispatchQueue.main.async {
                    self.todos = fetchedTodos
                    self.tableView.reloadData()
                }
            } catch let error as NSError {
                print("Unresolved erro, \(error.debugDescription)")
            }
        }
    }
}
