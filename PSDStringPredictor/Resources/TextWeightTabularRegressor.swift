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

    var featureNames: Set<String> {
        get {
            return ["char", "width", "height"]
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
        return nil
    }
    
    init(char_: String, width: Double, height: Double) {
        self.char_ = char_
        self.width = width
        self.height = height
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TextWeightTabularRegressorOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// fontsize as double value
    lazy var fontsize: Double = {
        [unowned self] in return self.provider.featureValue(for: "fontsize")!.doubleValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(fontsize: Double) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["fontsize" : MLFeatureValue(double: fontsize)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TextWeightTabularRegressor {
    var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: TextWeightTabularRegressor.self)
        return bundle.url(forResource: "TextWeightTabularRegressor", withExtension:"mlmodelc")!
    }

    /**
        Construct a model with explicit path to mlmodelc file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
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
        Construct a model with explicit path to mlmodelc file and configuration
        - parameters:
           - url: the file url of the model
           - configuration: the desired model configuration
           - throws: an NSError object that describes the problem
    */
    @available(macOS 10.14, iOS 12.0, tvOS 12.0, watchOS 5.0, *)
    init(contentsOf url: URL, configuration: MLModelConfiguration) throws {
        self.model = try MLModel(contentsOf: url, configuration: configuration)
    }

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
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as TextWeightTabularRegressorOutput
    */
    func prediction(char_: String, width: Double, height: Double) throws -> TextWeightTabularRegressorOutput {
        let input_ = TextWeightTabularRegressorInput(char_: char_, width: width, height: height)
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
