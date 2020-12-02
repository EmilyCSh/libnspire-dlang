module nspire.device;
import nspire.c.devinfo;

enum Battery {
    NSPIRE_BATT_POWERED = 0,
    NSPIRE_BATT_LOW = 241,
    NSPIRE_BATT_OK = 127,
    NSPIRE_BATT_UNKNOWN = 255
}

enum HWType {
    NSPIRE_CAS = 14,
    NSPIRE_NONCAS = 30,
    NSPIRE_CASCX = 15,
    NSPIRE_NONCASCX = 31,
    NSPIRE_CASCX_2 = 28,
    NSPIRE_NONCASCX_2 = 44
}

enum RunLevel
{
    NSPIRE_RUNLEVEL_RECOVERY = 1,
    NSPIRE_RUNLEVEL_OS = 2
}

struct FlashStorage {
    ulong free;
    ulong total;
}

struct Memory {
    ulong free;
    ulong total;
}

struct Version {
    ubyte major;
    ubyte minor;
    ushort build;
}

struct Power {
    Battery status;
    byte isCharging;
}

struct LCD {
    ushort width;
    ushort height;
    ubyte bbp;
    ubyte sampleMode;
}

struct FileExtensions {
    char[8] file;
    char[8] os;
}

struct DeviceInfo {
    FlashStorage flashStorage;
    Memory memory;  
    Version versionOs;
    Version versionBoot1;
    Version versionBoot2;
    HWType hwType;
    bool isCharging;
    Battery batteryStatus;
    ubyte clockSpeed;
    LCD lcd;
    FileExtensions fileExtensions;
    string deviceName;
    string electronicId;
    RunLevel runLevel;
    
    this(nspire_devinfo devinfo) {
        this.flashStorage = cast(FlashStorage) devinfo.storage;
        this.memory = cast(Memory) devinfo.ram;
        this.versionOs = cast(Version) devinfo.versions[nspire_version_index.NSPIRE_VER_OS];
        this.versionBoot1 = cast(Version) devinfo.versions[nspire_version_index.NSPIRE_VER_BOOT1];
        this.versionBoot2 = cast(Version) devinfo.versions[nspire_version_index.NSPIRE_VER_BOOT2];
        this.hwType = cast(HWType) devinfo.hw_type;
        this.isCharging = devinfo.batt.is_charging != 0;
        this.batteryStatus = cast(Battery) devinfo.batt.status;
        this.clockSpeed = devinfo.clock_speed;
        this.lcd = cast(LCD) devinfo.lcd;
        this.fileExtensions = cast(FileExtensions) devinfo.extensions;
        this.deviceName = devinfo.device_name.dup;
        this.electronicId = devinfo.electronic_id.dup;
        this.runLevel = cast(RunLevel) devinfo.runlevel;
    }
}
