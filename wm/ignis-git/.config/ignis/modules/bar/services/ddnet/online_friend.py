from ignis.gobject import IgnisProperty
from ignis.gobject import DataGObject

MATCH_DICT = {
    "name": "name",
    "server": "server",
    "map": "map"
}

class OnlineFriend(DataGObject):
    def __init__(self) -> None:
        super().__init__(match_dict=MATCH_DICT)
        self._name: str = ""
        self._server: str = ""
        self._map: str = ""

    @IgnisProperty
    def name(self) -> str:
        return self._name

    @IgnisProperty
    def server(self) -> str:
        return self._server

    @IgnisProperty
    def map(self) -> str:
        return self._map

