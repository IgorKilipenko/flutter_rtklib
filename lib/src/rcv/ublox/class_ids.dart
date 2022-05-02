const ClassIds = const {
    'NAV': 0x01,
    'RXM': 0x02,
    'INF': 0x04,
    'ACK': 0x05,
    'CFG': 0x06,
    'UPD': 0x09,
    'MON': 0x0a,
    'TIM': 0x0d,
    'MGA': 0x13, // Multiple GNSS Assistance Messages: Assistance data for various GNSS
    'LOG': 0x21,
    'SEC': 0x27
};

const NavMessageIds = const {
    'CLOCK': 0x22,
    'DOP': 0x04,
    'EOE': 0x61,
    'GEOFENCE': 0x39,
    'HPPOSECEF': 0x13,
    'HPPOSLLH': 0x014,
    'ODO': 0x09,
    'ORB': 0x34,
    'POSECEF': 0x01,
    'POSLLH': 0x02,
    'PVT': 0x07,
    'RELPOSNE': 0x3c,
    'RESETODO': 0x10,
    'SAT': 0x35,
    'SIG': 0x43,
    'STATUS': 0x03,
    'SVIN': 0x3b,
    'TIMEBDS': 0x24,
    'TIMEGAL': 0x25,
    'TIMEGLO': 0x23,
    'TIMEGPS': 0x20,
    'TIMELS': 0x26,
    'TIMEUTC': 0x21,
    'VELECEF': 0x11,
    'VELNED': 0x12
};

const GNSSfixTypes = const [
    {'val':0, 'name':'no fix'},
    {'val':1, 'name':'dead reckoning only'},
    {'val':2, 'name':'2D-fix'},
    {'val':3, 'name':'3D-fix'},
    {'val':4, 'name':'GNSS + dead reckoning combined'},
    {'val':5, 'name':'time only fix'}
];

