// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:ffi';
//import 'dart:typed_data';

class UbloxConfigKeys {
// The following consts are used to generate KEY values for the advanced protocol functions of VELGET/SET/DEL
  /// One bit
  static final Uint8 VAL_SIZE_1 = 0x01 as Uint8;

  /// One byte
  static final Uint8 VAL_SIZE_8 = 0x02 as Uint8;

  /// Two bytes
  static final Uint8 VAL_SIZE_16 = 0x03 as Uint8;

  /// Four bytes
  static final Uint8 VAL_SIZE_32 = 0x04 as Uint8;

  /// Eight bytes
  static final Uint8 VAL_SIZE_64 = 0x05 as Uint8;

/* These are the Bitfield layers definitions for the UBX-CFG-VALSET message (not to be confused with Bitfield deviceMask in UBX-CFG-CFG) */
  static final Uint8 VAL_LAYER_RAM = (1 << 0) as Uint8;
  static final Uint8 VAL_LAYER_BBR = (1 << 1) as Uint8;
  static final Uint8 VAL_LAYER_FLASH = (1 << 2) as Uint8;
  static final Uint8 VAL_LAYER_ALL = ((VAL_LAYER_RAM as int) |
      (VAL_LAYER_BBR as int) |
      (VAL_LAYER_FLASH as int)) as Uint8; // Not valid with getVal()

/* Below are various Groups, IDs, and sizes for various settings
 These can be used to call getVal/setVal/delVal 
 */

  static final Uint8 VAL_ID_PROT_UBX = 0x01 as Uint8;
  static final Uint8 VAL_ID_PROT_NMEA = 0x02 as Uint8;
  static final Uint8 VAL_ID_PROT_RTCM3 = 0x04 as Uint8;

  static final Uint8 VAL_GROUP_I2C = 0x51 as Uint8;
  static final Uint8 VAL_GROUP_I2COUTPROT = 0x72 as Uint8;
  static final Uint8 VAL_GROUP_UART1INPROT = 0x73 as Uint8;
  static final Uint8 VAL_GROUP_UART1OUTPROT = 0x74 as Uint8;
  static final Uint8 VAL_GROUP_UART2INPROT = 0x75 as Uint8;
  static final Uint8 VAL_GROUP_UART2OUTPROT = 0x76 as Uint8;
  static final Uint8 VAL_GROUP_USBINPROT = 0x77 as Uint8;
  static final Uint8 VAL_GROUP_USBOUTPROT = 0x78 as Uint8;

  /// All fields in UART group are currently 1 bit

  static final Uint8 VAL_GROUP_UART_SIZE = VAL_SIZE_1;

  /// All fields in I2C group are currently 1 byte
  static final Uint8 VAL_GROUP_I2C_SIZE = VAL_SIZE_8;

  static final Uint8 VAL_ID_I2C_ADDRESS = 0x01 as Uint8;

  /* Below are the key values for a given configuration setting */

}

/*
class ConfigurationSettings {

}*/

// CFG-BDS: BeiDou system configuration
class BDS {
  /// Use BeiDou geostationary satellites (PRN 1-5)
  static final Uint32 USE_PRN_1_TO_5 = 0x10340014 as Uint32;
}

// CFG-HW: Hardware configuration
class HW {
  /// Active antenna voltage control flag
  static final Uint32 ANT_CFG_VOLTCTRL = 0x10a3002e as Uint32;

  /// Short antenna detection flag
  static final Uint32 ANT_CFG_SHORTDET = 0x10a3002f as Uint32;

  /// Short antenna detection polarity
  static final Uint32 ANT_CFG_SHORTDET_POL = 0x10a30030 as Uint32;

  /// Open antenna detection flag
  static final Uint32 ANT_CFG_OPENDET = 0x10a30031 as Uint32;

  /// Open antenna detection polarity
  static final Uint32 ANT_CFG_OPENDET_POL = 0x10a30032 as Uint32;

  /// Power down antenna flag
  static final Uint32 ANT_CFG_PWRDOWN = 0x10a30033 as Uint32;

  /// Power down antenna logic polarity
  static final Uint32 ANT_CFG_PWRDOWN_POL = 0x10a30034 as Uint32;

  /// Automatic recovery from short state flag
  static final Uint32 ANT_CFG_RECOVER = 0x10a30035 as Uint32;

  /// ANT1 PIO number
  static final Uint32 ANT_SUP_SWITCH_PIN = 0x20a30036 as Uint32;

  /// ANT0 PIO number
  static final Uint32 ANT_SUP_SHORT_PIN = 0x20a30037 as Uint32;

  /// ANT2 PIO number
  static final Uint32 ANT_SUP_OPEN_PIN = 0x20a30038 as Uint32;

  /// Antenna supervisor engine selection
  static final Uint32 ANT_SUP_ENGINE = 0x20a30054 as Uint32;

  /// Antenna supervisor MADC engine short detection threshold
  static final Uint32 ANT_SUP_SHORT_THR = 0x20a30055 as Uint32;

  /// Antenna supervisor MADC engine open detection threshold
  static final Uint32 ANT_SUP_OPEN_THR = 0x20a30056 as Uint32;
}

// CFG-I2C: Configuration of the I2C interface
class I2C {
  /// I2C slave address of the receiver (7 bits)
  static final Uint32 ADDRESS = 0x20510001 as Uint32;

  /// Flag to disable timeouting the interface after 1.5 s
  static final Uint32 EXTENDEDTIMEOUT = 0x10510002 as Uint32;

  /// Flag to indicate if the I2C interface should be enabled
  static final Uint32 ENABLED = 0x10510003 as Uint32;
}

// CFG-I2CINPROT: Input protocol configuration of the I2C interface
class I2CINPROT {
  /// Flag to indicate if UBX should be an input protocol on I2C
  static final Uint32 UBX = 0x10710001 as Uint32;

  /// Flag to indicate if NMEA should be an input protocol on I2C
  static final Uint32 NMEA = 0x10710002 as Uint32;

  /// Flag to indicate if RTCM3X should be an input protocol on I2C
  static final Uint32 RTCM3X = 0x10710004 as Uint32;

  /// Flag to indicate if SPARTN should be an input protocol on I2C
  static final Uint32 SPARTN = 0x10710005 as Uint32;
}

// CFG-I2COUTPROT: Output protocol configuration of the I2C interface
class I2COUTPROT {
  /// Flag to indicate if UBX should be an output protocol on I2C
  static final Uint32 UBX = 0x10720001 as Uint32;

  /// Flag to indicate if NMEA should be an output protocol on I2C
  static final Uint32 NMEA = 0x10720002 as Uint32;

  /// Flag to indicate if RTCM3X should be an output protocol on I2C
  static final Uint32 RTCM3X = 0x10720004 as Uint32;
}

// CFG-INFMSG: Information message configuration
class INFMSG {
  /// Information message enable flags for the UBX protocol on the I2C interface
  static final Uint32 UBX_I2C = 0x20920001 as Uint32;

  /// Information message enable flags for the UBX protocol on the UART1 interface
  static final Uint32 UBX_UART1 = 0x20920002 as Uint32;

  /// Information message enable flags for the UBX protocol on the UART2 interface
  static final Uint32 UBX_UART2 = 0x20920003 as Uint32;

  /// Information message enable flags for the UBX protocol on the USB interface
  static final Uint32 UBX_USB = 0x20920004 as Uint32;

  /// Information message enable flags for the UBX protocol on the SPI interface
  static final Uint32 UBX_SPI = 0x20920005 as Uint32;

  /// Information message enable flags for the NMEA protocol on the I2C interface
  static final Uint32 NMEA_I2C = 0x20920006 as Uint32;

  /// Information message enable flags for the NMEA protocol on the UART1 interface
  static final Uint32 NMEA_UART1 = 0x20920007 as Uint32;

  /// Information message enable flags for the NMEA protocol on the UART2 interface
  static final Uint32 NMEA_UART2 = 0x20920008 as Uint32;

  /// Information message enable flags for the NMEA protocol on the USB interface
  static final Uint32 NMEA_USB = 0x20920009 as Uint32;

  /// Information message enable flags for the NMEA protocol on the SPI interface
  static final Uint32 NMEA_SPI = 0x2092000a as Uint32;
}

// CFG-ITFM: Jamming and interference monitor configuration
class ITFM {
  /// Broadband jamming detection threshold
  static final Uint32 BBTHRESHOLD = 0x20410001 as Uint32;

  /// CW jamming detection threshold
  static final Uint32 CWTHRESHOLD = 0x20410002 as Uint32;

  /// Enable interference detection
  static final Uint32 ENABLE = 0x1041000d as Uint32;

  /// Antenna setting
  static final Uint32 ANTSETTING = 0x20410010 as Uint32;

  /// Scan auxiliary bands
  static final Uint32 ENABLE_AUX = 0x10410013 as Uint32;
}

/// CFG-LOGFILTER: Data logger configuration
class LOGFILTER {
  /// Recording enabled
  static final Uint32 UBLOX_CFG_LOGFILTER_RECORD_ENA = 0x10de0002 as Uint32;

  /// Once per wake up
  static final Uint32 UBLOX_CFG_LOGFILTER_ONCE_PER_WAKE_UP_ENA =
      0x10de0003 as Uint32;

  /// Apply all filter settings
  static final Uint32 UBLOX_CFG_LOGFILTER_APPLY_ALL_FILTERS =
      0x10de0004 as Uint32;

  /// Minimum time interval between loggedpositions
  static final Uint32 UBLOX_CFG_LOGFILTER_MIN_INTERVAL = 0x30de0005 as Uint32;

  /// Time threshold
  static final Uint32 UBLOX_CFG_LOGFILTER_TIME_THRS = 0x30de0006 as Uint32;

  /// Speed threshold
  static final Uint32 UBLOX_CFG_LOGFILTER_SPEED_THRS = 0x30de0007 as Uint32;

  /// Position threshold
  static final Uint32 UBLOX_CFG_LOGFILTER_POSITION_THRS = 0x40de0008 as Uint32;
}

/// CFG-MOT: Motion detector configuration
class MOT {
  /// GNSS speed threshold below which platform is considered as stationary (a.k.a. static hold threshold)
  static final Uint32 GNSSSPEED_THRS = 0x20250038 as Uint32;

  /// Distance above which GNSS-based stationary motion is exit (a.k.a. static hold distance threshold)
  static final Uint32 GNSSDIST_THRS = 0x3025003b as Uint32;
}

/// Additional CFG_MSGOUT keys for the ZED-F9R HPS121
class MSGOUT_AdditionalZED_F9R_HPS121 {
  /// Output rate of the UBX-NAV-COV message on port I2C
  static final Uint32 UBX_NAV_COV_I2C = 0x20910083 as Uint32;

  /// Output rate of the UBX-NAV-COV message on port UART1
  static final Uint32 UBX_NAV_COV_UART1 = 0x20910084 as Uint32;

  /// Output rate of the UBX-NAV-COV message on port UART2
  static final Uint32 UBX_NAV_COV_UART2 = 0x20910085 as Uint32;

  /// Output rate of the UBX-NAV-COV message on port USB
  static final Uint32 UBX_NAV_COV_USB = 0x20910086 as Uint32;

  /// Output rate of the UBX-NAV-COV message on port SPI
  static final Uint32 UBX_NAV_COV_SPI = 0x20910087 as Uint32;

  /// Output rate of the NMEA-GX-THS message on port I2C
  static final Uint32 NMEA_ID_THS_I2C = 0x209100e2 as Uint32;

  /// Output rate of the NMEA-GX-THS message on port UART1
  static final Uint32 NMEA_ID_THS_UART1 = 0x209100e3 as Uint32;

  /// Output rate of the NMEA-GX-THS message on port UART2
  static final Uint32 NMEA_ID_THS_UART2 = 0x209100e4 as Uint32;

  /// Output rate of the NMEA-GX-THS message on port USB
  static final Uint32 NMEA_ID_THS_USB = 0x209100e5 as Uint32;

  /// Output rate of the NMEA-GX-THS message on port SPI
  static final Uint32 NMEA_ID_THS_SPI = 0x209100e6 as Uint32;

  /// Output rate of the UBX-ESF-STATUS message on port I2C
  static final Uint32 UBX_ESF_STATUS_I2C = 0x20910105 as Uint32;

  /// Output rate of the UBX-ESF-STATUS message on port UART1
  static final Uint32 UBX_ESF_STATUS_UART1 = 0x20910106 as Uint32;

  /// Output rate of the UBX-ESF-STATUS message on port UART2
  static final Uint32 UBX_ESF_STATUS_UART2 = 0x20910107 as Uint32;

  /// Output rate of the UBX-ESF-STATUS message on port USB
  static final Uint32 UBX_ESF_STATUS_USB = 0x20910108 as Uint32;

  /// Output rate of the UBX-ESF-STATUS message on port SPI
  static final Uint32 UBX_ESF_STATUS_SPI = 0x20910109 as Uint32;

  /// Output rate of the UBX-ESF-ALG message on port I2C
  static final Uint32 UBX_ESF_ALG_I2C = 0x2091010f as Uint32;

  /// Output rate of the UBX-ESF-ALG message on port UART1
  static final Uint32 UBX_ESF_ALG_UART1 = 0x20910110 as Uint32;

  /// Output rate of the UBX-ESF-ALG message on port UART2
  static final Uint32 UBX_ESF_ALG_UART2 = 0x20910111 as Uint32;

  /// Output rate of the UBX-ESF-ALG message on port USB
  static final Uint32 UBX_ESF_ALG_USB = 0x20910112 as Uint32;

  /// Output rate of the UBX-ESF-ALG message on port SPI
  static final Uint32 UBX_ESF_ALG_SPI = 0x20910113 as Uint32;

  /// Output rate of the UBX-ESF-INS message on port I2C
  static final Uint32 UBX_ESF_INS_I2C = 0x20910114 as Uint32;

  /// Output rate of the UBX-ESF-INS message on port UART1
  static final Uint32 UBX_ESF_INS_UART1 = 0x20910115 as Uint32;

  /// Output rate of the UBX-ESF-INS message on port UART2
  static final Uint32 UBX_ESF_INS_UART2 = 0x20910116 as Uint32;

  /// Output rate of the UBX-ESF-INS message on port USB
  static final Uint32 UBX_ESF_INS_USB = 0x20910117 as Uint32;

  /// Output rate of the UBX-ESF-INS message on port SPI
  static final Uint32 UBX_ESF_INS_SPI = 0x20910118 as Uint32;

  /// Output rate of the UBX-ESF-MEAS message on port I2C
  static final Uint32 UBX_ESF_MEAS_I2C = 0x20910277 as Uint32;

  /// Output rate of the UBX-ESF-MEAS message on port UART1
  static final Uint32 UBX_ESF_MEAS_UART1 = 0x20910278 as Uint32;

  /// Output rate of the UBX-ESF-MEAS message on port UART2
  static final Uint32 UBX_ESF_MEAS_UART2 = 0x20910279 as Uint32;

  /// Output rate of the UBX-ESF-MEAS message on port USB
  static final Uint32 UBX_ESF_MEAS_USB = 0x2091027a as Uint32;

  /// Output rate of the UBX-ESF-MEAS message on port SPI
  static final Uint32 UBX_ESF_MEAS_SPI = 0x2091027b as Uint32;

  /// Output rate of the UBX-ESF-RAW message on port I2C
  static final Uint32 UBX_ESF_RAW_I2C = 0x2091029f as Uint32;

  /// Output rate of the UBX-ESF-RAW message on port UART1
  static final Uint32 UBX_ESF_RAW_UART1 = 0x209102a0 as Uint32;

  /// Output rate of the UBX-ESF-RAW message on port UART2
  static final Uint32 UBX_ESF_RAW_UART2 = 0x209102a1 as Uint32;

  /// Output rate of the UBX-ESF-RAW message on port USB
  static final Uint32 UBX_ESF_RAW_USB = 0x209102a2 as Uint32;

  /// Output rate of the UBX-ESF-RAW message on port SPI
  static final Uint32 UBX_ESF_RAW_SPI = 0x209102a3 as Uint32;

  /// Output rate of the UBX-NAV-EELL message on port I2C
  static final Uint32 UBX_NAV_EELL_I2C = 0x20910313 as Uint32;

  /// Output rate of the UBX-NAV-EELL message on port UART1
  static final Uint32 UBX_NAV_EELL_UART1 = 0x20910314 as Uint32;

  /// Output rate of the UBX-NAV-EELL message on port UART2
  static final Uint32 UBX_NAV_EELL_UART2 = 0x20910315 as Uint32;

  /// Output rate of the UBX-NAV-EELL message on port USB
  static final Uint32 UBX_NAV_EELL_USB = 0x20910316 as Uint32;

  /// Output rate of the UBX-NAV-EELL message on port SPI
  static final Uint32 UBX_NAV_EELL_SPI = 0x20910317 as Uint32;

  /// Output rate of the UBX-NAV-PVAT message on port I2C
  static final Uint32 UBX_NAV_PVAT_I2C = 0x2091062a as Uint32;

  /// Output rate of the UBX-NAV-PVAT message on port UART1
  static final Uint32 UBX_NAV_PVAT_UART1 = 0x2091062b as Uint32;

  /// Output rate of the UBX-NAV-PVAT message on port UART2
  static final Uint32 UBX_NAV_PVAT_UART2 = 0x2091062c as Uint32;

  /// Output rate of the UBX-NAV-PVAT message on port USB
  static final Uint32 UBX_NAV_PVAT_USB = 0x2091062d as Uint32;

  /// Output rate of the UBX-NAV-PVAT message on port SPI
  static final Uint32 UBX_NAV_PVAT_SPI = 0x2091062e as Uint32;
}

