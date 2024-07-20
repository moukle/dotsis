const audio = await Service.import('audio')

/** @param {'speaker' | 'microphone'} type */
const VolumeSlider = (type = 'speaker') => Widget.Slider({
	class_name: "slider",
	hexpand: true,
	drawValue: false,
	onChange: ({ value }) => audio[type].volume = value,
	value: audio[type].bind('volume'),
})

var activeSpeaker = Variable("")
audio.connect(
	"speaker-changed", () => {
		let newName = audio.speaker ? audio.speaker.name : ""
		if (audio.speaker.name != activeSpeaker.value) {
			activeSpeaker.value = newName
		}
	}
)

const speakerSlider = VolumeSlider('speaker')
const micSlider = VolumeSlider('microphone')

let showBackends = Variable(false)
function SpeakerBackends() {
	const speakerIcons = Widget.Box({
		spacing: 20,
		setup: self => self.hook(activeSpeaker, () => {
			self.children = audio.speakers.map(SpeakerIcon)
		})
	})

	return Widget.Revealer({
		class_name: 'speakerIcons',
		transitionDuration: 1000,
		transition: 'slide_right',
		revealChild: showBackends.bind(),
		child: speakerIcons
	})
}

function SpeakerIcon(speakerStream) {
	let icon = speakerStream.name.includes('hdmi') ? 'spacy_speaker' : 'spacy_headphones'
	let isActive = speakerStream.name == audio.speaker.name
	return Widget.Button({
		child: Widget.Icon({ icon: icon, class_name: isActive ? 'active' : 'inactive' }),
		on_primary_click: () => { audio.speaker = speakerStream }
	})
}

export function Volume() {
	return Widget.EventBox({
		on_hover: () => showBackends.value = true,
		on_hover_lost: () => showBackends.value = false,
		class_name: "volume",
		child: Widget.Box([speakerSlider, SpeakerBackends()])
	})
}
