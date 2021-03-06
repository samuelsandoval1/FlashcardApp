//
//  CreationViewController.swift
//  FlashcardApp
//
//  Created by Samuel Sandoval on 3/6/21.
//

import UIKit

class CreationViewController: UIViewController {
    
    var flashcardController: ViewController!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
        let questionText = questionTextField.text
        let answerText = answerTextField.text
        flashcardController.updateFlashcard(question: questionText!, answer: answerText!)
        dismiss(animated: true)
    }

    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