/// Additional CFG_MSGOUT keys for the ZED-F9T
class MSGOUT_AdditionalZED_F9T {
  /// Output rate of the NMEA-NAV2-GX-GGA message on port I2C
  static final Uint32 NMEA_NAV2_ID_GGA_I2C = 0x20910661 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GGA message on port SPI
  static final Uint32 NMEA_NAV2_ID_GGA_SPI = 0x20910665 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GGA message on port UART1
  static final Uint32 NMEA_NAV2_ID_GGA_UART1 = 0x20910662 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GGA message on port UART2
  static final Uint32 NMEA_NAV2_ID_GGA_UART2 = 0x20910663 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GGA message on port USB
  static final Uint32 NMEA_NAV2_ID_GGA_USB = 0x20910664 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GLL message on port I2C
  static final Uint32 NMEA_NAV2_ID_GLL_I2C = 0x20910670 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GLL message on port SPI
  static final Uint32 NMEA_NAV2_ID_GLL_SPI = 0x20910674 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GLL message on port UART1
  static final Uint32 NMEA_NAV2_ID_GLL_UART1 = 0x20910671 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GLL message on port UART2
  static final Uint32 NMEA_NAV2_ID_GLL_UART2 = 0x20910672 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GLL message on port USB
  static final Uint32 NMEA_NAV2_ID_GLL_USB = 0x20910673 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GNS message on port I2C
  static final Uint32 NMEA_NAV2_ID_GNS_I2C = 0x2091065c as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GNS message on port SPI
  static final Uint32 NMEA_NAV2_ID_GNS_SPI = 0x20910660 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GNS message on port UART1
  static final Uint32 NMEA_NAV2_ID_GNS_UART1 = 0x2091065d as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GNS message on port UART2
  static final Uint32 NMEA_NAV2_ID_GNS_UART2 = 0x2091065e as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GNS message on port USB
  static final Uint32 NMEA_NAV2_ID_GNS_USB = 0x2091065f as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GSA message on port I2C
  static final Uint32 NMEA_NAV2_ID_GSA_I2C = 0x20910666 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GSA message on port SPI
  static final Uint32 NMEA_NAV2_ID_GSA_SPI = 0x2091066a as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GSA message on port UART1
  static final Uint32 NMEA_NAV2_ID_GSA_UART1 = 0x20910667 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GSA message on port UART2
  static final Uint32 NMEA_NAV2_ID_GSA_UART2 = 0x20910668 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-GSA message on port USB
  static final Uint32 NMEA_NAV2_ID_GSA_USB = 0x20910669 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-RMC message on port I2C
  static final Uint32 NMEA_NAV2_ID_RMC_I2C = 0x20910652 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-RMC message on port SPI
  static final Uint32 NMEA_NAV2_ID_RMC_SPI = 0x20910656 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-RMC message on port UART1
  static final Uint32 NMEA_NAV2_ID_RMC_UART1 = 0x20910653 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-RMC message on port UART2
  static final Uint32 NMEA_NAV2_ID_RMC_UART2 = 0x20910654 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-RMC message on port USB
  static final Uint32 NMEA_NAV2_ID_RMC_USB = 0x20910655 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-VTG message on port I2C
  static final Uint32 NMEA_NAV2_ID_VTG_I2C = 0x20910657 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-VTG message on port SPI
  static final Uint32 NMEA_NAV2_ID_VTG_SPI = 0x2091065b as Uint32;

  /// Output rate of the NMEA-NAV2-GX-VTG message on port UART1
  static final Uint32 NMEA_NAV2_ID_VTG_UART1 = 0x20910658 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-VTG message on port UART2
  static final Uint32 NMEA_NAV2_ID_VTG_UART2 = 0x20910659 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-VTG message on port USB
  static final Uint32 NMEA_NAV2_ID_VTG_USB = 0x2091065a as Uint32;

  /// Output rate of the NMEA-NAV2-GX-ZDA message on port I2C
  static final Uint32 NMEA_NAV2_ID_ZDA_I2C = 0x2091067f as Uint32;

  /// Output rate of the NMEA-NAV2-GX-ZDA message on port SPI
  static final Uint32 NMEA_NAV2_ID_ZDA_SPI = 0x20910683 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-ZDA message on port UART1
  static final Uint32 NMEA_NAV2_ID_ZDA_UART1 = 0x20910680 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-ZDA message on port UART2
  static final Uint32 NMEA_NAV2_ID_ZDA_UART2 = 0x20910681 as Uint32;

  /// Output rate of the NMEA-NAV2-GX-ZDA message on port USB
  static final Uint32 NMEA_NAV2_ID_ZDA_USB = 0x20910682 as Uint32;

  /// Output rate of the UBX-NAV2-CLOCK message on port I2C
  static final Uint32 UBX_NAV2_CLOCK_I2C = 0x20910430 as Uint32;

  /// Output rate of the UBX-NAV2-CLOCK message on port SPI
  static final Uint32 UBX_NAV2_CLOCK_SPI = 0x20910434 as Uint32;

  /// Output rate of the UBX-NAV2-CLOCK message on port UART1
  static final Uint32 UBX_NAV2_CLOCK_UART1 = 0x20910431 as Uint32;

  /// Output rate of the UBX-NAV2-CLOCK message on port UART2
  static final Uint32 UBX_NAV2_CLOCK_UART2 = 0x20910432 as Uint32;

  /// Output rate of the UBX-NAV2-CLOCK message on port USB
  static final Uint32 UBX_NAV2_CLOCK_USB = 0x20910433 as Uint32;

  /// Output rate of the UBX-NAV2-COV message onport I2C
  static final Uint32 UBX_NAV2_COV_I2C = 0x20910435 as Uint32;

  /// Output rate of the UBX-NAV2-COV message on port SPI
  static final Uint32 UBX_NAV2_COV_SPI = 0x20910439 as Uint32;

  /// Output rate of the UBX-NAV2-COV message on port UART1
  static final Uint32 UBX_NAV2_COV_UART1 = 0x20910436 as Uint32;

  /// Output rate of the UBX-NAV2-COV message on port UART2
  static final Uint32 UBX_NAV2_COV_UART2 = 0x20910437 as Uint32;

  /// Output rate of the UBX-NAV2-COV message onport USB
  static final Uint32 UBX_NAV2_COV_USB = 0x20910438 as Uint32;

  /// Output rate of the UBX-NAV2-DOP message on port I2C
  static final Uint32 UBX_NAV2_DOP_I2C = 0x20910465 as Uint32;

  /// Output rate of the UBX-NAV2-DOP message onport SPI
  static final Uint32 UBX_NAV2_DOP_SPI = 0x20910469 as Uint32;

  /// Output rate of the UBX-NAV2-DOP message onport UART1
  static final Uint32 UBX_NAV2_DOP_UART1 = 0x20910466 as Uint32;

  /// Output rate of the UBX-NAV2-DOP message onport UART2
  static final Uint32 UBX_NAV2_DOP_UART2 = 0x20910467 as Uint32;

  /// Output rate of the UBX-NAV2-DOP message on port USB
  static final Uint32 UBX_NAV2_DOP_USB = 0x20910468 as Uint32;

  /// Output rate of the UBX-NAV2-EOE message onport I2C
  static final Uint32 UBX_NAV2_EOE_I2C = 0x20910565 as Uint32;

  /// Output rate of the UBX-NAV2-EOE message on port SPI
  static final Uint32 UBX_NAV2_EOE_SPI = 0x20910569 as Uint32;

  /// Output rate of the UBX-NAV2-EOE message on port UART1
  static final Uint32 UBX_NAV2_EOE_UART1 = 0x20910566 as Uint32;

  /// Output rate of the UBX-NAV2-EOE message on port UART2
  static final Uint32 UBX_NAV2_EOE_UART2 = 0x20910567 as Uint32;

  /// Output rate of the UBX-NAV2-EOE message onport USB
  static final Uint32 UBX_NAV2_EOE_USB = 0x20910568 as Uint32;

  /// Output rate of the UBX-NAV2-ODO message on port I2C
  static final Uint32 UBX_NAV2_ODO_I2C = 0x20910475 as Uint32;

  /// Output rate of the UBX-NAV2-ODO message onport SPI
  static final Uint32 UBX_NAV2_ODO_SPI = 0x20910479 as Uint32;

  /// Output rate of the UBX-NAV2-ODO message onport UART1
  static final Uint32 UBX_NAV2_ODO_UART1 = 0x20910476 as Uint32;

  /// Output rate of the UBX-NAV2-ODO message onport UART2
  static final Uint32 UBX_NAV2_ODO_UART2 = 0x20910477 as Uint32;

  /// Output rate of the UBX-NAV2-ODO message on port USB
  static final Uint32 UBX_NAV2_ODO_USB = 0x20910478 as Uint32;

  /// Output rate of the UBX-NAV2-POSECEF message on port I2C
  static final Uint32 UBX_NAV2_POSECEF_I2C = 0x20910480 as Uint32;

  /// Output rate of the UBX-NAV2-POSECEF message on port SPI
  static final Uint32 UBX_NAV2_POSECEF_SPI = 0x20910484 as Uint32;

  /// Output rate of the UBX-NAV2-POSECEF message on port UART1
  static final Uint32 UBX_NAV2_POSECEF_UART1 = 0x20910481 as Uint32;

  /// Output rate of the UBX-NAV2-POSECEF message on port UART2
  static final Uint32 UBX_NAV2_POSECEF_UART2 = 0x20910482 as Uint32;

  /// Output rate of the UBX-NAV2-POSECEF message on port USB
  static final Uint32 UBX_NAV2_POSECEF_USB = 0x20910483 as Uint32;

  /// Output rate of the UBX-NAV2-POSLLH message on port I2C
  static final Uint32 UBX_NAV2_POSLLH_I2C = 0x20910485 as Uint32;

  /// Output rate of the UBX-NAV2-POSLLH message on port SPI
  static final Uint32 UBX_NAV2_POSLLH_SPI = 0x20910489 as Uint32;

  /// Output rate of the UBX-NAV2-POSLLH message on port UART1
  static final Uint32 UBX_NAV2_POSLLH_UART1 = 0x20910486 as Uint32;

  /// Output rate of the UBX-NAV2-POSLLH message on port UART2
  static final Uint32 UBX_NAV2_POSLLH_UART2 = 0x20910487 as Uint32;

  /// Output rate of the UBX-NAV2-POSLLH message on port USB
  static final Uint32 UBX_NAV2_POSLLH_USB = 0x20910488 as Uint32;

  /// Output rate of the UBX-NAV2-PVT message onport I2C
  static final Uint32 UBX_NAV2_PVT_I2C = 0x20910490 as Uint32;

  /// Output rate of the UBX-NAV2-PVT message on port SPI
  static final Uint32 UBX_NAV2_PVT_SPI = 0x20910494 as Uint32;

  /// Output rate of the UBX-NAV2-PVT message on port UART1
  static final Uint32 UBX_NAV2_PVT_UART1 = 0x20910491 as Uint32;

  /// Output rate of the UBX-NAV2-PVT message on port UART2
  static final Uint32 UBX_NAV2_PVT_UART2 = 0x20910492 as Uint32;

  /// Output rate of the UBX-NAV2-PVT message onport USB
  static final Uint32 UBX_NAV2_PVT_USB = 0x20910493 as Uint32;

  /// Output rate of the UBX-NAV2-SAT message on port I2C
  static final Uint32 UBX_NAV2_SAT_I2C = 0x20910495 as Uint32;

  /// Output rate of the UBX-NAV2-SAT message onport SPI
  static final Uint32 UBX_NAV2_SAT_SPI = 0x20910499 as Uint32;

  /// Output rate of the UBX-NAV2-SAT message onport UART1
  static final Uint32 UBX_NAV2_SAT_UART1 = 0x20910496 as Uint32;

  /// Output rate of the UBX-NAV2-SAT message onport UART2
  static final Uint32 UBX_NAV2_SAT_UART2 = 0x20910497 as Uint32;

  /// Output rate of the UBX-NAV2-SAT message on port USB
  static final Uint32 UBX_NAV2_SAT_USB = 0x20910498 as Uint32;

  /// Output rate of the UBX-NAV2-SBAS messageon port I2C
  static final Uint32 UBX_NAV2_SBAS_I2C = 0x20910500 as Uint32;

  /// Output rate of the UBX-NAV2-SBAS message on port SPI
  static final Uint32 UBX_NAV2_SBAS_SPI = 0x20910504 as Uint32;

  /// Output rate of the UBX-NAV2-SBAS message on port UART1
  static final Uint32 UBX_NAV2_SBAS_UART1 = 0x20910501 as Uint32;

  /// Output rate of the UBX-NAV2-SBAS message on port UART2
  static final Uint32 UBX_NAV2_SBAS_UART2 = 0x20910502 as Uint32;

  /// Output rate of the UBX-NAV2-SBAS messageon port USB
  static final Uint32 UBX_NAV2_SBAS_USB = 0x20910503 as Uint32;

  /// Output rate of the UBX-NAV2-SIG message on port I2C
  static final Uint32 UBX_NAV2_SIG_I2C = 0x20910505 as Uint32;

  /// Output rate of the UBX-NAV2-SIG message onport SPI
  static final Uint32 UBX_NAV2_SIG_SPI = 0x20910509 as Uint32;

  /// Output rate of the UBX-NAV2-SIG message onport UART1
  static final Uint32 UBX_NAV2_SIG_UART1 = 0x20910506 as Uint32;

  /// Output rate of the UBX-NAV2-SIG message onport UART2
  static final Uint32 UBX_NAV2_SIG_UART2 = 0x20910507 as Uint32;

  /// Output rate of the UBX-NAV2-SIG message on port USB
  static final Uint32 UBX_NAV2_SIG_USB = 0x20910508 as Uint32;

  /// Output rate of the UBX-NAV2-SLAS message on port I2C
  static final Uint32 UBX_NAV2_SLAS_I2C = 0x20910510 as Uint32;

  /// Output rate of the UBX-NAV2-SLAS message on port SPI
  static final Uint32 UBX_NAV2_SLAS_SPI = 0x20910514 as Uint32;

  /// Output rate of the UBX-NAV2-SLAS message on port UART1
  static final Uint32 UBX_NAV2_SLAS_UART1 = 0x20910511 as Uint32;

  /// Output rate of the UBX-NAV2-SLAS message on port UART2
  static final Uint32 UBX_NAV2_SLAS_UART2 = 0x20910512 as Uint32;

  /// Output rate of the UBX-NAV2-SLAS message on port USB
  static final Uint32 UBX_NAV2_SLAS_USB = 0x20910513 as Uint32;

  /// Output rate of the UBX-NAV2-STATUS message on port I2C
  static final Uint32 UBX_NAV2_STATUS_I2C = 0x20910515 as Uint32;

  /// Output rate of the UBX-NAV2-STATUS message on port SPI
  static final Uint32 UBX_NAV2_STATUS_SPI = 0x20910519 as Uint32;

  /// Output rate of the UBX-NAV2-STATUS message on port UART1
  static final Uint32 UBX_NAV2_STATUS_UART1 = 0x20910516 as Uint32;

  /// Output rate of the UBX-NAV2-STATUS message on port UART2
  static final Uint32 UBX_NAV2_STATUS_UART2 = 0x20910517 as Uint32;

  /// Output rate of the UBX-NAV2-STATUS message on port USB
  static final Uint32 UBX_NAV2_STATUS_USB = 0x20910518 as Uint32;

  /// Output rate of the UBX-NAV2-SVIN message on port I2C
  static final Uint32 UBX_NAV2_SVIN_I2C = 0x20910520 as Uint32;

  /// Output rate of the UBX-NAV2-SVIN message on port SPI
  static final Uint32 UBX_NAV2_SVIN_SPI = 0x20910524 as Uint32;

  /// Output rate of the UBX-NAV2-SVIN message on port UART1
  static final Uint32 UBX_NAV2_SVIN_UART1 = 0x20910521 as Uint32;

  /// Output rate of the UBX-NAV2-SVIN message on port UART2
  static final Uint32 UBX_NAV2_SVIN_UART2 = 0x20910522 as Uint32;

  /// Output rate of the UBX-NAV2-SVIN message on port USB
  static final Uint32 UBX_NAV2_SVIN_USB = 0x20910523 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEBDS message on port I2C
  static final Uint32 UBX_NAV2_TIMEBDS_I2C = 0x20910525 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEBDS message on port SPI
  static final Uint32 UBX_NAV2_TIMEBDS_SPI = 0x20910529 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEBDS message on port UART1
  static final Uint32 UBX_NAV2_TIMEBDS_UART1 = 0x20910526 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEBDS message on port UART2
  static final Uint32 UBX_NAV2_TIMEBDS_UART2 = 0x20910527 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEBDS message on port USB
  static final Uint32 UBX_NAV2_TIMEBDS_USB = 0x20910528 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGAL message on port I2C
  static final Uint32 UBX_NAV2_TIMEGAL_I2C = 0x20910530 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGAL message on port SPI
  static final Uint32 UBX_NAV2_TIMEGAL_SPI = 0x20910534 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGAL message on port UART1
  static final Uint32 UBX_NAV2_TIMEGAL_UART1 = 0x20910531 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGAL message on port UART2
  static final Uint32 UBX_NAV2_TIMEGAL_UART2 = 0x20910532 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGAL message on port USB
  static final Uint32 UBX_NAV2_TIMEGAL_USB = 0x20910533 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGLO message on port I2C
  static final Uint32 UBX_NAV2_TIMEGLO_I2C = 0x20910535 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGLO message on port SPI
  static final Uint32 UBX_NAV2_TIMEGLO_SPI = 0x20910539 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGLO message on port UART1
  static final Uint32 UBX_NAV2_TIMEGLO_UART1 = 0x20910536 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGLO message on port UART2
  static final Uint32 UBX_NAV2_TIMEGLO_UART2 = 0x20910537 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGLO message on port USB
  static final Uint32 UBX_NAV2_TIMEGLO_USB = 0x20910538 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGPS message on port I2C
  static final Uint32 UBX_NAV2_TIMEGPS_I2C = 0x20910540 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGPS message on port SPI
  static final Uint32 UBX_NAV2_TIMEGPS_SPI = 0x20910544 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGPS message on port UART1
  static final Uint32 UBX_NAV2_TIMEGPS_UART1 = 0x20910541 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGPS message on port UART2
  static final Uint32 UBX_NAV2_TIMEGPS_UART2 = 0x20910542 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEGPS message on port USB
  static final Uint32 UBX_NAV2_TIMEGPS_USB = 0x20910543 as Uint32;

  /// Output rate of the UBX-NAV2-TIMELS message on port I2C
  static final Uint32 UBX_NAV2_TIMELS_I2C = 0x20910545 as Uint32;

  /// Output rate of the UBX-NAV2-TIMELS message on port SPI
  static final Uint32 UBX_NAV2_TIMELS_SPI = 0x20910549 as Uint32;

  /// Output rate of the UBX-NAV2-TIMELS message on port UART1
  static final Uint32 UBX_NAV2_TIMELS_UART1 = 0x20910546 as Uint32;

  /// Output rate of the UBX-NAV2-TIMELS message on port UART2
  static final Uint32 UBX_NAV2_TIMELS_UART2 = 0x20910547 as Uint32;

  /// Output rate of the UBX-NAV2-TIMELS message on port USB
  static final Uint32 UBX_NAV2_TIMELS_USB = 0x20910548 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEQZSS message on port I2C
  static final Uint32 UBX_NAV2_TIMEQZSS_I2C = 0x20910575 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEQZSS message on port SPI
  static final Uint32 UBX_NAV2_TIMEQZSS_SPI = 0x20910579 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEQZSS message on port UART1
  static final Uint32 UBX_NAV2_TIMEQZSS_UART1 = 0x20910576 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEQZSS message on port UART2
  static final Uint32 UBX_NAV2_TIMEQZSS_UART2 = 0x20910577 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEQZSS message on port USB
  static final Uint32 UBX_NAV2_TIMEQZSS_USB = 0x20910578 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEUTC message on port I2C
  static final Uint32 UBX_NAV2_TIMEUTC_I2C = 0x20910550 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEUTC message on port SPI
  static final Uint32 UBX_NAV2_TIMEUTC_SPI = 0x20910554 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEUTC message on port UART1
  static final Uint32 UBX_NAV2_TIMEUTC_UART1 = 0x20910551 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEUTC message on port UART2
  static final Uint32 UBX_NAV2_TIMEUTC_UART2 = 0x20910552 as Uint32;

