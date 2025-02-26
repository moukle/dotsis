from ignis.widgets import Widget
from .widgets import StatusPill, Tray, KeyboardLayout, Battery, Apps, Workspaces, Workspaces2

class Bar(Widget.RevealerWindow):
    __gtype_name__ = "Bar"

    def __init__(self, monitor: int):
        bar_main = Widget.CenterBox(
            start_widget=Widget.Box(child=[Workspaces2()]),
            center_widget=Widget.Box(child=[Apps()]),
            end_widget=Widget.Box(
                child=[Tray(), Battery(), StatusPill(monitor)]
            )
        )

        bar_revealer = Widget.Revealer(
            hexpand=True,
            child = bar_main,
            transition_type = 'slide_up',
            transition_duration=0,
            reveal_child = True,
        )

        super().__init__(
            revealer=bar_revealer,
            anchor=["left", "bottom", "right"],
            exclusivity="exclusive",
            monitor=monitor,
            namespace=f"ignis_BAR_{monitor}",
            layer="top",
            kb_mode="none",
            child=Widget.EventBox(
                css_classes=["bar-widget"],
                child=[bar_revealer],
                on_hover = lambda x:bar_revealer.set_reveal_child(True),
                # on_hover_lost = lambda x:bar_revealer.set_reveal_child(False)
            ),
            css_classes=["unset"],
        )
