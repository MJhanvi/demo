

import Foundation
import SQLite3

class DBHelper
{
    init()
    {
        db = openDatabase()
        createTable()
    }

    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(fileURL)")
            return db
        }
    }
 
    func createTable() {

        let createTableString = "CREATE TABLE IF NOT EXISTS Restaurant(Id INTEGER PRIMARY KEY,name TEXT,phone TEXT, latitude INTEGER, longitude INTEGER, imageURL TEXT, address TEXT, isFavourite INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("person table created.")
            } else {
                print("person table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    func insert(id:Int, name:String, phone:String, lat_loc: Int, long_loc: Int, imageURL: String, address: String, isFav: Int)
    {
        let persons = read()
        for p in persons
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO Restaurant (Id, name, phone, latitude, longitude, imageURL, address, isFavourite) VALUES (NULL, ?, ?, ?, ?,?,?,?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (phone as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(lat_loc))
            sqlite3_bind_int(insertStatement, 4, Int32(long_loc))
            sqlite3_bind_text(insertStatement, 5, (imageURL as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, Int32(isFav))

            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func read() -> [Restaurant] {
        let queryStatementString = "SELECT * FROM Restaurant;"
        var queryStatement: OpaquePointer? = nil
        var psns : [Restaurant] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let phone = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let lat = sqlite3_column_int(queryStatement, 3)
                let long = sqlite3_column_int(queryStatement, 4)
                let imgurl = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                let checkFav = sqlite3_column_int(queryStatement, 7)

                psns.append(Restaurant(id: Int(id), name: name, phone: phone, lat_location: Int(lat), long_location: Int(long), image_url: imgurl, address: address, isFav: Int(checkFav)))

                print("Query Result:")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func fetchFavouriteRestaurants() -> [Restaurant] {
           let queryStatementString = "SELECT * FROM Restaurant WHERE isFavourite == 1 LIMIT 5;"
           var queryStatement: OpaquePointer? = nil
           var psns : [Restaurant] = []
           if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
               while sqlite3_step(queryStatement) == SQLITE_ROW {
                   let id = sqlite3_column_int(queryStatement, 0)
                   let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                   let phone = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                   let lat = sqlite3_column_int(queryStatement, 3)
                   let long = sqlite3_column_int(queryStatement, 4)
                   let imgurl = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                   let address = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                   let checkFav = sqlite3_column_int(queryStatement, 7)

                   psns.append(Restaurant(id: Int(id), name: name, phone: phone, lat_location: Int(lat), long_location: Int(long), image_url: imgurl, address: address, isFav: Int(checkFav)))

                   print("Query Result:")
               }
           } else {
               print("SELECT statement could not be prepared")
           }
           sqlite3_finalize(queryStatement)
           return psns
       }
    
}
