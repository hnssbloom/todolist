//
//  To_Do_ListTests.swift
//  To Do ListTests
//
//  Created by Alina Kazantseva on 2/20/25.
//

import XCTest
import CoreData
@testable import To_Do_List

final class To_Do_ListTests: XCTestCase {
    
    var tasksVC: TasksViewController!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = NSPersistentContainer(name: "To_Do_List")
        container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { (description, error) in
            XCTAssertNil(error)
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.persistentContainer = container
        context = container.viewContext
        tasksVC = TasksViewController()
        tasksVC.loadViewIfNeeded()
        UserDefaults.standard.removeObject(forKey: "didLoadInitialData")
    }
    
    override func tearDownWithError() throws {
        tasksVC = nil
        context = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Core Data Tests
    
    func testCreateTask() throws {
        // Arrange
        let initialCount = try context.count(for: TaskMO.fetchRequest())
        
        // Act
        let newTask = TaskMO(context: context)
        newTask.title = "Test Task"
        newTask.subTitle = "Test Description"
        newTask.creationDate = Date()
        newTask.isCompleted = false
        tasksVC.appDelegate.saveContext()
        
        // Assert
        let newCount = try context.count(for: TaskMO.fetchRequest())
        XCTAssertEqual(newCount, initialCount + 1)
    }
    
    func testDeleteTask() throws {
        // Arrange
        let task = TaskMO(context: context)
        task.title = "Task to delete"
        tasksVC.appDelegate.saveContext()
        
        // Act
        let indexPath = IndexPath(row: 0, section: 0)
        tasksVC.todos = [task]
        tasksVC.deleteItem(at: indexPath)
        
        // Assert
        let count = try context.count(for: TaskMO.fetchRequest())
        XCTAssertEqual(count, 0)
    }
    
    // MARK: - ViewController Tests
    func testSearchFunctionality() throws {
        // Arrange
        let task1 = TaskMO(context: context)
        task1.title = "Buy milk"
        let task2 = TaskMO(context: context)
        task2.title = "Read book"
        tasksVC.todos = [task1, task2]
        
        // Act
        tasksVC.performSearch("milk")
        
        // Assert
        XCTAssertEqual(tasksVC.todos.count, 1)
        XCTAssertEqual(tasksVC.todos.first?.title, "Buy milk")
    }
    
    // MARK: - TaskEditViewController Tests
    
    func testTaskEditing() throws {
        // Arrange
        let task = TaskMO(context: context)
        task.title = "Original Title"
        task.subTitle = "Original Description"
        let tableView = UITableView()
        let editVC = TaskEditViewController(task: task, tableView)
        
        // Act
        editVC.loadViewIfNeeded()
        editVC.titleTextField.text = "Updated Title"
        editVC.descriptionTextField.text = "Updated Description"
        editVC.saveButtonAction(UIButton())
        
        // Assert
        XCTAssertEqual(task.title, "Updated Title")
        XCTAssertEqual(task.subTitle, "Updated Description")
    }
}
