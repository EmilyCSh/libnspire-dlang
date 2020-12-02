module nspire;

import nspire.device;
import nspire.c.handle;
import nspire.c.devinfo;
import nspire.c.error;
import nspire.c.file;
import nspire.c.dir;
import nspire.c.os;
import core.stdc.config;
                               
enum ErrorCodes {
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

enum DirType {
    NSPIRE_FILE = 0,
    NSPIRE_DIR = 1
}

struct DirItem {
    string name;
    ulong size;
    ulong date;
    DirType type;
    
    this(nspire_dir_item dirItem) {
        this.name = dirItem.name.dup;
        this.size = dirItem.size;
        this.date = dirItem.date;
        this.type = cast(DirType) dirItem.type;
    }
}

struct Image {
    ushort width;
    ushort height;
    ubyte bbp;
    ubyte[] data;
    
    this(ushort width, ushort height, ubyte bbp, ubyte[] data) {
        this.width = width;
        this.height = height;
        this.bbp = bbp;
        this.data = data;
    }
}

struct NSpire {
    private nspire_handle_t* handle;
    private bool isInit = false;
    
    int init() {
        auto ret = nspire_init(&this.handle);
        
        if (ret == NSPIRE_ERR_SUCCESS) {
           isInit = true;
        }
        
        return ret;
    }
    
    void deinit() {
        if (isInit && this.handle) {
            nspire_free(this.handle);
        }
    }
    
    DeviceInfo getDeviceInfo(out int error) {
        nspire_devinfo devinfo;
        
        if (!isInit) {
            error = NSPIRE_ERR_NODEVICE;
            return DeviceInfo();
        }
        
        error = nspire_device_info(this.handle, &devinfo);
        
        if (error != ErrorCodes.NSPIRE_ERR_SUCCESS) {
            return DeviceInfo();
        }
        
        return DeviceInfo(devinfo);
    }
    
    static string errorStr(int error) {
        import std.string : fromStringz;
        
        if (error == NSPIRE_ERR_SUCCESS) {
            return "No error";
        }
        
        return nspire_strerror(error).fromStringz.idup;
    }
    
    int writeFile(string path, void[] data) {
        import std.string : toStringz;
        
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_file_write(this.handle, path.toStringz, data.ptr, data.length);
    }
    
    int readFile(string path, void[] data, out size_t readBytes) {
        import std.string : toStringz;
        
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_file_read(this.handle, path.toStringz, data.ptr, data.length, &readBytes);
    }
    
    int moveFile(string pathSrc, string pathDst) {
        import std.string : toStringz;
        
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_file_move(this.handle, pathSrc.toStringz, pathDst.toStringz);
    }
    
    int copyFile(string pathSrc, string pathDst) {
        import std.string : toStringz;
        
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_file_copy(this.handle, pathSrc.toStringz, pathDst.toStringz);
    }
    
    int deleteFile(string path) {
        import std.string : toStringz;
        
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_file_delete(this.handle, path.toStringz);
    }
    
    DirItem[] dirList(string path, out int error) {
        import std.string : toStringz;
        import std.stdio;
        
        DirItem[] items;
        nspire_dir_info* dir_info;
        
        
        if (!isInit) {
            error = NSPIRE_ERR_NODEVICE;
            return items;
        }
        
        error = nspire_dirlist(this.handle, path.toStringz, &dir_info);
        
        if (error != NSPIRE_ERR_SUCCESS) {
            return null;
        }
        
        nspire_dir_item* itemsMem = cast(nspire_dir_item*) &dir_info[1];
            
        for (size_t i = 0; i < (*dir_info).num; i++) {
            items ~= DirItem(itemsMem[i]);
        }
            
        nspire_dirlist_free(dir_info);
        return items;
    }
    
    int createDirectory(string path) {
        import std.string : toStringz;
        
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_dir_create(this.handle, path.toStringz);
    }
    
    int deleteDirectory(string path) {
        import std.string : toStringz;
        
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_dir_delete(this.handle, path.toStringz);
    }
    
    DirItem getAttr(string path, out int error) {
        import std.string : toStringz;
        nspire_dir_item dir_item;
        
        if (!isInit) {
            error = NSPIRE_ERR_NODEVICE;
            return DirItem();
        }
        
        error = nspire_attr(this.handle, path.toStringz, &dir_item);
        
        if (error != NSPIRE_ERR_SUCCESS) {
            return DirItem();
        }
        
        return cast(DirItem) dir_item;
    }
    
    int sendOs(void[] data) {
        if (!isInit) {
            return NSPIRE_ERR_NODEVICE;
        }
        
        return nspire_os_send(this.handle, data.ptr, data.length);
    }
}