  /// Output rate of the UBX-NAV2-TIMEUTC message on port USB
  static final Uint32 UBX_NAV2_TIMEUTC_USB = 0x20910553 as Uint32;

  /// Output rate of the UBX-NAV2-VELECEF message on port I2C
  static final Uint32 UBX_NAV2_VELECEF_I2C = 0x20910555 as Uint32;

  /// Output rate of the UBX-NAV2-VELECEF message on port SPI
  static final Uint32 UBX_NAV2_VELECEF_SPI = 0x20910559 as Uint32;

  /// Output rate of the UBX-NAV2-VELECEF message on port UART1
  static final Uint32 UBX_NAV2_VELECEF_UART1 = 0x20910556 as Uint32;

  /// Output rate of the UBX-NAV2-VELECEF message on port UART2
  static final Uint32 UBX_NAV2_VELECEF_UART2 = 0x20910557 as Uint32;

  /// Output rate of the UBX-NAV2-VELECEF message on port USB
  static final Uint32 UBX_NAV2_VELECEF_USB = 0x20910558 as Uint32;

  /// Output rate of the UBX-NAV2-VELNED message on port I2C
  static final Uint32 UBX_NAV2_VELNED_I2C = 0x20910560 as Uint32;

  /// Output rate of the UBX-NAV2-VELNED message on port SPI
  static final Uint32 UBX_NAV2_VELNED_SPI = 0x20910564 as Uint32;

  /// Output rate of the UBX-NAV2-VELNED message on port UART1
  static final Uint32 UBX_NAV2_VELNED_UART1 = 0x20910561 as Uint32;

  /// Output rate of the UBX-NAV2-VELNED message on port UART2
  static final Uint32 UBX_NAV2_VELNED_UART2 = 0x20910562 as Uint32;

  /// Output rate of the UBX-NAV2-VELNED message on port USB
  static final Uint32 UBX_NAV2_VELNED_USB = 0x20910563 as Uint32;

  /// Output rate of the UBX-NAV-NMI message on port I2C
  static final Uint32 UBX_NAV_NMI_I2C = 0x20910590 as Uint32;

  /// Output rate of the UBX-NAV-NMI message on port SPI
  static final Uint32 UBX_NAV_NMI_SPI = 0x20910594 as Uint32;

  /// Output rate of the UBX-NAV-NMI message on port UART1
  static final Uint32 UBX_NAV_NMI_UART1 = 0x20910591 as Uint32;

  /// Output rate of the UBX-NAV-NMI message on port UART2
  static final Uint32 UBX_NAV_NMI_UART2 = 0x20910592 as Uint32;

  /// Output rate of the UBX-NAV-NMI message on port USB
  static final Uint32 UBX_NAV_NMI_USB = 0x20910593 as Uint32;

  /// Output rate of the UBX-RXM-TM message on port I2C
  static final Uint32 UBX_RXM_TM_I2C = 0x20910610 as Uint32;

  /// Output rate of the UBX-RXM-TM message on port SPI
  static final Uint32 UBX_RXM_TM_SPI = 0x20910614 as Uint32;

  /// Output rate of the UBX-RXM-TM message on port UART1
  static final Uint32 UBX_RXM_TM_UART1 = 0x20910611 as Uint32;

  /// Output rate of the UBX-RXM-TM message on port UART2
  static final Uint32 UBX_RXM_TM_UART2 = 0x20910612 as Uint32;

  /// Output rate of the UBX-RXM-TM message on port USB
  static final Uint32 UBX_RXM_TM_USB = 0x20910613 as Uint32;

  /// Output rate of the UBX-SEC-SIGLOG message on port I2C
  static final Uint32 UBX_SEC_SIGLOG_I2C = 0x20910689 as Uint32;

  /// Output rate of the UBX-SEC-SIGLOG message on port SPI
  static final Uint32 UBX_SEC_SIGLOG_SPI = 0x2091068d as Uint32;

  /// Output rate of the UBX-SEC-SIGLOG message on port UART1
  static final Uint32 UBX_SEC_SIGLOG_UART1 = 0x2091068a as Uint32;

  /// Output rate of the UBX-SEC-SIGLOG message on port UART2
  static final Uint32 UBX_SEC_SIGLOG_UART2 = 0x2091068b as Uint32;

  /// Output rate of the UBX-SEC-SIGLOG message on port USB
  static final Uint32 UBX_SEC_SIGLOG_USB = 0x2091068c as Uint32;

  /// Output rate of the UBX-TIM-SVIN message on port I2C
  static final Uint32 UBX_TIM_SVIN_I2C = 0x20910097 as Uint32;

  /// Output rate of the UBX-TIM-SVIN message on port SPI
  static final Uint32 UBX_TIM_SVIN_SPI = 0x2091009b as Uint32;

  /// Output rate of the UBX-TIM-SVIN message on port UART1
  static final Uint32 UBX_TIM_SVIN_UART1 = 0x20910098 as Uint32;

  /// Output rate of the UBX-TIM-SVIN message on port UART2
  static final Uint32 UBX_TIM_SVIN_UART2 = 0x20910099 as Uint32;

  /// Output rate of the UBX-TIM-SVIN message on port USB
  static final Uint32 UBX_TIM_SVIN_USB = 0x2091009a as Uint32;
}

/// Additional CFG_MSGOUT keys for the NEO-D9S
class MSGOUT_AdditionalNEO_D9S {
  /// Output rate of the UBX_RXM_PMP message on port I2C
  static final Uint32 UBX_RXM_PMP_I2C = 0x2091031d as Uint32;

  /// Output rate of the UBX_RXM_PMP message on port SPI
  static final Uint32 UBX_RXM_PMP_SPI = 0x20910321 as Uint32;

  /// Output rate of the UBX_RXM_PMP message on port UART1
  static final Uint32 UBX_RXM_PMP_UART1 = 0x2091031e as Uint32;

  /// Output rate of the UBX_RXM_PMP message on port UART2
  static final Uint32 UBX_RXM_PMP_UART2 = 0x2091031f as Uint32;

  /// Output rate of the UBX_RXM_PMP message on port USB
  static final Uint32 UBX_RXM_PMP_USB = 0x20910320 as Uint32;

  /// Output rate of the UBX_MON_PMP message on port I2C
  static final Uint32 UBX_MON_PMP_I2C = 0x20910322 as Uint32;

  /// Output rate of the UBX_MON_PMP message on port SPI
  static final Uint32 UBX_MON_PMP_SPI = 0x20910326 as Uint32;

  /// Output rate of the UBX_MON_PMP message on port UART1
  static final Uint32 UBX_MON_PMP_UART1 = 0x20910323 as Uint32;

  /// Output rate of the UBX_MON_PMP message on port UART2
  static final Uint32 UBX_MON_PMP_UART2 = 0x20910324 as Uint32;

  /// Output rate of the UBX_MON_PMP message on port USB
  static final Uint32 UBX_MON_PMP_USB = 0x20910325 as Uint32;
}

/// CFG-NAV2: Secondary output configuration
class NAV2 {
  /// Enable secondary (NAV2) output
  static final Uint32 OUT_ENABLED = 0x10170001 as Uint32;

  /// Use SBAS integrity information in the secondary output
  static final Uint32 SBAS_USE_INTEGRITY = 0x10170002 as Uint32;
}

/// CFG-NAVHPG: High precision navigation configuration
class NAVHPG {
  /// Diﬀerential corrections mode
  static final Uint32 DGNSSMODE = 0x20140011 as Uint32;
}

/// CFG-NAVSPG: Standard precision navigation configuration
class NAVSPG {
  /// Position fix mode
  static final Uint32 FIXMODE = 0x20110011 as Uint32;

  /// Initial fix must be a 3D fix
  static final Uint32 INIFIX3D = 0x10110013 as Uint32;

  /// GPS week rollover number
  static final Uint32 WKNROLLOVER = 0x30110017 as Uint32;

  /// Use precise point positioning (PPP)
  static final Uint32 USE_PPP = 0x10110019 as Uint32;

  /// UTC standard to be used
  static final Uint32 UTCSTANDARD = 0x2011001c as Uint32;

  /// Dynamic platform model
  static final Uint32 DYNMODEL = 0x20110021 as Uint32;

  /// Acknowledge assistance input messages
  static final Uint32 ACKAIDING = 0x10110025 as Uint32;

  /// Use user geodetic datum parameters
  static final Uint32 USE_USRDAT = 0x10110061 as Uint32;

  /// Geodetic datum semi-major axis
  static final Uint32 USRDAT_MAJA = 0x50110062 as Uint32;

  /// Geodetic datum 1.0 flattening
  static final Uint32 USRDAT_FLAT = 0x50110063 as Uint32;

  /// Geodetic datum X axis shift at the origin
  static final Uint32 USRDAT_DX = 0x40110064 as Uint32;

  /// Geodetic datum Y axis shift at the origin
  static final Uint32 USRDAT_DY = 0x40110065 as Uint32;

  /// Geodetic datum Z axis shift at the origin
  static final Uint32 USRDAT_DZ = 0x40110066 as Uint32;

  /// arcsec Geodetic datum rotation about the X axis
  static final Uint32 USRDAT_ROTX = 0x40110067 as Uint32;

  /// arcsec Geodetic datum rotation about the Y axis
  static final Uint32 USRDAT_ROTY = 0x40110068 as Uint32;

  /// arcsec Geodetic datum rotation about the Z axis
  static final Uint32 USRDAT_ROTZ = 0x40110069 as Uint32;

  /// ppm Geodetic datum scale factor
  static final Uint32 USRDAT_SCALE = 0x4011006a as Uint32;

  /// Minimum number of satellites for navigation
  static final Uint32 INFIL_MINSVS = 0x201100a1 as Uint32;

  /// Maximum number of satellites for navigation
  static final Uint32 INFIL_MAXSVS = 0x201100a2 as Uint32;

  /// Minimum satellite signal level for navigation
  static final Uint32 INFIL_MINCNO = 0x201100a3 as Uint32;

  /// Minimum elevation for a GNSS satellite to be used in navigation
  static final Uint32 INFIL_MINELEV = 0x201100a4 as Uint32;

  /// Number of satellites required to have C/N0 above static final Uint32 UBLOX_CFG_NAVSPG-INFIL_CNOTHRS for as Uint32 a fix to be attempted
  static final Uint32 INFIL_NCNOTHRS = 0x201100aa as Uint32;

  /// C/N0 threshold for deciding whether to attempt a fix
  static final Uint32 INFIL_CNOTHRS = 0x201100ab as Uint32;

  /// Output filter position DOP mask (threshold)
  static final Uint32 OUTFIL_PDOP = 0x301100b1 as Uint32;

  /// Output filter time DOP mask (threshold)
  static final Uint32 OUTFIL_TDOP = 0x301100b2 as Uint32;

  /// Output filter position accuracy mask (threshold)
  static final Uint32 OUTFIL_PACC = 0x301100b3 as Uint32;

  /// Output filter time accuracy mask (threshold)
  static final Uint32 OUTFIL_TACC = 0x301100b4 as Uint32;

  /// Output filter frequency accuracy mask (threshold)
  static final Uint32 OUTFIL_FACC = 0x301100b5 as Uint32;

  /// Fixed altitude (mean sea level) for 2D fix mode
  static final Uint32 CONSTR_ALT = 0x401100c1 as Uint32;

  /// Fixed altitude variance for 2D mode
  static final Uint32 CONSTR_ALTVAR = 0x401100c2 as Uint32;

  /// DGNSS timeout
  static final Uint32 CONSTR_DGNSSTO = 0x201100c4 as Uint32;

  /// Permanently attenuated signal compensation mode
  static final Uint32 SIGATTCOMP = 0x201100d6 as Uint32;

  /// Enable Protection level. If enabled, protection level computing will be on.
  static final Uint32 PL_ENA = 0x101100d7 as Uint32;
}

/// CFG-NMEA: NMEA protocol configuration
class NMEA {
  /// NMEA protocol version
  static final Uint32 PROTVER = 0x20930001 as Uint32;

  /// Maximum number of SVs to report per Talker ID
  static final Uint32 MAXSVS = 0x20930002 as Uint32;

  /// Enable compatibility mode
  static final Uint32 COMPAT = 0x10930003 as Uint32;

  /// Enable considering mode
  static final Uint32 CONSIDER = 0x10930004 as Uint32;

  /// Enable strict limit to 82 characters maximum NMEA message length
  static final Uint32 LIMIT82 = 0x10930005 as Uint32;

  /// Enable high precision mode
  static final Uint32 HIGHPREC = 0x10930006 as Uint32;

  /// Display configuration for SVs that do not have value defined in NMEA
  static final Uint32 SVNUMBERING = 0x20930007 as Uint32;

  /// Disable reporting of GPS satellites
  static final Uint32 FILT_GPS = 0x10930011 as Uint32;

  /// Disable reporting of SBAS satellites
  static final Uint32 FILT_SBAS = 0x10930012 as Uint32;

  /// Disable reporting of Galileo satellites
  static final Uint32 FILT_GAL = 0x10930013 as Uint32;

  /// Disable reporting of QZSS satellites
  static final Uint32 FILT_QZSS = 0x10930015 as Uint32;

  /// Disable reporting of GLONASS satellites
  static final Uint32 FILT_GLO = 0x10930016 as Uint32;

  /// Disable reporting of BeiDou satellites
  static final Uint32 FILT_BDS = 0x10930017 as Uint32;

  /// Enable position output for failed or invalid fixes
  static final Uint32 OUT_INVFIX = 0x10930021 as Uint32;

  /// Enable position output for invalid fixes
  static final Uint32 OUT_MSKFIX = 0x10930022 as Uint32;

  /// Enable time output for invalid times
  static final Uint32 OUT_INVTIME = 0x10930023 as Uint32;

  /// Enable date output for invalid dates
  static final Uint32 OUT_INVDATE = 0x10930024 as Uint32;

  /// Restrict output to GPS satellites only
  static final Uint32 OUT_ONLYGPS = 0x10930025 as Uint32;

  /// Enable course over ground output even if it is frozen
  static final Uint32 OUT_FROZENCOG = 0x10930026 as Uint32;

  /// Main Talker ID
  static final Uint32 MAINTALKERID = 0x20930031 as Uint32;

  /// Talker ID for GSV NMEA messages
  static final Uint32 GSVTALKERID = 0x20930032 as Uint32;

  /// BeiDou Talker ID
  static final Uint32 BDSTALKERID = 0x30930033 as Uint32;
}

/// CFG-ODO: Odometer and low-speed course over ground filter
class ODO {
  /// Use odometer
  static final Uint32 USE_ODO = 0x10220001 as Uint32;

  /// Use low-speed course over ground filter
  static final Uint32 USE_COG = 0x10220002 as Uint32;

  /// Output low-pass filtered velocity
  static final Uint32 OUTLPVEL = 0x10220003 as Uint32;

  /// Output low-pass filtered course over ground (heading)
  static final Uint32 OUTLPCOG = 0x10220004 as Uint32;

  /// Odometer profile configuration
  static final Uint32 PROFILE = 0x20220005 as Uint32;

  /// Upper speed limit for low-speed course over ground filter
  static final Uint32 COGMAXSPEED = 0x20220021 as Uint32;

  /// Maximum acceptable position accuracy for computing low-speed filtered course over ground
  static final Uint32 COGMAXPOSACC = 0x20220022 as Uint32;

  /// Velocity low-pass filter level
  static final Uint32 VELLPGAIN = 0x20220031 as Uint32;

  /// Course over ground low-pass filter level (at speed < 8 m/s)
  static final Uint32 COGLPGAIN = 0x20220032 as Uint32;
}

/// CFG-PM: Configuration for receiver power management (NEO-D9S)
class PM {
  /// EXTINT pin select
  static final Uint32 EXTINTSEL = 0x20d0000b as Uint32;

  /// EXTINT pin control (Wake). Enable to keep receiver awake as long as selected EXTINT pin is "high".
  static final Uint32 EXTINTWAKE = 0x10d0000c as Uint32;

  /// EXTINT pin control (Backup). Enable to force receiver into BACKUP mode when selected EXTINT pin is "low".
  static final Uint32 EXTINTBACKUP = 0x10d0000d as Uint32;

  /// EXTINT pin control (Inactive). Enable to force backup in case EXTINT Pin is inactive for time longer than CFG-PM-EXTINTINACTIVITY.
  static final Uint32 EXTINTINACTIVE = 0x10d0000e as Uint32;

  /// Inactivity time out on EXTINT pin if enabled
  static final Uint32 EXTINTINACTIVITY = 0x40d0000f as Uint32;
}

/// CFG-PMP: Point to multipoint (PMP) configuration (NEO-D9S)
class PMP {
  /// Center frequency. The center frequency for the receiver can be set from 1525000000 to 1559000000 Hz.
  static final Uint32 CENTER_FREQUENCY = 0x40b10011 as Uint32;

  /// Search window. Search window can be set from 0 to 65535 Hz. It is +/- this value from the center frequency set by CENTER_FREQUENCY.
  static final Uint32 SEARCH_WINDOW = 0x30b10012 as Uint32;

  /// Use service ID. Enable/disable service ID check to confirm the correct service is received.
  static final Uint32 USE_SERVICE_ID = 0x10b10016 as Uint32;

  /// Service identifier. Defines the expected service ID.
  static final Uint32 SERVICE_ID = 0x30b10017 as Uint32;

  /// bps Data rate. The data rate of the received data.
  static final Uint32 DATA_RATE = 0x30b10013 as Uint32;

  /// Use descrambler. Enables/disables the descrambler.
  static final Uint32 USE_DESCRAMBLER = 0x10b10014 as Uint32;

  /// Descrambler initialization. Set the intialisation value for the descrambler.
  static final Uint32 DESCRAMBLER_INIT = 0x30b10015 as Uint32;

  /// Use prescrambling. Enables/disables the prescrambling.
  static final Uint32 USE_PRESCRAMBLING = 0x10b10019 as Uint32;

  /// Unique word. Defines value of unique word.
  static final Uint32 UNIQUE_WORD = 0x50b1001a as Uint32;
}

/// CFG-QZSS: QZSS system configuration
class QZSS {
  /// Apply QZSS SLAS DGNSS corrections
  static final Uint32 USE_SLAS_DGNSS = 0x10370005 as Uint32;

  /// Use QZSS SLAS data when it is in test mode (SLAS msg 0)
  static final Uint32 USE_SLAS_TESTMODE = 0x10370006 as Uint32;

  /// Raim out measurements that are not corrected by QZSS SLAS, if at least 5 measurements are corrected
  static final Uint32 USE_SLAS_RAIM_UNCORR = 0x10370007 as Uint32;

  /// Maximum baseline distance to closest Ground Monitoring Station: km
  static final Uint32 SLAS_MAX_BASELINE = 0x30370008 as Uint32;
}

/// CFG-RATE: Navigation and measurement rate configuration
class RATE {
  /// Nominal time between GNSS measurements
  static final Uint32 MEAS = 0x30210001 as Uint32;

  /// Ratio of number of measurements to number of navigation solutions
  static final Uint32 NAV = 0x30210002 as Uint32;

