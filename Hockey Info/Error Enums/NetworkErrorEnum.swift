//
//  NetworkErrorEnum.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/26/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation

enum NetworkErrorEnum: Error
{
    case retrieveData
    case decodeJSON
    case unableToConnect
}

/*
 enum DivisionError: Error {
 case zeroDivisor
 }
 
 extension DivisionError: LocalizedError {
 public var errorDescription: String? {
 switch self {
 case .zeroDivisor:
 return "Division by zero is quite problematic. " +
 "(https://en.wikipedia.org/wiki/Division_by_zero)"
 }
 }
 }
 
 func divide(_ x: Int, by y: Int) throws -> Int {
 guard y != 0 else {
 throw DivisionError.zeroDivisor
 }
 return x / y
 }
 
 
 
 
 
 
 
 do {
 let number = try divide(10, by: 0)
 print(number)
 }
 catch let error as DivisionError {
 print("Division error handler block")
 print(error.localizedDescription)
 }
 catch {
 print("Generic error handler block")
 print(error.localizedDescription)
 }
 
 
 
 
 
 Swift 5 Result type:
 
 func divide(_ x: Int, by y: Int, completion: (Result<Int, DivisionError>) -> Void) {
 guard y != 0 else {
 return completion(.failure(.zeroDivisor))
 }
 completion(.success(x / y))
 }
 
 divide(10, by: 0) { result in
 switch result {
 case .success(let number):
 print(number)
 case .failure(let error):
 print(error.localizedDescription)
 }
 }
 
 */
