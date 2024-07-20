export function Toggle() {
	return Widget.Button({
		class_name: 'themeToggle',
		child: Widget.Icon('spa_black_24dp'),
		on_primary_click: () => Utils.execAsync(['bash', '-c', 'toggle_theme.sh'])
	})
}
