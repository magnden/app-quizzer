//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {
    
    let allQuestions = QuestionBank()
    var pickedAnswer: Bool = false
    var questionNumber: Int = 0
    var score: Int = 0
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextQuestion()
    }


    @IBAction func answerPressed(_ sender: AnyObject) {
        
        // Set picked answer based on button that was pressed
        if sender.tag == 1 {
            pickedAnswer = true
        } else if sender.tag == 2 {
            pickedAnswer = false
        }
        
        checkAnswer()
        
        questionNumber += 1
        
        nextQuestion()
    }
    
    
    func updateUI() {
        
        scoreLabel.text = "Score: \(score)"
        progressLabel.text = "\(questionNumber + 1) / \(allQuestions.list.count)"
        UIView.animate(withDuration: 0.3) {
            self.progressBar.frame.size.width = (self.view.frame.size.width / 13) * CGFloat(self.questionNumber + 1)
        }
        
        
    }
    

    func nextQuestion() {
        if questionNumber <= allQuestions.list.count - 1 {
            questionLabel.text = allQuestions.list[questionNumber].questionText
            
            updateUI()
            
        } else {
            
            let alert = UIAlertController(title: createTitleForAlert(), message: "You scored a \(score) / \(allQuestions.list.count) Do you want to start over?", preferredStyle: .alert)
            
            let restartAction = UIAlertAction(title: "Restart", style: .default, handler: { (UIAlertAction) in
                self.startOver()
            })
            
            alert.addAction(restartAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func checkAnswer() {
        
        let correctAnswer = allQuestions.list[questionNumber].answer
        if correctAnswer == pickedAnswer {
            print("You got it!")
            SVProgressHUD.showSuccess(withStatus: "Correct!")
            SVProgressHUD.dismiss(withDelay: 1.0)
            score += 1
        } else {
            print("Wrong!")
            SVProgressHUD.showSuccess(withStatus: "Wrong!")
            SVProgressHUD.dismiss(withDelay: 0.3)
        }
        
    }
    
    
    func startOver() {
        questionNumber = 0
        score = 0
        nextQuestion()
    }
    
    func createTitleForAlert() -> String{
        let title: String
        // Check if user got more than 80% correct
        if score >= Int(round(0.8 * CGFloat(allQuestions.list.count))) {
            title = "You did Great!"
        }
        // Check if user got more than 60% correct
        else if score >= Int(round(0.6 * CGFloat(allQuestions.list.count))) {
            title = "You did Good!"
        }
        // Check if user got more than 40% correct
        else if score >= Int(round(0.4 * CGFloat(allQuestions.list.count))){
            title = "You did OK"
        }
        // Less than 40% correct
        else {
            title = "You didn't do so well"
        }
        return title
    }
    

    
}
