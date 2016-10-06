//
//  ViewController.swift
//  SwiftCalc
//
//  Created by Zach Zeleznick on 9/20/16.
//  Copyright © 2016 zzeleznick. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // MARK: Width and Height of Screen for Layout
    var w: CGFloat!
    var h: CGFloat!
    

    // IMPORTANT: Do NOT modify the name or class of resultLabel.
    //            We will be using the result label to run autograded tests.
    // MARK: The label to display our calculations
    var resultLabel = UILabel()
    
    // TODO: This looks like a good place to add some data structures.
    //       One data structure is initialized below for reference.
    var someDataStructure: [String] = [""]
    var inputContainsDot: Bool = false
    var input: String = ""
    var previousTerm: Double = 0
    var currentTerm: Double?
    var previousOperator: String = ""
    var tempInput: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        w = view.bounds.size.width
        h = view.bounds.size.height
        navigationItem.title = "Calculator"
        // IMPORTANT: Do NOT modify the accessibilityValue of resultLabel.
        //            We will be using the result label to run autograded tests.
        resultLabel.accessibilityValue = "resultLabel"
        makeButtons()
        // Do any additional setup here.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TODO: A method to update your data structure(s) would be nice.
    //       Modify this one or create your own.
    func updateSomeDataStructure(_ content: String) {
        print("Update me like one of those PCs")
    }
    
    func clearInput() {
        input = ""
        inputContainsDot = false
    }
    
    func displayDouble(number previousTerm: Double) -> String {
        var displayResult: String = "\(previousTerm)"
        if displayResult.hasSuffix(".0") {
            displayResult = displayResult[displayResult.startIndex..<displayResult.index(displayResult.endIndex, offsetBy: -2)]
        }
        if displayResult.characters.count > 7 {
            return displayResult[displayResult.startIndex..<displayResult.index(displayResult.startIndex, offsetBy: 7)]
        }
        return displayResult
    }
    
    // TODO: Ensure that resultLabel gets updated.
    //       Modify this one or create your own.
    func updateResultLabel(_ content: String) {
        print("Update me like one of those PCs")
        resultLabel.text = content
    }
    
    // TODO: A calculate method with no parameters, scary!
    //       Modify this one or create your own.
    func calculate() -> Double {
        guard !previousOperator.isEmpty else { return 0 }
//        let secondTerm: Double = Double(input) ?? 0
        let secondTerm: Double = currentTerm ?? 0
        if previousOperator == "+" {
            previousOperator = ""
            return previousTerm + secondTerm
        } else if previousOperator == "-" {
            previousOperator = ""
            return previousTerm - secondTerm
        } else if previousOperator == "*" {
            previousOperator = ""
            return previousTerm * secondTerm
        } else if previousOperator == "/" {
            previousOperator = ""
            return previousTerm / secondTerm
        }
        return 0
    }
    
    // TODO: A simple calculate method for integers.
    //       Modify this one or create your own.
    func intCalculate(a: Int, b:Int, operation: String) -> Int {
        print("Calculation requested for \(a) \(operation) \(b)")
        return 0
    }
    
    // TODO: A general calculate method for doubles
    //       Modify this one or create your own.
    func calculate(a: String, b:String, operation: String) -> Double {
        print("Calculation requested for \(a) \(operation) \(b)")
        return 0.0
    }
    
    // REQUIRED: The responder to a number button being pressed.
    func numberPressed(_ sender: CustomButton) {
        guard Int(sender.content) != nil else { return }
        guard input.characters.count < 7 else { return }
        print("The number \(sender.content) was pressed")
        // Fill me in!
        input = input + sender.content
        updateResultLabel(input)
        currentTerm = Double(input)
    }
    
    // REQUIRED: The responder to an operator button being pressed.
    func operatorPressed(_ sender: CustomButton) {
        // Fill me in!
        print("The operator \(sender.content) was pressed")
        // c
        if sender.content.caseInsensitiveCompare("c") == ComparisonResult.orderedSame {
            clearInput()
            updateResultLabel("0")
            return
        // ac
        } else if sender.content.caseInsensitiveCompare("ac") == ComparisonResult.orderedSame {
            previousTerm = 0
            previousOperator = ""
            clearInput()
            updateResultLabel("0")
            return
        // +/-
        } else if sender.content == "+/-" {
            if !input.isEmpty {
                if currentTerm ?? 0 <= 0 {
                    currentTerm = -(currentTerm ?? 0)
                    input = displayDouble(number: currentTerm!)
                } else if currentTerm ?? 0 > 0 && input.characters.count < 7 {
                    input = "-" + input
                    currentTerm = Double(input)!
                } else { return }
            } else if currentTerm ?? 0 <= 0 || (currentTerm ?? 0 > 0 && displayDouble(number: currentTerm ?? 0).characters.count < 7) {
                currentTerm = -(currentTerm ?? 0)
                updateResultLabel(displayDouble(number: currentTerm!))
            }
            return
        // %
        } else if sender.content == "%" {
            if !input.isEmpty {
                currentTerm = currentTerm ?? 0 / 100
                input = displayDouble(number: currentTerm!)
                updateResultLabel(input)
            } else {
                currentTerm = currentTerm ?? 0 / 100
                updateResultLabel(displayDouble(number: currentTerm!))
            }
            return
        // +, -, *, /, =
        } else if !previousOperator.isEmpty && currentTerm != nil { // if for a (op) b, a, b, and op all available
            // finish previous calculation
            // store result in previousTerm
            previousTerm = calculate()
            currentTerm = previousTerm
            // store operator in previous operator
            if ["+", "-", "*", "/"].contains(sender.content) {
                // + - * /
                previousOperator = sender.content
            } else {
                // =
                previousOperator = ""
            }
            // clean input, inputContainsDot
            clearInput()
            // update resultLabel with the result of previous calculation (previousTerm)
            if currentTerm! < 1e7 {
                updateResultLabel(displayDouble(number: currentTerm!))
            } else {
                // TODO: scientific notation
            }
            return
        // a = a or waiting for second term
        } else if previousOperator.isEmpty && currentTerm != nil {
            // store input in previousTerm
            previousTerm = currentTerm!
            //store operator in previous operator
            previousOperator = sender.content
            //clean input, inputContainsDot
            clearInput()
            currentTerm = nil
            return
        } else if currentTerm == nil {
            previousOperator = sender.content
            return
        }
    }
    
    // REQUIRED: The responder to a number or operator button being pressed.
    func buttonPressed(_ sender: CustomButton) {
       // Fill me in!
        print("The button \(sender.content) was pressed")
        if (sender.content == ".") {
            guard !inputContainsDot else { return }
            guard input.characters.count < 7 else { return }
            if input.isEmpty {
                input = "0"
            }
            input += sender.content
            inputContainsDot = true
            updateResultLabel(input)
        } else if sender.content == "0" {
            if input.isEmpty {
                updateResultLabel("0")
            }
        }
        currentTerm = Double(input) ?? 0
    }
    
    // IMPORTANT: Do NOT change any of the code below.
    //            We will be using these buttons to run autograded tests.
    
    func makeButtons() {
        // MARK: Adds buttons
        let digits = (1..<10).map({
            return String($0)
        })
        let operators = ["/", "*", "-", "+", "="]
        let others = ["C", "+/-", "%"]
        let special = ["0", "."]
        
        let displayContainer = UIView()
        view.addUIElement(displayContainer, frame: CGRect(x: 0, y: 0, width: w, height: 160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }
        displayContainer.addUIElement(resultLabel, text: "0", frame: CGRect(x: 70, y: 70, width: w-70, height: 90)) {
            element in
            guard let label = element as? UILabel else { return }
            label.textColor = UIColor.white
            label.font = UIFont(name: label.font.fontName, size: 60)
            label.textAlignment = NSTextAlignment.right
        }
        
        let calcContainer = UIView()
        view.addUIElement(calcContainer, frame: CGRect(x: 0, y: 160, width: w, height: h-160)) { element in
            guard let container = element as? UIView else { return }
            container.backgroundColor = UIColor.black
        }

        let margin: CGFloat = 1.0
        let buttonWidth: CGFloat = w / 4.0
        let buttonHeight: CGFloat = 100.0
        
        // MARK: Top Row
        for (i, el) in others.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Second Row 3x3
        for (i, digit) in digits.enumerated() {
            let x = (CGFloat(i%3) + 1.0) * margin + (CGFloat(i%3) * buttonWidth)
            let y = (CGFloat(i/3) + 1.0) * margin + (CGFloat(i/3) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: digit), text: digit,
            frame: CGRect(x: x, y: y+101.0, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(numberPressed), for: .touchUpInside)
            }
        }
        // MARK: Vertical Column of Operators
        for (i, el) in operators.enumerated() {
            let x = (CGFloat(3) + 1.0) * margin + (CGFloat(3) * buttonWidth)
            let y = (CGFloat(i) + 1.0) * margin + (CGFloat(i) * buttonHeight)
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: y, width: buttonWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.backgroundColor = UIColor.orange
                button.setTitleColor(UIColor.white, for: .normal)
                button.addTarget(self, action: #selector(operatorPressed), for: .touchUpInside)
            }
        }
        // MARK: Last Row for big 0 and .
        for (i, el) in special.enumerated() {
            let myWidth = buttonWidth * (CGFloat((i+1)%2) + 1.0) + margin * (CGFloat((i+1)%2))
            let x = (CGFloat(2*i) + 1.0) * margin + buttonWidth * (CGFloat(i*2))
            calcContainer.addUIElement(CustomButton(content: el), text: el,
            frame: CGRect(x: x, y: 405, width: myWidth, height: buttonHeight)) { element in
                guard let button = element as? UIButton else { return }
                button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            }
        }
    }

}

