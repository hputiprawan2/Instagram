//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Hanna Guest on 12/27/20.
//

import UIKit

struct EditProfileFormModel {
    let label: String
    let placeholder: String
    var value: String? // current value of the field - var because should be able to change as user types
}

final class EditProfileViewController: UIViewController, UITableViewDataSource {


    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FormTableViewCell.self,
                           forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()

    private var models = [[EditProfileFormModel]]() // 2 sections
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = createTableHeaderView()
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        configureModel()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didTapCancel))
    }
    
    private func configureModel() {
        // name, username, website, bio
        let section1Labels = ["Name", "Username", "Website", "Bio"]
        var section1 = [EditProfileFormModel]()
        for label in section1Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            section1.append(model)
        }
        models.append(section1)
        
        // email, phone, gender
        let section2Labels = ["Email", "Phone", "Gender"]
        var section2 = [EditProfileFormModel]()
        for label in section2Labels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            section2.append(model)
        }
        models.append(section2)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private Information"
    }
    
    private func createTableHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height / 4).integral) //.integral = round up
        let size = header.height / 1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width - size) / 2,
                                                        y: (header.height - size) / 2,
                                                        width: size,
                                                        height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true // rounded button
        profilePhotoButton.layer.cornerRadius = size / 2.0
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self,
                                     action: #selector(didTapProfilePhotoButton),
                                     for: .touchUpInside)
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        return header
    }
    
    // MARK: - Action
    
    @objc private func didTapSave() {
        // Save info to the DB
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChangeProfilePicture() {
        // Let user choose between taking a new picture or pick from the camera roll
        let actionSheet = UIAlertController(title: "Profile Picture", message: "Change Profile Picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // On iPad the activity view controller will be displayed as a popover, otherwise will crash
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }
    
    @objc private func didTapProfilePhotoButton() {
        
    }
}
