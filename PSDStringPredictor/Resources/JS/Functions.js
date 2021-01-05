
// ========================= Load from Functions.js ==============================

function selectLayer(name){
    var idselect = stringIDToTypeID( "select" );
        var desc25 = new ActionDescriptor();
        var idnull = stringIDToTypeID( "null" );
            var ref3 = new ActionReference();
            var idlayer = stringIDToTypeID( "layer" );
            ref3.putName( idlayer, name );
        desc25.putReference( idnull, ref3 );
        var idmakeVisible = stringIDToTypeID( "makeVisible" );
        desc25.putBoolean( idmakeVisible, false );
        var idlayerID = stringIDToTypeID( "layerID" );
            var list7 = new ActionList();
            list7.putInteger( 2 );
        desc25.putList( idlayerID, list7 );
    executeAction( idselect, desc25, DialogModes.NO );
}

function setTextAlignment(alignment){
    var idset = stringIDToTypeID( "set" );
        var desc26 = new ActionDescriptor();
        var idnull = stringIDToTypeID( "null" );
            var ref4 = new ActionReference();
            var idproperty = stringIDToTypeID( "property" );
            var idparagraphStyle = stringIDToTypeID( "paragraphStyle" );
            ref4.putProperty( idproperty, idparagraphStyle );
            var idtextLayer = stringIDToTypeID( "textLayer" );
            var idordinal = stringIDToTypeID( "ordinal" );
            var idtargetEnum = stringIDToTypeID( "targetEnum" );
            ref4.putEnumerated( idtextLayer, idordinal, idtargetEnum );
        desc26.putReference( idnull, ref4 );
        var idto = stringIDToTypeID( "to" );
            var desc27 = new ActionDescriptor();
            var idtextOverrideFeatureName = stringIDToTypeID( "textOverrideFeatureName" );
            desc27.putInteger( idtextOverrideFeatureName, 808464433 );
            var idalign = stringIDToTypeID( "align" );
            var idalignmentType = stringIDToTypeID( "alignmentType" );
            var idcenter = stringIDToTypeID( alignment ); //"center"
            desc27.putEnumerated( idalign, idalignmentType, idcenter );
        var idparagraphStyle = stringIDToTypeID( "paragraphStyle" );
        desc26.putObject( idto, idparagraphStyle, desc27 );
    executeAction( idset, desc26, DialogModes.NO );
}

function createRectangle(layerSet, layerName, posX, posY, width, height, color1){
    var artLayerRef = layerSet.artLayers.add()
    artLayerRef.name = layerName
    var selRegion = Array(Array(posX, posY),
                    Array(posX + width, posY),
                    Array(posX + width, posY + height),
                    Array(posX, posY + height),
                    Array(posX, posY))

    app.activeDocument.selection.select(selRegion)
    fillColor = new SolidColor
    fillColor.rgb.red = color1[0]
    fillColor.rgb.green = color1[1]
    fillColor.rgb.blue = color1[2]
    app.activeDocument.selection.fill(fillColor)

}

function ConsoleLog() {
    //To view log from OSX terminal, execute:
    //$ nc -lvk <port> (listens on localhost:<port>)
    this.socket = new Socket();
    this.estkIsRunning = BridgeTalk.isRunning ('estoolkit');
    this.hostPort = "127.0.0.1:8000";
    this.log = function(logMessage){
            if (this.estkIsRunning){
               $.writeln(logMessage);
            }
            else{
                if (this.socket.open(this.hostPort)){
                  this.socket.write (logMessage + "\n");
                  this.socket.close();
                }
            }
         }
    }

// =======================================================
