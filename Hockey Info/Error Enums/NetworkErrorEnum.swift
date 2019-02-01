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
