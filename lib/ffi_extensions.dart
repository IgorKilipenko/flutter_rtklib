import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as pkg_ffi;

typedef CString = ffi.Pointer<ffi.Char>;
typedef CStringArray = ffi.Pointer<CString>;

String getRootDirectory() {
  final scriptPath = Platform.script.toFilePath(windows: Platform.isWindows);
  final rootDir = File(scriptPath).parent.absolute.path;
  return rootDir;
}

CStringArray _strListToPointer(List<String> strings,
    {ffi.Allocator allocator = pkg_ffi.malloc}) {
  final resPtr = allocator<CString>(strings.length);

  strings.asMap().forEach((index, utf) {
    resPtr[index] = utf.toNativeUtf8(allocator: allocator).cast<ffi.Char>();
  });

  return resPtr;
}

extension PointerUtils on ffi.Pointer<ffi.NativeType> {
  bool get isNullPointer => address == 0;

  Uint8List copyRange(int length) {
    final list = Uint8List(length);
    list.setAll(0, cast<ffi.Uint8>().asTypedList(length));
    return list;
  }
}

extension ListStringUtils on List<String> {
  CStringArray toNativeArray({ffi.Allocator allocator = pkg_ffi.malloc}) {
    return _strListToPointer(this, allocator: allocator);
  }
}

extension ListDoubleUtils on List<double> {
  ffi.Pointer<ffi.Double> toNativeArray({ffi.Allocator allocator = pkg_ffi.malloc}) {
    final units = this;
    final result = allocator<ffi.Double>(units.length);
    final nativeArray = result.asTypedList(units.length);
    nativeArray.setAll(0, units);
    return result;
  }
}
