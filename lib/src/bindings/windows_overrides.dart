import 'dart:ffi' as ffi;
import 'package:flutter_rtklib/src/rtklib_bindings.dart';
// ignore_for_file: camel_case_types, non_constant_identifier_names

class stream_t_w extends ffi.Struct {
  /// type (STR_???)
  @ffi.Int()
  external int type;

  /// mode (STR_MODE_?)
  @ffi.Int()
  external int mode;

  /// state (-1:error,0:close,1:open)
  @ffi.Int()
  external int state;

  /// input bytes/rate
  @ffi.Uint32()
  external int inb;

  @ffi.Uint32()
  external int inr;

  /// output bytes/rate
  @ffi.Uint32()
  external int outb;

  @ffi.Uint32()
  external int outr;

  /// input tick tick
  @ffi.Uint32()
  external int tick_i;

  /// output tick
  @ffi.Uint32()
  external int tick_o;

  /// active tick
  @ffi.Uint32()
  external int tact;

  /// input/output bytes at tick
  @ffi.Uint32()
  external int inbt;

  @ffi.Uint32()
  external int outbt;

  /// lock flag
  external CRITICAL_SECTION lock;

  /// type dependent port control struct
  external ffi.Pointer<ffi.Void> port;

  @ffi.Array.multi([1024])
  external ffi.Array<ffi.Char> path;

  @ffi.Array.multi([1024])
  external ffi.Array<ffi.Char> msg;
}

typedef CRITICAL_SECTION = RTL_CRITICAL_SECTION;
typedef RTL_CRITICAL_SECTION = _RTL_CRITICAL_SECTION;

class _RTL_CRITICAL_SECTION extends ffi.Struct {
  external PRTL_CRITICAL_SECTION_DEBUG DebugInfo;

  @LONG()
  external int LockCount;

  @LONG()
  external int RecursionCount;

  external HANDLE OwningThread;

  external HANDLE LockSemaphore;

  @ULONG_PTR()
  external int SpinCount;
}

typedef PRTL_CRITICAL_SECTION_DEBUG = ffi.Pointer<_RTL_CRITICAL_SECTION_DEBUG>;

class _RTL_CRITICAL_SECTION_DEBUG extends ffi.Struct {
  @WORD()
  external int Type;

  @WORD()
  external int CreatorBackTraceIndex;

  external ffi.Pointer<_RTL_CRITICAL_SECTION> CriticalSection;

  external LIST_ENTRY ProcessLocksList;

  @DWORD()
  external int EntryCount;

  @DWORD()
  external int ContentionCount;

  @DWORD()
  external int Flags;

  @WORD()
  external int CreatorBackTraceIndexHigh;

  @WORD()
  external int SpareWORD;
}

typedef WORD = ffi.UnsignedShort;
typedef LIST_ENTRY = _LIST_ENTRY;

class _LIST_ENTRY extends ffi.Struct {
  external ffi.Pointer<_LIST_ENTRY> Flink;

  external ffi.Pointer<_LIST_ENTRY> Blink;
}

typedef DWORD = ffi.UnsignedLong;
typedef LONG = ffi.Long;
typedef HANDLE = ffi.Pointer<ffi.Void>;
typedef ULONG_PTR = ffi.UnsignedLongLong;

/// stream server type
class strsvr_t_w extends ffi.Struct {
  /// server state (0:stop,1:running)
  @ffi.Int()
  external int state;

  /// server cycle (ms)
  @ffi.Int()
  external int cycle;

  /// input/monitor buffer size (bytes)
  @ffi.Int()
  external int buffsize;

  /// NMEA request cycle (ms) (0:no)
  @ffi.Int()
  external int nmeacycle;

  /// relay back of output streams (0:no)
  @ffi.Int()
  external int relayback;

  /// number of streams (1 input + (nstr-1) outputs
  @ffi.Int()
  external int nstr;

  /// data length in peek buffer (bytes)
  @ffi.Int()
  external int npb;

  @ffi.Array.multi([16, 4096])
  external ffi.Array<ffi.Array<ffi.Char>> cmds_periodic;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Double> nmeapos;

