
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
   //var y = arguments.length;
   var i = 0;

   var lineArray = [];
   lineArray[0] = new PathPointInfo;
   lineArray[0].kind = PointKind.CORNERPOINT;
   lineArray[0].anchor = [posX, posY];
   lineArray[0].leftDirection = lineArray[0].anchor;
   lineArray[0].rightDirection = lineArray[0].anchor;

   lineArray[1] = new PathPointInfo;
   lineArray[1].kind = PointKind.CORNERPOINT;
   lineArray[1].anchor = [posX + width, posY];
   lineArray[1].leftDirection = lineArray[1].anchor;
   lineArray[1].rightDirection = lineArray[1].anchor;

   lineArray[2] = new PathPointInfo;
   lineArray[2].kind = PointKind.CORNERPOINT;
   lineArray[2].anchor = [posX + width, posY + height];
   lineArray[2].leftDirection = lineArray[2].anchor;
   lineArray[2].rightDirection = lineArray[2].anchor;

   lineArray[3] = new PathPointInfo;
   lineArray[3].kind = PointKind.CORNERPOINT;
   lineArray[3].anchor = [posX, posY + height];
   lineArray[3].leftDirection = lineArray[3].anchor;
   lineArray[3].rightDirection = lineArray[3].anchor;

   var lineSubPathArray = new SubPathInfo();
   lineSubPathArray.closed = true;
   lineSubPathArray.operation = ShapeOperation.SHAPEADD;
   lineSubPathArray.entireSubPath = lineArray;
   var myPathItem = docRef.pathItems.add(layerName, [lineSubPathArray]);
   

   var desc88 = new ActionDescriptor();
   var ref60 = new ActionReference();
   ref60.putClass(stringIDToTypeID("contentLayer"));
   desc88.putReference(charIDToTypeID("null"), ref60);
   var desc89 = new ActionDescriptor();
   var desc90 = new ActionDescriptor();
   var desc91 = new ActionDescriptor();
   desc91.putDouble(charIDToTypeID("Rd  "), color1[0]); // R
   desc91.putDouble(charIDToTypeID("Grn "), color1[1]); // G
   desc91.putDouble(charIDToTypeID("Bl  "), color1[2]); // B
   var id481 = charIDToTypeID("RGBC");
   desc90.putObject(charIDToTypeID("Clr "), id481, desc91);
   desc89.putObject(charIDToTypeID("Type"), stringIDToTypeID("solidColorLayer"), desc90);
   desc88.putObject(charIDToTypeID("Usng"), stringIDToTypeID("contentLayer"), desc89);
   executeAction(charIDToTypeID("Mk  "), desc88, DialogModes.NO);
   rename(layerName)
   myPathItem.remove();
}

function rename(name){
    var idset = stringIDToTypeID( "set" );
    var desc920 = new ActionDescriptor();
    var idnull = stringIDToTypeID( "null" );
        var ref264 = new ActionReference();
        var idlayer = stringIDToTypeID( "layer" );
        var idordinal = stringIDToTypeID( "ordinal" );
        var idtargetEnum = stringIDToTypeID( "targetEnum" );
        ref264.putEnumerated( idlayer, idordinal, idtargetEnum );
    desc920.putReference( idnull, ref264 );
    var idto = stringIDToTypeID( "to" );
        var desc921 = new ActionDescriptor();
        var idname = stringIDToTypeID( "name" );
        desc921.putString( idname, name );
    var idlayer = stringIDToTypeID( "layer" );
    desc920.putObject( idto, idlayer, desc921 );
executeAction( idset, desc920, DialogModes.NO );
}

// =======================================================
