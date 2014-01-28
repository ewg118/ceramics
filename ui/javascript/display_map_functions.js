$(document).ready(function () {
	var id = $('title').attr('id');
	initialize_map(id);
});

function initialize_map(id) {
	var args = OpenLayers.Util.getParameters();
	
	map = new OpenLayers.Map('mapcontainer', {
		controls:[
		new OpenLayers.Control.PanZoomBar(),
		new OpenLayers.Control.Navigation(),
		new OpenLayers.Control.ScaleLine(),
		new OpenLayers.Control.LayerSwitcher({
			'ascending': true
		})]
	});
	
	//google physical
	map.addLayer(new OpenLayers.Layer.Google(
	"Google Physical", {
		type: google.maps.MapTypeId.TERRAIN
	}));
	
	//get KML
	var kmlLayer = new OpenLayers.Layer.Vector('KML', {
		eventListeners: {
			'loadend': kmlLoaded
		},
		strategies:[
		new OpenLayers.Strategy.Fixed()],
		protocol: new OpenLayers.Protocol.HTTP({
			url: id + '.kml',
			format: new OpenLayers.Format.KML({
				extractStyles: true,
				extractAttributes: true
			})
		})
	});
	
	//add origin point last
	map.addLayer(kmlLayer);
	
	function kmlLoaded() {
		map.zoomToExtent(kmlLayer.getDataExtent());
		//map.zoomTo('6');
	}
	
	/*************** OBJECT KML FEATURES ******************/
	objectControl = new OpenLayers.Control.SelectFeature([kmlLayer], {
		clickout: true,
		//toggle: true,
		multiple: false,
		hover: false,
		//toggleKey: "ctrlKey",
		//multipleKey: "shiftKey"
	});
	
	map.addControl(objectControl);
	objectControl.activate();
	kmlLayer.events.on({
		"featureselected": onFeatureSelect, "featureunselected": onFeatureUnselect
	});
	
	function onFeatureSelect(event) {
		var feature = event.feature;
		message = '<div><h2>' + feature.attributes.name + '</h2>' + feature.attributes.description + '</div>';
		popup = new OpenLayers.Popup.FramedCloud("id", event.feature.geometry.bounds.getCenterLonLat(), null, message, null, true, onPopupClose);
		event.popup = popup;
		map.addPopup(popup);
	}
	
	function onPopupClose(event) {
		map.removePopup(map.popups[0]);
	}
	
	
	function onFeatureUnselect(event) {
		map.removePopup(map.popups[0]);
	}
}