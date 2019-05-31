//
//  GigsDetailViewController.swift
//  Gigs
//
//  Created by Michael Stoffer on 5/28/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class GigsDetailViewController: UIViewController {
    
    // MARK: - @IBOutlets and Properties
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dueDatePicker: UIDatePicker!
    @IBOutlet var descriptionTextView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
    }
    
    // MARK: - @IBActions and Methods
    @IBAction func saveGig(_ sender: UIBarButtonItem) {
        guard let title = self.titleTextField.text,
            let description = self.descriptionTextView.text else { return }
        let dueDate = self.dueDatePicker.date
        
        self.gigController.createGig(withTitle: title, withDescription: description, withDueDate: dueDate) { (_) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateViews() {
        if let gig = self.gig {
            self.titleTextField.text = gig.title
            self.descriptionTextView.text = gig.description
            self.dueDatePicker.date = gig.dueDate
        } else {
            self.title = "New Gig"
        }
    }
}
