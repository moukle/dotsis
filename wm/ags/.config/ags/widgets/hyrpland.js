const hyprland = await Service.import('hyprland')

const focusedTitle = Widget.Label({
	label: hyprland.active.client.bind('title'),
	visible: hyprland.active.client.bind('address')
		.as(addr => !!addr),
})

const dispatch = ws => hyprland.messageAsync(`dispatch workspace ${ws}`);

const activeId = hyprland.active.workspace.bind("id")
function workspace_button(id) {
	return Widget.Button({
		on_clicked: () => hyprland.messageAsync(`dispatch workspace ${id}`),
		class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
		attribute: id,
		label: ``,
	})
}

function workspace_button_box(id_start, id_end) {
	return Widget.Box({
		class_name: 'workspaces_box',
		spacing: 3,
		children: Array.from({ length: id_end - id_start }, (_, i) => i + 1 + id_start).map(id => workspace_button(id)),

		setup: self => self.hook(hyprland, () => self.children.forEach(btn => {
			if (btn.class_name != 'focused') {
				btn.class_name = hyprland.workspaces.some(ws => ws.id === btn.attribute && ws.windows > 0) ? 'active' : ''
			}
		})),
	})
}

export const Workspaces = () => Widget.EventBox({
	onScrollUp: () => dispatch('+1'),
	onScrollDown: () => dispatch('-1'),
	child: Widget.Box({
		class_name: 'workspaces',
		spacing: 15,
		children: [
			Widget.Box({
				class_name: 'workspaces_box_box',
				spacing: 0,
				vertical: true,
				children: [
					workspace_button_box(10, 15),
					workspace_button_box(15, 20)
				]
			}),
			Widget.Box({
				class_name: 'workspaces_box_box',
				spacing: 0,
				vertical: true,
				children: [
					workspace_button_box(0, 5),
					workspace_button_box(5, 10)]
			}),
		],
	}),
})
