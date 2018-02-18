//
//  MyTileLayer.swift
//  AspenApp
//
//  Created by Frank YAN on 2017-05-03.
//  Copyright © 2017 Frank YAN. All rights reserved.
//

import Foundation
import GoogleMaps
import FMDB

class MyTileLayer: GMSSyncTileLayer
{
    @objc var fileURL: URL
    
    @objc init(fileName: String)
    {
        self.fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(fileName)
        
        super.init()
    }
    
    @objc func getMapLayerBounds() -> [Double]
    {
        var boundsStringArray: [String] = []
        var boundsArray: [Double] = []
        let database = FMDatabase(path: fileURL.path)
        guard database.open() else {
            return []
        }
        let sqlMapBounds = "select value from metadata where name = 'bounds'"
        do
        {
            let rs = try database.executeQuery(sqlMapBounds, values: nil)
            if rs.next()
            {
                guard let boundsString = rs.string(forColumnIndex: 0) else {
                    return []
                }
                boundsStringArray = boundsString.components(separatedBy: ",")
                
            }
            database.close()
        }
        catch
        {
            return []
        }
        for item in boundsStringArray
        {
            boundsArray.append(Double(item)!)
        }
        return boundsArray
    }
    
    override func tileFor(x: UInt, y: UInt, zoom: UInt) -> UIImage?
    {
        let database = FMDatabase(path: fileURL.path)
        
        guard database.open() else {
            print("Unable to open database")
            return kGMSTileLayerNoTile
        }
        let sqlString = "select tile_data from images where tile_id = \'" + "\(zoom)" + "/" + "\(x)" + "/" + "\(y)\'"
        do
        {
            let rs = try database.executeQuery(sqlString, values: nil)
            if rs.next()
            {
                guard let data = rs.data(forColumnIndex: 0) else {
                    database.close()
                    return kGMSTileLayerNoTile
                }
                database.close()
                return UIImage(data: data)
            }
        }
        catch
        {
            database.close()
            return kGMSTileLayerNoTile
        }
        database.close()
        return kGMSTileLayerNoTile
    }
}
