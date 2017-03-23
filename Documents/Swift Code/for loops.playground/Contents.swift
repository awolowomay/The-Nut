//: Playground - noun: a place where people can play

import UIKit

let array = [8, 4, 8, 1]

for number in array {
    
    print(number)
    
}

//create an array with 4 names of friends/family print "hi there ---!"

let friends = ["Jesus", "Simay", "Maddie", "Gavin"]

for friends in friends {
    
    print ("Hi there " + friends + "!")
}


var numbers = [7, 2, 9, 4, 1]

for (index, value) in numbers.enumerated() {
    
    
    numbers[index] += 1
    
}

print (numbers)


// array containing 8, 7, 19, 28. Halve each of the values using for loop



var myArray = [8.0, 7.0, 19.0, 28.0]

for (index, value) in myArray.enumerated() {
    
    myArray[index] = value / 2

}

print (myArray)





