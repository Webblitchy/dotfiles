import QtQuick 2.0

QtObject {
	readonly property color defaultNormalColor: theme.textColor
	readonly property color normalColor: defaultNormalColor

	readonly property color defaultChargingColor: '#1e1'
	readonly property color chargingColor: defaultChargingColor

	readonly property color defaultLowBatteryColor: '#e33'
	readonly property color lowBatteryColor: defaultLowBatteryColor

	readonly property int defaultFontSize: 16
	readonly property int fontSize: plasmoid.configuration.fontSize || defaultFontSize
}
