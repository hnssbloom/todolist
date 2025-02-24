import UIKit

class TaskEditViewController: UIViewController {
    //MARK: - Properties
    //UI Elements
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let titleTextField = UITextField()
    let descriptionTextField = UITextField()
    let saveButton = UIButton(type: .system)
    let stackView = UIStackView()
    
    //Other
    var task: TaskMO
    var tableView: UITableView
    let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        stackViewConfig()
        saveButtonConfig()
        tapGestureConfig()
    }
    
    //MARK: - Initializers
    init(task: TaskMO, _ tableView: UITableView) {
        self.task = task
        self.tableView = tableView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
