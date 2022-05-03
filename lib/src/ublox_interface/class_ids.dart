// ignore_for_file: constant_identifier_names

class ClassIds {
  /// UBX-NAV – Navigation solution messages
  static const NAV = 0x01;

  /// UBX-RXM – Receiver manager messages
  static const RXM = 0x02;

  /// UBX-INF – Information messages
  static const INF = 0x04;

  /// UBX-ACK – Acknowledgement and negative acknowledgement messages
  static const ACK = 0x05;

  /// UBX-CFG – Configuration and command messages
  static const CFG = 0x06;

  /// UBX-UPD – Firmware update messages
  static const UPD = 0x09;

  // UBX-MON – Monitoring messages
  static const MON = 0x0a;

  /// UBX-TIM – Timing messages
  static const TIM = 0x0d;

  /// UBX-MGA – GNSS assistance (A-GNSS) messages. Assistance data for various GNS
  static const MGA = 0x13;

  /// UBX-LOG – Logging messages
  static const LOG = 0x21;

  /// UBX-SEC – Security messages
  static const SEC = 0x27;

  /// UBX-NAV2 – Navigation solution messages (Secondary output)
  static const NAV2 = 0x29;
}

/// UBX-NAV – Navigation solution messages
class UbxNavigationMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.NAV;

  /// Clock solution (Periodic/polled)
  static const CLOCK = /*0x01*/ 0x22;

  /// Covariance matrices (Periodic/polled)
  static const COV = /*0x01*/ 0x36;

  /// Dilution of precision (Periodic/polled)
  static const DOP = /*0x01*/ 0x04;

  /// End of epoch (Periodic)
  static const EOE = /*0x01*/ 0x61;

  /// Geofencing status (Periodic/polled)
  static const GEOFENCE = /*0x01*/ 0x39;

  /// High precision position solution in ECEF (Periodic/polled)
  static const HPPOSECEF = /*0x01*/ 0x13;

  /// High precision geodetic position solution (Periodic/polled)
  static const HPPOSLLH = /*0x01*/ 0x14;

  /// Odometer solution (Periodic/polled)
  static const ODO = /*0x01*/ 0x09;

  /// GNSS orbit database info (Periodic/polled)
  static const ORB = /*0x01*/ 0x34;

  /// Protection level information (Periodic)
  static const PL = /*0x01*/ 0x62;

  /// Position solution in ECEF (Periodic/polled)
  static const POSECEF = /*0x01*/ 0x01;

  /// Geodetic position solution (Periodic/polled)
  static const POSLLH = /*0x01*/ 0x02;

  /// Navigation position velocity time solution (Periodic/polled)
  static const PVT = /*0x01*/ 0x07;

  /// Relative positioning information in NED frame (Periodic/polled)
  static const RELPOSNED = /*0x01*/ 0x3c;

  /// Reset odometer (Command)
  static const RESETODO = /*0x01*/ 0x10;

  /// Satellite information (Periodic/polled)
  static const SAT = /*0x01*/ 0x35;

  /// SBAS status data (Periodic/polled)
  static const SBAS = /*0x01*/ 0x32;

  /// Signal information (Periodic/polled)
  static const SIG = /*0x01*/ 0x43;

  /// QZSS L1S SLAS status data (Periodic/polled)
  static const SLAS = /*0x01*/ 0x42;

  /// Receiver navigation status (Periodic/polled)
  static const STATUS = /*0x01*/ 0x03;

  /// Survey-in data (Periodic/polled)
  static const SVIN = /*0x01*/ 0x3b;

  /// BeiDou time solution (Periodic/polled)
  static const TIMEBDS = /*0x01*/ 0x24;

  /// Galileo time solution (Periodic/polled)
  static const TIMEGAL = /*0x01*/ 0x25;

  /// GLONASS time solution (Periodic/polled)
  static const TIMEGLO = /*0x01*/ 0x23;

  /// GPS time solution (Periodic/polled)
  static const TIMEGPS = /*0x01*/ 0x20;

  /// Leap second event information (Periodic/polled)
  static const TIMELS = /*0x01*/ 0x26;

  /// QZSS time solution (Periodic/polled)
  static const TIMEQZSS = /*0x01*/ 0x27;

  /// UTC time solution (Periodic/polled)
  static const TIMEUTC = /*0x01*/ 0x21;

  /// Velocity solution in ECEF (Periodic/polled)
  static const VELECEF = /*0x01*/ 0x11;

  /// Velocity solution in NED frame (Periodic/polled)
  static const VELNED = /*0x01*/ 0x12;
}

