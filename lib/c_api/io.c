#include "rtklib_api.h"

extern FILE* openReadFile(const char *filename) {
    return fopen(filename, "r");
}

extern FILE* openWriteFile(const char *filename) {
    return fopen(filename, "w");
}

extern FILE* openFile(const char *filename, const char * mode) {
    return fopen(filename, "w");
}
