//
// TrackingRegressor.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TrackingRegressorInput : MLFeatureProvider {

    /// chars as string value
    var chars: String

    /// fontSize as double value
    var fontSize: Double

    /// width as double value
    var width: Double

    /// fontWeight as string value
    var fontWeight: String

    var featureNames: Set<String> {
        get {
            return ["chars", "fontSize", "width", "fontWeight"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "chars") {
            return MLFeatureValue(string: chars)
        }
        if (featureName == "fontSize") {
            return MLFeatureValue(double: fontSize)
        }
        if (featureName == "width") {
            return MLFeatureValue(double: width)
        }
        if (featureName == "fontWeight") {
            return MLFeatureValue(string: fontWeight)
        }
        return nil
    }
    
    init(chars: String, fontSize: Double, width: Double, fontWeight: String) {
        self.chars = chars
        self.fontSize = fontSize
        self.width = width
        self.fontWeight = fontWeight
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TrackingRegressorOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// tracking as double value
    lazy var tracking: Double = {
        [unowned self] in return self.provider.featureValue(for: "tracking")!.doubleValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(tracking: Double) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["tracking" : MLFeatureValue(double: tracking)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TrackingRegressor {
    let model: MLModel
    static var shared = TrackingRegressor.init()
    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "TrackingRegressor", withExtension:"mlmodelc")!
    }

    /**
        Construct TrackingRegressor instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of TrackingRegressor.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `TrackingRegressor.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct TrackingRegressor instance by automatically loading the model from the app's bundle.
    */
    @available(*, deprecated, message: "Use init(configuration:) instead and handle errors appropriately.")
    private convenience init() {
        try! self.init(contentsOf: type(of:self).urlOfModelInThisBundle)
    }

    /**
        Construct a model with configuration

        - parameters:
           - configuration: the desired model configuration

        - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct TrackingRegressor instance with explicit path to mlmodelc file
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
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(contentsOf modelURL: URL, configuration: MLModelConfiguration) throws {
        try self.init(model: MLModel(contentsOf: modelURL, configuration: configuration))
    }

    /**
        Construct TrackingRegressor instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
//    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
//    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<TrackingRegressor, Error>) -> Void) {
//        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
//    }

    /**
        Construct TrackingRegressor instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
//    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
//    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<TrackingRegressor, Error>) -> Void) {
//        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
//            if let error = error {
//                handler(.failure(error))
//            } else if let model = model {
//                handler(.success(TrackingRegressor(model: model)))
//            } else {
//                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
//            }
//        }
//    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as TrackingRegressorInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TrackingRegressorOutput
    */
    func prediction(input: TrackingRegressorInput) throws -> TrackingRegressorOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as TrackingRegressorInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TrackingRegressorOutput
    */
    func prediction(input: TrackingRegressorInput, options: MLPredictionOptions) throws -> TrackingRegressorOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return TrackingRegressorOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - chars as string value
            - fontSize as double value
            - width as double value
            - fontWeight as string value

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TrackingRegressorOutput
    */
    func prediction(chars: String, fontSize: Double, width: Double, fontWeight: String) throws -> TrackingRegressorOutput {
        let input_ = TrackingRegressorInput(chars: chars, fontSize: fontSize, width: width, fontWeight: fontWeight)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [TrackingRegressorInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [TrackingRegressorOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [TrackingRegressorInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [TrackingRegressorOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [TrackingRegressorOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  TrackingRegressorOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
