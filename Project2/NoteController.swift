//
//  NoteController.swift
//  Project2
//
//  Created by Mark Hunnewell on 4/6/24.
//

import SwiftUI

class NoteController: UIViewController, UITextViewDelegate {
    var plistPath: [String]?
    
    let placeholder = "Note text here..."
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        textView.text = placeholder
        textView.textColor = .lightGray
        
        readPlist()
    }
    
    func readPlist() {
        let infoPlistPath = Bundle.main.path(forResource: "NotesList", ofType: "plist")
        let dict = NSArray(contentsOfFile: infoPlistPath!) as? [String]
        
        plistPath = dict
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = .lightGray
        }
    }
    
    
    @IBAction func saveNote(_ sender: UIButton) {
        
        let text = textView.text!
        
        do {
            let url = Bundle.main.url(forResource: "NotesList", withExtension: "plist")
            
            plistPath!.append(text)
            
            let data = try PropertyListSerialization.data(fromPropertyList: plistPath!, format: .xml, options: 0)
            try data.write(to: url!, options: [.atomic, .completeFileProtection])
            
        } catch {print("ERROR")}
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    
}
