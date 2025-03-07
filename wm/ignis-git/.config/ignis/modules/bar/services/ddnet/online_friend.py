import asyncio
from ignis.gobject import IgnisProperty, DataGObject
from ignis.utils import Utils


MATCH_DICT = {
    "name": "name",
    "server": "server",
    "server_ip": "server_ip",
    "map": "map"
}

class OnlineFriend(DataGObject):
    def __init__(self) -> None:
        super().__init__(match_dict=MATCH_DICT)
        self._name: str = ""
        self._server: str = ""
        self._server_ip: str = ""
        self._map: str = ""

    @IgnisProperty
    def name(self) -> str:
        return self._name

    @IgnisProperty
    def server(self) -> str:
        return self._server

    @IgnisProperty
    def server_ip(self) -> str:
        return self._server_ip

    @IgnisProperty
    def map(self) -> str:
        return self._map

    def join(self) -> None:
        asyncio.create_task(
            Utils.exec_sh_async(
                f"DDNet 'connect {self.server_ip}'"
            )
        )
