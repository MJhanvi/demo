
import Foundation

class Restaurant
{
    var name: String = ""
    var phone: String = ""
    var id: Int = 0
    var lat_location: Int = 0
    var long_location: Int = 0
    var image_url: String = ""
    var address: String = ""
    var isFav: Int = 0

    init(id:Int, name:String, phone:String, lat_location: Int, long_location: Int, image_url: String, address: String,isFav: Int)
    {
        self.id = id
        self.name = name
        self.phone = phone
        self.lat_location = lat_location
        self.long_location = long_location
        self.image_url = image_url
        self.address = address
        self.isFav = isFav
    }
    
}
