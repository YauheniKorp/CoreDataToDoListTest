//
//  ViewController.swift
//  CoreDataToDoList
//
//  Created by Admin on 17.02.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var models = [ToDoListItem]()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: MainTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "To Do List"
        view.addSubview(tableView)
        getAllItems()
        self.models = models.sorted { $0.check && !$1.check}
        tableView.delegate = self
        tableView.dataSource = self
        configureNavBar()
        
    }
    
    private func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItem))
    }
    
    @objc func addNewItem() {
        let alert = UIAlertController(title: "Add new item", message: "Enter name of new item:", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Name"
            textfield.autocorrectionType = .no
            textfield.autocapitalizationType = .none
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {return}
            self?.createItem(name: text)
            self?.models = self?.models.sorted { $0.check && !$1.check} ?? [ToDoListItem]()
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    private func getAllItems() {
        do {
            models = try context.fetch(ToDoListItem.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch  {
            // print error
        }
        
        
    }
    
    private func createItem(name: String) {
        let item = ToDoListItem(context: context)
        item.name = name
        item.createdAt = Date()
        item.check = false
        do {
            try context.save()
            self.getAllItems()
        } catch  {
            
        }
    }
    
    private func deleteItem(item: ToDoListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems()
        } catch  {
            
        }
    }
    
    private func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        
        do {
            try context.save()
            getAllItems()
            DispatchQueue.main.async {
                self.models = self.models.sorted { $0.check && !$1.check}
                self.tableView.reloadData()
            }
        } catch  {
            
        }
    }
    
    private func updateItem(item: ToDoListItem, state: Bool) {
        item.check = state
        do {
            try context.save()
            getAllItems()
        } catch  {
            
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
            
        }
        cell.configure(with: model)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            guard let model = self?.models[indexPath.row] else {return}
            let alert = UIAlertController(title: "Edit cell", message: "Enter new name", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = model.name
            
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {return}
                self?.updateItem(item: model, newName: newName)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true)
            
        }))
        
        sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let model = self?.models[indexPath.row] else {return}
            self?.deleteItem(item: model)
        }))
        
        present(sheet, animated: true)
    }
    
    
}

extension ViewController: MainTableViewCellDelegate {
    func checkDidTap(_ model: ToDoListItem) {
        
        updateItem(item: model, state: !model.check)
        self.models = self.models.sorted { $0.check && !$1.check}
        UIView.animate(withDuration: 1) {
            self.tableView.reloadData()
        }
        
    }
    
    
    
    
}
