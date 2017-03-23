//: Playground - noun: a place where people can play

import UIKit



// Dictionary

var dictionary = ["computer": " something to play Call of Duty on", "Coffee": "best drink ever"]

print (dictionary ["computer"]!)

print (dictionary.count)

dictionary["pen"] = "Old fashioned writing implement"

dictionary.removeValue(forKey: "computer")

print (dictionary)

var gameCharacters = [String: Decimal]()

gameCharacters["ghost"] = 8.7


// Challenge menu Pizza (10.99) Ice cream (4.99) Salad (7.99) print " the total cost of my meal is xxx"

let menu = ["pizza": 10.99, "ice cream": 4.99, "salad": 7.99]

print ("The total cost of my meal is \(menu["pizza"]! + menu["ice cream"]!)")



















var str = "Hello, playground"

var array  = [18, 23, 28]

print(array[0])

print(array.count)

//append adds on to the array
array.append(5)

//remove... removes a particualr item
array.remove(at: 1)

array.sort()

print(array)

// challenge 3.87, 7.1 8.9 remove 7.1 and append the product of then 3.87 and 8.9

var myArray = [3.87, 7.1, 8.9]

myArray.remove(at: 1)

myArray.append(myArray[0] * myArray[1])

//let mixArray = ["Awo", 18, true]

let stringArray = [String]() //create an array that will contain some string
















