//
// TrackingRegressor.swift
//
// This file was automatically generated and should not be edited.
//

import CoreML


/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TrackingRegressorInput : MLFeatureProvider {

    /// First as string value
    var First: String

    /// Second as string value
    var Second: String

    /// Fontsize as double value
    var Fontsize: Double

    /// Distance as double value
    var Distance: Double

    var featureNames: Set<String> {
        get {
            return ["First", "Second", "Fontsize", "Distance"]
        }
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "First") {
            return MLFeatureValue(string: First)
        }
        if (featureName == "Second") {
            return MLFeatureValue(string: Second)
        }
        if (featureName == "Fontsize") {
            return MLFeatureValue(double: Fontsize)
        }
        if (featureName == "Distance") {
            return MLFeatureValue(double: Distance)
        }
        return nil
    }
    
    init(First: String, Second: String, Fontsize: Double, Distance: Double) {
        self.First = First
        self.Second = Second
        self.Fontsize = Fontsize
        self.Distance = Distance
    }
}

/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TrackingRegressorOutput : MLFeatureProvider {

    /// Source provided by CoreML

    private let provider : MLFeatureProvider


    /// Tracking as double value
    lazy var Tracking: Double = {
        [unowned self] in return self.provider.featureValue(for: "Tracking")!.doubleValue
    }()

    var featureNames: Set<String> {
        return self.provider.featureNames
    }
    
    func featureValue(for featureName: String) -> MLFeatureValue? {
        return self.provider.featureValue(for: featureName)
    }

    init(Tracking: Double) {
        self.provider = try! MLDictionaryFeatureProvider(dictionary: ["Tracking" : MLFeatureValue(double: Tracking)])
    }

    init(features: MLFeatureProvider) {
        self.provider = features
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
class TrackingRegressor {
    var model: MLModel

/// URL of model assuming it was installed in the same bundle as this class
    class var urlOfModelInThisBundle : URL {
        let bundle = Bundle(for: TrackingRegressor.self)
        return bundle.url(forResource: "TrackingRegressor", withExtension:"mlmodelc")!
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
            - First as string value
            - Second as string value
            - Fontsize as double value
            - Distance as double value
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as TrackingRegressorOutput
    */
    func prediction(First: String, Second: String, Fontsize: Double, Distance: Double) throws -> TrackingRegressorOutput {
        let input_ = TrackingRegressorInput(First: First, Second: Second, Fontsize: Fontsize, Distance: Distance)
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