  /// Time system to which measurements are aligned
  static final Uint32 TIMEREF = 0x20210003 as Uint32;

  /// Output rate of priority navigation mode messages
  static final Uint32 NAV_PRIO = 0x20210004 as Uint32;
}

/// CFG-RINV: Remote inventory
class RINV {
  /// Dump data at startup
  static final Uint32 DUMP = 0x10c70001 as Uint32;

  /// Data is binary
  static final Uint32 BINARY = 0x10c70002 as Uint32;

  /// Size of data
  static final Uint32 DATA_SIZE = 0x20c70003 as Uint32;

  /// Data bytes 1-8 (LSB)
  static final Uint32 CHUNK0 = 0x50c70004 as Uint32;

  /// Data bytes 9-16
  static final Uint32 CHUNK1 = 0x50c70005 as Uint32;

  /// Data bytes 17-240x44434241.
  static final Uint32 CHUNK2 = 0x50c70006 as Uint32;

  /// Data bytes 25-30 (MSB)
  static final Uint32 CHUNK3 = 0x50c70007 as Uint32;
}

/// CFG-RTCM: RTCM protocol configuration
class RTCM {
  /// RTCM DF003 (Reference station ID) output value
  static final Uint32 DF003_OUT = 0x30090001 as Uint32;

  /// RTCM DF003 (Reference station ID) input value
  static final Uint32 DF003_IN = 0x30090008 as Uint32;

  /// RTCM input filter configuration based on RTCM DF003 (Reference station ID) value
  static final Uint32 DF003_IN_FILTER = 0x20090009 as Uint32;
}

/// CFG-SBAS: SBAS configuration
class SBAS {
  /// Use SBAS data when it is in test mode (SBAS msg 0)
  static final Uint32 USE_TESTMODE = 0x10360002 as Uint32;

  /// Use SBAS GEOs as a ranging source (for navigation)
  static final Uint32 USE_RANGING = 0x10360003 as Uint32;

  /// Use SBAS diﬀerential corrections
  static final Uint32 USE_DIFFCORR = 0x10360004 as Uint32;

  /// Use SBAS integrity information
  static final Uint32 USE_INTEGRITY = 0x10360005 as Uint32;

  /// SBAS PRN search configuration
  static final Uint32 PRNSCANMASK = 0x50360006 as Uint32;
}

///  CFG-SEC: Security configuration (ZED-F9R)
class SEC {
  /// Configuration lockdown
  static final Uint32 CFG_LOCK = 0x10f60009 as Uint32;

  /// Configuration lockdown exempted group 1
  static final Uint32 CFG_LOCK_UNLOCKGRP1 = 0x30f6000a as Uint32;

  /// Configuration lockdown exempted group 2
  static final Uint32 CFG_LOCK_UNLOCKGRP2 = 0x30f6000b as Uint32;
}

/// CFG-SFCORE: Sensor fusion (SF) core configuration (ZED-F9R)
class SFCORE {
  /// Use ADR/UDR sensor fusion
  static final Uint32 USE_SF = 0x10080001 as Uint32;
}

/// CFG-SFIMU: Sensor fusion (SF) inertial measurement unit (IMU) configuration (ZED-F9R)
class SFIMU {
  /// Time period between each update for the saved temperature-dependent gyroscope bias table
  static final Uint32 GYRO_TC_UPDATE_PERIOD = 0x30060007 as Uint32;

  /// Gyroscope sensor RMS threshold
  static final Uint32 GYRO_RMSTHDL = 0x20060008 as Uint32;

  /// Nominal gyroscope sensor data sampling frequency
  static final Uint32 GYRO_FREQUENCY = 0x20060009 as Uint32;

  /// Gyroscope sensor data latency due to e.g. CAN bus
  static final Uint32 GYRO_LATENCY = 0x3006000a as Uint32;

  /// Gyroscope sensor data accuracy
  static final Uint32 GYRO_ACCURACY = 0x3006000b as Uint32;

  /// Accelerometer RMS threshold
  static final Uint32 ACCEL_RMSTHDL = 0x20060015 as Uint32;

  /// Nominal accelerometer sensor data sampling frequency
  static final Uint32 ACCEL_FREQUENCY = 0x20060016 as Uint32;

  /// Accelerometer sensor data latency due to e.g. CAN bus
  static final Uint32 ACCEL_LATENCY = 0x30060017 as Uint32;

  /// Accelerometer sensor data accuracy
  static final Uint32 ACCEL_ACCURACY = 0x30060018 as Uint32;

  /// IMU enabled
  static final Uint32 IMU_EN = 0x1006001d as Uint32;

  /// SCL PIO of the IMU I2C
  static final Uint32 IMU_I2C_SCL_PIO = 0x2006001e as Uint32;

  /// SDA PIO of the IMU I2C
  static final Uint32 IMU_I2C_SDA_PIO = 0x2006001f as Uint32;

  /// Enable automatic IMU-mount alignment
  static final Uint32 AUTO_MNTALG_ENA = 0x10060027 as Uint32;

  /// User-defined IMU-mount yaw angle [0, 360]
  static final Uint32 IMU_MNTALG_YAW = 0x4006002d as Uint32;

  /// User-defined IMU-mount pitch angle [-90, 90]
  static final Uint32 IMU_MNTALG_PITCH = 0x3006002e as Uint32;

  /// User-defined IMU-mount roll angle [-180, 180]
  static final Uint32 IMU_MNTALG_ROLL = 0x3006002f as Uint32;
}

/// CFG-SFODO: Sensor fusion (SF) odometer configuration (ZED-F9R)
class SFODO {
  /// Use combined rear wheel ticks instead of the single tick
  static final Uint32 UBLOX_CFG_SFODO_COMBINE_TICKS = 0x10070001 as Uint32;

  /// Use speed measurements
  static final Uint32 UBLOX_CFG_SFODO_USE_SPEED = 0x10070003 as Uint32;

  /// Disable automatic estimation of maximum absolute wheel tick counter
  static final Uint32 UBLOX_CFG_SFODO_DIS_AUTOCOUNTMAX = 0x10070004 as Uint32;

  /// Disable automatic wheel tick direction pin polarity detection
  static final Uint32 UBLOX_CFG_SFODO_DIS_AUTODIRPINPOL = 0x10070005 as Uint32;

  /// Disable automatic receiver reconfiguration for processing speed data
  static final Uint32 UBLOX_CFG_SFODO_DIS_AUTOSPEED = 0x10070006 as Uint32;

  /// Wheel tick scale factor
  static final Uint32 UBLOX_CFG_SFODO_FACTOR = 0x40070007 as Uint32;

  /// Wheel tick quantization
  static final Uint32 UBLOX_CFG_SFODO_QUANT_ERROR = 0x40070008 as Uint32;

  /// Wheel tick counter maximum value
  static final Uint32 UBLOX_CFG_SFODO_COUNT_MAX = 0x40070009 as Uint32;

  /// Wheel tick data latency due to e.g. CAN bus
  static final Uint32 UBLOX_CFG_SFODO_LATENCY = 0x3007000a as Uint32;

  /// Nominal wheel tick data frequency (0 = not set)
  static final Uint32 UBLOX_CFG_SFODO_FREQUENCY = 0x2007000b as Uint32;

  /// Count both rising and falling edges on wheel tick signal
  static final Uint32 UBLOX_CFG_SFODO_CNT_BOTH_EDGES = 0x1007000d as Uint32;

  /// Speed sensor dead band (0 = not set)
  static final Uint32 UBLOX_CFG_SFODO_SPEED_BAND = 0x3007000e as Uint32;

  /// Wheel tick signal enabled
  static final Uint32 UBLOX_CFG_SFODO_USE_WT_PIN = 0x1007000f as Uint32;

  /// Wheel tick direction pin polarity
  static final Uint32 UBLOX_CFG_SFODO_DIR_PINPOL = 0x10070010 as Uint32;

  /// Disable automatic use of wheel tick or speed data received over the software interface
  static final Uint32 UBLOX_CFG_SFODO_DIS_AUTOSW = 0x10070011 as Uint32;
}

/// CFG-SIGNAL: Satellite systems (GNSS) signal configuration
class SIGNAL {
  /// GPS enable
  static final Uint32 UBLOX_CFG_SIGNAL_GPS_ENA = 0x1031001f as Uint32;

  /// GPS L1C/A
  static final Uint32 UBLOX_CFG_SIGNAL_GPS_L1CA_ENA = 0x10310001 as Uint32;

  /// GPS L5
  static final Uint32 UBLOX_CFG_SIGNAL_GPS_L5_ENA = 0x10310004 as Uint32;

  /// GPS L2C (only on u-blox F9 platform products)
  static final Uint32 UBLOX_CFG_SIGNAL_GPS_L2C_ENA = 0x10310003 as Uint32;

  /// SBAS enable
  static final Uint32 UBLOX_CFG_SIGNAL_SBAS_ENA = 0x10310020 as Uint32;

  /// SBAS L1C/A
  static final Uint32 UBLOX_CFG_SIGNAL_SBAS_L1CA_ENA = 0x10310005 as Uint32;

  /// Galileo enable
  static final Uint32 UBLOX_CFG_SIGNAL_GAL_ENA = 0x10310021 as Uint32;

  /// Galileo E1
  static final Uint32 UBLOX_CFG_SIGNAL_GAL_E1_ENA = 0x10310007 as Uint32;

  /// Galileo E5a
  static final Uint32 UBLOX_CFG_SIGNAL_GAL_E5A_ENA = 0x10310009 as Uint32;

  /// Galileo E5b (only on u-blox F9 platform products)
  static final Uint32 UBLOX_CFG_SIGNAL_GAL_E5B_ENA = 0x1031000a as Uint32;

  /// BeiDou Enable
  static final Uint32 UBLOX_CFG_SIGNAL_BDS_ENA = 0x10310022 as Uint32;

  /// BeiDou B1I
  static final Uint32 UBLOX_CFG_SIGNAL_BDS_B1_ENA = 0x1031000d as Uint32;

  /// BeiDou B1C
  static final Uint32 UBLOX_CFG_SIGNAL_BDS_B1C_ENA = 0x1031000f as Uint32;

  /// BeiDou B2a
  static final Uint32 UBLOX_CFG_SIGNAL_BDS_B2A_ENA = 0x10310028 as Uint32;

  /// BeiDou B2I (only on u-blox F9 platform products)
  static final Uint32 UBLOX_CFG_SIGNAL_BDS_B2_ENA = 0x1031000e as Uint32;

  /// QZSS enable
  static final Uint32 UBLOX_CFG_SIGNAL_QZSS_ENA = 0x10310024 as Uint32;

  /// QZSS L1C/A
  static final Uint32 UBLOX_CFG_SIGNAL_QZSS_L1CA_ENA = 0x10310012 as Uint32;

  /// QZSS L5
  static final Uint32 UBLOX_CFG_SIGNAL_QZSS_L5_ENA = 0x10310017 as Uint32;

  /// QZSS L1S
  static final Uint32 UBLOX_CFG_SIGNAL_QZSS_L1S_ENA = 0x10310014 as Uint32;

  /// QZSS L2C (only on u-blox F9 platform products)
  static final Uint32 UBLOX_CFG_SIGNAL_QZSS_L2C_ENA = 0x10310015 as Uint32;

  /// GLONASS enable
  static final Uint32 UBLOX_CFG_SIGNAL_GLO_ENA = 0x10310025 as Uint32;

  /// GLONASS L1
  static final Uint32 UBLOX_CFG_SIGNAL_GLO_L1_ENA = 0x10310018 as Uint32;

  /// GLONASS L2 (only on u-blox F9 platform products)
  static final Uint32 UBLOX_CFG_SIGNAL_GLO_L2_ENA = 0x1031001a as Uint32;
}

// CFG-SPARTN: Configuration of the SPARTN interface
class SPARTN {
  static final Uint32 USE_SOURCE = 0x20a70001 as Uint32;
}

// CFG-SPI: Configuration of the SPI interface
class SPI {
  /// Number of bytes containing 0xFF to receive before switching oﬀ reception. Range: 0 (mechanism oﬀ) - 63
  static final Uint32 MAXFF = 0x20640001 as Uint32;

  /// Clock polarity select: 0: Active Hight Clock, SCLK idles low, 1: Active Low Clock, SCLK idles high
  static final Uint32 CPOLARITY = 0x10640002 as Uint32;

  /// Clock phase select: 0: Data captured on first edge of SCLK, 1: Data captured on second edge of SCLK
  static final Uint32 CPHASE = 0x10640003 as Uint32;

  /// Flag to disable timeouting the interface after 1.5s
  static final Uint32 EXTENDEDTIMEOUT = 0x10640005 as Uint32;

  /// Flag to indicate if the SPI interface should be enabled
  static final Uint32 ENABLED = 0x10640006 as Uint32;
}

/// CFG-SPIINPROT: Input protocol configuration of the SPI interface
class SPIINPROT {
  /// Flag to indicate if UBX should be an input protocol on SPI
  static final Uint32 UBX = 0x10790001 as Uint32;

  /// Flag to indicate if NMEA should be an input protocol on SPI
  static final Uint32 NMEA = 0x10790002 as Uint32;

  /// Flag to indicate if RTCM3X should be an input protocol on SPI
  static final Uint32 RTCM3X = 0x10790004 as Uint32;

  /// Flag to indicate if SPARTN should be an input protocol on SPI
  static final Uint32 SPARTN = 0x10790005 as Uint32;
}

/// CFG-SPIOUTPROT: Output protocol configuration of the SPI interface
class SPIOUTPROT {
  /// Flag to indicate if UBX should be an output protocol on SPI
  static final Uint32 UBX = 0x107a0001 as Uint32;

  /// Flag to indicate if NMEA should be an output protocol on SPI
  static final Uint32 NMEA = 0x107a0002 as Uint32;

  /// Flag to indicate if RTCM3X should be an output protocol on SPI
  static final Uint32 RTCM3X = 0x107a0004 as Uint32;
}

// CFG-TMODE: Time mode configuration
class TMODE {
  /// Receiver mode
  static final Uint32 MODE = 0x20030001 as Uint32;

  /// Determines whether the ARP position is given in ECEF or LAT/LON/HEIGHT?
  static final Uint32 POS_TYPE = 0x20030002 as Uint32;

  /// ECEF X coordinate of the ARP position.
  static final Uint32 ECEF_X = 0x40030003 as Uint32;

  /// ECEF Y coordinate of the ARP position.
  static final Uint32 ECEF_Y = 0x40030004 as Uint32;

  /// ECEF Z coordinate of the ARP position.
  static final Uint32 ECEF_Z = 0x40030005 as Uint32;

  /// High-precision ECEF X coordinate of the ARP position.
  static final Uint32 ECEF_X_HP = 0x20030006 as Uint32;

  /// High-precision ECEF Y coordinate of the ARP position.
  static final Uint32 ECEF_Y_HP = 0x20030007 as Uint32;

  /// High-precision ECEF Z coordinate of the ARP position.
  static final Uint32 ECEF_Z_HP = 0x20030008 as Uint32;

  /// Latitude of the ARP position.
  static final Uint32 LAT = 0x40030009 as Uint32;

  /// Longitude of the ARP position.
  static final Uint32 LON = 0x4003000a as Uint32;

  /// Height of the ARP position.
  static final Uint32 HEIGHT = 0x4003000b as Uint32;

  /// High-precision latitude of the ARP position
  static final Uint32 LAT_HP = 0x2003000c as Uint32;

  /// High-precision longitude of the ARP position.
  static final Uint32 LON_HP = 0x2003000d as Uint32;

  /// High-precision height of the ARP position.
  static final Uint32 HEIGHT_HP = 0x2003000e as Uint32;

  /// Fixed position 3D accuracy
  static final Uint32 FIXED_POS_ACC = 0x4003000f as Uint32;

  /// Survey-in minimum duration
  static final Uint32 SVIN_MIN_DUR = 0x40030010 as Uint32;

  /// Survey-in position accuracy limit
  static final Uint32 SVIN_ACC_LIMIT = 0x40030011 as Uint32;
}

/// CFG-TP: Timepulse configuration
class TP {
  /// Determines whether the time pulse is interpreted as frequency or period
  static final Uint32 PULSE_DEF = 0x20050023 as Uint32;

  /// Determines whether the time pulse length is interpreted as length[us] or pulse ratio[%]
  static final Uint32 PULSE_LENGTH_DEF = 0x20050030 as Uint32;

  /// Antenna cable delay
  static final Uint32 ANT_CABLEDELAY = 0x30050001 as Uint32;

  /// Time pulse period (TP1)
  static final Uint32 PERIOD_TP1 = 0x40050002 as Uint32;

  /// Time pulse period when locked to GNSS time (TP1)
  static final Uint32 PERIOD_LOCK_TP1 = 0x40050003 as Uint32;

  /// Time pulse frequency (TP1)
  static final Uint32 FREQ_TP1 = 0x40050024 as Uint32;

  /// Time pulse frequency when locked to GNSS time (TP1)
  static final Uint32 FREQ_LOCK_TP1 = 0x40050025 as Uint32;

  /// Time pulse length (TP1)
  static final Uint32 LEN_TP1 = 0x40050004 as Uint32;

  /// Time pulse length when locked to GNSS time (TP1)
  static final Uint32 LEN_LOCK_TP1 = 0x40050005 as Uint32;

  /// Time pulse duty cycle (TP1)
  static final Uint32 DUTY_TP1 = 0x5005002a as Uint32;

  /// Time pulse duty cycle when locked to GNSS time (TP1)
  static final Uint32 DUTY_LOCK_TP1 = 0x5005002b as Uint32;

  /// User-configurable time pulse delay (TP1)
  static final Uint32 USER_DELAY_TP1 = 0x40050006 as Uint32;

  /// Enable the first timepulse
  static final Uint32 TP1_ENA = 0x10050007 as Uint32;

  /// Sync time pulse to GNSS time or local clock (TP1)
  static final Uint32 SYNC_GNSS_TP1 = 0x10050008 as Uint32;

  /// Use locked parameters when possible (TP1)
  static final Uint32 USE_LOCKED_TP1 = 0x10050009 as Uint32;

  /// Align time pulse to top of second (TP1)
  static final Uint32 ALIGN_TO_TOW_TP1 = 0x1005000a as Uint32;

  /// Set time pulse polarity (TP1)
  static final Uint32 POL_TP1 = 0x1005000b as Uint32;

  /// Time grid to use (TP1)
  static final Uint32 TIMEGRID_TP1 = 0x2005000c as Uint32;

  /// Time pulse period (TP2)
  static final Uint32 PERIOD_TP2 = 0x4005000d as Uint32;

  /// Time pulse period when locked to GNSS time
  static final Uint32 PERIOD_LOCK_TP2 = 0x4005000e as Uint32;

  /// Time pulse frequency (TP2)
  static final Uint32 FREQ_TP2 = 0x40050026 as Uint32;

  /// Time pulse frequency when locked to GNSS time
  static final Uint32 FREQ_LOCK_TP2 = 0x40050027 as Uint32;

