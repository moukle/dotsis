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
	return Widget.Box({
		class_name: 'tray',
		spacing: 0,
		children: [
			Widget.Button({
				class_name: 'toggle',
				child:
					Widget.Icon({
						icon: isVisible.bind().as(v => v ?
							"./res/arrow_right_black_24dp.svg" :
							"./res/arrow_left_black_24dp.svg")
					}),
				// onHover: ({ }) => isVisible.value = true,
				on_primary_click: ({ }) => isVisible.value = !isVisible.value,
			}),
			Widget.Revealer({
				revealChild: isVisible.bind(),
				transitionDuration: 500,
				transition: 'slide_right',
				child: SysTray()
			})
		]
	})
}
