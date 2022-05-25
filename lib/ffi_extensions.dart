import 'dart:ffi' as ffi;
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as pkg_ffi;

typedef CString = ffi.Pointer<ffi.Char>;
typedef CStringArray = ffi.Pointer<CString>;

String getRootDirectory() {
  return File(Platform.script.toFilePath(windows: false)).parent.absolute.path;
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