  /// Time pulse length (TP2)
  static final Uint32 LEN_TP2 = 0x4005000f as Uint32;

  /// Time pulse length when locked to GNSS time
  static final Uint32 LEN_LOCK_TP2 = 0x40050010 as Uint32;

  /// Time pulse duty cycle (TP2)
  static final Uint32 DUTY_TP2 = 0x5005002c as Uint32;

  /// Time pulse duty cycle when locked to GNSS time
  static final Uint32 DUTY_LOCK_TP2 = 0x5005002d as Uint32;

  /// User-configurable time pulse delay (TP2)
  static final Uint32 USER_DELAY_TP2 = 0x40050011 as Uint32;

  /// Enable the second timepulse
  static final Uint32 TP2_ENA = 0x10050012 as Uint32;

  /// Sync time pulse to GNSS time or local clock
  static final Uint32 SYNC_GNSS_TP2 = 0x10050013 as Uint32;

  /// Use locked parameters when possible (TP2)
  static final Uint32 USE_LOCKED_TP2 = 0x10050014 as Uint32;

  /// Align time pulse to top of second (TP2)
  static final Uint32 ALIGN_TO_TOW_TP2 = 0x10050015 as Uint32;

  /// Set time pulse polarity (TP2)
  static final Uint32 POL_TP2 = 0x10050016 as Uint32;

  /// Time grid to use (TP2)
  static final Uint32 TIMEGRID_TP2 = 0x20050017 as Uint32;

  /// Set drive strength of TP1
  static final Uint32 DRSTR_TP1 = 0x20050035 as Uint32;

  /// Set drive strength of TP2
  static final Uint32 DRSTR_TP2 = 0x20050036 as Uint32;
}

/// CFG-TXREADY: TX ready configuration
class TXREADY {
  /// Flag to indicate if TX ready pin mechanism should be enabled
  static final Uint32 ENABLED = 0x10a20001 as Uint32;

  /// The polarity of the TX ready pin: false:high- active, true:low-active
  static final Uint32 POLARITY = 0x10a20002 as Uint32;

  /// Pin number to use for the TX ready functionality
  static final Uint32 PIN = 0x20a20003 as Uint32;

  /// Amount of data that should be ready on the interface before triggering the TX ready pin
  static final Uint32 THRESHOLD = 0x30a20004 as Uint32;

  /// Interface where the TX ready feature should be linked to
  static final Uint32 INTERFACE = 0x20a20005 as Uint32;
}

/// CFG-UART1: Configuration of the UART1 interface
class UART1 {
  /// The baud rate that should be configured on the UART1
  static final Uint32 UBLOX_CFG_UART1_BAUDRATE = 0x40520001 as Uint32;

  /// Number of stopbits that should be used on UART1
  static final Uint32 UBLOX_CFG_UART1_STOPBITS = 0x20520002 as Uint32;

  /// Number of databits that should be used on UART1
  static final Uint32 UBLOX_CFG_UART1_DATABITS = 0x20520003 as Uint32;

  /// Parity mode that should be used on UART1
  static final Uint32 UBLOX_CFG_UART1_PARITY = 0x20520004 as Uint32;

  /// Flag to indicate if the UART1 should be enabled
  static final Uint32 UBLOX_CFG_UART1_ENABLED = 0x10520005 as Uint32;
}

/// CFG-UART1INPROT: Input protocol configuration of the UART1 interface
class UART1INPROT {
  /// Flag to indicate if UBX should be an input protocol on UART1
  static final Uint32 UBX = 0x10730001 as Uint32;

  /// Flag to indicate if NMEA should be an input protocol on UART1
  static final Uint32 NMEA = 0x10730002 as Uint32;

  /// Flag to indicate if RTCM3X should be an input protocol on UART1
  static final Uint32 RTCM3X = 0x10730004 as Uint32;

  /// Flag to indicate if SPARTN should be an input protocol on UART1
  static final Uint32 SPARTN = 0x10730005 as Uint32;
}

/// CFG-UART1OUTPROT: Output protocol configuration of the UART1 interface
class UART1OUTPROT {
  /// Flag to indicate if UBX should be an output protocol on UART1
  static final Uint32 UBX = 0x10740001 as Uint32;

  /// Flag to indicate if NMEA should be an output protocol on UART1
  static final Uint32 NMEA = 0x10740002 as Uint32;

  /// Flag to indicate if RTCM3X should be an output protocol on UART1
  static final Uint32 RTCM3X = 0x10740004 as Uint32;
}

/// CFG-UART2: Configuration of the UART2 interface
class UART2 {
  /// The baud rate that should be configured on the UART2
  static final Uint32 BAUDRATE = 0x40530001 as Uint32;

  /// Number of stopbits that should be used on UART2
  static final Uint32 STOPBITS = 0x20530002 as Uint32;

  /// Number of databits that should be used on UART2
  static final Uint32 DATABITS = 0x20530003 as Uint32;

  /// Parity mode that should be used on UART2
  static final Uint32 PARITY = 0x20530004 as Uint32;

  /// Flag to indicate if the UART2 should be enabled
  static final Uint32 ENABLED = 0x10530005 as Uint32;

  /// UART2 Remapping
  static final Uint32 REMAP = 0x10530006 as Uint32;
}

/// CFG-UART2INPROT: Input protocol configuration of the UART2 interface
class UART2INPROT {
  /// Flag to indicate if UBX should be an input protocol on UART2
  static final Uint32 UBX = 0x10750001 as Uint32;

  /// Flag to indicate if NMEA should be an input protocol on UART2
  static final Uint32 NMEA = 0x10750002 as Uint32;

  /// Flag to indicate if RTCM3X should be an input protocol on UART2
  static final Uint32 RTCM3X = 0x10750004 as Uint32;

  /// Flag to indicate if SPARTN should be an input protocol on UART2
  static final Uint32 SPARTN = 0x10750005 as Uint32;
}

// CFG-UART2OUTPROT: Output protocol configuration of the UART2 interface
class UART2OUTPROT {
  /// Flag to indicate if UBX should be an output protocol on UART2
  static final Uint32 UBX = 0x10760001 as Uint32;

  /// Flag to indicate if NMEA should be an output protocol on UART2
  static final Uint32 NMEA = 0x10760002 as Uint32;

  /// Flag to indicate if RTCM3X should be an output protocol on UART2
  static final Uint32 RTCM3X = 0x10760004 as Uint32;
}

/// CFG-USB: Configuration of the USB interface
class USB {
  /// Flag to indicate if the USB interface should be enabled
  static final Uint32 ENABLED = 0x10650001 as Uint32;

  /// Self-powered device
  static final Uint32 SELFPOW = 0x10650002 as Uint32;

  /// Vendor ID
  static final Uint32 VENDOR_ID = 0x3065000a as Uint32;

  /// Vendor ID
  static final Uint32 PRODUCT_ID = 0x3065000b as Uint32;

  /// Power consumption
  static final Uint32 POWER = 0x3065000c as Uint32;

  /// Vendor string characters 0-7
  static final Uint32 VENDOR_STR0 = 0x5065000d as Uint32;

  /// Vendor string characters 8-15
  static final Uint32 VENDOR_STR1 = 0x5065000e as Uint32;

  /// Vendor string characters 16-23
  static final Uint32 VENDOR_STR2 = 0x5065000f as Uint32;

  /// Vendor string characters 24-31
  static final Uint32 VENDOR_STR3 = 0x50650010 as Uint32;

  /// Product string characters 0-7
  static final Uint32 PRODUCT_STR0 = 0x50650011 as Uint32;

  /// Product string characters 8-15
  static final Uint32 PRODUCT_STR1 = 0x50650012 as Uint32;

  /// Product string characters 16-23
  static final Uint32 PRODUCT_STR2 = 0x50650013 as Uint32;

  /// Product string characters 24-31
  static final Uint32 PRODUCT_STR3 = 0x50650014 as Uint32;

  /// Serial number string characters 0-7
  static final Uint32 SERIAL_NO_STR0 = 0x50650015 as Uint32;

  /// Serial number string characters 8-15
  static final Uint32 SERIAL_NO_STR1 = 0x50650016 as Uint32;

  /// Serial number string characters 16-23
  static final Uint32 SERIAL_NO_STR2 = 0x50650017 as Uint32;

  /// Serial number string characters 24-31
  static final Uint32 SERIAL_NO_STR3 = 0x50650018 as Uint32;
}

/// CFG-USBINPROT: Input protocol configuration of the USB interface
class USBINPROT {
  /// Flag to indicate if UBX should be an input protocol on USB
  static final Uint32 UBX = 0x10770001 as Uint32;

  /// Flag to indicate if NMEA should be an input protocol on USB
  static final Uint32 NMEA = 0x10770002 as Uint32;

  /// Flag to indicate if RTCM3X should be an input protocol on USB
  static final Uint32 RTCM3X = 0x10770004 as Uint32;

  /// Flag to indicate if SPARTN should be an input protocol on USB
  static final Uint32 SPARTN = 0x10770005 as Uint32;
}

// CFG-USBOUTPROT: Output protocol configuration of the USB interface
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
class USBOUTPROT {
  /// Flag to indicate if UBX should be an output protocol on USB
  static final Uint32 UBX = 0x10780001 as Uint32;

  /// Flag to indicate if NMEA should be an output protocol on USB
  static final Uint32 NMEA = 0x10780002 as Uint32;

  /// Flag to indicate if RTCM3X should be an output protocol on USB
  static final Uint32 RTCM3X = 0x10780004 as Uint32;
}

// CFG-GEOFENCE: Geofencing configuration
//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
class GEOFENCE {
  /// Required confidence level for state evaluation
  static final Uint32 CONFLVL = 0x20240011 as Uint32;

  /// Use PIO combined fence state output
  static final Uint32 USE_PIO = 0x10240012 as Uint32;

  /// PIO pin polarity
  static final Uint32 PINPOL = 0x20240013 as Uint32;

  /// PIO pin number
  static final Uint32 PIN = 0x20240014 as Uint32;

  /// Use frst geofence
  static final Uint32 USE_FENCE1 = 0x10240020 as Uint32;

  /// Latitude of the first geofence circle center
  static final Uint32 FENCE1_LAT = 0x40240021 as Uint32;

  /// Longitude of the first geofence circle center
  static final Uint32 FENCE1_LON = 0x40240022 as Uint32;

  /// Radius of the first geofence circle
  static final Uint32 FENCE1_RAD = 0x40240023 as Uint32;

  /// Use second geofence
  static final Uint32 USE_FENCE2 = 0x10240030 as Uint32;

  /// Latitude of the second geofence circle center
  static final Uint32 FENCE2_LAT = 0x40240031 as Uint32;

  /// Longitude of the second geofence circle center
  static final Uint32 FENCE2_LON = 0x40240032 as Uint32;

  /// Radius of the second geofence circle
  static final Uint32 FENCE2_RAD = 0x40240033 as Uint32;

  /// Use third geofence
  static final Uint32 USE_FENCE3 = 0x10240040 as Uint32;

  /// Latitude of the third geofence circle center
  static final Uint32 FENCE3_LAT = 0x40240041 as Uint32;

  /// Longitude of the third geofence circle center
  static final Uint32 FENCE3_LON = 0x40240042 as Uint32;

  /// Radius of the third geofence circle
  static final Uint32 FENCE3_RAD = 0x40240043 as Uint32;

  /// Use fourth geofence
  static final Uint32 USE_FENCE4 = 0x10240050 as Uint32;

  /// Latitude of the fourth geofence circle center
  static final Uint32 FENCE4_LAT = 0x40240051 as Uint32;

  /// Longitude of the fourth geofence circle center
  static final Uint32 FENCE4_LON = 0x40240052 as Uint32;

  /// Radius of the fourth geofence circle
  static final Uint32 FENCE4_RAD = 0x40240053 as Uint32;
}

/// CFG-MSGOUT: Message output configuration.
/// For each message and port a separate output rate (per second, per epoch) can be configured.
class MSGOUT {
  /// Output rate of the NMEA-GX-DTM message on port I2C
  static final Uint32 NMEA_ID_DTM_I2C = 0x209100a6 as Uint32;

  /// Output rate of the NMEA-GX-DTM message on port SPI
  static final Uint32 NMEA_ID_DTM_SPI = 0x209100aa as Uint32;

  /// Output rate of the NMEA-GX-DTM message on port UART1
  static final Uint32 NMEA_ID_DTM_UART1 = 0x209100a7 as Uint32;

  /// Output rate of the NMEA-GX-DTM message on port UART2
  static final Uint32 NMEA_ID_DTM_UART2 = 0x209100a8 as Uint32;

  /// Output rate of the NMEA-GX-DTM message on port USB
  static final Uint32 NMEA_ID_DTM_USB = 0x209100a9 as Uint32;

  /// Output rate of the NMEA-GX-GBS message on port I2C
  static final Uint32 NMEA_ID_GBS_I2C = 0x209100dd as Uint32;

  /// Output rate of the NMEA-GX-GBS message on port SPI
  static final Uint32 NMEA_ID_GBS_SPI = 0x209100e1 as Uint32;

  /// Output rate of the NMEA-GX-GBS message on port UART1
  static final Uint32 NMEA_ID_GBS_UART1 = 0x209100de as Uint32;

  /// Output rate of the NMEA-GX-GBS message on port UART2
  static final Uint32 NMEA_ID_GBS_UART2 = 0x209100df as Uint32;

  /// Output rate of the NMEA-GX-GBS message on port USB
  static final Uint32 NMEA_ID_GBS_USB = 0x209100e0 as Uint32;

  /// Output rate of the NMEA-GX-GGA message on port I2C
  static final Uint32 NMEA_ID_GGA_I2C = 0x209100ba as Uint32;

  /// Output rate of the NMEA-GX-GGA message on port SPI
  static final Uint32 NMEA_ID_GGA_SPI = 0x209100be as Uint32;

  /// Output rate of the NMEA-GX-GGA message on port UART1
  static final Uint32 NMEA_ID_GGA_UART1 = 0x209100bb as Uint32;

  /// Output rate of the NMEA-GX-GGA message on port UART2
  static final Uint32 NMEA_ID_GGA_UART2 = 0x209100bc as Uint32;

  /// Output rate of the NMEA-GX-GGA message on port USB
  static final Uint32 NMEA_ID_GGA_USB = 0x209100bd as Uint32;

  /// Output rate of the NMEA-GX-GLL message on port I2C
  static final Uint32 NMEA_ID_GLL_I2C = 0x209100c9 as Uint32;

  /// Output rate of the NMEA-GX-GLL message on port SPI
  static final Uint32 NMEA_ID_GLL_SPI = 0x209100cd as Uint32;

  /// Output rate of the NMEA-GX-GLL message on port UART1
  static final Uint32 NMEA_ID_GLL_UART1 = 0x209100ca as Uint32;

  /// Output rate of the NMEA-GX-GLL message on port UART2
  static final Uint32 NMEA_ID_GLL_UART2 = 0x209100cb as Uint32;

  /// Output rate of the NMEA-GX-GLL message on port USB
  static final Uint32 NMEA_ID_GLL_USB = 0x209100cc as Uint32;

  /// Output rate of the NMEA-GX-GNS message on port I2C
  static final Uint32 NMEA_ID_GNS_I2C = 0x209100b5 as Uint32;

  /// Output rate of the NMEA-GX-GNS message on port SPI
  static final Uint32 NMEA_ID_GNS_SPI = 0x209100b9 as Uint32;

  /// Output rate of the NMEA-GX-GNS message on port UART1
  static final Uint32 NMEA_ID_GNS_UART1 = 0x209100b6 as Uint32;

  /// Output rate of the NMEA-GX-GNS message on port UART2
  static final Uint32 NMEA_ID_GNS_UART2 = 0x209100b7 as Uint32;

  /// Output rate of the NMEA-GX-GNS message on port USB
  static final Uint32 NMEA_ID_GNS_USB = 0x209100b8 as Uint32;

  /// Output rate of the NMEA-GX-GRS message on port I2C
  static final Uint32 NMEA_ID_GRS_I2C = 0x209100ce as Uint32;

  /// Output rate of the NMEA-GX-GRS message on port SPI
  static final Uint32 NMEA_ID_GRS_SPI = 0x209100d2 as Uint32;

  /// Output rate of the NMEA-GX-GRS message on port UART1
  static final Uint32 NMEA_ID_GRS_UART1 = 0x209100cf as Uint32;

  /// Output rate of the NMEA-GX-GRS message on port UART2
  static final Uint32 NMEA_ID_GRS_UART2 = 0x209100d0 as Uint32;

  /// Output rate of the NMEA-GX-GRS message on port USB
  static final Uint32 NMEA_ID_GRS_USB = 0x209100d1 as Uint32;

  /// Output rate of the NMEA-GX-GSA message on port I2C
  static final Uint32 NMEA_ID_GSA_I2C = 0x209100bf as Uint32;

  /// Output rate of the NMEA-GX-GSA message on port SPI
  static final Uint32 NMEA_ID_GSA_SPI = 0x209100c3 as Uint32;

  /// Output rate of the NMEA-GX-GSA message on port UART1
  static final Uint32 NMEA_ID_GSA_UART1 = 0x209100c0 as Uint32;

  /// Output rate of the NMEA-GX-GSA message on port UART2
  static final Uint32 NMEA_ID_GSA_UART2 = 0x209100c1 as Uint32;

  /// Output rate of the NMEA-GX-GSA message on port USB
  static final Uint32 NMEA_ID_GSA_USB = 0x209100c2 as Uint32;

  /// Output rate of the NMEA-GX-GST message on port I2C
  static final Uint32 NMEA_ID_GST_I2C = 0x209100d3 as Uint32;

  /// Output rate of the NMEA-GX-GST message on port SPI
  static final Uint32 NMEA_ID_GST_SPI = 0x209100d7 as Uint32;

  /// Output rate of the NMEA-GX-GST message on port UART1
  static final Uint32 NMEA_ID_GST_UART1 = 0x209100d4 as Uint32;

  /// Output rate of the NMEA-GX-GST message on port UART2
  static final Uint32 NMEA_ID_GST_UART2 = 0x209100d5 as Uint32;

  /// Output rate of the NMEA-GX-GST message on port USB
  static final Uint32 NMEA_ID_GST_USB = 0x209100d6 as Uint32;

  /// Output rate of the NMEA-GX-GSV message on port I2C
  static final Uint32 NMEA_ID_GSV_I2C = 0x209100c4 as Uint32;

  /// Output rate of the NMEA-GX-GSV message on port SPI
  static final Uint32 NMEA_ID_GSV_SPI = 0x209100c8 as Uint32;

  /// Output rate of the NMEA-GX-GSV message on port UART1
  static final Uint32 NMEA_ID_GSV_UART1 = 0x209100c5 as Uint32;

  /// Output rate of the NMEA-GX-GSV message on port UART2
  static final Uint32 NMEA_ID_GSV_UART2 = 0x209100c6 as Uint32;

  /// Output rate of the NMEA-GX-GSV message on port USB
  static final Uint32 NMEA_ID_GSV_USB = 0x209100c7 as Uint32;

