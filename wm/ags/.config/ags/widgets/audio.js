const audio = await Service.import('audio')

/** @param {'speaker' | 'microphone'} type */
const VolumeSlider = (type = 'speaker') => Widget.Slider({
	hexpand: true,
	drawValue: false,
	onChange: ({ value }) => audio[type].volume = value,
	value: audio[type].bind('volume'),
})

const speakerSlider = VolumeSlider('speaker')
const micSlider = VolumeSlider('microphone')

export function Volume() {
	return Widget.Box({
		class_name: "volume",
		css: "min-width: 90px",
		children: [speakerSlider],
	})
}
