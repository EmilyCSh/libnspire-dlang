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
module nspire.c.error;
extern (C):

enum
{
    NSPIRE_ERR_SUCCESS = 0,

    /* Generic */
    NSPIRE_ERR_TIMEOUT = -1,
    NSPIRE_ERR_NOMEM = -2,
    NSPIRE_ERR_INVALID = -3,

    /* USB */
    NSPIRE_ERR_LIBUSB = -4,
    NSPIRE_ERR_NODEVICE = -5,

    /* Packet */
    NSPIRE_ERR_INVALPKT = -6,
    NSPIRE_ERR_NACK = -7,

    /* Service */
    NSPIRE_ERR_BUSY = -8,

    /* File/Dir services */
    NSPIRE_ERR_EXISTS = -9,
    NSPIRE_ERR_NONEXIST = -10,

    /* OS install */
    NSPIRE_ERR_OSFAILED = -11,

    /* Number of errors */
    NSPIRE_ERR_MAX = -12
}

const(char)* nspire_strerror (int error);

