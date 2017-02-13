//
//  QuizVC.swift
//  TOEICPart5Quiz
//
//  Created by Tuan-Vi Phan on 4/2/16.
//  Copyright © 2016 Tuan-Vi Phan. All rights reserved.
//

import UIKit

class QuizVC: UIViewController {
    
    // MARK: - variables
    var questionsFullTest = [QuestionAndAnswer]()
    var questionsGetted = [QuestionAndAnswer]()
    var questionNow: QuestionAndAnswer!
    
    var totalQuestion: Int = 0
    var correctNumber: Int = 0
    var countQuestion: Int = 1
    
    var answerArrayCheck = ["", "", "", ""]
    
    // MARK: - Outlet
    
    @IBOutlet weak var correctNumberLabel: UILabel! // show how many questions is correct?
    @IBOutlet weak var countQuestionLabel: UILabel! // show how many questions is showed?
    @IBOutlet weak var questionLabel: UILabel! // This is question of sentence
    
    @IBOutlet weak var beginButtonLabel: UIButton!
    @IBOutlet weak var nextQuestionButtonLabel: UIButton!
    @IBOutlet weak var answer1ButtonLabel: UIButton!
    @IBOutlet weak var answer2ButtonLabel: UIButton!
    @IBOutlet weak var answer3ButtonLabel: UIButton!
    @IBOutlet weak var answer4ButtonLabel: UIButton!
    
    var swipeRight = UISwipeGestureRecognizer()
    var swipeLeft = UISwipeGestureRecognizer()
    
    // MARK: - Action
    
    @IBAction func beginButtonPressed(_ sender: UIButton) {
        
        print(questionsGetted.count)
        beginButtonLabel.isEnabled = false
        nextQuestionButtonLabel.isEnabled = false
        swipeRight.isEnabled = false
        questionNow = getOneQuestion()
        updateQuestionLabel()
    }

    @IBAction func nextQuestionButtonPressed(_ sender: UIButton) {
        
        countQuestion += 1
        nextQuestionButtonLabel.isEnabled = false
        swipeRight.isEnabled = false
        updateStateAnswers("normal")
        
        answer1ButtonLabel.isEnabled = true
        answer2ButtonLabel.isEnabled = true
        answer3ButtonLabel.isEnabled = true
        answer4ButtonLabel.isEnabled = true
        
        questionNow = getOneQuestion()
        
        updateQuestionLabel()
    }
    
    @IBAction func answer(_ sender: UIButton) {
        
        if answerArrayCheck[sender.tag] == "right" {
            
            print("You are correct!")
            correctNumber += 1
            correctNumberLabel.text = checkLabel("\(correctNumber)")
        } else {
            print("You are wrong!")
        }
        
        nextQuestionButtonLabel.isEnabled = true
        swipeRight.isEnabled = true
        
        updateStateAnswers("stateAnswer")
    }
    