  /// Output rate of the NMEA-GX-RLM message on port I2C
  static final Uint32 NMEA_ID_RLM_I2C = 0x20910400 as Uint32;

  /// Output rate of the NMEA-GX-RLM message on port SPI
  static final Uint32 NMEA_ID_RLM_SPI = 0x20910404 as Uint32;

  /// Output rate of the NMEA-GX-RLM message on port UART1
  static final Uint32 NMEA_ID_RLM_UART1 = 0x20910401 as Uint32;

  /// Output rate of the NMEA-GX-RLM message on port UART2
  static final Uint32 NMEA_ID_RLM_UART2 = 0x20910402 as Uint32;

  /// Output rate of the NMEA-GX-RLM message on port USB
  static final Uint32 NMEA_ID_RLM_USB = 0x20910403 as Uint32;

  /// Output rate of the NMEA-GX-RMC message on port I2C
  static final Uint32 NMEA_ID_RMC_I2C = 0x209100ab as Uint32;

  /// Output rate of the NMEA-GX-RMC message on port SPI
  static final Uint32 NMEA_ID_RMC_SPI = 0x209100af as Uint32;

  /// Output rate of the NMEA-GX-RMC message on port UART1
  static final Uint32 NMEA_ID_RMC_UART1 = 0x209100ac as Uint32;

  /// Output rate of the NMEA-GX-RMC message on port UART2
  static final Uint32 NMEA_ID_RMC_UART2 = 0x209100ad as Uint32;

  /// Output rate of the NMEA-GX-RMC message on port USB
  static final Uint32 NMEA_ID_RMC_USB = 0x209100ae as Uint32;

  /// Output rate of the NMEA-GX-VLW message on port I2C
  static final Uint32 NMEA_ID_VLW_I2C = 0x209100e7 as Uint32;

  /// Output rate of the NMEA-GX-VLW message on port SPI
  static final Uint32 NMEA_ID_VLW_SPI = 0x209100eb as Uint32;

  /// Output rate of the NMEA-GX-VLW message on port UART1
  static final Uint32 NMEA_ID_VLW_UART1 = 0x209100e8 as Uint32;

  /// Output rate of the NMEA-GX-VLW message on port UART2
  static final Uint32 NMEA_ID_VLW_UART2 = 0x209100e9 as Uint32;

  /// Output rate of the NMEA-GX-VLW message on port USB
  static final Uint32 NMEA_ID_VLW_USB = 0x209100ea as Uint32;

  /// Output rate of the NMEA-GX-VTG message on port I2C
  static final Uint32 NMEA_ID_VTG_I2C = 0x209100b0 as Uint32;

  /// Output rate of the NMEA-GX-VTG message on port SPI
  static final Uint32 NMEA_ID_VTG_SPI = 0x209100b4 as Uint32;

  /// Output rate of the NMEA-GX-VTG message on port UART1
  static final Uint32 NMEA_ID_VTG_UART1 = 0x209100b1 as Uint32;

  /// Output rate of the NMEA-GX-VTG message on port UART2
  static final Uint32 NMEA_ID_VTG_UART2 = 0x209100b2 as Uint32;

  /// Output rate of the NMEA-GX-VTG message on port USB
  static final Uint32 NMEA_ID_VTG_USB = 0x209100b3 as Uint32;

  /// Output rate of the NMEA-GX-ZDA message on port I2C
  static final Uint32 NMEA_ID_ZDA_I2C = 0x209100d8 as Uint32;

  /// Output rate of the NMEA-GX-ZDA message on port SPI
  static final Uint32 NMEA_ID_ZDA_SPI = 0x209100dc as Uint32;

  /// Output rate of the NMEA-GX-ZDA message on port UART1
  static final Uint32 NMEA_ID_ZDA_UART1 = 0x209100d9 as Uint32;

  /// Output rate of the NMEA-GX-ZDA message on port UART2
  static final Uint32 NMEA_ID_ZDA_UART2 = 0x209100da as Uint32;

  /// Output rate of the NMEA-GX-ZDA message on port USB
  static final Uint32 NMEA_ID_ZDA_USB = 0x209100db as Uint32;

  /// Output rate of the NMEA-GX-PUBX00 message on port I2C
  static final Uint32 PUBX_ID_POLYP_I2C = 0x209100ec as Uint32;

  /// Output rate of the NMEA-GX-PUBX00 message on port SPI
  static final Uint32 PUBX_ID_POLYP_SPI = 0x209100f0 as Uint32;

  /// Output rate of the NMEA-GX-PUBX00 message on port UART1
  static final Uint32 PUBX_ID_POLYP_UART1 = 0x209100ed as Uint32;

  /// Output rate of the NMEA-GX-PUBX00 message on port UART2
  static final Uint32 PUBX_ID_POLYP_UART2 = 0x209100ee as Uint32;

  /// Output rate of the NMEA-GX-PUBX00 message on port USB
  static final Uint32 PUBX_ID_POLYP_USB = 0x209100ef as Uint32;

  /// Output rate of the NMEA-GX-PUBX03 message on port I2C
  static final Uint32 PUBX_ID_POLYS_I2C = 0x209100f1 as Uint32;

  /// Output rate of the NMEA-GX-PUBX03 message on port SPI
  static final Uint32 PUBX_ID_POLYS_SPI = 0x209100f5 as Uint32;

  /// Output rate of the NMEA-GX-PUBX03 message on port UART1
  static final Uint32 PUBX_ID_POLYS_UART1 = 0x209100f2 as Uint32;

  /// Output rate of the NMEA-GX-PUBX03 message on port UART2
  static final Uint32 PUBX_ID_POLYS_UART2 = 0x209100f3 as Uint32;

  /// Output rate of the NMEA-GX-PUBX03 message on port USB
  static final Uint32 PUBX_ID_POLYS_USB = 0x209100f4 as Uint32;

  /// Output rate of the NMEA-GX-PUBX04 message on port I2C
  static final Uint32 PUBX_ID_POLYT_I2C = 0x209100f6 as Uint32;

  /// Output rate of the NMEA-GX-PUBX04 message on port SPI
  static final Uint32 PUBX_ID_POLYT_SPI = 0x209100fa as Uint32;

  /// Output rate of the NMEA-GX-PUBX04 message on port UART1
  static final Uint32 PUBX_ID_POLYT_UART1 = 0x209100f7 as Uint32;

  /// Output rate of the NMEA-GX-PUBX04 message on port UART2
  static final Uint32 PUBX_ID_POLYT_UART2 = 0x209100f8 as Uint32;

  /// Output rate of the NMEA-GX-PUBX04 message on port USB
  static final Uint32 PUBX_ID_POLYT_USB = 0x209100f9 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1005 message on port I2C
  static final Uint32 RTCM_3X_TYPE1005_I2C = 0x209102bd as Uint32;

  /// Output rate of the RTCM-3X-TYPE1005 message on port SPI
  static final Uint32 RTCM_3X_TYPE1005_SPI = 0x209102c1 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1005 message on port UART1
  static final Uint32 RTCM_3X_TYPE1005_UART1 = 0x209102be as Uint32;

  /// Output rate of the RTCM-3X-TYPE1005 message on port UART2
  static final Uint32 RTCM_3X_TYPE1005_UART2 = 0x209102bf as Uint32;

  /// Output rate of the RTCM-3X-TYPE1005 message on port USB
  static final Uint32 RTCM_3X_TYPE1005_USB = 0x209102c0 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1074 message on port I2C
  static final Uint32 RTCM_3X_TYPE1074_I2C = 0x2091035e as Uint32;

  /// Output rate of the RTCM-3X-TYPE1074 message on port SPI
  static final Uint32 RTCM_3X_TYPE1074_SPI = 0x20910362 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1074 message on port UART1
  static final Uint32 RTCM_3X_TYPE1074_UART1 = 0x2091035f as Uint32;

  /// Output rate of the RTCM-3X-TYPE1074 message on port UART2
  static final Uint32 RTCM_3X_TYPE1074_UART2 = 0x20910360 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1074 message on port USB
  static final Uint32 RTCM_3X_TYPE1074_USB = 0x20910361 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1077 message on port I2C
  static final Uint32 RTCM_3X_TYPE1077_I2C = 0x209102cc as Uint32;

  /// Output rate of the RTCM-3X-TYPE1077 message on port SPI
  static final Uint32 RTCM_3X_TYPE1077_SPI = 0x209102d0 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1077 message on port UART1
  static final Uint32 RTCM_3X_TYPE1077_UART1 = 0x209102cd as Uint32;

  /// Output rate of the RTCM-3X-TYPE1077 message on port UART2
  static final Uint32 RTCM_3X_TYPE1077_UART2 = 0x209102ce as Uint32;

  /// Output rate of the RTCM-3X-TYPE1077 message on port USB
  static final Uint32 RTCM_3X_TYPE1077_USB = 0x209102cf as Uint32;

  /// Output rate of the RTCM-3X-TYPE1084 message on port I2C
  static final Uint32 RTCM_3X_TYPE1084_I2C = 0x20910363 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1084 message on port SPI
  static final Uint32 RTCM_3X_TYPE1084_SPI = 0x20910367 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1084 message on port UART1
  static final Uint32 RTCM_3X_TYPE1084_UART1 = 0x20910364 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1084 message on port UART2
  static final Uint32 RTCM_3X_TYPE1084_UART2 = 0x20910365 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1084 message on port USB
  static final Uint32 RTCM_3X_TYPE1084_USB = 0x20910366 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1087 message on port I2C
  static final Uint32 RTCM_3X_TYPE1087_I2C = 0x209102d1 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1087 message on port SPI
  static final Uint32 RTCM_3X_TYPE1087_SPI = 0x209102d5 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1087 message on port UART1
  static final Uint32 RTCM_3X_TYPE1087_UART1 = 0x209102d2 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1087 message on port UART2
  static final Uint32 RTCM_3X_TYPE1087_UART2 = 0x209102d3 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1087 message on port USB
  static final Uint32 RTCM_3X_TYPE1087_USB = 0x209102d4 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1094 message on port I2C
  static final Uint32 RTCM_3X_TYPE1094_I2C = 0x20910368 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1094 message on port SPI
  static final Uint32 RTCM_3X_TYPE1094_SPI = 0x2091036c as Uint32;

  /// Output rate of the RTCM-3X-TYPE1094 message on port UART1
  static final Uint32 RTCM_3X_TYPE1094_UART1 = 0x20910369 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1094 message on port UART2
  static final Uint32 RTCM_3X_TYPE1094_UART2 = 0x2091036a as Uint32;

  /// Output rate of the RTCM-3X-TYPE1094 message on port USB
  static final Uint32 RTCM_3X_TYPE1094_USB = 0x2091036b as Uint32;

  /// Output rate of the RTCM-3X-TYPE1097 message on port I2C
  static final Uint32 RTCM_3X_TYPE1097_I2C = 0x20910318 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1097 message on port SPI
  static final Uint32 RTCM_3X_TYPE1097_SPI = 0x2091031c as Uint32;

  /// Output rate of the RTCM-3X-TYPE1097 message on port UART1
  static final Uint32 RTCM_3X_TYPE1097_UART1 = 0x20910319 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1097 message on port UART2
  static final Uint32 RTCM_3X_TYPE1097_UART2 = 0x2091031a as Uint32;

  /// Output rate of the RTCM-3X-TYPE1097 message on port USB
  static final Uint32 RTCM_3X_TYPE1097_USB = 0x2091031b as Uint32;

  /// Output rate of the RTCM-3X-TYPE1124 message on port I2C
  static final Uint32 RTCM_3X_TYPE1124_I2C = 0x2091036d as Uint32;

  /// Output rate of the RTCM-3X-TYPE1124 message on port SPI
  static final Uint32 RTCM_3X_TYPE1124_SPI = 0x20910371 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1124 message on port UART1
  static final Uint32 RTCM_3X_TYPE1124_UART1 = 0x2091036e as Uint32;

  /// Output rate of the RTCM-3X-TYPE1124 message on port UART2
  static final Uint32 RTCM_3X_TYPE1124_UART2 = 0x2091036f as Uint32;

  /// Output rate of the RTCM-3X-TYPE1124 message on port USB
  static final Uint32 RTCM_3X_TYPE1124_USB = 0x20910370 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1127 message on port I2C
  static final Uint32 RTCM_3X_TYPE1127_I2C = 0x209102d6 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1127 message on port SPI
  static final Uint32 RTCM_3X_TYPE1127_SPI = 0x209102da as Uint32;

  /// Output rate of the RTCM-3X-TYPE1127 message on port UART1
  static final Uint32 RTCM_3X_TYPE1127_UART1 = 0x209102d7 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1127 message on port UART2
  static final Uint32 RTCM_3X_TYPE1127_UART2 = 0x209102d8 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1127 message on port USB
  static final Uint32 RTCM_3X_TYPE1127_USB = 0x209102d9 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1230 message on port I2C
  static final Uint32 RTCM_3X_TYPE1230_I2C = 0x20910303 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1230 message on port SPI
  static final Uint32 RTCM_3X_TYPE1230_SPI = 0x20910307 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1230 message on port UART1
  static final Uint32 RTCM_3X_TYPE1230_UART1 = 0x20910304 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1230 message on port UART2
  static final Uint32 RTCM_3X_TYPE1230_UART2 = 0x20910305 as Uint32;

  /// Output rate of the RTCM-3X-TYPE1230 message on port USB
  static final Uint32 RTCM_3X_TYPE1230_USB = 0x20910306 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_0 message on port I2C
  static final Uint32 RTCM_3X_TYPE4072_0_I2C = 0x209102fe as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_0 message on port SPI
  static final Uint32 RTCM_3X_TYPE4072_0_SPI = 0x20910302 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_0 message on port UART1
  static final Uint32 RTCM_3X_TYPE4072_0_UART1 = 0x209102ff as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_0 message on port UART2
  static final Uint32 RTCM_3X_TYPE4072_0_UART2 = 0x20910300 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_0 message on port USB
  static final Uint32 RTCM_3X_TYPE4072_0_USB = 0x20910301 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_1 message on port I2C
  static final Uint32 RTCM_3X_TYPE4072_1_I2C = 0x20910381 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_1 message on port SPI
  static final Uint32 RTCM_3X_TYPE4072_1_SPI = 0x20910385 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_1 message on port UART1
  static final Uint32 RTCM_3X_TYPE4072_1_UART1 = 0x20910382 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_1 message on port UART2
  static final Uint32 RTCM_3X_TYPE4072_1_UART2 = 0x20910383 as Uint32;

  /// Output rate of the RTCM-3X-TYPE4072_1 message on port USB
  static final Uint32 RTCM_3X_TYPE4072_1_USB = 0x20910384 as Uint32;

  /// Output rate of the UBX-LOG-INFO message on port I2C
  static final Uint32 UBX_LOG_INFO_I2C = 0x20910259 as Uint32;

  /// Output rate of the UBX-LOG-INFO message on port SPI
  static final Uint32 UBX_LOG_INFO_SPI = 0x2091025d as Uint32;

  /// Output rate of the UBX-LOG-INFO message on port UART1
  static final Uint32 UBX_LOG_INFO_UART1 = 0x2091025a as Uint32;

  /// Output rate of the UBX-LOG-INFO message on port UART2
  static final Uint32 UBX_LOG_INFO_UART2 = 0x2091025b as Uint32;

  /// Output rate of the UBX-LOG-INFO message on port USB
  static final Uint32 UBX_LOG_INFO_USB = 0x2091025c as Uint32;

  /// Output rate of the UBX-MON-COMMS message on port I2C
  static final Uint32 UBX_MON_COMMS_I2C = 0x2091034f as Uint32;

  /// Output rate of the UBX-MON-COMMS message on port SPI
  static final Uint32 UBX_MON_COMMS_SPI = 0x20910353 as Uint32;

  /// Output rate of the UBX-MON-COMMS message on port UART1
  static final Uint32 UBX_MON_COMMS_UART1 = 0x20910350 as Uint32;

  /// Output rate of the UBX-MON-COMMS message on port UART2
  static final Uint32 UBX_MON_COMMS_UART2 = 0x20910351 as Uint32;

  /// Output rate of the UBX-MON-COMMS message on port USB
  static final Uint32 UBX_MON_COMMS_USB = 0x20910352 as Uint32;

  /// Output rate of the UBX-MON-HW2 message on port I2C
  static final Uint32 UBX_MON_HW2_I2C = 0x209101b9 as Uint32;

  /// Output rate of the UBX-MON-HW2 message on port SPI
  static final Uint32 UBX_MON_HW2_SPI = 0x209101bd as Uint32;

  /// Output rate of the UBX-MON-HW2 message on port UART1
  static final Uint32 UBX_MON_HW2_UART1 = 0x209101ba as Uint32;

  /// Output rate of the UBX-MON-HW2 message on port UART2
  static final Uint32 UBX_MON_HW2_UART2 = 0x209101bb as Uint32;

  /// Output rate of the UBX-MON-HW2 message on port USB
  static final Uint32 UBX_MON_HW2_USB = 0x209101bc as Uint32;

  /// Output rate of the UBX-MON-HW3 message on port I2C
  static final Uint32 UBX_MON_HW3_I2C = 0x20910354 as Uint32;

  /// Output rate of the UBX-MON-HW3 message on port SPI
  static final Uint32 UBX_MON_HW3_SPI = 0x20910358 as Uint32;

  /// Output rate of the UBX-MON-HW3 message on port UART1
  static final Uint32 UBX_MON_HW3_UART1 = 0x20910355 as Uint32;

  /// Output rate of the UBX-MON-HW3 message on port UART2
  static final Uint32 UBX_MON_HW3_UART2 = 0x20910356 as Uint32;

  /// Output rate of the UBX-MON-HW3 message on port USB
  static final Uint32 UBX_MON_HW3_USB = 0x20910357 as Uint32;

  /// Output rate of the UBX-MON-HW message on port I2C
  static final Uint32 UBX_MON_HW_I2C = 0x209101b4 as Uint32;

  /// Output rate of the UBX-MON-HW message on port SPI
  static final Uint32 UBX_MON_HW_SPI = 0x209101b8 as Uint32;

  /// Output rate of the UBX-MON-HW message on port UART1
  static final Uint32 UBX_MON_HW_UART1 = 0x209101b5 as Uint32;

  /// Output rate of the UBX-MON-HW message on port UART2
  static final Uint32 UBX_MON_HW_UART2 = 0x209101b6 as Uint32;

  /// Output rate of the UBX-MON-HW message on port USB
  static final Uint32 UBX_MON_HW_USB = 0x209101b7 as Uint32;

  /// Output rate of the UBX-MON-IO message on port I2C
  static final Uint32 UBX_MON_IO_I2C = 0x209101a5 as Uint32;

  /// Output rate of the UBX-MON-IO message on port SPI
  static final Uint32 UBX_MON_IO_SPI = 0x209101a9 as Uint32;

  /// Output rate of the UBX-MON-IO message on port UART1
  static final Uint32 UBX_MON_IO_UART1 = 0x209101a6 as Uint32;

  /// Output rate of the UBX-MON-IO message on port UART2
  static final Uint32 UBX_MON_IO_UART2 = 0x209101a7 as Uint32;

