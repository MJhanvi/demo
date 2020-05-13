//
//  ListViewController.swift
//  Demo
//
//  Created by Jhanvi M. on 13/05/20.
//  Copyright © 2020 Jhanvi. All rights reserved.
//

import UIKit
import SDWebImage

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var arr_resturants = NSMutableArray()
    var shouldEndPage = Bool()
    var currentPageIndex : Int = 1
    var total_entries = 0
    
    var db:DBHelper = DBHelper()
    var restaurants:[Restaurant] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.shouldEndPage = false
        self.fetchData()
    }

    @objc func resevedClick(sender: UIButton){
        let indexPath = sender.tag
        if let data = self.arr_resturants[indexPath] as? NSDictionary {
            if let rid = data.value(forKey: "id") as? Int {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
                vc.res_id = rid
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func favoriteClicked(sender: UIButton){
        let indexPath = sender.tag
        if let data = self.arr_resturants[indexPath] as? NSDictionary {
        }
    }
    
    func fetchData() {
        WebserviceHandler.shared.getList(pageCount: currentPageIndex) { (isSuccess, response) in
            if isSuccess {
                //Load data on database
                if let entries = response.value(forKey: "total_entries") as? Int{
                     self.total_entries = entries
                 }
                if let data = response.value(forKey: "restaurants") as? NSArray, data.count > 0 {
                    for rest in data {
                        let dict = rest as! NSDictionary
                        let name = dict .value(forKey: "name") as? String ?? ""
                        let phone = dict .value(forKey: "phone") as? String ?? ""
                        let address = dict .value(forKey: "address") as? String ?? ""
                        let imgUrl = dict .value(forKey: "image_url") as? String ?? ""
                        let lat = dict .value(forKey: "lat") as? Int ?? 0
                        let lng = dict .value(forKey: "lng") as? Int ?? 0
                        let id = dict .value(forKey: "lng") as? Int ?? 0

                        self.db.insert(id: id, name: name, phone: phone, lat_loc: lat, long_loc: lng, imageURL: imgUrl, address: address, isFav: 0)
                    }
                    self.restaurants = self.db.read()
                    self.arr_resturants.addObjects(from: data as! [Any])
                    if self.arr_resturants.count < 50 {
                           self.shouldEndPage = true
                       }
                } else {
                    if self.arr_resturants.count > 0{
                        self.shouldEndPage = true
                    }
                }
                
                self.tableView.reloadData()
            } else {
                //Error, Something went wrong
            }
        }
        currentPageIndex = currentPageIndex + 1

    }

}

extension ListViewController : UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.shouldEndPage &&  self.arr_resturants.count > 0 && (indexPath.row == self.arr_resturants.count) { return 60 }

        return 400
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSections: Int = 0
        
        if self.arr_resturants.count > 0
        {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
            numOfSections = 1
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No record found"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.restaurants.count > 0 {
            return self.restaurants.count + 1
        }
        return 0
        
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if self.arr_resturants.count > 0 && indexPath.row == self.arr_resturants.count - 1 && self.arr_resturants.count > 49 && self.shouldEndPage == false {
            self.fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if (self.arr_resturants.count > 0 && (indexPath.row == self.arr_resturants.count)) {
            
            let indicatorCell = tableView.dequeueReusableCell(withIdentifier:"indicatorCell", for: indexPath)
            let activityBar = indicatorCell.viewWithTag(1001) as! UIActivityIndicatorView
            let endLable = indicatorCell.viewWithTag(1002) as! UILabel
            
            if self.shouldEndPage {
                
                endLable.isHidden = false
                activityBar.isHidden = true
                activityBar.stopAnimating()
                return indicatorCell
                
            } else {
                endLable.isHidden = true
                activityBar.isHidden = false
                activityBar.startAnimating()
                return indicatorCell
            }
        }
        
        let displayData = tableView.dequeueReusableCell(withIdentifier:"dataCell", for: indexPath)
        let imgView = displayData.contentView.viewWithTag(1001) as! UIImageView
        let lbl_name = displayData.contentView.viewWithTag(1002) as! UILabel
        let lbl_address = displayData.contentView.viewWithTag(1003) as! UILabel
        let lbl_contact = displayData.contentView.viewWithTag(1004) as! UILabel
        
        let btn_favourite = displayData.contentView.viewWithTag(1005) as! UIButton
        btn_favourite.addTarget(self, action: #selector(favoriteClicked(sender:)), for:.touchUpInside)
        
        if let btn_reserve = displayData.contentView.viewWithTag(1006) as? UIButton {
            btn_reserve.tag = indexPath.row
            btn_reserve.addTarget(self, action: #selector(resevedClick(sender:)), for:.touchUpInside)
            btn_reserve.cornerRadius = 8
        }
        
        let mainview = displayData.contentView.viewWithTag(999) as! UIView
        mainview.cornerRadius = 5
        mainview.dropShadow(color:.lightGray, opacity: 1, offSet: CGSize(width: 0, height:3), radius: 2, scale: true)
        
        if self.arr_resturants.count > 0 {
        
            
          if let dict = self.restaurants[indexPath.row] as? Restaurant{
            let imgUrl = dict.image_url as! String
            imgView.sd_setImage(with: URL.init(string: imgUrl), placeholderImage: UIImage.init(named: "placeholder"), options: .highPriority, progress: nil) { (image, error, CacheType, url) in
                if error == nil{
                    imgView.image = image
                } else {
                    imgView.image = UIImage.init(named: "placeholder")
                }
            }
            
                lbl_name.text = dict.name
                lbl_address.text = dict.address
                lbl_contact.text = "Contact : \(dict.phone)"
            
            }
        }
        return displayData
    }
    
}
