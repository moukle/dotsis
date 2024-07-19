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

	return Widget.Box({
		class_name: 'player',
		children: [coverButton, title]
	})
}

export const players = Widget.Box({
	children: mpris.bind('players').as(p => p.map(Player))
})
