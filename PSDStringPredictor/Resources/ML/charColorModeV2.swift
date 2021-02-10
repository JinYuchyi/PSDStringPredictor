//
// charColorModeV2.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class charColorModeV2Input : MLFeatureProvider {

    /// rescaling_2_input as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 70 pixels wide by 70 pixels high
    var rescaling_2_input: CVPixelBuffer

    var featureNames: Set<String> {
        get {
            return ["rescaling_2_input"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "rescaling_2_input") {
            return MLFeatureValue(pixelBuffer: rescaling_2_input)
        }
        return nil
    }
    
    init(rescaling_2_input: CVPixelBuffer) {
        self.rescaling_2_input = rescaling_2_input
    }

    convenience init(rescaling_2_inputWith rescaling_2_input: CGImage) throws {
        let __rescaling_2_input = try MLFeatureValue(cgImage: rescaling_2_input, pixelsWide: 70, pixelsHigh: 70, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!
        self.init(rescaling_2_input: __rescaling_2_input)
    }

    convenience init(rescaling_2_inputAt rescaling_2_input: URL) throws {
        let __rescaling_2_input = try MLFeatureValue(imageAt: rescaling_2_input, pixelsWide: 70, pixelsHigh: 70, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!
        self.init(rescaling_2_input: __rescaling_2_input)
    }

    func setRescaling_2_input(with rescaling_2_input: CGImage) throws  {
        self.rescaling_2_input = try MLFeatureValue(cgImage: rescaling_2_input, pixelsWide: 70, pixelsHigh: 70, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!
    }

    func setRescaling_2_input(with rescaling_2_input: URL) throws  {
        self.rescaling_2_input = try MLFeatureValue(imageAt: rescaling_2_input, pixelsWide: 70, pixelsHigh: 70, pixelFormatType: kCVPixelFormatType_OneComponent8, options: nil).imageBufferValue!
    }
}


/// Model Prediction Output Type
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class charColorModeV2Output : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// Identity as dictionary of strings to doubles
    lazy var Identity: [String : Double] = {
        [unowned self] in return self.provider.featureValue(for: "Identity")!.dictionaryValue as! [String : Double]
    }()

    /// classLabel as string value
    lazy var classLabel: String = {
        [unowned self] in return self.provider.featureValue(for: "classLabel")!.stringValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(Identity: [String : Double], classLabel: String) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["Identity" : MLFeatureValue(dictionary: Identity as [AnyHashable : NSNumber]), "classLabel" : MLFeatureValue(string: classLabel)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
class charColorModeV2 {
    let model: MLModel
    static var shared = charColorModeV2.init()

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "charColorModeV2", withExtension:"mlmodelc")!
    }

    /**
        Construct charColorModeV2 instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of charColorModeV2.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `charColorModeV2.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct charColorModeV2 instance by automatically loading the model from the app's bundle.
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
        Construct charColorModeV2 instance with explicit path to mlmodelc file
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
        Construct charColorModeV2 instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<charColorModeV2, Error>) -> Void) {
        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
    }

    /**
        Construct charColorModeV2 instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<charColorModeV2, Error>) -> Void) {
        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
            if let error = error {
                handler(.failure(error))
            } else if let model = model {
                handler(.success(charColorModeV2(model: model)))
            } else {
                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
            }
        }
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as charColorModeV2Input

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as charColorModeV2Output
    */
    func prediction(input: charColorModeV2Input) throws -> charColorModeV2Output {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as charColorModeV2Input
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as charColorModeV2Output
    */
    func prediction(input: charColorModeV2Input, options: MLPredictionOptions) throws -> charColorModeV2Output {
        let outFeatures = try model.prediction(from: input, options:options)
        return charColorModeV2Output(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - rescaling_2_input as grayscale (kCVPixelFormatType_OneComponent8) image buffer, 70 pixels wide by 70 pixels high

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as charColorModeV2Output
    */
    func prediction(rescaling_2_input: CVPixelBuffer) throws -> charColorModeV2Output {
        let input_ = charColorModeV2Input(rescaling_2_input: rescaling_2_input)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [charColorModeV2Input]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [charColorModeV2Output]
    */
    func predictions(inputs: [charColorModeV2Input], options: MLPredictionOptions = MLPredictionOptions()) throws -> [charColorModeV2Output] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [charColorModeV2Output] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  charColorModeV2Output(features: outProvider)
            results.append(result)
        }
        return results
    }
}
