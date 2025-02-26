import json
from typing import Any
from ignis.widgets import Widget
from ignis.services.hyprland import HyprlandService
from ignis.base_service import BaseService
from ignis.gobject import IgnisProperty
from ignis.utils import Utils
import os

from ..services import MyHyprlandService

def truncate_title(string: str, to: int) -> str:
    defaults = {
        "Spotify Premium" : "Spotify",
        "Zen Browser": "Zen"
    }

    if string in defaults:
        return defaults[string]
    elif len(string) > to:
        return string[:to] + "..."
    else:
        return string

hyprland = HyprlandService.get_default()
class CustomHyprlandService(BaseService):
    def __init__(self):
        super().__init__()

        self._clients: list[dict[str, Any]] = []

        hyprland.connect("notify::workspaces", lambda *_: self.__custom_sync_clients())
        hyprland.connect("notify::active-window", lambda *_: self.__custom_sync_clients())

        self.__custom_sync_clients()

    @IgnisProperty
    def clients(self) -> list[dict[str, Any]]:
        """
        - read-only

        A list of clients.
        """
        return self._clients

    def __custom_sync_clients(self) -> None:
        # Get all clients grouped by workspace
        clients_data = json.loads(
            Utils.exec_sh(
                "hyprctl clients -j | jq \
                    'group_by(.workspace.id) | map({id: .[0].workspace.id, clients: (map({class, title, initialTitle, focusHistoryID, pid}) | sort_by(.pid))})'"
            ).stdout
        )

        # Get the active workspace
        active_workspace = json.loads(Utils.exec_sh("hyprctl activeworkspace -j").stdout)

        # Check if the active workspace already has an entry, if not, add a placeholder entry
        active_workspace_id = active_workspace['id']
        workspace_found = False

        # Check if the active workspace is already in the grouped clients
        for workspace in clients_data:
            if workspace['id'] == active_workspace_id:
                workspace_found = True
                break

        # If no clients exist for the active workspace, add a placeholder with no clients
        if not workspace_found:
            clients_data.append({
                'id': active_workspace_id,
                'clients': []  # No clients in the active workspace
            })

        # Add the 'focused' field based on focusHistoryID
        for workspace in clients_data:
            for client in workspace['clients']:
                client['focused'] = (client['focusHistoryID'] == 0 and workspace_found)
                del client['focusHistoryID']

        # Update the clients list
        self._clients = sorted(clients_data, key = lambda x: x["id"])
        self.notify("clients")

hyprland_clients = CustomHyprlandService.get_default()

class WorkspaceButton(Widget.Button):
    def __init__(self, workspace: dict) -> None:
        super().__init__(
            css_classes=["workspace", "unset"],
            on_click=lambda x, id=workspace["id"]: hyprland.switch_to_workspace(id),
            halign="start",
            valign="center",
            child=Widget.CenterBox(
                hexpand=False,
                vexpand=False,
                center_widget = Widget.Box(
                    spacing = 8,
                    child=
                        [Widget.Label(label=str(workspace["id"]),
                                      css_classes=["workspace-number"])] +
                        [Widget.Box(
                            spacing=3,
                            child = [
                                Widget.Icon(image=Utils.get_app_icon_name(c["class"].lower()),
                                            pixel_size=32),
                                Widget.Label(label=truncate_title(c["initialTitle"], 12) if c["focused"] else "",
                                             css_classes=["workspace-title"])
                            ])
                        for c in workspace["clients"]
                    ]),
            )
        )
        if workspace["id"] == hyprland.active_workspace["id"]:
            self.add_css_class("active")


def scroll_workspaces(direction: str) -> None:
    current = hyprland.active_workspace["id"]
    if direction == "up":
        target = current - 1
        hyprland.switch_to_workspace(target)
    else:
        target = current + 1
        if target == 11:
            return
        hyprland.switch_to_workspace(target)


class Workspaces2(Widget.Box):
    def __init__(self):
        if hyprland.is_available:
            child = [
                Widget.EventBox(
                    on_scroll_up=lambda x: scroll_workspaces("up"),
                    on_scroll_down=lambda x: scroll_workspaces("down"),
                    css_classes=["workspaces"],
                    child=hyprland_clients.bind(
                        "clients",
                        transform=lambda value: [WorkspaceButton(i) for i in value],
                    ),
                )
            ]
        else:
            child = []
        super().__init__(child=child)
