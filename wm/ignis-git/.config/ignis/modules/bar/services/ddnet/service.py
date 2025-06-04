import requests
import os
from time import sleep

from typing import List

from ignis.base_service import BaseService
from ignis.gobject import IgnisProperty
from ignis.utils import Utils

from .online_friend import OnlineFriend
from .constants import DEFAULT_ENDPOINT_URL, DEFAULT_DDNET_SETTINGS

class DDNetService(BaseService):
    def __init__(self):
        super().__init__()
        self._friends_online: List[OnlineFriend] = []
        self._friends: List[str] = []

        if self.is_available:
            self.__update_friends()
            self.__update_friends_online()
            self.__poll()

    @IgnisProperty
    def is_available(self) -> bool:
        def internet_connection():
            try:
                response = requests.get(DEFAULT_ENDPOINT_URL, timeout=5)
                return True
            except requests.ConnectionError:
                return False

        return (os.path.exists(DEFAULT_DDNET_SETTINGS) and
                internet_connection())

    @IgnisProperty
    def friends_online(self) -> List[OnlineFriend]:
        return self._friends_online

    @Utils.run_in_thread
    def __poll(self) -> None:
        while True:
            sleep(60)
            self.__update_friends_online()

    def __update_friends(self) -> None:
        with open(DEFAULT_DDNET_SETTINGS, "r") as f:
            lines = [line.strip() for line in f if line.startswith("add_friend")]
        names = [line.split('"')[1] for line in lines]
        self.friends = [n for n in names if n != '']

    def __update_friends_online(self) -> None:
        res = requests.get(DEFAULT_ENDPOINT_URL).json()
        servers = res["servers"]
        found_friends = [
            {
                "name": client["name"], 
                "server": server["info"]["name"],
                "server_ip": server["addresses"][0],
                "map": server["info"]["map"]["name"]
            }
            for server in servers
            for client in server.get("info", {}).get("clients", [])
            if client["name"] in self.friends
        ]

        self._friends_online = [OnlineFriend() for _ in found_friends]
        [f.sync(fd) for f,fd in zip(self._friends_online, found_friends)]
        self.notify("friends_online")
