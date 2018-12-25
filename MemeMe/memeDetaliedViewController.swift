//
//  memeDetaliedViewController.swift
//  MemeMe
//
//  Created by MAC on 07/12/2018.
//  Copyright © 2018 MAC. All rights reserved.
//

import UIKit

class memeDetaliedViewController: UIViewController {
   
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.imageView.image = self.meme.memedImage
        
    }// Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


