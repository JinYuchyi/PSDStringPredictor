//
// TextWeightTabularRegressor.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TextWeightTabularRegressorInput : MLFeatureProvider {

    /// char as string value
    var char_: String

    /// width as double value
    var width: Double

    /// height as double value
    var height: Double

    /// fontWeight as string value
    var fontWeight: String

    var featureNames: Set<String> {
        get {
            return ["char", "width", "height", "fontWeight"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "char") {
            return MLFeatureValue(string: char_)
        }
        if (featureName == "width") {
            return MLFeatureValue(double: width)
        }
        if (featureName == "height") {
            return MLFeatureValue(double: height)
        }
        if (featureName == "fontWeight") {
            return MLFeatureValue(string: fontWeight)
        }
        return nil
    }
    
    init(char_: String, width: Double, height: Double, fontWeight: String) {
        self.char_ = char_
        self.width = width
        self.height = height
        self.fontWeight = fontWeight
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TextWeightTabularRegressorOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// fontSize as double value
    lazy var fontSize: Double = {
        [unowned self] in return self.provider.featureValue(for: "fontSize")!.doubleValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(fontSize: Double) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["fontSize" : MLFeatureValue(double: fontSize)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TextWeightTabularRegressor {
    let model: MLModel

    /// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: self)
        return bundle.url(forResource: "TextWeightTabularRegressor", withExtension:"mlmodelc")!
    }

    /**
        Construct TextWeightTabularRegressor instance with an existing MLModel object.

        Usually the application does not use this initializer unless it makes a subclass of TextWeightTabularRegressor.
        Such application may want to use `MLModel(contentsOfURL:configuration:)` and `TextWeightTabularRegressor.urlOfModelInThisBundle` to create a MLModel object to pass-in.

        - parameters:
          - model: MLModel object
    */
    init(model: MLModel) {
        self.model = model
    }

    /**
        Construct TextWeightTabularRegressor instance by automatically loading the model from the app's bundle.
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
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    convenience init(configuration: MLModelConfiguration) throws {
        try self.init(contentsOf: type(of:self).urlOfModelInThisBundle, configuration: configuration)
    }

    /**
        Construct TextWeightTabularRegressor instance with explicit path to mlmodelc file
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
        Construct TextWeightTabularRegressor instance asynchronously with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
//    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
//    class func load(configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<TextWeightTabularRegressor, Error>) -> Void) {
//        return self.load(contentsOf: self.urlOfModelInThisBundle, configuration: configuration, completionHandler: handler)
//    }

    /**
        Construct TextWeightTabularRegressor instance asynchronously with URL of the .mlmodelc directory with optional configuration.

        Model loading may take time when the model content is not immediately available (e.g. encrypted model). Use this factory method especially when the caller is on the main thread.

        - parameters:
          - modelURL: the URL to the model
          - configuration: the desired model configuration
          - handler: the completion handler to be called when the model loading completes successfully or unsuccessfully
    */
//    @available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
//    class func load(contentsOf modelURL: URL, configuration: MLModelConfiguration = MLModelConfiguration(), completionHandler handler: @escaping (Swift.Result<TextWeightTabularRegressor, Error>) -> Void) {
//        MLModel.__loadContents(of: modelURL, configuration: configuration) { (model, error) in
//            if let error = error {
//                handler(.failure(error))
//            } else if let model = model {
//                handler(.success(TextWeightTabularRegressor(model: model)))
//            } else {
//                fatalError("SPI failure: -[MLModel loadContentsOfURL:configuration::completionHandler:] vends nil for both model and error.")
//            }
//        }
//    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as TextWeightTabularRegressorInput

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextWeightTabularRegressorOutput
    */
    func prediction(input: TextWeightTabularRegressorInput) throws -> TextWeightTabularRegressorOutput {
        return try self.prediction(input: input, options: MLPredictionOptions())
    }

    /**
        Make a prediction using the structured interface

        - parameters:
           - input: the input to the prediction as TextWeightTabularRegressorInput
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextWeightTabularRegressorOutput
    */
    func prediction(input: TextWeightTabularRegressorInput, options: MLPredictionOptions) throws -> TextWeightTabularRegressorOutput {
        let outFeatures = try model.prediction(from: input, options:options)
        return TextWeightTabularRegressorOutput(features: outFeatures)
    }

    /**
        Make a prediction using the convenience interface

        - parameters:
            - char_ as string value
            - width as double value
            - height as double value
            - fontWeight as string value

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as TextWeightTabularRegressorOutput
    */
    func prediction(char_: String, width: Double, height: Double, fontWeight: String) throws -> TextWeightTabularRegressorOutput {
        let input_ = TextWeightTabularRegressorInput(char_: char_, width: width, height: height, fontWeight: fontWeight)
        return try self.prediction(input: input_)
    }

    /**
        Make a batch prediction using the structured interface

        - parameters:
           - inputs: the inputs to the prediction as [TextWeightTabularRegressorInput]
           - options: prediction options 

        - throws: an NSError object that describes the problem

        - returns: the result of the prediction as [TextWeightTabularRegressorOutput]
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    func predictions(inputs: [TextWeightTabularRegressorInput], options: MLPredictionOptions = MLPredictionOptions()) throws -> [TextWeightTabularRegressorOutput] {
        let batchIn = MLArrayBatchProvider(array: inputs)
        let batchOut = try model.predictions(from: batchIn, options: options)
        var results : [TextWeightTabularRegressorOutput] = []
        results.reserveCapacity(inputs.count)
        for i in 0..<batchOut.count {
            let outProvider = batchOut.features(at: i)
            let result =  TextWeightTabularRegressorOutput(features: outProvider)
            results.append(result)
        }
        return results
    }
}