/// UBX-CFG – Configuration and command messages
class UbxConfigMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.NAV;

  /// Antenna control settings (Get/set)
  static const UBX_CFG_ANT = /*0x06*/ 0x13;

  /// Clear, save and load configurations (Command)
  static const UBX_CFG_CFG = /*0x06*/ 0x09;

  /// Set user-defined datum (Set)
  /// Get currently defined datum (Get)
  static const UBX_CFG_DAT = /*0x06*/ 0x06;

  /// DGNSS configuration (Get/set)
  static const UBX_CFG_DGNSS = /*0x06*/ 0x70;

  /// Geofencing configuration (Get/set)
  static const UBX_CFG_GEOFENCE = /*0x06*/ 0x69;

  /// GNSS system configuration (Get/set)
  static const UBX_CFG_GNSS = /*0x06*/ 0x3e;

  /// Poll configuration for one protocol (Poll request)
  /// Information message configuration (Get/set)
  static const UBX_CFG_INF = /*0x06*/ 0x02;

  /// Jamming/interference monitor configuration (Get/set)
  static const UBX_CFG_ITFM = /*0x06*/ 0x39;

  /// Data logger configuration (Get/set)
  static const UBX_CFG_LOGFILTER = /*0x06*/ 0x47;

  /// Poll a message configuration (Poll request)
  /// Set message rate(s) (Get/set)
  /// Set message rate (Get/set)
  static const UBX_CFG_MSG = /*0x06*/ 0x01;

  /// Navigation engine settings (Get/set)
  static const UBX_CFG_NAV5 = /*0x06*/ 0x24;

  /// Navigation engine expert settings (Get/set)
  static const UBX_CFG_NAVX5 = /*0x06*/ 0x23;

  /// Extended NMEA protocol configuration V1 (Get/set)
  static const UBX_CFG_NMEA = /*0x06*/ 0x17;

  /// Odometer, low-speed COG engine settings (Get/set)
  static const UBX_CFG_ODO = /*0x06*/ 0x1e;

  /// Polls the configuration for one I/O port (Poll request)
  /// Port configuration for UART ports (Get/set)
  /// Port configuration for USB port (Get/set)
  /// Port configuration for SPI port (Get/set)
  /// Port configuration for I2C (DDC) port (Get/set)
  static const UBX_CFG_PRT = /*0x06*/ 0x00;

  /// Put receiver in a defined power state (Set)
  static const UBX_CFG_PWR = /*0x06*/ 0x57;

  /// Navigation/measurement rate settings (Get/set)
  static const UBX_CFG_RATE = /*0x06*/ 0x08;

  /// Contents of remote inventory (Get/set)
  static const UBX_CFG_RINV = /*0x06*/ 0x34;

  /// Reset receiver / Clear backup data structures (Command)
  static const UBX_CFG_RST = /*0x06*/ 0x04;

  /// SBAS configuration (Get/set)
  static const UBX_CFG_SBAS = /*0x06*/ 0x16;

  /// Time mode settings 3 (Get/set)
  static const UBX_CFG_TMODE3 = /*0x06*/ 0x71;

  /// Time pulse parameters (Get/set)
  static const UBX_CFG_TP5 = /*0x06*/ 0x31;

  /// USB configuration (Get/set)
  static const UBX_CFG_USB = /*0x06*/ 0x1b;

  /// Delete configuration item values (Set)
  /// Delete configuration item values (with transaction) (Set)
  static const UBX_CFG_VALDEL = /*0x06*/ 0x8c;

  /// Get configuration items (Poll request)
  /// Configuration items (Polled)
  static const UBX_CFG_VALGET = /*0x06*/ 0x8b;

  /// Set configuration item values (Set)
  /// Set configuration item values (with transaction) (Set)
  static const UBX_CFG_VALSET = /*0x06*/ 0x8a;
}

