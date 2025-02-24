//
//  TaskEditViewController + Extensions.swift
//  To Do List
//
//  Created by Alina Kazantseva on 2/23/25.
//

import UIKit

//MARK: - TaskEditViewController Methods
extension TaskEditViewController {
    func stackViewConfig() {
        //Calling all of the configuration methods
        titleLabelConfig()
        titleTextFieldConfig()
        descriptionLabelConfig()
        descriptionTextFieldConfig()
        
        //Adding each UI element on the stackView
        [titleLabel, titleTextField, descriptionLabel, descriptionTextField].forEach { stackView.addArrangedSubview($0) }
        
        //Setting additional configuration parameters for stackView
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        //Constraints
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func titleLabelConfig() {
        titleLabel.text = "Change your task's title ⬇️"
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 17)
    }
    
    func titleTextFieldConfig() {
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = task.title
        titleTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
        titleTextField.leftViewMode = .always
        titleTextField.layer.borderColor = UIColor.black.cgColor
        
        //Constraints
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func descriptionLabelConfig() {
        descriptionLabel.text =  "Change your task's description ⬇️"
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.font = .boldSystemFont(ofSize: 17)
    }
    
    func descriptionTextFieldConfig() {
        descriptionTextField.borderStyle = .roundedRect
        descriptionTextField.placeholder = task.subTitle
        descriptionTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 0))
        descriptionTextField.leftViewMode = .always
        descriptionTextField.layer.borderColor = UIColor.black.cgColor
        
        //Constraints
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func saveButtonConfig() {
        saveButton.setTitle("Save changes", for: .normal)
        saveButton.setTitleColor(Colors.middleBlue, for: .normal)
        saveButton.backgroundColor = Colors.lightBlue
        saveButton.titleLabel!.font = .boldSystemFont(ofSize: 17)
        saveButton.layer.cornerRadius = 15
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        
        //Constraints
        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 130),
            saveButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func tapGestureConfig() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func saveButtonAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.saveButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self?.saveButton.backgroundColor = Colors.darkLightBlue
        }, completion: { [weak self] _ in
            UIView.animate(withDuration: 0.1) {
                self?.saveButton.transform = CGAffineTransform.identity
                self?.saveButton.backgroundColor = Colors.lightBlue
            }
        })
        task.title = titleTextField.text!.isEmpty ? task.title : titleTextField.text
        task.subTitle = descriptionTextField.text!.isEmpty ? task.subTitle : descriptionTextField.text
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    @objc private func tapGestureAction(_ sender: Any) {
        titleTextField.resignFirstResponder()
        descriptionTextField.resignFirstResponder()
    }
}
