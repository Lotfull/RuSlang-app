//
//  CreateEditWordVC.swift
//  SlangApp
//
//  Created by Kam Lotfull on 31.05.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol CreateWordVCDelegate: class {
    func createEditWordVCDidCancel(_ controller: CreateEditWordVC)
    func createEditWordVCDone(_ controller: CreateEditWordVC, adding word: Word)
    func createEditWordVCDone(_ controller: CreateEditWordVC, editing word: Word)
}

class CreateEditWordVC: UITableViewController {
    // MARK: - MAIN FUNCS
    override func viewDidLoad() {
        super.viewDidLoad()
        if let word = editingWord {
            title = "Edit \(word.name)"
            nameField.text = word.name
            definitionField.text = word.definition
            groupField.text = word.group
            typeField.text = word.type
            examplesTextView.text = word.examples
            originTextView.text = word.origin
            hashtagsField.text = word.hashtags
            synonymsField.text = word.synonyms
            favoriteSwitch.isOn = word.favorite
            doneBarButton.isEnabled = true
        }
        title = editingWord != nil ? editingWord!.name : "Добавить слово"
    }
    
    weak var delegate: CreateWordVCDelegate?
    
    // MARK: - TABLEVIEW FUNCS
    
    func reloading(_ controller: WordDetailTableViewCell, indexPath: IndexPath) {
        do {
            try managedObjectContext.save()
        } catch {
            print ("There was managedObjectContext.save() error")
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: - @IBO and @IBA
    
    
    
    // MARK: - VARS and LETS
    var managedObjectContext: NSManagedObjectContext!
    var editingWord: Word?
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var definitionField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var groupField: UITextField!
    @IBOutlet weak var synonymsField: UITextField!
    @IBOutlet weak var originTextView: UITextView!
    @IBOutlet weak var examplesTextView: UITextView!
    @IBOutlet weak var hashtagsField: UITextField!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameField.becomeFirstResponder()
    }
    
    @IBAction func cancel() {
        delegate?.createEditWordVCDidCancel(self)
    }
    @IBAction func done() {
        //needToUpdate = true
        if let word = editingWord {
            word.name = nameField.text!
            word.definition = definitionField.text!
            word.group = groupField.text
            word.type = typeField.text
            word.examples = examplesTextView.text
            word.origin = originTextView.text
            word.hashtags = hashtagsField.text
            word.synonyms = synonymsField.text
            word.favorite = favoriteSwitch.isOn
            delegate?.createEditWordVCDone(self, editing: word)
        } else {
            let word = Word(context: managedObjectContext)
            word.name = nameField.text!
            word.definition = definitionField.text!
            word.group = groupField.text
            word.type = typeField.text
            word.examples = examplesTextView.text
            word.origin = originTextView.text
            word.hashtags = hashtagsField.text
            word.synonyms = synonymsField.text
            word.favorite = favoriteSwitch.isOn
            delegate?.createEditWordVCDone(self, adding: word)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneBarButton.isEnabled = (newText.length > 0)
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
    
    
    
    
    
    
    
    
    
    
    

}