  /// input buffers
  external ffi.Pointer<ffi.Uint8> buff;

  /// peek buffer
  external ffi.Pointer<ffi.Uint8> pbuf;

  /// start tick
  @ffi.Uint32()
  external int tick;

  @ffi.Array.multi([16])
  external ffi.Array<stream_t_w> stream;

  @ffi.Array.multi([16])
  external ffi.Array<stream_t_w> strlog;

  @ffi.Array.multi([16])
  external ffi.Array<ffi.Pointer<strconv_t>> conv;

  /// server thread
  external HANDLE thread;

  /// lock flag
  external CRITICAL_SECTION lock;
}

/// RTK server type
class rtksvr_t_w extends ffi.Struct {
  /// server state (0:stop,1:running)
  @ffi.Int()
  external int state;

  /// processing cycle (ms)
  @ffi.Int()
  external int cycle;

  /// NMEA request cycle (ms) (0:no req)
  @ffi.Int()
  external int nmeacycle;

  /// NMEA request (0:no,1:nmeapos,2:single sol)
  @ffi.Int()
  external int nmeareq;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Double> nmeapos;

  /// input buffer size (bytes)
  @ffi.Int()
  external int buffsize;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Int> format;

  @ffi.Array.multi([2])
  external ffi.Array<solopt_t> solopt;

  /// ephemeris select (0:all,1:rover,2:base,3:corr)
  @ffi.Int()
  external int navsel;

  /// number of sbas message
  @ffi.Int()
  external int nsbs;

  /// number of solution buffer
  @ffi.Int()
  external int nsol;

  /// RTK control/result struct
  external rtk_t rtk;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Int> nb;

  @ffi.Array.multi([2])
  external ffi.Array<ffi.Int> nsb;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Int> npb;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Pointer<ffi.Uint8>> buff;

  @ffi.Array.multi([2])
  external ffi.Array<ffi.Pointer<ffi.Uint8>> sbuf;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Pointer<ffi.Uint8>> pbuf;

  @ffi.Array.multi([256])
  external ffi.Array<sol_t> solbuf;

  @ffi.Array.multi([3, 10])
  external ffi.Array<ffi.Array<ffi.Uint32>> nmsg;

  @ffi.Array.multi([3])
  external ffi.Array<raw_t> raw;

  @ffi.Array.multi([3])
  external ffi.Array<rtcm_t> rtcm;

  @ffi.Array.multi([3])
  external ffi.Array<gtime_t> ftime;

  @ffi.Array.multi([3, 1024])
  external ffi.Array<ffi.Array<ffi.Char>> files;

  @ffi.Array.multi([3, 128])
  external ffi.Array<ffi.Array<obs_t>> obs;

  /// navigation data
  external nav_t nav;

  @ffi.Array.multi([32])
  external ffi.Array<sbsmsg_t> sbsmsg;

  @ffi.Array.multi([8])
  external ffi.Array<stream_t_w> stream;

  /// monitor stream
  external ffi.Pointer<stream_t_w> moni;

  /// start tick
  @ffi.Uint32()
  external int tick;

  /// server thread
  external HANDLE thread;

  /// CPU time (ms) for a processing cycle
  @ffi.Int()
  external int cputime;

  /// missing observation data count
  @ffi.Int()
  external int prcout;

  /// number of averaging base pos
  @ffi.Int()
  external int nave;

  @ffi.Array.multi([3])
  external ffi.Array<ffi.Double> rb_ave;

  @ffi.Array.multi([3, 4096])
  external ffi.Array<ffi.Array<ffi.Char>> cmds_periodic;

  @ffi.Array.multi([4096])
  external ffi.Array<ffi.Char> cmd_reset;

  /// baseline length to reset (km)
  @ffi.Double()
  external double bl_reset;

  /// lock flag
  external CRITICAL_SECTION lock;
}

/*
class __sFILE_w extends ffi.Opaque {}

typedef va_list_w = ffi.Pointer<ffi.Char>;

const int FILEPATHSEP_W = 92; // '\\'
*/