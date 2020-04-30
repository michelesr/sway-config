#!/usr/bin/env python3
import dbus

bus = dbus.SystemBus()

def get_active_connections():
    conn = bus.get_object('org.freedesktop.NetworkManager', '/org/freedesktop/NetworkManager')
    iface = dbus.Interface(conn, dbus_interface='org.freedesktop.DBus.Properties')
    m = iface.get_dbus_method("Get", dbus_interface=None)
    return [ str(ac) for ac in m("org.freedesktop.NetworkManager", "ActiveConnections") ]

def get_active_connection_info(path):
    conn = bus.get_object('org.freedesktop.NetworkManager', path)
    iface = dbus.Interface(conn, dbus_interface='org.freedesktop.DBus.Properties')
    m = iface.get_dbus_method("Get", dbus_interface=None)
    Id = m("org.freedesktop.NetworkManager.Connection.Active", "Id")

    return str(Id)

if __name__ == '__main__':
    for connection in get_active_connections():
        print(get_active_connection_info(connection))
