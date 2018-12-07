//
//  Extensions.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/7/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import Foundation

extension String
{
    func fromBase64() -> String?
    {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else
        {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String?
    {
        guard let data = self.data(using: String.Encoding.utf8) else
        {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

extension Int: Sequence
{
    public func makeIterator() -> CountableRange<Int>.Iterator
    {
        return (0..<self).makeIterator()
    }
}
