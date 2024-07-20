const clock = Variable("", {
	poll: [5000, 'date "+%H:%M"'],
})

const date = Variable("", {
	poll: [100000, 'date "+%e"'],
})

function Date() {
	return Widget.Box({
		class_name: 'datebox',
		child: Widget.Label({
			class_name: "date",
			label: date.bind(),
		})
	})
}

function Clock() {
	return Widget.Label({
		class_name: "clock",
		label: clock.bind(),
	})
}


export function DateClock() {
	return Widget.Box({
		children: [Date(), Clock()],
	})
}
