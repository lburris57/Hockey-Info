//
//  DatabaseErrorEnum.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/27/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation

enum DatabaseErrorEnum: Error
{
    case saveToDatabase
    case readFromDatabase
}
