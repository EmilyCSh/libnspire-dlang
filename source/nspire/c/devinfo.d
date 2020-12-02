/*
    This file is part of libnspire.

    libnspire is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    libnspire is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with libnspire.  If not, see <http://www.gnu.org/licenses/>.
*/
module nspire.c.devinfo;
import nspire.c.handle;

extern (C):

enum nspire_battery
{
    NSPIRE_BATT_POWERED = 0,
    NSPIRE_BATT_LOW = 241,
    NSPIRE_BATT_OK = 127,
    NSPIRE_BATT_UNKNOWN = 255
}

enum nspire_version_index
{
    NSPIRE_VER_OS = 0,
    NSPIRE_VER_BOOT1 = 1,
    NSPIRE_VER_BOOT2 = 2,

    /* Reserved */
    NSPIRE_VER_MAXNUM = 3
}

enum nspire_type
{
    NSPIRE_CAS = 14,
    NSPIRE_NONCAS = 30,
    NSPIRE_CASCX = 15,
    NSPIRE_NONCASCX = 31
}

enum nspire_runlevel
{
    NSPIRE_RUNLEVEL_RECOVERY = 1,
    NSPIRE_RUNLEVEL_OS = 2
}

struct nspire_devinfo
{
    /* Flash storage */
    struct _Anonymous_0
    {
        ulong free;
        ulong total;
    }

    _Anonymous_0 storage;

    /* Memory */
    struct _Anonymous_1
    {
        ulong free;
        ulong total;
    }

    _Anonymous_1 ram;

    /* Versions */
    struct _Anonymous_2
    {
        ubyte major;
        ubyte minor;
        ushort build;
    }

    _Anonymous_2[nspire_version_index.NSPIRE_VER_MAXNUM] versions;
    nspire_type hw_type;

    /* Power */
    struct _Anonymous_3
    {
        nspire_battery status;
        ubyte is_charging;
    }

    _Anonymous_3 batt;
    ubyte clock_speed;

    /* LCD */
    struct _Anonymous_4
    {
        ushort width;
        ushort height;
        ubyte bbp;
        ubyte sample_mode;
    }

    _Anonymous_4 lcd;

    /* File extensions */
    struct _Anonymous_5
    {
        char[8] file;
        char[8] os;
    }

    _Anonymous_5 extensions;

    /* ID */
    char[20] device_name;
    char[28] electronic_id;

    /* Misc */
    nspire_runlevel runlevel;
}

int nspire_device_info (nspire_handle_t* handle, nspire_devinfo* i);

