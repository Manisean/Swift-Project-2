//
//  ViewController.swift
//  Project2
//
//  Created by Mark Hunnewell on 4/4/24.
//

import UIKit


struct Model {
    var tableviewSections: String
    var tableviewRows: [String]
    var tableviewDate: [String]
}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
}

class ViewController: UIViewController{
    
    var tableViewData = [Model]()
    var favNotes = [""]
    var normNotes: [String]?
    var plistPath: [String]?
    var date = Date()
    var normDateArr = [""]
    var favDateArr = [""]
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readPlist()

        normDateArr.removeFirst()
        favDateArr.removeFirst()
        favNotes.removeFirst()
        
        addFav()
        addOther()
        
        tableview.reloadData()
    }
     
    func readPlist() {
        let infoPlistPath = Bundle.main.path(forResource: "NotesList", ofType: "plist")
        let dict = NSArray(contentsOfFile: infoPlistPath!) as? [String]
        var tempArr = [""]
        
        plistPath = dict
        
        tempArr.removeAll()
        
        for note in plistPath! {
            tempArr.append(note)
        }
        
        normNotes = tempArr
    }
    
    @IBAction func reloadBtn(_ sender: UIButton) {
        self.tableViewData.removeAll()
        readPlist()
        addFav()
        addOther()
        tableview.reloadData()
    }
    
    @IBAction func newNoteAction(_ sender: UIButton) {
        let noteView = storyboard?.instantiateViewController(withIdentifier: "NoteVC") as! NoteController
        date = Date()
        normDateArr.append(date.formatted())
        present(noteView, animated: true)
    }
    
    func addFav() {
        self.tableViewData.append(Model(tableviewSections: "Favorites 💛", tableviewRows: favNotes , tableviewDate: favDateArr))
        print(favNotes)
    }
    
    func addOther() {
        self.tableViewData.append(Model(tableviewSections: "Other Notes", tableviewRows: normNotes ?? [""], tableviewDate: normDateArr))
        print(normNotes!)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func moveToFavorite(indexPath: IndexPath) {
        
        let note = normNotes![indexPath.row]
        let date = normDateArr[indexPath.row]
        
        favNotes.append(note)
        favDateArr.append(date)
        addFav()
    }
    
    func deleteCell(indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            favNotes.remove(at: indexPath.row)
            favDateArr.remove(at: indexPath.row)
            addFav()
            
        } else if indexPath.section == 1 {
            normNotes?.remove(at: indexPath.row)
            normDateArr.remove(at: indexPath.row)
            addOther()
        }
        
    }
    
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                        title: "Favourite") { [weak self] (action, view, completionHandler) in
            self?.moveToFavorite(indexPath: indexPath)
                                            completionHandler(true)
        }
        
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal,
                                       title: "Delete") { [weak self] (action, view, completionHandler) in
                                        self?.deleteCell(indexPath: indexPath)
                                        completionHandler(true)
        }
        
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData[section].tableviewRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTableViewCell
        
        cell.noteLabel?.text = tableViewData[indexPath.section].tableviewRows[indexPath.row]
        
        cell.dateLabel?.text = tableViewData[indexPath.section].tableviewDate[indexPath.row]
        
        print(indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = tableViewData[section].tableviewSections
        cell?.backgroundColor = .systemCyan
        cell?.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

