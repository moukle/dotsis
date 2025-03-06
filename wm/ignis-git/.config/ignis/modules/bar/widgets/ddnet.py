from ..services import DDNetService

import ignis.widgets as Widget
from ignis.app import IgnisApp
# from .menu import opened_menu

ddnet = DDNetService.get_default()
app = IgnisApp.get_default()

class FriendsDetailed(Widget.Window):
    def __init__(self):
        super().__init__(
            visible=False,
            popup=True,
            kb_mode="on_demand",
            layer="top",
            css_classes=["ddnet-center"],
            anchor=["bottom", "right"],
            namespace="ignis_FRIENDS_DETAILED",
            hexpand=True,
            vexpand=False,
            child= Widget.EventBox(
                hexpand=True,
                vexpand=False,
                vertical=True,
                css_classes=["ddnet-center-widget"],
                on_hover_lost=lambda _: app.close_window("ignis_FRIENDS_DETAILED"),
                child = ddnet.bind(
                        "friends_online",
                        transform= lambda friends_online: [
                            Widget.CenterBox(
                                vertical=False,
                                start_widget=Widget.Label(label=f.name),
                                # center_widget=Widget.Label(label=f.server),
                                end_widget=Widget.Label(label=f.map),
                            )
                            for f in friends_online]
                ),
            ),
        )

FriendsDetailed()


class DDNet(Widget.Button):
    def __init__(self):
        self._friends_detailed: Widget.Window = app.get_window("ignis_FRIENDS_DETAILED")

        if ddnet.is_available:
            child = ddnet.bind(
                "friends_online",
                transform=lambda value: Widget.Label(
                    label= "     " + str(len(value)),
                    css_classes=["ddnet-open"]
                )
            )
        else:
            child = None
        super().__init__(
            child=child,

            css_classes=self._friends_detailed.bind(
                "visible",
                lambda value: ["clock", "unset", "active"]
                if value
                else ["clock", "unset"],
            ),

            on_click=self.__on_click
        )

    def __on_click(self, _) -> None:
        self._friends_detailed.visible = not self._friends_detailed.visible

