//
//  FavouritesViewController.swift
//  Demo
//
//  Created by Jhanvi M. on 13/05/20.
//  Copyright © 2020 Jhanvi. All rights reserved.
//

import Foundation
import UIKit

class FavouritesViewController: UIViewController {

        @IBOutlet weak var tableView: UITableView!

        var arr_resturants = NSMutableArray()
        var shouldEndPage = Bool()
        var currentPageIndex : Int = 1
        var total_entries = 0
        var db:DBHelper = DBHelper()
           
           var restuarants:[Restaurant] = []
           
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
                if let rid = data.value(forKey: "id") as? Int {
                    //UPDATE Restaurant SET isFavourite = 1 WHERE id = rid
                }
            }
        }
        
        func fetchData() {
            restuarants = db.fetchFavouriteRestaurants()
            self.tableView.reloadData()
        }

    }

    extension FavouritesViewController : UITableViewDelegate, UITableViewDataSource{

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
            
            if self.restuarants.count > 0 {
                return self.restuarants.count + 1
            }
            return 0
            
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
                  
                      
                    if let dict = self.restuarants[indexPath.row] as? Restaurant{
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

