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
    
    // MARK: - Action
    
    @IBAction func beginButtonPressed(sender: UIButton) {
        
        print(questionsGetted.count)
        beginButtonLabel.enabled = false
        nextQuestionButtonLabel.enabled = false
        questionNow = getOneQuestion()
        updateQuestionLabel()
    }

    @IBAction func nextQuestionButtonPressed(sender: UIButton) {
        
        countQuestion++
        nextQuestionButtonLabel.enabled = false
        updateStateAnswers("normal")
        
        answer1ButtonLabel.enabled = true
        answer2ButtonLabel.enabled = true
        answer3ButtonLabel.enabled = true
        answer4ButtonLabel.enabled = true
        
        questionNow = getOneQuestion()
        
        updateQuestionLabel()
    }
    
    @IBAction func answer(sender: UIButton) {
        
        if answerArrayCheck[sender.tag] == "right" {
            
            print("You are correct!")
            correctNumber++
            correctNumberLabel.text = checkLabel("\(correctNumber)")
        } else {
            print("You are wrong!")
        }
        
        nextQuestionButtonLabel.enabled = true
        
        updateStateAnswers("stateAnswer")
    }
    
    // MARK: - my func
    func getOneQuestion() -> QuestionAndAnswer {
        
        var question = QuestionAndAnswer(question: "", answerArray: ["", "", "", ""], answerCorrect: "")
        if questionsGetted.count > 0 {
            
            let random = Int(arc4random_uniform(UInt32(questionsGetted.count)))
            question = questionsGetted[random]
            questionsGetted.removeAtIndex(random)
            totalQuestion++
        } else if questionsGetted.count == 0 {
            
            nextQuestionButtonLabel.setTitle("Finish", forState: .Normal)
            
            var messageString: String = "You got \(correctNumber) points"
            if correctNumber == totalQuestion {
                messageString += "\nYou are excellent!"
            }
            let alert = UIAlertController(title: "You have finished your test", message: messageString, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { _ in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        
        return question
    }
    
    func getManyQuestions(originQuestions: [QuestionAndAnswer], numQuestion: Int) {
        
        var questions = originQuestions
        for _ in 1...numQuestion {
            
            let random = Int(arc4random_uniform(UInt32(questions.count)))
            questionsGetted.append(questions[random])
            questions.removeAtIndex(random)
        }
        
        totalQuestion = 0

        print("You just get \(numQuestion) question")
    }
    
    func updateStateAnswers(state: String) {
        
        if state == "normal" {
            let blueeColor = UIColor(red: 0.000, green: 0.502, blue: 1.000, alpha: 1.00)
            answer1ButtonLabel.setTitleColor(blueeColor, forState: .Normal)
            answer2ButtonLabel.setTitleColor(blueeColor, forState: .Normal)
            answer3ButtonLabel.setTitleColor(blueeColor, forState: .Normal)
            answer4ButtonLabel.setTitleColor(blueeColor, forState: .Normal)
        }
        
        if state == "stateAnswer" {
            
            var checkColor = [UIColor(), UIColor(), UIColor(), UIColor()]
            for i in 0..<answerArrayCheck.count {
                if answerArrayCheck[i] == "right" {
                    checkColor[i] = UIColor.redColor()
                } else {
                    checkColor[i] = UIColor.grayColor()
                }
            }
            
            answer1ButtonLabel.setTitleColor(checkColor[0], forState: .Normal)
            answer2ButtonLabel.setTitleColor(checkColor[1], forState: .Normal)
            answer3ButtonLabel.setTitleColor(checkColor[2], forState: .Normal)
            answer4ButtonLabel.setTitleColor(checkColor[3], forState: .Normal)
            
            print(answerArrayCheck)
            answer1ButtonLabel.enabled = false
            answer2ButtonLabel.enabled = false
            answer3ButtonLabel.enabled = false
            answer4ButtonLabel.enabled = false
        }
    }
    
    func updateQuestionLabel() {
        
        countQuestionLabel.text = checkLabel("\(countQuestion)")
        
        questionLabel.text = self.questionNow.question
        UIView.animateWithDuration(0.5, delay: 0.1, options: [], animations: { () -> Void in
            self.questionLabel.alpha = 1.0
            self.questionLabel.center.x += self.view.bounds.width
            }, completion: nil)
        
        // mix array answer
        questionNow.answerArray.sortInPlace{(a,b) -> Bool in return rand()%2==0}
        
        answer1ButtonLabel.setTitle(questionNow.answerArray[0], forState: .Normal)
        answer2ButtonLabel.setTitle(questionNow.answerArray[1], forState: .Normal)
        answer3ButtonLabel.setTitle(questionNow.answerArray[2], forState: .Normal)
        answer4ButtonLabel.setTitle(questionNow.answerArray[3], forState: .Normal)
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations: { () -> Void in
            self.answer1ButtonLabel.alpha = 1.0
            self.answer1ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations: { () -> Void in
            self.answer2ButtonLabel.alpha = 1.0
            self.answer2ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations: { () -> Void in
            self.answer3ButtonLabel.alpha = 1.0
            self.answer3ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.2, options: [], animations: { () -> Void in
            self.answer4ButtonLabel.alpha = 1.0
            self.answer4ButtonLabel.center.x += self.view.bounds.width
            }, completion: nil)
        
        for i in 0...questionNow.answerArray!.count-1 {
            
            let q = questionNow.answerArray[i]
            if q == questionNow.answerCorrect! {
                answerArrayCheck[i] = "right"
            } else {
                answerArrayCheck[i] = "wrong"
            }
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
    
    func checkLabel(label: String) -> String {
        
        let newLabel: String!
        if label.characters.count == 1 {
            newLabel = "0\(label)"
        } else {
            newLabel = label
        }
        
        return newLabel
    }
    
    // MARK: - viewDid
    override func viewDidLoad() {
        super.viewDidLoad()

        getManyQuestions(questionsFullTest, numQuestion: 40)
        
        beginButtonLabel.enabled = true
        
        print(questionsFullTest.count)
        updateStateAnswers("normal")
        hideLabelQuestionAndAnswer()
    }

}