  /// Output rate of the UBX-MON-IO message on port USB
  static final Uint32 UBX_MON_IO_USB = 0x209101a8 as Uint32;

  /// Output rate of the UBX-MON-MSGPP message on port I2C
  static final Uint32 UBX_MON_MSGPP_I2C = 0x20910196 as Uint32;

  /// Output rate of the UBX-MON-MSGPP message on port SPI
  static final Uint32 UBX_MON_MSGPP_SPI = 0x2091019a as Uint32;

  /// Output rate of the UBX-MON-MSGPP message on port UART1
  static final Uint32 UBX_MON_MSGPP_UART1 = 0x20910197 as Uint32;

  /// Output rate of the UBX-MON-MSGPP message on port UART2
  static final Uint32 UBX_MON_MSGPP_UART2 = 0x20910198 as Uint32;

  /// Output rate of the UBX-MON-MSGPP message on port USB
  static final Uint32 UBX_MON_MSGPP_USB = 0x20910199 as Uint32;

  /// Output rate of the UBX-MON-RF message on port I2C
  static final Uint32 UBX_MON_RF_I2C = 0x20910359 as Uint32;

  /// Output rate of the UBX-MON-RF message on port SPI
  static final Uint32 UBX_MON_RF_SPI = 0x2091035d as Uint32;

  /// Output rate of the UBX-MON-RF message on port UART1
  static final Uint32 UBX_MON_RF_UART1 = 0x2091035a as Uint32;

  /// Output rate of the UBX-MON-RF message on port UART2
  static final Uint32 UBX_MON_RF_UART2 = 0x2091035b as Uint32;

  /// Output rate of the UBX-MON-RF message on port USB
  static final Uint32 UBX_MON_RF_USB = 0x2091035c as Uint32;

  /// Output rate of the UBX-MON-RXBUF message on port I2C
  static final Uint32 UBX_MON_RXBUF_I2C = 0x209101a0 as Uint32;

  /// Output rate of the UBX-MON-RXBUF message on port SPI
  static final Uint32 UBX_MON_RXBUF_SPI = 0x209101a4 as Uint32;

  /// Output rate of the UBX-MON-RXBUF message on port UART1
  static final Uint32 UBX_MON_RXBUF_UART1 = 0x209101a1 as Uint32;

  /// Output rate of the UBX-MON-RXBUF message on port UART2
  static final Uint32 UBX_MON_RXBUF_UART2 = 0x209101a2 as Uint32;

  /// Output rate of the UBX-MON-RXBUF message on port USB
  static final Uint32 UBX_MON_RXBUF_USB = 0x209101a3 as Uint32;

  /// Output rate of the UBX-MON-RXR message on port I2C
  static final Uint32 UBX_MON_RXR_I2C = 0x20910187 as Uint32;

  /// Output rate of the UBX-MON-RXR message on port SPI
  static final Uint32 UBX_MON_RXR_SPI = 0x2091018b as Uint32;

  /// Output rate of the UBX-MON-RXR message on port UART1
  static final Uint32 UBX_MON_RXR_UART1 = 0x20910188 as Uint32;

  /// Output rate of the UBX-MON-RXR message on port UART2
  static final Uint32 UBX_MON_RXR_UART2 = 0x20910189 as Uint32;

  /// Output rate of the UBX-MON-RXR message on port USB
  static final Uint32 UBX_MON_RXR_USB = 0x2091018a as Uint32;

  /// Output rate of the UBX-MON-SPAN message on port I2C
  static final Uint32 UBX_MON_SPAN_I2C = 0x2091038b as Uint32;

  /// Output rate of the UBX-MON-SPAN message on port SPI
  static final Uint32 UBX_MON_SPAN_SPI = 0x2091038f as Uint32;

  /// Output rate of the UBX-MON-SPAN message on port UART1
  static final Uint32 UBX_MON_SPAN_UART1 = 0x2091038c as Uint32;

  /// Output rate of the UBX-MON-SPAN message on port UART2
  static final Uint32 UBX_MON_SPAN_UART2 = 0x2091038d as Uint32;

  /// Output rate of the UBX-MON-SPAN message on port USB
  static final Uint32 UBX_MON_SPAN_USB = 0x2091038e as Uint32;

  /// Output rate of the UBX-MON-SYS message on port I2C
  static final Uint32 UBX_MON_SYS_I2C = 0x2091069d as Uint32;

  /// Output rate of the UBX-MON-SYS message on port SPI
  static final Uint32 UBX_MON_SYS_SPI = 0x209106a1 as Uint32;

  /// Output rate of the UBX-MON-SYS message on port UART1
  static final Uint32 UBX_MON_SYS_UART1 = 0x2091069e as Uint32;

  /// Output rate of the UBX-MON-SYS message on port UART2
  static final Uint32 UBX_MON_SYS_UART2 = 0x2091069f as Uint32;

  /// Output rate of the UBX-MON-SYS message on port USB
  static final Uint32 UBX_MON_SYS_USB = 0x209106a0 as Uint32;

  /// Output rate of the UBX-MON-TXBUF message on port I2C
  static final Uint32 UBX_MON_TXBUF_I2C = 0x2091019b as Uint32;

  /// Output rate of the UBX-MON-TXBUF message on port SPI
  static final Uint32 UBX_MON_TXBUF_SPI = 0x2091019f as Uint32;

  /// Output rate of the UBX-MON-TXBUF message on port UART1
  static final Uint32 UBX_MON_TXBUF_UART1 = 0x2091019c as Uint32;

  /// Output rate of the UBX-MON-TXBUF message on port UART2
  static final Uint32 UBX_MON_TXBUF_UART2 = 0x2091019d as Uint32;

  /// Output rate of the UBX-MON-TXBUF message on port USB
  static final Uint32 UBX_MON_TXBUF_USB = 0x2091019e as Uint32;

  /// Output rate of the UBX_NAV_ATT message on port I2C
  static final Uint32 UBX_NAV_ATT_I2C = 0x2091001f as Uint32;

  /// Output rate of the UBX_NAV_ATT message on port SPI
  static final Uint32 UBX_NAV_ATT_SPI = 0x20910023 as Uint32;

  /// Output rate of the UBX_NAV_ATT message on port UART1
  static final Uint32 UBX_NAV_ATT_UART1 = 0x20910020 as Uint32;

  /// Output rate of the UBX_NAV_ATT message on port UART2
  static final Uint32 UBX_NAV_ATT_UART2 = 0x20910021 as Uint32;

  /// Output rate of the UBX_NAV_ATT message on port USB
  static final Uint32 UBX_NAV_ATT_USB = 0x20910022 as Uint32;

  /// Output rate of the UBX-NAV-CLOCK message on port I2C
  static final Uint32 UBX_NAV_CLOCK_I2C = 0x20910065 as Uint32;

  /// Output rate of the UBX-NAV-CLOCK message on port SPI
  static final Uint32 UBX_NAV_CLOCK_SPI = 0x20910069 as Uint32;

  /// Output rate of the UBX-NAV-CLOCK message on port UART1
  static final Uint32 UBX_NAV_CLOCK_UART1 = 0x20910066 as Uint32;

  /// Output rate of the UBX-NAV-CLOCK message on port UART2
  static final Uint32 UBX_NAV_CLOCK_UART2 = 0x20910067 as Uint32;

  /// Output rate of the UBX-NAV-CLOCK message on port USB
  static final Uint32 UBX_NAV_CLOCK_USB = 0x20910068 as Uint32;

  /// Output rate of the UBX-NAV-DOP message on port I2C
  static final Uint32 UBX_NAV_DOP_I2C = 0x20910038 as Uint32;

  /// Output rate of the UBX-NAV-DOP message on port SPI
  static final Uint32 UBX_NAV_DOP_SPI = 0x2091003c as Uint32;

  /// Output rate of the UBX-NAV-DOP message on port UART1
  static final Uint32 UBX_NAV_DOP_UART1 = 0x20910039 as Uint32;

  /// Output rate of the UBX-NAV-DOP message on port UART2
  static final Uint32 UBX_NAV_DOP_UART2 = 0x2091003a as Uint32;

  /// Output rate of the UBX-NAV-DOP message on port USB
  static final Uint32 UBX_NAV_DOP_USB = 0x2091003b as Uint32;

  /// Output rate of the UBX-NAV-EOE message on port I2C
  static final Uint32 UBX_NAV_EOE_I2C = 0x2091015f as Uint32;

  /// Output rate of the UBX-NAV-EOE message on port SPI
  static final Uint32 UBX_NAV_EOE_SPI = 0x20910163 as Uint32;

  /// Output rate of the UBX-NAV-EOE message on port UART1
  static final Uint32 UBX_NAV_EOE_UART1 = 0x20910160 as Uint32;

  /// Output rate of the UBX-NAV-EOE message on port UART2
  static final Uint32 UBX_NAV_EOE_UART2 = 0x20910161 as Uint32;

  /// Output rate of the UBX-NAV-EOE message on port USB
  static final Uint32 UBX_NAV_EOE_USB = 0x20910162 as Uint32;

  /// Output rate of the UBX-NAV-GEOFENCE message on port I2C
  static final Uint32 UBX_NAV_GEOFENCE_I2C = 0x209100a1 as Uint32;

  /// Output rate of the UBX-NAV-GEOFENCE message on port SPI
  static final Uint32 UBX_NAV_GEOFENCE_SPI = 0x209100a5 as Uint32;

  /// Output rate of the UBX-NAV-GEOFENCE message on port UART1
  static final Uint32 UBX_NAV_GEOFENCE_UART1 = 0x209100a2 as Uint32;

  /// Output rate of the UBX-NAV-GEOFENCE message on port UART2
  static final Uint32 UBX_NAV_GEOFENCE_UART2 = 0x209100a3 as Uint32;

  /// Output rate of the UBX-NAV-GEOFENCE message on port USB
  static final Uint32 UBX_NAV_GEOFENCE_USB = 0x209100a4 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSECEF message on port I2C
  static final Uint32 UBX_NAV_HPPOSECEF_I2C = 0x2091002e as Uint32;

  /// Output rate of the UBX-NAV-HPPOSECEF message on port SPI
  static final Uint32 UBX_NAV_HPPOSECEF_SPI = 0x20910032 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSECEF message on port UART1
  static final Uint32 UBX_NAV_HPPOSECEF_UART1 = 0x2091002f as Uint32;

  /// Output rate of the UBX-NAV-HPPOSECEF message on port UART2
  static final Uint32 UBX_NAV_HPPOSECEF_UART2 = 0x20910030 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSECEF message on port USB
  static final Uint32 UBX_NAV_HPPOSECEF_USB = 0x20910031 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSLLH message on port I2C
  static final Uint32 UBX_NAV_HPPOSLLH_I2C = 0x20910033 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSLLH message on port SPI
  static final Uint32 UBX_NAV_HPPOSLLH_SPI = 0x20910037 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSLLH message on port UART1
  static final Uint32 UBX_NAV_HPPOSLLH_UART1 = 0x20910034 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSLLH message on port UART2
  static final Uint32 UBX_NAV_HPPOSLLH_UART2 = 0x20910035 as Uint32;

  /// Output rate of the UBX-NAV-HPPOSLLH message on port USB
  static final Uint32 UBX_NAV_HPPOSLLH_USB = 0x20910036 as Uint32;

  /// Output rate of the UBX-NAV-ODO message on port I2C
  static final Uint32 UBX_NAV_ODO_I2C = 0x2091007e as Uint32;

  /// Output rate of the UBX-NAV-ODO message on port SPI
  static final Uint32 UBX_NAV_ODO_SPI = 0x20910082 as Uint32;

  /// Output rate of the UBX-NAV-ODO message on port UART1
  static final Uint32 UBX_NAV_ODO_UART1 = 0x2091007f as Uint32;

  /// Output rate of the UBX-NAV-ODO message on port UART2
  static final Uint32 UBX_NAV_ODO_UART2 = 0x20910080 as Uint32;

  /// Output rate of the UBX-NAV-ODO message on port USB
  static final Uint32 UBX_NAV_ODO_USB = 0x20910081 as Uint32;

  /// Output rate of the UBX-NAV-ORB message on port I2C
  static final Uint32 UBX_NAV_ORB_I2C = 0x20910010 as Uint32;

  /// Output rate of the UBX-NAV-ORB message on port SPI
  static final Uint32 UBX_NAV_ORB_SPI = 0x20910014 as Uint32;

  /// Output rate of the UBX-NAV-ORB message on port UART1
  static final Uint32 UBX_NAV_ORB_UART1 = 0x20910011 as Uint32;

  /// Output rate of the UBX-NAV-ORB message on port UART2
  static final Uint32 UBX_NAV_ORB_UART2 = 0x20910012 as Uint32;

  /// Output rate of the UBX-NAV-ORB message on port USB
  static final Uint32 UBX_NAV_ORB_USB = 0x20910013 as Uint32;

  /// Output rate of the UBX-NAV-PL message on port I2C
  static final Uint32 UBX_NAV_PL_I2C = 0x20910415 as Uint32;

  /// Output rate of the UBX-NAV-PL message on port SPI
  static final Uint32 UBX_NAV_PL_SPI = 0x20910419 as Uint32;

  /// Output rate of the UBX-NAV-PL message on port UART1
  static final Uint32 UBX_NAV_PL_UART1 = 0x20910416 as Uint32;

  /// Output rate of the UBX-NAV-PL message on port UART2
  static final Uint32 UBX_NAV_PL_UART2 = 0x20910417 as Uint32;

  /// Output rate of the UBX-NAV-PL message on port USB
  static final Uint32 UBX_NAV_PL_USB = 0x20910418 as Uint32;

  /// Output rate of the UBX-NAV-POSECEF message on port I2C
  static final Uint32 UBX_NAV_POSECEF_I2C = 0x20910024 as Uint32;

  /// Output rate of the UBX-NAV-POSECEF message on port SPI
  static final Uint32 UBX_NAV_POSECEF_SPI = 0x20910028 as Uint32;

  /// Output rate of the UBX-NAV-POSECEF message on port UART1
  static final Uint32 UBX_NAV_POSECEF_UART1 = 0x20910025 as Uint32;

  /// Output rate of the UBX-NAV-POSECEF message on port UART2
  static final Uint32 UBX_NAV_POSECEF_UART2 = 0x20910026 as Uint32;

  /// Output rate of the UBX-NAV-POSECEF message on port USB
  static final Uint32 UBX_NAV_POSECEF_USB = 0x20910027 as Uint32;

  /// Output rate of the UBX-NAV-POSLLH message on port I2C
  static final Uint32 UBX_NAV_POSLLH_I2C = 0x20910029 as Uint32;

  /// Output rate of the UBX-NAV-POSLLH message on port SPI
  static final Uint32 UBX_NAV_POSLLH_SPI = 0x2091002d as Uint32;

  /// Output rate of the UBX-NAV-POSLLH message on port UART1
  static final Uint32 UBX_NAV_POSLLH_UART1 = 0x2091002a as Uint32;

  /// Output rate of the UBX-NAV-POSLLH message on port UART2
  static final Uint32 UBX_NAV_POSLLH_UART2 = 0x2091002b as Uint32;

  /// Output rate of the UBX-NAV-POSLLH message on port USB
  static final Uint32 UBX_NAV_POSLLH_USB = 0x2091002c as Uint32;

  /// Output rate of the UBX-NAV-PVT message on port I2C
  static final Uint32 UBX_NAV_PVT_I2C = 0x20910006 as Uint32;

  /// Output rate of the UBX-NAV-PVT message on port SPI
  static final Uint32 UBX_NAV_PVT_SPI = 0x2091000a as Uint32;

  /// Output rate of the UBX-NAV-PVT message on port UART1
  static final Uint32 UBX_NAV_PVT_UART1 = 0x20910007 as Uint32;

  /// Output rate of the UBX-NAV-PVT message on port UART2
  static final Uint32 UBX_NAV_PVT_UART2 = 0x20910008 as Uint32;

  /// Output rate of the UBX-NAV-PVT message on port USB
  static final Uint32 UBX_NAV_PVT_USB = 0x20910009 as Uint32;

  /// Output rate of the UBX-NAV-RELPOSNED message on port I2C
  static final Uint32 UBX_NAV_RELPOSNED_I2C = 0x2091008d as Uint32;

  /// Output rate of the UBX-NAV-RELPOSNED message on port SPI
  static final Uint32 UBX_NAV_RELPOSNED_SPI = 0x20910091 as Uint32;

  /// Output rate of the UBX-NAV-RELPOSNED message on port UART1
  static final Uint32 UBX_NAV_RELPOSNED_UART1 = 0x2091008e as Uint32;

  /// Output rate of the UBX-NAV-RELPOSNED message on port UART2
  static final Uint32 UBX_NAV_RELPOSNED_UART2 = 0x2091008f as Uint32;

  /// Output rate of the UBX-NAV-RELPOSNED message on port USB
  static final Uint32 UBX_NAV_RELPOSNED_USB = 0x20910090 as Uint32;

  /// Output rate of the UBX-NAV-SAT message on port I2C
  static final Uint32 UBX_NAV_SAT_I2C = 0x20910015 as Uint32;

  /// Output rate of the UBX-NAV-SAT message on port SPI
  static final Uint32 UBX_NAV_SAT_SPI = 0x20910019 as Uint32;

  /// Output rate of the UBX-NAV-SAT message on port UART1
  static final Uint32 UBX_NAV_SAT_UART1 = 0x20910016 as Uint32;

  /// Output rate of the UBX-NAV-SAT message on port UART2
  static final Uint32 UBX_NAV_SAT_UART2 = 0x20910017 as Uint32;

  /// Output rate of the UBX-NAV-SAT message on port USB
  static final Uint32 UBX_NAV_SAT_USB = 0x20910018 as Uint32;

  /// Output rate of the UBX-NAV-SBAS message on port I2C
  static final Uint32 UBX_NAV_SBAS_I2C = 0x2091006a as Uint32;

  /// Output rate of the UBX-NAV-SBAS message on port SPI
  static final Uint32 UBX_NAV_SBAS_SPI = 0x2091006e as Uint32;

  /// Output rate of the UBX-NAV-SBAS message on port UART1
  static final Uint32 UBX_NAV_SBAS_UART1 = 0x2091006b as Uint32;

  /// Output rate of the UBX-NAV-SBAS message on port UART2
  static final Uint32 UBX_NAV_SBAS_UART2 = 0x2091006c as Uint32;

  /// Output rate of the UBX-NAV-SBAS message on port USB
  static final Uint32 UBX_NAV_SBAS_USB = 0x2091006d as Uint32;

  /// Output rate of the UBX-NAV-SIG message on port I2C
  static final Uint32 UBX_NAV_SIG_I2C = 0x20910345 as Uint32;

  /// Output rate of the UBX-NAV-SIG message on port SPI
  static final Uint32 UBX_NAV_SIG_SPI = 0x20910349 as Uint32;

  /// Output rate of the UBX-NAV-SIG message on port UART1
  static final Uint32 UBX_NAV_SIG_UART1 = 0x20910346 as Uint32;

