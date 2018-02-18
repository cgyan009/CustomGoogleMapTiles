# CustomGoogleMapTiles
SQLite format map tiles
Sometimes, we need to use customed map tiles as maplayer on top of google maps. There are some tools in the market which can generated map tiles from pdf or imaginary format maps. There is one forms of these map tiles are stored in SQLite database file. This class will fetch maptiles in the database and display them as google maps layer.
usage:

                let layer = MyTileLayer(fileName: "map tiles file path")
                layer.tileSize = 512
                layer.map = self.mapView

