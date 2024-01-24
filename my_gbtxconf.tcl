#!/bin/sh

#################################################################
#
# gbtx_config_registers_golden.txt
#
A_GI2C_DATA=0x30
A_GI2C_ERRN=0x31
A_GI2C_STAT=0x32
A_GI2C_FLAG=0x33
A_GI2C_RADL=0x34
A_GI2C_RADH=0x35
A_GI2C_RNML=0x36
A_GI2C_RNMH=0x37

D_DATA_1=0xa
D_DATA_2=0xb
D_DATA_3=0xc

START_ADDR=0x0
NUM_WORDS=0x3

ASCII_w=0x77
ASCII_r=0x72
#################################################################

cd /home/arm/tof/dev/gbtx

./i686/gbtxconf -l 1 -A $A_GI2C_STAT
	# q		--> read FIFO_OUT or proceed
	# b		--> wait
	# x		--> error ! read GI2C_ERRN and re-read
	# e		--> OK !!! proceed
	
echo "Writing 3 GBTx registers with $D_DATA_1, $D_DATA_2 and $D_DATA_3"
./i686/gbtxconf -l 1 -A $A_GI2C_RADL -w $START_ADDR
./i686/gbtxconf -l 1 -A $A_GI2C_RADH -w $START_ADDR>>8
./i686/gbtxconf -l 1 -A $A_GI2C_RNML -w $NUM_WORDS
./i686/gbtxconf -l 1 -A $A_GI2C_RNMH -w $NUM_WORDS>>8
./i686/gbtxconf -l 1 -A $A_GI2C_DATA -w $D_DATA_1
./i686/gbtxconf -l 1 -A $A_GI2C_DATA -w $D_DATA_2
./i686/gbtxconf -l 1 -A $A_GI2C_DATA -w $D_DATA_3
./i686/gbtxconf -l 1 -A $A_GI2C_STAT -w $ASCII_w

sleep 2
./i686/gbtxconf -l 1 -A $A_GI2C_STAT
	# r		--> I2C working!
	# x		--> error ! read GI2C_ERRN and re-read
	# e		--> OK !!! proceed

echo "Reading $NUM_WORDS GBTx registers"
./i686/gbtxconf -l 1 -A $A_GI2C_RADL -w $START_ADDR
./i686/gbtxconf -l 1 -A $A_GI2C_RADH -w $START_ADDR>>8
./i686/gbtxconf -l 1 -A $A_GI2C_RNML -w $NUM_WORDS
./i686/gbtxconf -l 1 -A $A_GI2C_RNMH -w $NUM_WORDS>>8
./i686/gbtxconf -l 1 -A $A_GI2C_STAT -w $ASCII_r

sleep 2
./i686/gbtxconf -l 1 -A $A_GI2C_STAT
	# r		--> I2C working!
	# x		--> error ! read GI2C_ERRN and re-read
	# q		--> done! Data ready to be read out, proceed!	

for data in `seq 1 $NUM_WORDS`;
do
        echo "GBTx register $data begin read is"
        ./i686/gbtxconf -l 1 -A $A_GI2C_DATA
done