/// UBX-ACK – Acknowledgement and negative acknowledgement messages
class UbxAcknowledgementMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.ACK;

  /// Message acknowledged (Output)
  static const UBX_ACK_ACK = /*0x05*/ 0x01;

  /// Message not acknowledged (Output)
  static const UBX_ACK_NAK = /*0x05*/ 0x00;
}

/// UBX-INF – Information messages
class UbxInformationMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.INF;

  /// ASCII output with debug contents (Output)
  static const UBX_INF_DEBUG = /*0x04*/ 0x04;

  /// ASCII output with error contents (Output)
  static const UBX_INF_ERROR = /*0x04*/ 0x00;

  /// ASCII output with informational contents (Output)
  static const UBX_INF_NOTICE = /*0x04*/ 0x02;

  /// ASCII output with test contents (Output)
  static const UBX_INF_TEST = /*0x04*/ 0x03;

  /// ASCII output with warning contents (Output)
  static const UBX_INF_WARNING = /*0x04*/ 0x01;
}

/// UBX-LOG – Logging messages
class UbxLogMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.LOG;

  /// Create log file (Command)
  static const UBX_LOG_CREATE = /*0x21*/ 0x07;

  /// Erase logged data (Command)
  static const UBX_LOG_ERASE = /*0x21*/ 0x03;

  /// Find index of a log entry based on a given time (Input)
  /// Response to FINDTIME request (Output)
  static const UBX_LOG_FINDTIME = /*0x21*/ 0x0e;

  /// Poll for log information (Poll request)
  /// Log information (Output)
  static const UBX_LOG_INFO = /*0x21*/ 0x08;

  /// Request log data (Command)
  static const UBX_LOG_RETRIEVE = /*0x21*/ 0x09;

  /// Position fix log entry (Output)
  static const UBX_LOG_RETRIEVEPOS = /*0x21*/ 0x0b;

  /// Odometer log entry (Output)
  static const UBX_LOG_RETRIEVEPOSEXTRA = /*0x21*/ 0x0f;

  /// Byte string log entry (Output)
  static const UBX_LOG_RETRIEVESTRING = /*0x21*/ 0x0d;

  /// Store arbitrary string in on-board flash (Command)
  static const UBX_LOG_STRING = /*0x21*/ 0x04;
}

/// UBX-MGA – GNSS assistance (A-GNSS) messages
class UbxAGnssMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.MGA;

  /// Multiple GNSS acknowledge message (Output)
  static const UBX_MGA_ACK = /*0x13*/ 0x60;

  /// BeiDou ephemeris assistance (Input)
  /// BeiDou almanac assistance (Input)
  /// BeiDou health assistance (Input)
  /// BeiDou UTC assistance (Input)
  /// BeiDou ionosphere assistance (Input)
  static const UBX_MGA_BDS = /*0x13*/ 0x03;

  /// Poll the navigation database (Poll request)
  /// Navigation database dump entry (Input/output)
  static const UBX_MGA_DBD = /*0x13*/ 0x80;

  /// Galileo ephemeris assistance (Input)
  /// Galileo almanac assistance (Input)
  /// Galileo GPS time offset assistance (Input)
  /// Galileo UTC assistance (Input)
  static const UBX_MGA_GAL = /*0x13*/ 0x02;

  /// GLONASS ephemeris assistance (Input)
  /// GLONASS almanac assistance (Input)
  /// GLONASS auxiliary time offset assistance (Input)
  static const UBX_MGA_GLO = /*0x13*/ 0x06;

  /// GPS ephemeris assistance (Input)
  /// GPS almanac assistance (Input)
  /// GPS health assistance (Input)
  /// GPS UTC assistance (Input)
  /// GPS ionosphere assistance (Input)
  static const UBX_MGA_GPS = /*0x13*/ 0x00;

  /// Initial position assistance (Input)
  /// Initial time assistance (Input)
  /// Initial clock drift assistance (Input)
  /// Initial frequency assistance (Input)
  static const UBX_MGA_INI = /*0x13*/ 0x40;

  /// QZSS ephemeris assistance (Input)
  /// QZSS almanac assistance (Input)
  /// QZSS health assistance (Input)
  static const UBX_MGA_QZSS = /*0x13*/ 0x05;
}

