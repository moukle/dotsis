import { Workspaces } from './widgets/hyrpland.js'
import { DateClock } from './widgets/date.js'
import { players } from './widgets/media.js'
import { Volume } from './widgets/audio.js'
import { SysTrayIndicator } from './widgets/tray.js'

const separator = Widget.Separator({
	vertical: false,
})

function Left() {
	return Widget.Box({
		spacing: 8,
		children: [
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
		spacing: 8,
		children: [
			DateClock(),
			separator,
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
			css: "padding: 0.5rem",
			start_widget: Left(),
			center_widget: Center(),
			end_widget: Right(),
		}),
	})
}


App.config({
	style: './style.css',
	windows: [Bar(1)],
});
