const systemtray = await Service.import('systemtray')

export function SysTray() {
	const items = systemtray.bind("items")
		.as(items => items.map(item => Widget.Button({
			child: Widget.Icon({ icon: item.bind("icon"), css: 'font-size:30px' }),
			on_primary_click: (_, event) => item.activate(event),
			on_secondary_click: (_, event) => item.openMenu(event),
			tooltip_markup: item.bind("tooltip_markup"),
		})))

	return Widget.Box({
		spacing: 5,
		children: items,
	})
}

var isVisible = Variable(false)
export function SysTrayIndicator() {
	return Widget.EventBox({
		on_hover: () => isVisible.value = true,
		on_hover_lost: () => isVisible.value = false,
		class_name: 'tray',
		child: Widget.Box({
			children: [
				Widget.Icon({
					class_name: 'toggle',
					icon: isVisible.bind().as(v => v ?
						"arrow_right_black_24dp" :
						"arrow_left_black_24dp")
				}),
				Widget.Revealer({
					revealChild: isVisible.bind(),
					transitionDuration: 500,
					transition: 'slide_right',
					child: SysTray()
				})
			]
		})
	})
}