/// UBX-MON – Monitoring messages
class UbxMonitoringMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.MON;

  /// Communication port information (Periodic/polled)
  static const UBX_MON_COMMS = /*0x0a*/ 0x36;

  /// Information message major GNSS selection (Polled)
  static const UBX_MON_GNSS = /*0x0a*/ 0x28;

  /// Hardware status (Periodic/polled)
  static const UBX_MON_HW = /*0x0a*/ 0x09;

  /// Extended hardware status (Periodic/polled)
  static const UBX_MON_HW2 = /*0x0a*/ 0x0b;

  /// I/O pin status (Periodic/polled)
  static const UBX_MON_HW3 = /*0x0a*/ 0x37;

  /// I/O system status (Periodic/polled)
  static const UBX_MON_IO = /*0x0a*/ 0x02;

  /// Message parse and process status (Periodic/polled)
  static const UBX_MON_MSGPP = /*0x0a*/ 0x06;

  /// Installed patches (Polled)
  static const UBX_MON_PATCH = /*0x0a*/ 0x27;

  /// RF information (Periodic/polled)
  static const UBX_MON_RF = /*0x0a*/ 0x38;

  /// Receiver buffer status (Periodic/polled)
  static const UBX_MON_RXBUF = /*0x0a*/ 0x07;

  /// Receiver status information (Output)
  static const UBX_MON_RXR = /*0x0a*/ 0x21;

  /// Signal characteristics (Periodic/polled)
  static const UBX_MON_SPAN = /*0x0a*/ 0x31;

  /// Current system performance information (Periodic/polled)
  static const UBX_MON_SYS = /*0x0a*/ 0x39;

  /// Transmitter buffer status (Periodic/polled)
  static const UBX_MON_TXBUF = /*0x0a*/ 0x08;

  /// Receiver and software version (Polled)
  static const UBX_MON_VER = /*0x0a*/ 0x04;
}

/// UBX-NAV2 – Navigation solution messages (Secondary output)
class UbxNavigationSecMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.NAV2;

  /// Clock solution (Periodic/polled)
  static const UBX_NAV2_CLOCK = /*0x29*/ 0x22;

  /// Covariance matrices (Periodic/polled)
  static const UBX_NAV2_COV = /*0x29*/ 0x36;

  /// Dilution of precision (Periodic/polled)
  static const UBX_NAV2_DOP = /*0x29*/ 0x04;

  /// End of epoch (Periodic)
  static const UBX_NAV2_EOE = /*0x29*/ 0x61;

  /// Odometer solution (Periodic/polled)
  static const UBX_NAV2_ODO = /*0x29*/ 0x09;

  /// Position solution in ECEF (Periodic/polled)
  static const UBX_NAV2_POSECEF = /*0x29*/ 0x01;

  /// Geodetic position solution (Periodic/polled)
  static const UBX_NAV2_POSLLH = /*0x29*/ 0x02;

  /// Navigation position velocity time solution (Periodic/polled)
  static const UBX_NAV2_PVT = /*0x29*/ 0x07;

  /// Satellite information (Periodic/polled)
  static const UBX_NAV2_SAT = /*0x29*/ 0x35;

  /// SBAS status data (Periodic/polled)
  static const UBX_NAV2_SBAS = /*0x29*/ 0x32;

  /// Signal information (Periodic/polled)
  static const UBX_NAV2_SIG = /*0x29*/ 0x43;

  /// QZSS L1S SLAS status data (Periodic/polled)
  static const UBX_NAV2_SLAS = /*0x29*/ 0x42;

  /// Receiver navigation status (Periodic/polled)
  static const UBX_NAV2_STATUS = /*0x29*/ 0x03;

  /// Survey-in data (Periodic/polled)
  static const UBX_NAV2_SVIN = /*0x29*/ 0x3b;

  /// BeiDou time solution (Periodic/polled)
  static const UBX_NAV2_TIMEBDS = /*0x29*/ 0x24;

  /// Galileo time solution (Periodic/polled)
  static const UBX_NAV2_TIMEGAL = /*0x29*/ 0x25;

  /// GLONASS time solution (Periodic/polled)
  static const UBX_NAV2_TIMEGLO = /*0x29*/ 0x23;

  /// GPS time solution (Periodic/polled)
  static const UBX_NAV2_TIMEGPS = /*0x29*/ 0x20;

  /// Leap second event information (Periodic/polled)
  static const UBX_NAV2_TIMELS = /*0x29*/ 0x26;

  /// QZSS time solution (Periodic/polled)
  static const UBX_NAV2_TIMEQZSS = /*0x29*/ 0x27;

  /// UTC time solution (Periodic/polled)
  static const UBX_NAV2_TIMEUTC = /*0x29*/ 0x21;

  /// Velocity solution in ECEF (Periodic/polled)
  static const UBX_NAV2_VELECEF = /*0x29*/ 0x11;

  /// Velocity solution in NED frame (Periodic/polled)
  static const UBX_NAV2_VELNED = /*0x29*/ 0x12;
}

