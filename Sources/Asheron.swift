struct Asheron {

    var text = "Hello, World!"
    
    init() {
        let fileManager = IndexFileManager()
        let indexFile = try! fileManager.open(path: "/Users/jkolb/src/Dereth/Data/client_portal.dat")
        let data = try! indexFile.readData(handle: 0xFFFF0001)
        print(data)
    }
}
