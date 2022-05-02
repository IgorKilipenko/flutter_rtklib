// ignore_for_file: constant_identifier_names

import 'dart:typed_data';
import 'dart:math';

import 'package:flutter_rtklib/src/rcv/ublox/class_ids.dart';

const MAX_MSG_LEN = 8192;
const HEADER_BYTES = [181, 98];

const UBX_SYNCH_1 = 0xb5;
const UBX_SYNCH_2 = 0x62;

const PAYLOAD_OFFSET = 6;
const CHECKSUM_LEN = 2;

class UbxDecoder {
  int _nbyte = 0;
  final Uint8List _uintBuffer = Uint8List(MAX_MSG_LEN);
  //ByteData _dataView;

  UbxDecoder() {
    //this._dataView = new ByteData.view(_uintBuffer.buffer);
  }

  //_allowedClasses = [];

  //final _payloadOffset = 6;
  var _length = 0;
  bool syncHeader(int data, Uint8List buffer) {
    buffer[0] = buffer[1];
    buffer[1] = data;

    return checkHeader(buffer);
  }

  bool checkHeader(Uint8List buffer) {
    return buffer[0] == HEADER_BYTES[0] && buffer[1] == HEADER_BYTES[1];
  }

  dynamic decodePvtMsg(UbxPacket ubxPacket) {
    if (ubxPacket.payloadLength < 92) {
      print('Warn decode PVT message, payload length < 92');
      return null;
    }

    var payload = ubxPacket.payload;

    final PvtMessage pvtMsg = PvtMessage.init(
      classId: ClassIds['NAV'],
      msgId: NavMessageIds['PVT'],
      iTow: payload.getUint32(0, Endian.little),
      year: payload.getUint16(4, Endian.little),
      month: payload.getUint8(6),
      day: payload.getUint8(7),
      hour: payload.getUint8(8),
      min: payload.getUint8(9),
      sec: payload.getUint8(10),
      //  ..............
      fixType: payload.getUint8(20),
      carrierSolution: payload.getUint8(21) >> 6,
      numSatInSolution: payload.getUint8(23),
      longitude: _getDeg(payload.getInt32(24, Endian.little), 7),
      latitude: _getDeg(payload.getInt32(28, Endian.little), 7),
      height: _getDistM(payload.getInt32(32, Endian.little).toDouble()),
      heightMSL: _getDistM(payload.getInt32(36, Endian.little).toDouble()),
      horizontalAcc: _getDistM(payload.getUint32(40, Endian.little).toDouble()),
      verticalAcc: _getDistM(payload.getUint32(44, Endian.little).toDouble()),
      groundSpeed: _getDistM(payload.getInt32(60, Endian.little).toDouble()),
      headMotion: _getDeg(payload.getInt32(64, Endian.little), 5),
      speedAcc: _getDistM(payload.getUint32(68, Endian.little).toDouble()),
      headAcc: _getDeg(payload.getUint32(72, Endian.little), 5),
      pDOP: payload.getUint16(76, Endian.little),
      headVeh: _getDeg(payload.getInt32(84, Endian.little), 5),
      // ...............
    );

    return pvtMsg;
  }

  UbxPacket? inputData(int data) {
    if (_nbyte == 0) {
      _length = 0;
      if (!syncHeader(data, _uintBuffer)) {
        return null;
      } else {
        _nbyte = 2;
        return null;
      }
    }

    _uintBuffer[_nbyte++] = data;

    if (_nbyte == PAYLOAD_OFFSET) {
      //****this._length = new Uint16Array(this._buffer, 4, 2)[0] + 8;
      _length = Uint16List.view(_uintBuffer.buffer, 4, 2)[0] + 8;
      if (_length > MAX_MSG_LEN) {
        _nbyte = 0;
        return null;
      }
    }

    if (_nbyte == _length) {
      _nbyte = 0;
      if (!checkHeader(_uintBuffer)) {
        return null;
      }
      if (testChecksum(_uintBuffer, _length)) {
        ////********const ubxPacket = this.decodePacket(new DataView(buffer.buffer.slice(0, this._length)));
        final ubxPacket = decodePacket(ByteData.view(
            _cloneByteBuffer(_uintBuffer.buffer, 0, _length)));
        if (ubxPacket != null) {
          //////this.emit(UbxDecoder._emits.ubxPacket, ubxPacket);
          if (ubxPacket.classId == ClassIds['NAV']) {
            if (ubxPacket.msgId == NavMessageIds['PVT']) {
              var pvtMsg = decodePvtMsg(ubxPacket);
              if (pvtMsg != null) {
                /////this.emit(
                /////    UbxDecoder._emits.pvtMsg,
                /////    pvtMsg
                /////);
                return pvtMsg;
              }
            }

            //////case NavMessageIds.HPPOSLLH:
            //////  const hpposllhMsg = this.decodeNavHPPOSLLHMsg(ubxPacket);
            //////  if (hpposllhMsg) {
            //////    this.emit(UbxDecoder._emits.hpposllh, hpposllhMsg);
            //////    return hpposllhMsg;
            //////  }

          } else {
            ///// this.emit(UbxDecoder._emits.message, ubxPacket);
          }
        }

        return ubxPacket;
      }
    }

    return null;
  }