/// UBX-RXM – Receiver manager messages
class UbxReceiverManagerMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.RXM;

  /// Differential correction input status (Output)
  static const UBX_RXM_COR = /*0x02*/ 0x34;

  /// Satellite measurements for RRLP (Periodic/polled)
  static const UBX_RXM_MEASX = /*0x02*/ 0x14;

  /// PMP (LBAND) message (Input)
  static const UBX_RXM_PMP = /*0x02*/ 0x72;

  /// Power management request (Command)
  static const UBX_RXM_PMREQ = /*0x02*/ 0x41;

  /// QZSS L6 message (Input)
  static const UBX_RXM_QZSSL6 = /*0x02*/ 0x73;

  /// Multi-GNSS raw measurements (Periodic/polled)
  static const UBX_RXM_RAWX = /*0x02*/ 0x15;

  /// Galileo SAR short-RLM report (Output)
  /// Galileo SAR long-RLM report (Output)
  static const UBX_RXM_RLM = /*0x02*/ 0x59;

  /// RTCM input status (Output)
  static const UBX_RXM_RTCM = /*0x02*/ 0x32;

  /// Broadcast navigation data subframe (Output)
  static const UBX_RXM_SFRBX = /*0x02*/ 0x13;

  /// SPARTN input status (Output)
  static const UBX_RXM_SPARTN = /*0x02*/ 0x33;

  /// Poll installed keys (Poll request)
  /// Transfer dynamic SPARTN keys (Input/output)
  static const UBX_RXM_SPARTNKEY = /*0x02*/ 0x36;
}

/// UBX-SEC – Security messages
class UbxSecurityMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.SEC;

  /// Unique chip ID (Output)
  static const UBX_SEC_UNIQID = /*0x27*/ 0x03;
}

/// UBX-TIM – Timing messages
class UbxTimingMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.TIM;

  /// Time mark data (Periodic/polled)
  static const UBX_TIM_TM2 = /*0x0d*/ 0x03;

  /// Time pulse time data (Periodic/polled)
  static const UBX_TIM_TP = /*0x0d*/ 0x01;

  /// Sourced time verification (Periodic/polled)
  static const UBX_TIM_VRFY = /*0x0d*/ 0x06;
}

/// UBX-UPD – Firmware update messages
class UbxFirmwareMessageIds {
  /// Class Id
  static const CLASS_ID = ClassIds.UPD;

  /// Poll backup restore status (Poll request)
  /// Create backup in flash (Command)
  /// Clear backup in flash (Command)
  /// Backup creation acknowledge (Output)
  /// System restored from backup (Output)
  static const UBX_UPD_SOS = /*0x09*/ 0x14;
}

const GNSSfixTypes = [
  {'val': 0, 'name': 'no fix'},
  {'val': 1, 'name': 'dead reckoning only'},
  {'val': 2, 'name': '2D-fix'},
  {'val': 3, 'name': '3D-fix'},
  {'val': 4, 'name': 'GNSS + dead reckoning combined'},
  {'val': 5, 'name': 'time only fix'}
];
