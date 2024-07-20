const { query } = await Service.import("applications")

function launch(binName) {
	Utils.execAsync(['bash', '-c', binName])
}

function AppIcon(binName, iconPath) {
	return Widget.Button({
		child: Widget.Icon({ icon: iconPath, class_name: "icon" }),
		on_primary_click: () => launch(binName)
	})
}

export function Dock() {
	return Widget.Box({
		class_name: "dock",
		spacing: 20,
		children: [
			AppIcon("firefox", "spacy_chrome"),
			AppIcon("discord", "space_discord"),
			AppIcon("spotify", "space_musicbee"),
			AppIcon("kitty", "spacy_sublime"),
		]
	})
}
