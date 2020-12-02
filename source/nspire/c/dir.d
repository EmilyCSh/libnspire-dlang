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
module nspire.c.dir;
import nspire.c.handle;
import nspire.c.file : nspire_file_move;
import core.stdc.config;

extern (C):

enum nspire_dir_type
{
    NSPIRE_FILE = 0,
    NSPIRE_DIR = 1
}

struct nspire_dir_item
{
    char[240] name;
    c_ulong size;
    c_ulong date;
    nspire_dir_type type;
}

struct nspire_dir_info
{
    c_ulong num;
}

int nspire_dirlist (nspire_handle_t*, const(char)*, nspire_dir_info**);
void nspire_dirlist_free (nspire_dir_info* d);
int nspire_dir_create (nspire_handle_t* handle, const(char)* path);
int nspire_dir_delete (nspire_handle_t* handle, const(char)* path);

int nspire_attr (nspire_handle_t*, const(char)*, nspire_dir_item*);

alias nspire_dir_move = nspire_file_move;
alias nspire_dir_rename = nspire_file_move;

