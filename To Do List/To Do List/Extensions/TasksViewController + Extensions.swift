import UIKit
import CoreData

//MARK: - UITableViewDelegate conformance
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskEditViewController = TaskEditViewController(task: todos[indexPath.row], tableView)
        taskEditViewController.modalPresentationStyle = .pageSheet
        taskEditViewController.sheetPresentationController!.detents = [.medium(), .large()]
        taskEditViewController.sheetPresentationController!.prefersGrabberVisible = true
        present(taskEditViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completion) in
            self?.deleteItem(at: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: - UITableViewDataSource conformance
extension TasksViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return TaskCell(task: todos[indexPath.row], style: .value2, reuseIdentifier: TaskCell.id)
    }
}

//MARK: - UITextFieldDelegate conformance
extension TasksViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()
        do {
            todos = try context!.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Unresolved error while fetching, \(error.debugDescription)")
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(performSearch), with: updatedText, afterDelay: 0.3)
        
        return true
    }
}

//MARK: - TasksViewController UI Configuration Methods
extension TasksViewController {
    func titleViewConfig() {
        //Calling methods to set up all the subviews of the titleView
        titleLabelConfig()
        captionLabelConfig()
        newTaskButtonConfig()
        
        //Constraints
        view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func tableViewConfig() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.id)
        tableView.showsVerticalScrollIndicator = false
        
        //Constraints
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func titleLabelConfig() {
        titleLabel.text = "Your tasks 🖊️"
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 30)
        titleLabel.textAlignment = .left
        
        //Constraints
        titleView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 5)
        ])
    }
    
    private func captionLabelConfig() {
        captionLabel.text = formattedDate(from: Date())
        captionLabel.textColor = .secondaryLabel
        captionLabel.font = .systemFont(ofSize: 13)
        captionLabel.textAlignment = .center
        
        //Constraints
        titleView.addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captionLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 5),
            captionLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor, constant: -10)
        ])
    }
    
    private func newTaskButtonConfig() {
        newTaskButton.setTitle("Add Task", for: .normal)
        newTaskButton.setTitleColor(Colors.middleBlue, for: .normal)
        newTaskButton.backgroundColor = Colors.lightBlue
        newTaskButton.titleLabel!.font = .boldSystemFont(ofSize: 17)
        newTaskButton.layer.cornerRadius = 15
        newTaskButton.addTarget(self,action: #selector(newTaskButtonAction),for: .touchUpInside)
        
        //Constraints
        titleView.addSubview(newTaskButton)
        newTaskButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            newTaskButton.topAnchor.constraint(equalTo: titleView.topAnchor, constant: 15),
            newTaskButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: 5),
            newTaskButton.widthAnchor.constraint(equalToConstant: 130),
            newTaskButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func searchFieldConfig() {
        //Generic UITextField configuration
        searchField.delegate = self
        searchField.clearButtonMode = .whileEditing
        searchField.layer.cornerRadius = 10
        searchField.layer.masksToBounds = true
        searchField.borderStyle = .none
        searchField.backgroundColor = .white
        searchField.placeholder = "Search"
        searchField.textColor = .label
        searchField.font = .preferredFont(forTextStyle: .body)
        searchField.autocorrectionType = .no
        searchField.autocapitalizationType = .none
        searchField.returnKeyType = .search
        searchField.clearButtonMode = .whileEditing
        
        //An icon to be displayed at the left edge of the text field
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .systemGray2
        
        //A container for the icon
        //Why a container? I tried adding a searchIcon as it is, as the left view, but it was acommodated too close the the leading edge and looked really ugly. Usually I solve it by adding an empty UIView as the 'leftView' with a fixed width to add a little place between the leading edge and text field's placeholder/entered text. But this time it was different. I already added a searchIcon as the left view and can't add more additional space there(because I can't just shove another UIView in there to achieve a desired outcome). So what do I do? After thinking for a good while I've decided to wrap the 'searchIcon' inside another UIView and constraint it there. Took more code, but worked.
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 18))
        iconContainer.addSubview(searchIcon)
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchIcon.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor, constant: 8),
            searchIcon.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: -4),
            searchIcon.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
        
        //Adding a container as the left view
        searchField.leftView = iconContainer
        searchField.leftViewMode = .always
        
        //Constraints
        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchField.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
}

//MARK: - TasksViewController Methods
extension TasksViewController {
    @objc func performSearch(_ searchText: String) {
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
                return
            }
            let fetchRequest: NSFetchRequest<TaskMO> = TaskMO.fetchRequest()
            if !searchText.isEmpty {
                fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            }
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do {
                todos = try context.fetch(fetchRequest)
                tableView.reloadData()
            } catch let error as NSError {
                print("Fetch error: \(error.debugDescription)")
            }
        }
    
    @objc private func newTaskButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.newTaskButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self?.newTaskButton.backgroundColor = Colors.darkLightBlue
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.1) {
                self?.newTaskButton.transform = CGAffineTransform.identity
                self?.newTaskButton.backgroundColor = Colors.lightBlue
            }
        })
        
        //Creating an alert
        let alertController = UIAlertController(title: "Got something on ya' mind?", message: "Write it down!", preferredStyle: .alert)
        
        //Adding two textfields, first one is for task's title and second one is for task's caption/description
        alertController.addTextField()
        alertController.addTextField()
        
        //Setting placeholders for each textfield
        alertController.textFields?.first!.placeholder = "Give your task a title!"
        alertController.textFields![1].placeholder = "Describe it in more detail!"
        
        //Configuring actions for the alert, first action is a simple 'cancel' action and second action is a more complicated one, which will create a new TaskMO object
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addTaskAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            guard let self else { return }
            guard !alertController.textFields![0].text!.isEmpty || !alertController.textFields![1].text!.isEmpty else { return }
            let newTask = TaskMO(context: self.appDelegate.persistentContainer.viewContext)
            newTask.title = alertController.textFields!.first!.text
            newTask.subTitle = alertController.textFields![1].text
            newTask.creationDate = Date()
            newTask.isCompleted = false
            self.todos.append(newTask)
            self.tableView.reloadData()
            self.appDelegate.saveContext()
        }
        
        //Adding two actions to the alert
        [cancelAction, addTaskAction].forEach { alertController.addAction($0) }
        
        //Presenting alert on the screen
        present(alertController, animated: true)
    }
        
    //Method that maps JSONDataModel.Task objetcs to TaskMO objects
    func createTaskMO(from jsonData: JSONDataModel.Task, in context: NSManagedObjectContext) {
        let task = TaskMO(context: context)
        task.title = jsonData.todo
        task.subTitle = jsonData.todo
        task.isCompleted = jsonData.completed
        task.creationDate = Date()
    }
    
    //Method to perform initially
    func loadInitialDataIfNeeded() {
        networkManger.fetchAllTasks { [weak self] tasks in
            guard let self else { return }
            let context = self.appDelegate.persistentContainer.viewContext
            tasks.forEach {
                self.createTaskMO(from: $0, in: context)
            }
            appDelegate.saveContext()
            DispatchQueue.main.async {
                self.todos = try! context.fetch(TaskMO.fetchRequest())
                self.tableView.reloadData()
                UserDefaults.standard.set(true, forKey: "didLoadInitialData")
            }
        }
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let context = appDelegate.persistentContainer.viewContext
        let taskToDelete = todos[indexPath.row]
        todos.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        context.delete(taskToDelete)
        appDelegate.saveContext()
    }
}

//Method that returns current date in formatted style, for example - Saturday, 22, February
public func formattedDate(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, d, MMMM"
    return formatter.string(from: date)
}
