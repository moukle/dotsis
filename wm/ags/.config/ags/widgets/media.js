const mpris = await Service.import('mpris')

/** @param {import('types/service/mpris').MprisPlayer} player */
function Player(player) {
	const coverTitle = Widget.Label({
		class_name: "covertxt",
		vpack: "start",
		label: player.bind("cover_path"),
		css: player.bind("cover_path").transform(p => `
		          background-image: url('${p}');
		      `),
	})

	const cover = Widget.Box({
		class_name: "cover",
		vpack: "start",
		css: player.bind("cover_path").transform(p => `
            background-image: url('${p}');
        `),
	})

	const coverButton = Widget.Button({
		onClicked: () => player.playPause(),
		child: cover
	})

	const title = Widget.Label().hook(player, label => {
		const { track_artists, track_title } = player;
		label.label = `${track_artists.join(', ')} - ${track_title}`;
		label.class_name = 'title';
	})

	const titlePause = Widget.Button({
		onClicked: () => player.playPause(),
		child: title
	})

	let isHovered = Variable(false)
	const prevSong = Widget.Revealer({
		transitionDuration: 500,
		transition: 'slide_left',
		revealChild: isHovered.bind(),
		child: Widget.Button({
			class_name: 'controls',
			onClicked: () => player.previous(),
			child: Widget.Icon('arrow_left_black_24dp')
		})
	})

	const nextSong = Widget.Revealer({
		transitionDuration: 500,
		transition: 'slide_right',
		revealChild: isHovered.bind(),
		child: Widget.Button({
			class_name: 'controls',
			onClicked: () => player.next(),
			child: Widget.Icon('arrow_right_black_24dp')
		})
	})

	const titleControls = Widget.EventBox({
		on_hover: () => isHovered.value = true,
		on_hover_lost: () => isHovered.value = false,
		child: Widget.Box([prevSong, titlePause, nextSong])
	})

	return Widget.Box({
		class_name: 'player',
		children: [coverButton, titleControls]
	})
}

export const players = Widget.Box({
	children: mpris.bind('players').as(p => p.map(Player))
})
