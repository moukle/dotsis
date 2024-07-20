import { Toggle } from './widgets/theme.js'
import { Workspaces } from './widgets/hyrpland.js'

import { players } from './widgets/media.js'

import { Dock } from './widgets/dock.js'
import { DateClock } from './widgets/date.js'
import { Volume } from './widgets/audio.js'
import { SysTrayIndicator } from './widgets/tray.js'

function Separator() {
	return Widget.Separator({
		vertical: false,
	})
}

function Left() {
	return Widget.Box({
		spacing: 8,
		children: [
			Toggle(),
			Separator(),
			Workspaces(),
		],
	})
}

function Center() {
	return Widget.Box({
		spacing: 8,
		children: [
			players
			// Notification(),
		],
	})
}

function Right() {
	return Widget.Box({
		hpack: "end",
		spacing: 20,
		children: [
			DateClock(),
			Dock(),
			Separator(),
			Volume(),
			SysTrayIndicator()
		],
	})
}

function Bar(monitor = 0) {
	return Widget.Window({
		monitor,
		class_name: "bar",
		name: `bar_${monitor}`,
		exclusivity: "exclusive",
		anchor: ['bottom', 'left', 'right'],
		child: Widget.CenterBox({
			css: "padding-top: 0.5rem; padding-bottom: 0.5rem; padding-left: 1.5rem; padding-right: 1.5rem",
			start_widget: Left(),
			center_widget: Center(),
			end_widget: Right(),
		}),
	})
}


App.config({
	style: './style.css',
	windows: [Bar(0)],
});

App.addIcons("/home/mori/.config/ags/res/spacepotato/")