  bool testChecksum(Uint8List buffer, int length) {
    Uint8List ck = Uint8List.fromList([0, 0]);
    const offset = 2;
    final int len = length - 2;

    //num i = offset;
    for (int i = offset; i < len; i++) {
      ck[0] += buffer[i];
      ck[1] += ck[0];
    }
    bool res = (ck[0] == buffer[length - 2]) && (ck[1] == buffer[length - 1]);
    return res;
  }

  UbxPacket? decodePacket(ByteData view) {
    final sync_1 = view.getUint8(0);
    final sync_2 = view.getUint8(1);
    final classId = view.getUint8(2);
    final msgId = view.getUint8(3);
    final payloadLength = view.getUint16(4, Endian.little);
    final packetLength = PAYLOAD_OFFSET + payloadLength + CHECKSUM_LEN;
    if (packetLength <= 0 || view.lengthInBytes < packetLength) {
      print('Error decode ubxPacket. Buffer length !== packetLength');
      return null;
    }

    ///const payload = new DataView(
    ///    view.buffer.slice(PAYLOAD_OFFSET, packetLength - CHECKSUM_LEN)
    ///);

    final payload = ByteData.view(view.buffer, PAYLOAD_OFFSET,
        packetLength - CHECKSUM_LEN - PAYLOAD_OFFSET);

    final checkSum = view.getInt16(packetLength - CHECKSUM_LEN, Endian.little);
    final UbxPacket ubxPacket = UbxPacket.init(
        sync_1: sync_1,
        sync_2: sync_2,
        classId: classId,
        msgId: msgId,
        payloadLength: payloadLength,
        packetLength: packetLength,
        payload: payload,
        checkSum: checkSum);

    //ubxPacket.sync_1 = sync_1;
    //ubxPacket.sync_2 = sync_2;
    //ubxPacket.classId = classId;
    //ubxPacket.msgId = msgId;
    //ubxPacket.payloadLength = payloadLength;
    //ubxPacket.packetLength = packetLength;
    //ubxPacket.payload = payload;
    //ubxPacket.checkSum = checkSum;

    return ubxPacket;
  }
}

class UbxPacket {
  late int sync_1;
  late int sync_2;
  late int classId;
  late int msgId;
  late int payloadLength;
  late int packetLength;
  late ByteData payload;
  late int checkSum;

  UbxPacket();

  UbxPacket.init(
      {
      required this.sync_1,
      required this.sync_2,
      required this.classId,
      required this.msgId,
      required this.payloadLength,
      required this.packetLength,
      required this.payload,
      required this.checkSum
      });
}

class PvtMessage extends UbxPacket {
  late num iTow;
  late num year;
  late num month;
  late num day;
  late num hour;
  late num min;
  late num sec;
  //  ..............
  int fixType;
  int carrierSolution;
  int numSatInSolution;
  double longitude;
  double latitude;
  double height;
  double heightMSL;
  num horizontalAcc;
  num verticalAcc;
  num groundSpeed;
  num headMotion;
  num speedAcc;
  num headAcc;
  num pDOP;
  num headVeh;
  // ...............

  PvtMessage.init({
    sync_1,
    sync_2,
    classId,
    msgId,
    payloadLength,
    packetLength,
    payload,
    checkSum,
    iTow,
    year,
    month,
    day,
    hour,
    min,
    sec,
    //  ..............
    required this.fixType,
    required this.carrierSolution,
    required this.numSatInSolution,
    required this.longitude,
    required this.latitude,
    required this.height,
    required this.heightMSL,
    required this.horizontalAcc,
    required this.verticalAcc,
    required this.groundSpeed,
    required this.headMotion,
    required this.speedAcc,
    required this.headAcc,
    required this.pDOP,
    required this.headVeh,
    // ...............
  }) : super.init(
            sync_1: sync_1,
            sync_2: sync_2,
            classId: classId,
            msgId: msgId,
            payloadLength: payloadLength,
            packetLength: packetLength,
            payload: payload,
            checkSum: checkSum);
}

double _getDeg(num deg, num e) {
  return deg / pow(10, e);
}

double _getDistM(double val) {
  return val / 1000;
}

ByteBuffer _cloneByteBuffer(ByteBuffer buffer, int start, int end) {
  assert(start >= 0 && end >= start && end <= buffer.lengthInBytes);

  var ub = Uint8List.view(buffer);
  return ub.sublist(start, end).buffer;
}
