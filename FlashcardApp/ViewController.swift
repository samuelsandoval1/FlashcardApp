//
//  ViewController.swift
//  FlashcardApp
//
//  Created by Samuel Sandoval on 2/13/21.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {
    @IBOutlet var frontLabel: UILabel!
    @IBOutlet var backLabel: UILabel!

    @IBOutlet var nextButton: UIButton!
    @IBOutlet var prevButton: UIButton!
    @IBOutlet var card: UIView!
    
    var flashcards = [Flashcard]() // Array holding flashcards
    var currentIndex = 0 // current flash card index

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the capital of Brazil", answer: "Brasilia", isExisting: false)
            //  prevButton.isEnabled = false
        }
        else {
            updateLabels()
            updateNextPrevButtons()
        }
        card.layer.cornerRadius = 20.0
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        backLabel.layer.cornerRadius = 20.0
        backLabel.clipsToBounds = true
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // First start with the flashcard invisible and slightly smaller in size
        card.alpha = 0.0
            
        // Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
                  
            self.card.transform = CGAffineTransform.identity
              
        })
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        updateNextPrevButtons()
        animateCardOut(buttonType: "next")
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        if currentIndex >= 0 {
            updateNextPrevButtons()
            animateCardOut(buttonType: "prev")
        }
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete it?", preferredStyle: .actionSheet)
        present(alert, animated: true)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
    }

    func deleteCurrentFlashcard() {
        flashcards.remove(at: currentIndex)
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count - 1
        }
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            if self.frontLabel.isHidden == false {
                self.frontLabel.isHidden = true
            }
            else {
                self.frontLabel.isHidden = false
            }
        })
    }
    
    func animateCardOut(buttonType: String) {
        UIView.animate(withDuration: 0.3, animations: {
            if buttonType == "next" {
                self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
            }
            else {
                self.card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
            }
        }, completion: { _ in
            // update labels
            self.updateLabels()
            // run other animation
            self.animateCardIn(buttonType: buttonType)
        })
    }
    
    func animateCardIn(buttonType: String) {
        // Start on the right side
        if buttonType == "next" {
            card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        }
        else {
            card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    func updateFlashcard(question: String, answer: String, isExisting: Bool) {
        let flashcard = Flashcard(question: question, answer: answer)
        
        if isExisting {
            flashcards[currentIndex] = flashcard
        }
        else {
            flashcards.append(flashcard)
            
            print("😎 Added new flashcard")
            print("😎 We now have \(flashcards.count) flashcards")
            
            currentIndex = flashcards.count - 1
            print("😎 Our current index is \(currentIndex)")
        }
        updateNextPrevButtons()
        updateLabels()
    }
    
    func updateNextPrevButtons() {
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
            prevButton.isEnabled = true
        }
        else {
            nextButton.isEnabled = true
            if currentIndex == 0 {
                prevButton.isEnabled = false
            }
        }
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk() {
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            ["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        print("🎉 Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardController = self

        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }
    }
}
