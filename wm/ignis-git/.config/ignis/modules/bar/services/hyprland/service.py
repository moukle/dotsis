import json
import os
import socket
from ignis.utils import Utils
from typing import Any
from ignis.exceptions import HyprlandIPCNotFoundError
from ignis.base_service import BaseService
from ignis.gobject import IgnisProperty
from .constants import HYPR_SOCKET_DIR


class MyHyprlandService(BaseService):
    def __init__(self):
        super().__init__()

        self._workspaces: list[dict[str, Any]] = []
        self._workspaces2: list[dict[str, Any]] = []
        self._active_workspace: dict[str, Any] = {}
        self._kb_layout: str = ""
        self._active_window: dict[str, Any] = {}

        if self.is_available:
            self.__listen_events()

            self.__sync_kb_layout()
            self.__sync_workspaces()
            self.__sync_active_window()

    @IgnisProperty
    def is_available(self) -> bool:
        """
        - read-only

        Whether Hyprland IPC is available.
        """
        return os.path.exists(HYPR_SOCKET_DIR)

    @IgnisProperty
    def workspaces(self) -> list[dict[str, Any]]:
        """
        - read-only

        A list of workspaces.
        """
        return self._workspaces

    @IgnisProperty
    def workspaces2(self) -> list[dict[str, Any]]:
        """
        - read-only

        A list of workspaces.
        """
        return self._workspaces2

    @IgnisProperty
    def active_workspace(self) -> dict[str, Any]:
        """
        - read-only

        The currently active workspace.
        """
        return self._active_workspace

    @IgnisProperty
    def kb_layout(self) -> str:
        """
        - read-only

        The currenly active keyboard layout.
        """
        return self._kb_layout

    @IgnisProperty
    def active_window(self) -> dict[str, Any]:
        """
        - read-only

        The currenly focused window.
        """
        return self._active_window

    @Utils.run_in_thread
    def __listen_events(self) -> None:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
            sock.connect(f"{HYPR_SOCKET_DIR}/.socket2.sock")
            for event in Utils.listen_socket(sock, errors="ignore"):
                self.__on_event_received(event)

    def __on_event_received(self, event: str) -> None:
        if (
            event.startswith("workspace>>")
            or event.startswith("destroyworkspace>>")
            or event.startswith("focusedmon>>")
        ):
            self.__sync_workspaces()
        elif event.startswith("activelayout>>"):
            self.__sync_kb_layout()

        elif event.startswith("activewindow>>"):
            self.__sync_active_window()

    def __sync_workspaces(self) -> None:
        self._workspaces = sorted(
            json.loads(self.send_command("j/workspaces")), key=lambda x: x["id"]
        )
        self._active_workspace = json.loads(self.send_command("j/activeworkspace"))

        self._workspaces2 = json.loads(
            Utils.exec_sh(
                "hyprctl clients -j | jq 'group_by(.workspace.id) | map({id: .[0].workspace.id, clients: map({class, title})})'"
            ).stdout
        )

        self.notify("workspaces")
        self.notify("workspaces2")
        self.notify("active-workspace")

    def __sync_kb_layout(self) -> None:
        for kb in json.loads(self.send_command("j/devices"))["keyboards"]:
            if kb["main"]:
                self._kb_layout = kb["active_keymap"]
                self.notify("kb_layout")

    def __sync_active_window(self) -> None:
        self._active_window = json.loads(self.send_command("j/activewindow"))
        self.notify("active_window")

    def send_command(self, cmd: str) -> str:
        """
        Send a command to the Hyprland IPC.
        Supports the same commands as ``hyprctl``.
        If you want to receive the response in JSON format, use this syntax: ``j/COMMAND``.

        Args:
            cmd: The command to send.

        Returns:
            Response from Hyprland IPC.

        Raises:
            HyprlandIPCNotFoundError: If Hyprland IPC is not found.
        """
        if not self.is_available:
            raise HyprlandIPCNotFoundError()

        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
            sock.connect(f"{HYPR_SOCKET_DIR}/.socket.sock")
            return Utils.send_socket(sock, cmd, errors="ignore")

    def switch_kb_layout(self) -> None:
        """
        Switch to the next keyboard layout.
        """
        for kb in json.loads(self.send_command("j/devices"))["keyboards"]:
            if kb["main"]:
                self.send_command(f"switchxkblayout {kb['name']} next")

    def switch_to_workspace(self, workspace_id: int) -> None:
        """
        Switch to a workspace by its ID.

        Args:
            workspace_id: The ID of the workspace to switch to.
        """
        self.send_command(f"dispatch workspace {workspace_id}")