    // MARK: - my func
    func getOneQuestion() -> QuestionAndAnswer {
        
        var question = QuestionAndAnswer(question: "", answerArray: ["", "", "", ""], answerCorrect: "")
        if questionsGetted.count > 0 {
            
            let random = Int(arc4random_uniform(UInt32(questionsGetted.count)))
            question = questionsGetted[random]
            questionsGetted.remove(at: random)
            totalQuestion += 1
        } else if questionsGetted.count == 0 {
            
            nextQuestionButtonLabel.setTitle("Finish", for: UIControlState())
            
            var messageString: String = "You got \(correctNumber) points"
            if correctNumber == totalQuestion {
                messageString += "\nYou are excellent!"
            }
            let alert = UIAlertController(title: "FINISHED", message: messageString, preferredStyle: UIAlertControllerStyle.actionSheet)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                self.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        return question
    }
    
    func getManyQuestions(_ originQuestions: [QuestionAndAnswer], numQuestion: Int) -> [QuestionAndAnswer] {
        
        var questions: [QuestionAndAnswer] = originQuestions
        var returnQuesttions: [QuestionAndAnswer] = [QuestionAndAnswer]()
        
        for _ in 1...numQuestion {
            let random = Int(arc4random_uniform(UInt32(questions.count)))
            returnQuesttions.append(questions[random])
            questions.remove(at: random)
        }

        print("You just get \(numQuestion) question")
        
        return returnQuesttions
    }
    
    func updateStateAnswers(_ state: String) {
        
        if state == "normal" {
            let blueeColor = UIColor(red: 0.000, green: 0.502, blue: 1.000, alpha: 1.00)
            answer1ButtonLabel.setTitleColor(blueeColor, for: UIControlState())
            answer2ButtonLabel.setTitleColor(blueeColor, for: UIControlState())
            answer3ButtonLabel.setTitleColor(blueeColor, for: UIControlState())
            answer4ButtonLabel.setTitleColor(blueeColor, for: UIControlState())
        }
        
        if state == "stateAnswer" {
            
            var checkColor = [UIColor(), UIColor(), UIColor(), UIColor()]
            for i in 0..<answerArrayCheck.count {
                checkColor[i] = (answerArrayCheck[i] == "right") ? UIColor.red : UIColor.gray
            }
            
            answer1ButtonLabel.setTitleColor(checkColor[0], for: UIControlState())
            answer2ButtonLabel.setTitleColor(checkColor[1], for: UIControlState())
            answer3ButtonLabel.setTitleColor(checkColor[2], for: UIControlState())
            answer4ButtonLabel.setTitleColor(checkColor[3], for: UIControlState())
            
            print(answerArrayCheck)
            answer1ButtonLabel.isEnabled = false
            answer2ButtonLabel.isEnabled = false
            answer3ButtonLabel.isEnabled = false
            answer4ButtonLabel.isEnabled = false
        }
    }
    
    func updateQuestionLabel() {
        
        countQuestionLabel.text = (countQuestion <= questionsFullTest.count) ? checkLabel("\(countQuestion)") : "00"
        
        questionLabel.text = self.questionNow.question
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: { () -> Void in
            self.questionLabel.alpha = 1.0
            self.questionLabel.center.x += self.view.bounds.width
            }, completion: nil)
        
        // mix array answer
        questionNow.answerArray.sort{(a,b) -> Bool in return arc4random()%2==0}
        
        answer1ButtonLabel.setTitle(questionNow.answerArray[0], for: UIControlState())
        answer2ButtonLabel.setTitle(questionNow.answerArray[1], for: UIControlState())
        answer3ButtonLabel.setTitle(questionNow.answerArray[2], for: UIControlState())
        answer4ButtonLabel.setTitle(questionNow.answerArray[3], for: UIControlState())
        UIView.animate(withDuration: 0.5, delay: 0.2, options: [], animations: { () -> Void in
            self.answer1ButtonLabel.alpha = 1.0
            self.answer1ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: { () -> Void in
            self.answer2ButtonLabel.alpha = 1.0
            self.answer2ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.4, options: [], animations: { () -> Void in
            self.answer3ButtonLabel.alpha = 1.0
            self.answer3ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: [], animations: { () -> Void in
            self.answer4ButtonLabel.alpha = 1.0
            self.answer4ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        
        for i in 0...questionNow.answerArray.count-1 {
            
            let q = questionNow.answerArray[i]
            print(questionNow.answerCorrect)
            
            answerArrayCheck[i] = (q == questionNow.answerCorrect) ? "right" : "wrong"
        }
        print(answerArrayCheck)
    }
    
    func hideLabelQuestionAndAnswer() {
        
        questionLabel.center.x -= view.bounds.width
        answer1ButtonLabel.center.x -= view.bounds.width
        answer2ButtonLabel.center.x -= view.bounds.width
        answer3ButtonLabel.center.x -= view.bounds.width
        answer4ButtonLabel.center.x -= view.bounds.width
        
        questionLabel.alpha = 0.0
        answer1ButtonLabel.alpha = 0.0
        answer2ButtonLabel.alpha = 0.0
        answer3ButtonLabel.alpha = 0.0
        answer4ButtonLabel.alpha = 0.0
    }
    
    func checkLabel(_ label: String) -> String {
        
        let newLabel: String!
        
        newLabel = (label.characters.count == 1) ? "0\(label)" : label
        
        return newLabel
    }
    
    func swipeLeftToQuit() {
        let messageString: String = "Do you want to cancel the test?"
        let alert = UIAlertController(title: "!ALERT!", message: messageString, preferredStyle: UIAlertControllerStyle.actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()

        questionsGetted = getManyQuestions(questionsFullTest, numQuestion: questionsFullTest.count)
        
        updateStateAnswers("normal")
        hideLabelQuestionAndAnswer()
        
        swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(QuizVC.nextQuestionButtonPressed))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(QuizVC.swipeLeftToQuit))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        beginButtonLabel.isEnabled = true
        nextQuestionButtonLabel.isEnabled = false
        swipeRight.isEnabled = false
    }

}
