CC=gcc
FC=gfortran
CXX=cxx

HDF5_OBJ = lib/libhdf5.a lib/libhdf5.la lib/libhdf5.so
NCC_OBJ = lib/libnetcdf.a lib/libnetcdf.la lib/libnetcdf.so
NCF_OBJ = lib/libnetcdff.a lib/libnetcdff.la lib/libnetcdff.so
NCO_OBJ = lib/libnco.a

export BUILD_DIR := $(PWD)
export CPPFLAGS := -I$(BUILD_DIR)/include
export LDFLAGS := -L$(BUILD_DIR)/lib

all: $(HDF5_OBJ) $(NCC_OBJ) $(NCF_OBJ) $(NCO_OBJ)

hdf5: $(HDF5_OBJ)

netcdf: $(NCC_OBJ) $(NCF_OBJ)

nco: $(NCO_OBJ)

$(HDF5_OBJ): src/hdf5/Makefile
	$(MAKE) -C src/hdf5 install

$(NCC_OBJ): src/netcdf-c/Makefile $(HDF5_OBJ)
	$(MAKE) -C src/netcdf-c install

$(NCF_OBJ): src/netcdf-fortran/Makefile $(HDF5_OBJ) $(NCC_OBJ)
	$(MAKE) -C src/netcdf-fortran install

$(NCO_OBJ): src/nco/Makefile $(NCC_OBJ) $(NCF_OBJ)
	$(MAKE) -C src/nco install

src/hdf5/Makefile:
	cd src/hdf5; ./configure --prefix=$(BUILD_DIR)

src/netcdf-c/Makefile:
	cd src/netcdf-c; ./configure --prefix=$(BUILD_DIR)

src/netcdf-fortran/Makefile:
	cd src/netcdf-fortran; ./configure --prefix=$(BUILD_DIR)

src/nco/Makefile:
	cd src/nco; ./configure --prefix=$(BUILD_DIR) --disable-ncap2 --enable-netcdf4

clean:
	-rm -vfR bin lib include share
	-cd src/hdf5; make clean
	-cd src/netcdf-c; make clean
	-cd src/netcdf-fortran; make clean
	-cd src/nco; make clean

distclean:
	-rm -vfR bin lib include share
	-cd src/hdf5; make distclean
	-cd src/netcdf-c; make distclean
	-cd src/netcdf-fortran; make distclean
	-cd src/nco; make distclean

