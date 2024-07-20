const { query } = await Service.import("applications")

function launch(binName) {
	let app = query(binName)[0]
	app.launch()
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
			AppIcon("DDNet", "space_ddnet"),
			AppIcon("firefox", "spacy_chrome"),
			AppIcon("nautilus", "space_explorer"),
			AppIcon("discord", "space_discord"),
			AppIcon("spotify", "space_musicbee"),
			AppIcon("kitty", "spacy_sublime")
		]
	})
}
