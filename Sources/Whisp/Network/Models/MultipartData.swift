import Foundation

public struct MultipartData {
    public struct File {
        public let data: Data
        public let name: String
        public let filename: String
        public let mimeType: MimeType
        
        public init(
            data: Data,
            name: String,
            filename: String,
            mimeType: MimeType
        ) {
            self.data = data
            self.name = name
            self.filename = filename
            self.mimeType = mimeType
        }
    }
    
    public let files: [File]
    public let parameters: [String: String]?
    
    public init(
        files: [File],
        parameters: [String: String]? = nil
    ) {
        self.files = files
        self.parameters = parameters
    }
}

public struct MimeType: Sendable {
    public let value: String
    
    init(value: String) {
        self.value = value
    }
    
    // Images
    public static let jpeg = MimeType(value: "image/jpeg")
    public static let png = MimeType(value: "image/png")
    public static let gif = MimeType(value: "image/gif")
    public static let webp = MimeType(value: "image/webp")
    public static let heic = MimeType(value: "image/heic")
    
    // Documents
    public static let pdf = MimeType(value: "application/pdf")
    public static let doc = MimeType(value: "application/msword")
    public static let docx = MimeType(value: "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
    
    // Audio
    public static let mp3 = MimeType(value: "audio/mpeg")
    public static let wav = MimeType(value: "audio/wav")
    
    // Video
    public static let mp4 = MimeType(value: "video/mp4")
    public static let mov = MimeType(value: "video/quicktime")
    
    public static func custom(_ value: String) -> MimeType {
        MimeType(value: value)
    }
}
