//
// SymbolObjectDetector.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class SymbolObjectDetectorInput : MLFeatureProvider {

    /// Input image as color (kCVPixelFormatType_32BGRA) image buffer, 416 pixels wide by 416 pixels high
    var imagePath: CVPixelBuffer

    /// The maximum allowed overlap (as intersection-over-union ratio) for any pair of output bounding boxes (default: 0.45) as optional double value
    var iouThreshold: Double? = nil

    /// The minimum confidence score for an output bounding box (default: 0.25) as optional double value
    var confidenceThreshold: Double? = nil

    var featureNames: Set<String> {
        get {
            return ["imagePath", "iouThreshold", "confidenceThreshold"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "imagePath") {
            return MLFeatureValue(pixelBuffer: imagePath)
        }
        if (featureName == "iouThreshold") {
            return iouThreshold == nil ? nil : MLFeatureValue(double: iouThreshold!)
        }
        if (featureName == "confidenceThreshold") {
            return confidenceThreshold == nil ? nil : MLFeatureValue(double: confidenceThreshold!)
        }
        return nil
    }
    
    init(imagePath: CVPixelBuffer, iouThreshold: Double? = nil, confidenceThreshold: Double? = nil) {
        self.imagePath = imagePath
        self.iouThreshold = iouThreshold
        self.confidenceThreshold = confidenceThreshold
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imagePathWith imagePath: CGImage, iouThreshold: Double? = nil, confidenceThreshold: Double? = nil) throws {
        let __imagePath = try MLFeatureValue(cgImage: imagePath, pixelsWide: 416, pixelsHigh: 416, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
        self.init(imagePath: __imagePath, iouThreshold: iouThreshold, confidenceThreshold: confidenceThreshold)
    }


    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    convenience init(imagePathAt imagePath: URL, iouThreshold: Double? = nil, confidenceThreshold: Double? = nil) throws {
        let __imagePath = try MLFeatureValue(imageAt: imagePath, pixelsWide: 416, pixelsHigh: 416, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
        self.init(imagePath: __imagePath, iouThreshold: iouThreshold, confidenceThreshold: confidenceThreshold)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImagePath(with imagePath: CGImage) throws  {
        self.imagePath = try MLFeatureValue(cgImage: imagePath, pixelsWide: 416, pixelsHigh: 416, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func setImagePath(with imagePath: URL) throws  {
        self.imagePath = try MLFeatureValue(imageAt: imagePath, pixelsWide: 416, pixelsHigh: 416, pixelFormatType: kCVPixelFormatType_32ARGB, options: nil).imageBufferValue!
    }
}


/// Model Prediction Output Type
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class SymbolObjectDetectorOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// Boxes × Class confidence (see user-defined metadata "classes") as multidimensional array of doubles
    lazy var confidence: MLMultiArray = {
        [unowned self] in return self.provider.featureValue(for: "confidence")!.multiArrayValue
    }()!

    /// Boxes × [x, y, width, height] (relative to image size) as multidimensional array of doubles
    lazy var coordinates: MLMultiArray = {
        [unowned self] in return self.provider.featureValue(for: "coordinates")!.multiArrayValue
    }()!

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(confidence: MLMultiArray, coordinates: MLMultiArray) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["confidence" : MLFeatureValue(multiArray: confidence), "coordinates" : MLFeatureValue(multiArray: coordinates)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
class SymbolObjectDetector {
    let model: MLModel
    static var shared = SymbolObjectDetector.init()
    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "SymbolObjectDetector", withExtension:"mlmodelc")!
    }

    /**
        Construct SymbolObjectDetector instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of SymbolObjectDetector.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `SymbolObjectDetector.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct SymbolObjectDetector instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct SymbolObjectDetector instance with explicit path to mlmodelc file
        - parameters:
           - modelURL: the file url of the model

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL) throws {
        try self.init(model: MLModel(contentsOf: modelURL))
    }

    /**
        Construct a model with URL of the .mlmodelc directory and configuration

        - parameters:
           - modelURL: the file url of the model
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct SymbolObjectDetector instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<SymbolObjectDetector, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct SymbolObjectDetector instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<SymbolObjectDetector, Error>) -> Void) {
        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
            if let error = error {
                handler(.failure(error))
            } else if let model = model {
                handler(.success(SymbolObjectDetector(model: model)))
            } else {
                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
            }
        }
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as SymbolObjectDetectorInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as SymbolObjectDetectorOutput
    */
    func prediction(input: SymbolObjectDetectorInput) throws -> SymbolObjectDetectorOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as SymbolObjectDetectorInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as SymbolObjectDetectorOutput
    */
    func prediction(input: SymbolObjectDetectorInput, options: MLPredictionOptions) throws -> SymbolObjectDetectorOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return SymbolObjectDetectorOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - imagePath: Input image as color (kCVPixelFormatType_32BGRA) image buffer, 416 pixels wide by 416 pixels high
            - iouThreshold: The maximum allowed overlap (as intersection-over-union ratio) for any pair of output bounding boxes (default: 0.45) as optional double value
            - confidenceThreshold: The minimum confidence score for an output bounding box (default: 0.25) as optional double value

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as SymbolObjectDetectorOutput
    */
    func prediction(imagePath: CVPixelBuffer, iouThreshold: Double?, confidenceThreshold: Double?) throws -> SymbolObjectDetectorOutput {
        let input_ = SymbolObjectDetectorInput(imagePath: imagePath, iouThreshold: iouThreshold, confidenceThreshold: confidenceThreshold)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [SymbolObjectDetectorInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [SymbolObjectDetectorOutput]
    */
    func predictions(inputs: [SymbolObjectDetectorInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [SymbolObjectDetectorOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [SymbolObjectDetectorOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  SymbolObjectDetectorOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
