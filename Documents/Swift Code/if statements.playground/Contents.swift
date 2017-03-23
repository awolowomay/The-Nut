//: Playground - noun: a place where people can play

import UIKit

let age = 18

// Greater than or equal to

if age >= 18 {
    
    print ("You can play!")
    
} else {

    print ("You're too young")
}

// Check username

let name = "rob"

if name != "rob"{
    
    print ("Hi " + name + "! You can play")

} else {
    
    print ("Sorry, " + name + ", you can't play")
    
}

// 2 if statements with and

if name == "rob" && age >= 18 {
    
    print("you can play")
    
} else if name == "rob" {
    
    print("Sorry Rob, you need to get older")
}


// 2 if statements with or

if name == "rob" || name == "kirsten" {
    
    print ("Welcome " + name)
    
}

// Booleans with if statements

let isMale = true

if isMale {
    
    print("You're male!")
    
}

// Login system. username/password variables. 1. They are correct  2. they are both wrong 3. username is wrong 4. password is wrong

let username = "Awolowo"
let password = "eatmynut4321"

if username == "Awolowo" && password == "eatmynut4321" {
    
    print ("They are correct")

} else if username != "Awolowo" && password != "eatmynut4321" {
    
    print ("They are both wrong")

} else if username == "Awolowo" {
    
    print ("password is wrong")
    
} else  {
    
    print ("The username is wrong")
}

// random number

let diceRoll = arc4random_uniform(5)