  /// Output rate of the UBX-NAV-SIG message on port UART2
  static final Uint32 UBX_NAV_SIG_UART2 = 0x20910347 as Uint32;

  /// Output rate of the UBX-NAV-SIG message on port USB
  static final Uint32 UBX_NAV_SIG_USB = 0x20910348 as Uint32;

  /// Output rate of the UBX-NAV-SLAS message on port I2C
  static final Uint32 UBX_NAV_SLAS_I2C = 0x20910336 as Uint32;

  /// Output rate of the UBX-NAV-SLAS message on port SPI
  static final Uint32 UBX_NAV_SLAS_SPI = 0x2091033a as Uint32;

  /// Output rate of the UBX-NAV-SLAS message on port UART1
  static final Uint32 UBX_NAV_SLAS_UART1 = 0x20910337 as Uint32;

  /// Output rate of the UBX-NAV-SLAS message on port UART2
  static final Uint32 UBX_NAV_SLAS_UART2 = 0x20910338 as Uint32;

  /// Output rate of the UBX-NAV-SLAS message on port USB
  static final Uint32 UBX_NAV_SLAS_USB = 0x20910339 as Uint32;

  /// Output rate of the UBX-NAV-STATUS message on port I2C
  static final Uint32 UBX_NAV_STATUS_I2C = 0x2091001a as Uint32;

  /// Output rate of the UBX-NAV-STATUS message on port SPI
  static final Uint32 UBX_NAV_STATUS_SPI = 0x2091001e as Uint32;

  /// Output rate of the UBX-NAV-STATUS message on port UART1
  static final Uint32 UBX_NAV_STATUS_UART1 = 0x2091001b as Uint32;

  /// Output rate of the UBX-NAV-STATUS message on port UART2
  static final Uint32 UBX_NAV_STATUS_UART2 = 0x2091001c as Uint32;

  /// Output rate of the UBX-NAV-STATUS message on port USB
  static final Uint32 UBX_NAV_STATUS_USB = 0x2091001d as Uint32;

  /// Output rate of the UBX-NAV-SVIN message on port I2C
  static final Uint32 UBX_NAV_SVIN_I2C = 0x20910088 as Uint32;

  /// Output rate of the UBX-NAV-SVIN message on port SPI
  static final Uint32 UBX_NAV_SVIN_SPI = 0x2091008c as Uint32;

  /// Output rate of the UBX-NAV-SVIN message on port UART1
  static final Uint32 UBX_NAV_SVIN_UART1 = 0x20910089 as Uint32;

  /// Output rate of the UBX-NAV-SVIN message on port UART2
  static final Uint32 UBX_NAV_SVIN_UART2 = 0x2091008a as Uint32;

  /// Output rate of the UBX-NAV-SVIN message on port USB
  static final Uint32 UBX_NAV_SVIN_USB = 0x2091008b as Uint32;

  /// Output rate of the UBX-NAV-TIMEBDS message on port I2C
  static final Uint32 UBX_NAV_TIMEBDS_I2C = 0x20910051 as Uint32;

  /// Output rate of the UBX-NAV-TIMEBDS message on port SPI
  static final Uint32 UBX_NAV_TIMEBDS_SPI = 0x20910055 as Uint32;

  /// Output rate of the UBX-NAV-TIMEBDS message on port UART1
  static final Uint32 UBX_NAV_TIMEBDS_UART1 = 0x20910052 as Uint32;

  /// Output rate of the UBX-NAV-TIMEBDS message on port UART2
  static final Uint32 UBX_NAV_TIMEBDS_UART2 = 0x20910053 as Uint32;

  /// Output rate of the UBX-NAV-TIMEBDS message on port USB
  static final Uint32 UBX_NAV_TIMEBDS_USB = 0x20910054 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGAL message on port I2C
  static final Uint32 UBX_NAV_TIMEGAL_I2C = 0x20910056 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGAL message on port SPI
  static final Uint32 UBX_NAV_TIMEGAL_SPI = 0x2091005a as Uint32;

  /// Output rate of the UBX-NAV-TIMEGAL message on port UART1
  static final Uint32 UBX_NAV_TIMEGAL_UART1 = 0x20910057 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGAL message on port UART2
  static final Uint32 UBX_NAV_TIMEGAL_UART2 = 0x20910058 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGAL message on port USB
  static final Uint32 UBX_NAV_TIMEGAL_USB = 0x20910059 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGLO message on port I2C
  static final Uint32 UBX_NAV_TIMEGLO_I2C = 0x2091004c as Uint32;

  /// Output rate of the UBX-NAV-TIMEGLO message on port SPI
  static final Uint32 UBX_NAV_TIMEGLO_SPI = 0x20910050 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGLO message on port UART1
  static final Uint32 UBX_NAV_TIMEGLO_UART1 = 0x2091004d as Uint32;

  /// Output rate of the UBX-NAV-TIMEGLO message on port UART2
  static final Uint32 UBX_NAV_TIMEGLO_UART2 = 0x2091004e as Uint32;

  /// Output rate of the UBX-NAV-TIMEGLO message on port USB
  static final Uint32 UBX_NAV_TIMEGLO_USB = 0x2091004f as Uint32;

  /// Output rate of the UBX-NAV-TIMEGPS message on port I2C
  static final Uint32 UBX_NAV_TIMEGPS_I2C = 0x20910047 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGPS message on port SPI
  static final Uint32 UBX_NAV_TIMEGPS_SPI = 0x2091004b as Uint32;

  /// Output rate of the UBX-NAV-TIMEGPS message on port UART1
  static final Uint32 UBX_NAV_TIMEGPS_UART1 = 0x20910048 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGPS message on port UART2
  static final Uint32 UBX_NAV_TIMEGPS_UART2 = 0x20910049 as Uint32;

  /// Output rate of the UBX-NAV-TIMEGPS message on port USB
  static final Uint32 UBX_NAV_TIMEGPS_USB = 0x2091004a as Uint32;

  /// Output rate of the UBX-NAV-TIMELS message on port I2C
  static final Uint32 UBX_NAV_TIMELS_I2C = 0x20910060 as Uint32;

  /// Output rate of the UBX-NAV-TIMELS message on port SPI
  static final Uint32 UBX_NAV_TIMELS_SPI = 0x20910064 as Uint32;

  /// Output rate of the UBX-NAV-TIMELS message on port UART1
  static final Uint32 UBX_NAV_TIMELS_UART1 = 0x20910061 as Uint32;

  /// Output rate of the UBX-NAV-TIMELS message on port UART2
  static final Uint32 UBX_NAV_TIMELS_UART2 = 0x20910062 as Uint32;

  /// Output rate of the UBX-NAV-TIMELS message on port USB
  static final Uint32 UBX_NAV_TIMELS_USB = 0x20910063 as Uint32;

  /// Output rate of the UBX-NAV-TIMEQZSSmessage on port I2C
  static final Uint32 UBX_NAV_TIMEQZSS_I2C = 0x20910386 as Uint32;

  /// Output rate of the UBX-NAV-TIMEQZSSmessage on port SPI
  static final Uint32 UBX_NAV_TIMEQZSS_SPI = 0x2091038a as Uint32;

  /// Output rate of the UBX-NAV-TIMEQZSSmessage on port UART1
  static final Uint32 UBX_NAV_TIMEQZSS_UART1 = 0x20910387 as Uint32;

  /// Output rate of the UBX-NAV-TIMEQZSSmessage on port UART2
  static final Uint32 UBX_NAV_TIMEQZSS_UART2 = 0x20910388 as Uint32;

  /// Output rate of the UBX-NAV-TIMEQZSSmessage on port USB
  static final Uint32 UBX_NAV_TIMEQZSS_USB = 0x20910389 as Uint32;

  /// Output rate of the UBX-NAV-TIMEUTC message on port I2C
  static final Uint32 UBX_NAV_TIMEUTC_I2C = 0x2091005b as Uint32;

  /// Output rate of the UBX-NAV-TIMEUTC message on port SPI
  static final Uint32 UBX_NAV_TIMEUTC_SPI = 0x2091005f as Uint32;

  /// Output rate of the UBX-NAV-TIMEUTC message on port UART1
  static final Uint32 UBX_NAV_TIMEUTC_UART1 = 0x2091005c as Uint32;

  /// Output rate of the UBX-NAV-TIMEUTC message on port UART2
  static final Uint32 UBX_NAV_TIMEUTC_UART2 = 0x2091005d as Uint32;

  /// Output rate of the UBX-NAV-TIMEUTC message on port USB
  static final Uint32 UBX_NAV_TIMEUTC_USB = 0x2091005e as Uint32;

  /// Output rate of the UBX-NAV-VELECEF message on port I2C
  static final Uint32 UBX_NAV_VELECEF_I2C = 0x2091003d as Uint32;

  /// Output rate of the UBX-NAV-VELECEF message on port SPI
  static final Uint32 UBX_NAV_VELECEF_SPI = 0x20910041 as Uint32;

  /// Output rate of the UBX-NAV-VELECEF message on port UART1
  static final Uint32 UBX_NAV_VELECEF_UART1 = 0x2091003e as Uint32;

  /// Output rate of the UBX-NAV-VELECEF message on port UART2
  static final Uint32 UBX_NAV_VELECEF_UART2 = 0x2091003f as Uint32;

  /// Output rate of the UBX-NAV-VELECEF message on port USB
  static final Uint32 UBX_NAV_VELECEF_USB = 0x20910040 as Uint32;

  /// Output rate of the UBX-NAV-VELNED message on port I2C
  static final Uint32 UBX_NAV_VELNED_I2C = 0x20910042 as Uint32;

  /// Output rate of the UBX-NAV-VELNED message on port SPI
  static final Uint32 UBX_NAV_VELNED_SPI = 0x20910046 as Uint32;

  /// Output rate of the UBX-NAV-VELNED message on port UART1
  static final Uint32 UBX_NAV_VELNED_UART1 = 0x20910043 as Uint32;

  /// Output rate of the UBX-NAV-VELNED message on port UART2
  static final Uint32 UBX_NAV_VELNED_UART2 = 0x20910044 as Uint32;

  /// Output rate of the UBX-NAV-VELNED message on port USB
  static final Uint32 UBX_NAV_VELNED_USB = 0x20910045 as Uint32;

  /// Output rate of the UBX-RXM-COR message on port I2C
  static final Uint32 UBX_RXM_COR_I2C = 0x209106b6 as Uint32;

  /// Output rate of the UBX-RXM-COR message on port SPI
  static final Uint32 UBX_RXM_COR_SPI = 0x209106ba as Uint32;

  /// Output rate of the UBX-RXM-COR message on port UART1
  static final Uint32 UBX_RXM_COR_UART1 = 0x209106b7 as Uint32;

  /// Output rate of the UBX-RXM-COR message on port UART2
  static final Uint32 UBX_RXM_COR_UART2 = 0x209106b8 as Uint32;

  /// Output rate of the UBX-RXM-COR message on port USB
  static final Uint32 UBX_RXM_COR_USB = 0x209106b9 as Uint32;

  /// Output rate of the UBX-RXM-MEASX message on port I2C
  static final Uint32 UBX_RXM_MEASX_I2C = 0x20910204 as Uint32;

  /// Output rate of the UBX-RXM-MEASX message on port SPI
  static final Uint32 UBX_RXM_MEASX_SPI = 0x20910208 as Uint32;

  /// Output rate of the UBX-RXM-MEASX message on port UART1
  static final Uint32 UBX_RXM_MEASX_UART1 = 0x20910205 as Uint32;

  /// Output rate of the UBX-RXM-MEASX message on port UART2
  static final Uint32 UBX_RXM_MEASX_UART2 = 0x20910206 as Uint32;

  /// Output rate of the UBX-RXM-MEASX message on port USB
  static final Uint32 UBX_RXM_MEASX_USB = 0x20910207 as Uint32;

  /// Output rate of the UBX-RXM-RAWX message on port I2C
  static final Uint32 UBX_RXM_RAWX_I2C = 0x209102a4 as Uint32;

  /// Output rate of the UBX-RXM-RAWX message on port SPI
  static final Uint32 UBX_RXM_RAWX_SPI = 0x209102a8 as Uint32;

  /// Output rate of the UBX-RXM-RAWX message on port UART1
  static final Uint32 UBX_RXM_RAWX_UART1 = 0x209102a5 as Uint32;

  /// Output rate of the UBX-RXM-RAWX message on port UART2
  static final Uint32 UBX_RXM_RAWX_UART2 = 0x209102a6 as Uint32;

  /// Output rate of the UBX-RXM-RAWX message on port USB
  static final Uint32 UBX_RXM_RAWX_USB = 0x209102a7 as Uint32;

  /// Output rate of the UBX-RXM-RLM message on port I2C
  static final Uint32 UBX_RXM_RLM_I2C = 0x2091025e as Uint32;

  /// Output rate of the UBX-RXM-RLM message on port SPI
  static final Uint32 UBX_RXM_RLM_SPI = 0x20910262 as Uint32;

  /// Output rate of the UBX-RXM-RLM message on port UART1
  static final Uint32 UBX_RXM_RLM_UART1 = 0x2091025f as Uint32;

  /// Output rate of the UBX-RXM-RLM message on port UART2
  static final Uint32 UBX_RXM_RLM_UART2 = 0x20910260 as Uint32;

  /// Output rate of the UBX-RXM-RLM message on port USB
  static final Uint32 UBX_RXM_RLM_USB = 0x20910261 as Uint32;

  /// Output rate of the UBX-RXM-RTCM message on port I2C
  static final Uint32 UBX_RXM_RTCM_I2C = 0x20910268 as Uint32;

  /// Output rate of the UBX-RXM-RTCM message on port SPI
  static final Uint32 UBX_RXM_RTCM_SPI = 0x2091026c as Uint32;

  /// Output rate of the UBX-RXM-RTCM message on port UART1
  static final Uint32 UBX_RXM_RTCM_UART1 = 0x20910269 as Uint32;

  /// Output rate of the UBX-RXM-RTCM message on port UART2
  static final Uint32 UBX_RXM_RTCM_UART2 = 0x2091026a as Uint32;

  /// Output rate of the UBX-RXM-RTCM message on port USB
  static final Uint32 UBX_RXM_RTCM_USB = 0x2091026b as Uint32;

  /// Output rate of the UBX-RXM-SFRBX message on port I2C
  static final Uint32 UBX_RXM_SFRBX_I2C = 0x20910231 as Uint32;

  /// Output rate of the UBX-RXM-SFRBX message on port SPI
  static final Uint32 UBX_RXM_SFRBX_SPI = 0x20910235 as Uint32;

  /// Output rate of the UBX-RXM-SFRBX message on port UART1
  static final Uint32 UBX_RXM_SFRBX_UART1 = 0x20910232 as Uint32;

  /// Output rate of the UBX-RXM-SFRBX message on port UART2
  static final Uint32 UBX_RXM_SFRBX_UART2 = 0x20910233 as Uint32;

  /// Output rate of the UBX-RXM-SFRBX message on port USB
  static final Uint32 UBX_RXM_SFRBX_USB = 0x20910234 as Uint32;

  /// Output rate of the UBX-RXM-SPARTN message on port I2C
  static final Uint32 UBX_RXM_SPARTN_I2C = 0x20910605 as Uint32;

  /// Output rate of the UBX-RXM-SPARTN message on port UART1
  static final Uint32 UBX_RXM_SPARTN_UART1 = 0x20910606 as Uint32;

  /// Output rate of the UBX-RXM-SPARTN message on port UART2
  static final Uint32 UBX_RXM_SPARTN_UART2 = 0x20910607 as Uint32;

  /// Output rate of the UBX-RXM-SPARTN message on port USB
  static final Uint32 UBX_RXM_SPARTN_USB = 0x20910608 as Uint32;

  /// Output rate of the UBX-RXM-SPARTN message on port SPI
  static final Uint32 UBX_RXM_SPARTN_SPI = 0x20910609 as Uint32;

  /// Output rate of the UBX-SEC-SIG message on port I2C
  static final Uint32 UBX_SEC_SIG_I2C = 0x20910634 as Uint32;

  /// Output rate of the UBX-SEC-SIG message on port SPI
  static final Uint32 UBX_SEC_SIG_SPI = 0x20910638 as Uint32;

  /// Output rate of the UBX-SEC-SIG message on port UART1
  static final Uint32 UBX_SEC_SIG_UART1 = 0x20910635 as Uint32;

  /// Output rate of the UBX-SEC-SIG message on port UART2
  static final Uint32 UBX_SEC_SIG_UART2 = 0x20910636 as Uint32;

  /// Output rate of the UBX-SEC-SIG message on port USB
  static final Uint32 UBX_SEC_SIG_USB = 0x20910637 as Uint32;

  /// Output rate of the UBX-TIM-TM2 message on port I2C
  static final Uint32 UBX_TIM_TM2_I2C = 0x20910178 as Uint32;

  /// Output rate of the UBX-TIM-TM2 message on port SPI
  static final Uint32 UBX_TIM_TM2_SPI = 0x2091017c as Uint32;

  /// Output rate of the UBX-TIM-TM2 message on port UART1
  static final Uint32 UBX_TIM_TM2_UART1 = 0x20910179 as Uint32;

  /// Output rate of the UBX-TIM-TM2 message on port UART2
  static final Uint32 UBX_TIM_TM2_UART2 = 0x2091017a as Uint32;

  /// Output rate of the UBX-TIM-TM2 message on port USB
  static final Uint32 UBX_TIM_TM2_USB = 0x2091017b as Uint32;

  /// Output rate of the UBX-TIM-TP message on port I2C
  static final Uint32 UBX_TIM_TP_I2C = 0x2091017d as Uint32;

  /// Output rate of the UBX-TIM-TP message on port SPI
  static final Uint32 UBX_TIM_TP_SPI = 0x20910181 as Uint32;

  /// Output rate of the UBX-TIM-TP message on port UART1
  static final Uint32 UBX_TIM_TP_UART1 = 0x2091017e as Uint32;

  /// Output rate of the UBX-TIM-TP message on port UART2
  static final Uint32 UBX_TIM_TP_UART2 = 0x2091017f as Uint32;

  /// Output rate of the UBX-TIM-TP message on port USB
  static final Uint32 UBX_TIM_TP_USB = 0x20910180 as Uint32;

  /// Output rate of the UBX-TIM-VRFY message on port I2C
  static final Uint32 UBX_TIM_VRFY_I2C = 0x20910092 as Uint32;

  /// Output rate of the UBX-TIM-VRFY message on port SPI
  static final Uint32 UBX_TIM_VRFY_SPI = 0x20910096 as Uint32;

  /// Output rate of the UBX-TIM-VRFY message on port UART1
  static final Uint32 UBX_TIM_VRFY_UART1 = 0x20910093 as Uint32;

  /// Output rate of the UBX-TIM-VRFY message on port UART2
  static final Uint32 UBX_TIM_VRFY_UART2 = 0x20910094 as Uint32;

  /// Output rate of the UBX-TIM-VRFY message on port USB
  static final Uint32 UBX_TIM_VRFY_USB = 0x20910095 as Uint32;
}
