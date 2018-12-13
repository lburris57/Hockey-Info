//
//  DisplayPlayerViewController.swift
//  Hockey Info
//
//  Created by Larry Burris on 12/12/18.
//  Copyright © 2018 Larry Burris. All rights reserved.
//
import UIKit
import RealmSwift
import Kingfisher

class DisplayPlayerViewController: UIViewController
{
    @IBOutlet weak var teamLogo: UIImageView!
    @IBOutlet weak var jerseyNumber: UILabel!
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var birthCty: UILabel!
    @IBOutlet weak var birthCountry: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var shoots: UILabel!
    @IBOutlet weak var shootsLabel: UILabel!
    @IBOutlet weak var position: UILabel!
    
    var playerResult: NHLPlayer?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let player = playerResult
        {
            let dateOfBirth = player.birthDate
            
            if(!dateOfBirth.isEmpty)
            {
                let month = dateOfBirth.slicing(from: 5, length: 2)
                let day = dateOfBirth.slicing(from: 8, length: 2)
                let year = dateOfBirth.slicing(from: 0, length: 4)
                
                birthDate.text = month! + "/" + day! + "/" + year!
            }
            else
            {
                birthDate.text = ""
            }
            
            teamLogo.image = UIImage(named: player.teamAbbreviation)
            jerseyNumber.text = player.jerseyNumber
            firstName.text = player.firstName
            lastName.text = player.lastName
            age.text = player.age
            birthCty.text = player.birthCity
            birthCountry.text = player.birthCountry
            height.text = player.height
            weight.text = player.weight
            position.text = player.position
            
            if(player.imageURL.isEmpty)
            {
                playerImage.image = UIImage(named: "photo-not-available")
            }
            else
            {
                let url = URL(string: player.imageURL)
                playerImage.kf.setImage(with: url)
            }
            
            if(player.shoots.isEmpty)
            {
                shootsLabel.isHidden = true
                shoots.isHidden = true
            }
            else
            {
                shootsLabel.isHidden = false
                shoots.isHidden = false
                
                shoots.text = player.shoots
            }
        }
    }
}
