//
//  CreationViewController.swift
//  FlashcardApp
//
//  Created by Samuel Sandoval on 3/6/21.
//

import UIKit

class CreationViewController: UIViewController {
    var flashcardController: ViewController!
    @IBOutlet var questionTextField: UITextField!
    @IBOutlet var answerTextField: UITextField!
    var initialQuestion: String?
    var initialAnswer: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapOnDone(_ sender: Any) {
        let questionText = questionTextField.text
        let answerText = answerTextField.text

        if questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty {
            let alert = UIAlertController(title: "Missing text", message: "You need to enter both a question and an answer", preferredStyle: .alert)
            present(alert, animated: true)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            alert.addAction(okAction)
        }
        else {
            var isExisting = false
            if initialQuestion != nil {
                isExisting = true
            }
            flashcardController.updateFlashcard(question: questionText!, answer: answerText!, isExisting: isExisting)
            dismiss(animated: true)
        }
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
