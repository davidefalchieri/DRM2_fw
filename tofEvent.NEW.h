/*

   ALICE TOF Raw Data description: master file

   Header file to describe TOF event fragment: defines, macros and data structures


   @P. Antonioli / INFN-Bologna
   March 2006

   Dec. 2019 moved old CDH to new TDH, updated format for RUN3: new DRM2, new TRM format

*/
#ifndef _TOFEVENT_H
#define _TOFEVENT_H 1
#ifndef _STDINT_H
#include <stdint.h>
#endif

/* RAW Data Header */
// RDH - RAW Data Header
typedef struct {
  //---------------------------------- CRU Word 0 (128 bit)
  uint8_t  version        :  8;        // 32bit w0
  uint8_t  size           :  8;        // 
  uint16_t blockLength    : 16;        //--------------
  uint16_t feeId          : 16;        // 32bit w1        bit 6-0 del registro A_DRM_ID (cosi' da 0-71 ce la facciamo 0x47) 
  uint8_t  prioBits       :  8;        // 
  uint8_t  mbz0           :  8;        //
  uint16_t offsetSize     : 16;        //--------------
  uint16_t memorySize     : 16;        // 32bit w2
  uint8_t  linkId         :  8;        //--------------
  uint8_t  packetCnt      :  8;        // 32bit w3
  unsigned cruId          : 12;        // 
  unsigned dataPathWrap   :  4;        //
  //---------------------------------- CRU Word 1 (128 bit)
  uint32_t triggerOrbit   : 32;        // 32bit w4
  uint32_t orbit          : 32;        // 32bit w5
  uint32_t mbz1a          : 32;        // 32bit w6
  uint32_t mbz1b          : 32;        // 32bit w7
  //---------------------------------- CRU Word 2 (128 bit)
  unsigned trgBunchCnt    : 12;        // 32bit w8
  unsigned mbz2a          :  4;        // 
  unsigned bunchCnt       : 12;        //
  unsigned mbz2b          :  4;        //-------------
  uint32_t triggerType    : 32;        // 32bit w9
  uint64_t mbz2c          : 64;        // 32bit w10+11
  //---------------------------------- CRU Word 3 (128 bit)
  uint16_t detField       : 16;        // 32bit w12
  uint16_t par            : 16;        //-------------
  uint8_t  stopBits       :  8;        // 32bit w13
  uint16_t pageCnt        : 16;        // 
  uint8_t  mbz3a          :  8;        //-------------
  uint64_t mbz3b          : 64;        // 32bit w14+15
}   __attribute__((__packed__)) rawDataHeaderV4_t;

typedef struct {
  //---------------------------------- CRU Word 0 (128 bit)
  uint8_t  version        :  8;        // 32bit w0
  uint8_t  size           :  8;        // 
  uint16_t feeId          : 16;        //--------------
  uint8_t  prioBits       :  8;        // 32bit w1
  unsigned mbz0           : 24;        //--------------
  uint16_t offsetSize     : 16;        // 32bit w2
  uint16_t memorySize     : 16;        //--------------
  uint8_t  linkId         :  8;        // 32bit w3
  uint8_t  packetCnt      :  8;        // 
  unsigned cruId          : 12;        //
  unsigned dataPathWrap   :  4;        //
  //---------------------------------- CRU Word 1 (128 bit)
  unsigned bunchCnt       : 12;        // 32bit w4
  unsigned mbz1           : 20;        //-------------
  uint32_t orbit          : 32;        // 32bit w5
  uint64_t mbz1Long       : 64;        // 32bit w6+7
  //---------------------------------- CRU Word 2 (128 bit)
  uint32_t triggerType    : 32;        // 32bit w8
  uint16_t pageCnt        : 16;        // 32bit w9
  uint8_t  stopBits       :  8;        //
  uint8_t  mbz2a          :  8;        //-------------
  uint64_t mbz2b          : 64;        // 32bit w10+11
  //---------------------------------- CRU Word 3 (128 bit)
  uint32_t detField       : 32;        // 32bit w12
  uint16_t par            : 16;        // 32bit w13
  uint16_t mbz3a          : 16;        //-------------
  uint64_t mbz3b          : 64;        // 32bit w14+15
} __attribute__((__packed__)) rawDataHeaderV5_t;

typedef struct {
  //---------------------------------- CRU Word 0 (128 bit)
  uint8_t  version        :  8;        // 32bit w0
  uint8_t  size           :  8;        // 
  uint16_t feeId          : 16;        //--------------
  uint8_t  prioBits       :  8;        // 32bit w1
  uint8_t  detectorId     :  8;
  unsigned mbz0           : 16;        //--------------
  uint16_t offsetSize     : 16;        // 32bit w2
  uint16_t memorySize     : 16;        //--------------
  uint8_t  linkId         :  8;        // 32bit w3
  uint8_t  packetCnt      :  8;        // 
  unsigned cruId          : 12;        //
  unsigned dataPathWrap   :  4;        //
  //---------------------------------- CRU Word 1 (128 bit)
  unsigned bunchCnt       : 12;        // 32bit w4
  unsigned mbz1           : 20;        //-------------
  uint32_t orbit          : 32;        // 32bit w5
  uint64_t mbz1Long       : 64;        // 32bit w6+7
  //---------------------------------- CRU Word 2 (128 bit)
  uint32_t triggerType    : 32;        // 32bit w8
  uint16_t pageCnt        : 16;        // 32bit w9
  uint8_t  stopBits       :  8;        //
  uint8_t  mbz2a          :  8;        //-------------
  uint64_t mbz2b          : 64;        // 32bit w10+11
  //---------------------------------- CRU Word 3 (128 bit)
  uint32_t detField       : 32;        // 32bit w12
  uint16_t par            : 16;        // 32bit w13
  uint16_t mbz3a          : 16;        //-------------
  uint64_t mbz3b          : 64;        // 32bit w14+15
} __attribute__((__packed__)) rawDataHeaderV6_t;

#define RDH_SIZE        sizeof(rawDataHeaderV6_t)            // size is in bytes length is in words
#define RDH_LENGTH      RDH_SIZE/4
#define RDH_VERSION(a)  (a&0xFF)    
#define RDH_OFFSET(a)   (a&0xFFFF)
#define RDH_EVSIZE(a)   ((a >> 16) & 0xFFFF)
#define RDH_LINK(a)     (a&0xFF)                             // to be added: take into account end point/cruId

/* GEO Ad assigned to TOF modules */
#define DRM_GEOAD                 1
#define LTM_GEOAD                 2
#define TRM_GEOAD_MIN             3
#define TRM_GEOAD_MAX            12 

/* Symbols and macros valid for all slots */
#define TOF_HEADER                4
#define TOF_TRAILER               5
#define TOF_FILLER                7
#define FILLER_WORD               (TOF_FILLER << 28)
#define TOF_GETGEO(x)             (x & 0xF )
#define TOF_GETDATAID(x)          ((x>>28) & 0xF)



/* TOF Data Header (former CDH)
        |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00|
        -------------------------------------------------------------------------------------------------
Word 0  |   0100    |           00          |        Event Length (Bytes)                               |
        -------------------------------------------------------------------------------------------------
Word 1  |                                     LHC Orbit                                                 |
        -------------------------------------------------------------------------------------------------
*/
// TDH - TOF Data Header
typedef struct {
  unsigned bytePayload    : 20;                
  unsigned mbz            :  8;                //    - metterci 8 bit di trigger dispatched nell'orbita?
  unsigned dataId         :  4;
  uint32_t orbit          : 32;
} __attribute__((__packed__)) tofDataHeader_t;
#define TDH_SIZE        sizeof(tofDataHeader_t)                  // size is in bytes length is in words
#define TDH_LENGTH      TDH_SIZE/4

#define TDH_HEADER(d)   TOF_GETDATAID(d)
#define TDH_PAYLOAD(d)  (d&0xFFFFF)
#define TDH_WORDS(d)    TDH_PAYLOAD(d)/4
#define TDH_ORBIT(d)    (d&0xFFFFFFFF)     //32 bit




/* DRM headers & trailer 

        |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00|
        -------------------------------------------------------------------------------------------------
Word 0  |   0100    |      DRM Id        |                 Event Length (Words)             |  0001     |
        -------------------------------------------------------------------------------------------------
Word 1  |   0100    |0 | DRMHWords | DRMHVersion  | CLK |0 |  Slot Participating Mask       |  0001     |
        -------------------------------------------------------------------------------------------------
Word 2  |   0100    |TO|  Slot Fault Mask               |0 |  Slot Enable Mask              |  0001     |
        -------------------------------------------------------------------------------------------------
Word 3  |   0100    |   Bunch Crossing (Local)          |    Bunch Crossing (GBTx)          |  0001     |
        -------------------------------------------------------------------------------------------------
Word 4  |   0100    |        00             |  Temp Ad  | 00 |   Temp Value                 |  0001     |
        -------------------------------------------------------------------------------------------------
Word 5  |   0100    |        00       |IR|                   Event CRC                      |  0001     |
        -------------------------------------------------------------------------------------------------
Trailer |   0101    |        000                        |    Event Counter (Local)          |  0001     |
        -------------------------------------------------------------------------------------------------
*/
// DRMH - DRM Data Header and Trailer
typedef struct {
//----------------------------------- Word 0
  unsigned slotId0         :  4; 
  unsigned eventWords      : 16;               // meglio portarlo a 16
  unsigned drmId           :  8;               // 0-71== 0x0-0x47 (Bit 8 > 0x80 announce DRM generated payload)) ricopiare bit 7-0 del registro A_DRM_ID
  unsigned dataId0         :  4;
//----------------------------------- Word 1
  unsigned slotId1         :  4;
  unsigned partSlotMask    : 11;               
  unsigned mbz1a           :  1;
  unsigned clockStatus     :  2; 
  unsigned drmhVersion     :  5;               // (Bit 4 identifies RUN3/4 data format) --> 5 bits is enough!
  unsigned drmHSize        :  4;               // it doesn't count previous word, so currently it is 5
  unsigned mbz1b           :  1;
  unsigned dataId1         :  4;
//----------------------------------- Word 2
  unsigned slotId2         :  4;
  unsigned enaSlotMask     : 11;
  unsigned mbz2            :  1;
  unsigned faultSlotMask   : 11;
  unsigned readoutTimeOut  :  1;
  unsigned dataId2         :  4;
//----------------------------------- Word 3
  unsigned slotId3         :  4;
  unsigned gbtBunchCnt     : 12;
  unsigned locBunchCnt     : 12;
  unsigned dataId3         :  4;
//----------------------------------- Word 4
  unsigned slotId4         :  4;
  unsigned tempValue       : 10;
  unsigned mbz4a           :  2;
  unsigned tempAddress     :  4;
  unsigned mbz4b           :  8;
  unsigned dataId4         :  4;
//----------------------------------- Word 5
  unsigned slotId5         :  4;
  unsigned eventCRC        : 16;
  unsigned irq1            :  1;
  unsigned mbz5            :  7;
  unsigned dataId5         :  4;
} __attribute__((__packed__)) drmDataHeader_t;

typedef struct {
  unsigned slotId          :  4;
  unsigned locEvCnt        : 12;
  unsigned mbz             : 12;                
  unsigned dataId          :  4;
} __attribute__((__packed__)) drmDataTrailer_t;



#define DRMH_SIZE       sizeof(drmDataHeader_t)
#define DRMH_LENGTH     DRMH_SIZE/4
#define DRM_HEAD_NW     DRMH_LENGTH

// Word 0
#define DRM_DRMID(a)    ((a & 0x007E00000)>>21)   //was FE    ///CHECK
#define DRM_EVWORDS(a)  ((a & 0x0001FFFF0)>>4)                ///CHECK
// Word 1
#define DRM_SLOTID(a)   ((a & 0x00007FF0)>>4)
#define DRM_CLKFLG(a)   ((a & 0x00018000)>>15)    //was 10000>>15
#define DRM_VERSID(a)   ((a & 0x003E0000)>>17)    //waa 1E0000>>16
#define DRM_HSIZE(a)    ((a & 0x03C00000)>>22)    //was 3E0000>>21
// Word 2
#define DRM_ENABLEID(a) ((a & 0x00007FF0)>>4)
#define DRM_FAULTID(a)  ((a & 0x07FF0000)>>16)
#define DRM_RTMO(a)     ((a & 0x08000000)>>27)
// Word 3
#define DRM_BCGBT(a)    ((a & 0x0000FFF0)>>4)
#define DRM_BCLOC(a)    ((a & 0x0FFF0000)>>16)
// Word 4
#define DRM_TEMP(a)     ((a & 0x00003FF0)>>4)
#define DRM_SENSAD(a)   ((a & 0x00070000)>>18)
// Word 5
#define DRM_EVCRC(a)    ((a & 0x000FFFF0)>>4)
// Trailer
#define DRM_LOCEVCNT(a) ((a & 0x0000FFF0)>>4)

/* TRM headers & trailers */
#define TRM_HEADER       TOF_HEADER
#define TRM_TRAILER      TOF_TRAILER
#define CHAIN_0_HEADER   0
#define CHAIN_0_TRAILER  1  
#define CHAIN_1_HEADER   2
#define CHAIN_1_TRAILER  3  
#define HIT_LEADING      0xA
#define HIT_TRAILING     0xC
#define REPORT_ERROR     6
#define DEBERR           REPORT_ERROR

#define TRM_WORDID(a)    TOF_GETDATAID(a)   // legacy

/* TRM Global Header                 
  |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00|
  -------------------------------------------------------------------------------------------------
  |   0100    | E|         EVENT NUMBER (10)   |             EVENT WORDS (13)         |  SLOT ID  |
                |
                |__ Empty event
*/
// TRM - TRM Data Global and Chain Header and Trailer 
typedef struct {
  unsigned slotId         :   4;
  unsigned eventWords     :  13;
  unsigned eventCnt       :  10;
  unsigned emptyBit       :   1;
  unsigned dataId         :   4;
} __attribute__((__packed__)) trmDataHeader_t;
#define TRM_EVCNT_GH(a)  ((a & 0x07FE0000)>>17)
#define TRM_EVWORDS(a)   ((a & 0x0001FFF0)>>4)

/* TRM Chain Header
  |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00|
  -------------------------------------------------------------------------------------------------
  | 0000/0010 |        RESERVED                   |             BUNCH ID              |  SLOT ID  |
*/
typedef struct {
  unsigned slotId         :   4;
  unsigned bunchCnt       :  12;
  unsigned mbz            :  12;
  unsigned dataId         :   4;     // bit 29 flag the chain
} __attribute__((__packed__)) trmChainHeader_t;
#define TRM_BUNCHID(a)   ((a & 0x0000FFF0)>>4)


/* TRM Chain Trailer
  |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00|
  -------------------------------------------------------------------------------------------------
  | 0001/0011 |        EVENT COUNTER              |           CHAIN_EVNT_WORD (12)    |  STATUS   |
*/
typedef struct {
  unsigned status         :   4;
  unsigned mbz            :  12;
  unsigned eventCnt       :  12;
  unsigned dataId         :   4;    // bit 29 flag the chain
} __attribute__((__packed__)) trmChainTrailer_t;
#define TRM_EVCNT_CT(a)  ((a & 0x0FFF0000)>>16)
#define TRM_CHAINSTAT(a) (a & 0xF) 



/* TRM Global Trailer  
  |31|30|29|28|27|26|25|24|23|22|21|20|19|18|17|16|15|14|13|12|11|10|09|08|07|06|05|04|03|02|01|00|
  -------------------------------------------------------------------------------------------------
  |   0101    | L|TS|CN| SENS AD|        TEMP (8)       |     EVENT CRC (12)                | X| X|
                |  |  |
                |  |  |__ Chain
                |  |__ Temp Status bit (1=OK,0=not valid)
                |__ Lut error
*/
typedef struct {
  unsigned trailerMark    :   2;
  unsigned eventCRC       :  12;
  unsigned tempValue      :   8;
  unsigned tempAddress    :   3;
  unsigned tempChain      :   1;
  unsigned tempAck        :   1;
  unsigned lutErrorBit    :   1;
  unsigned dataId         :   4;
} __attribute__((__packed__)) trmDataTrailer_t;

#define TRM_LUTERRBIT(a) ((a & 0x08000000)>>27)
#define TRM_PB24TEMP(a)  ((a & 0x003FC000)>>14)
#define TRM_PB24ID(a)    ((a & 0x01C00000)>>22)
#define TRM_PB24CHAIN(a) ((a & 0x02000000)>>25)
#define TRM_PB24ACK(a)   ((a & 0x04000000)>>26)
#define TRM_EVCRC2(a)    ((a & 0x00003FFC)>>2)
#define TRM_TERM(a)      (a  & 0x3)

//#define TRM_EVCNT2(a)    ((a & 0x07FE0000)>>17)
//#define TRM_EVCRC(a)     ((a & 0x0000FFF0)>>4)

// TDC Hit Decoding
#define TRM_TIMEFINE(a)  (a&0xFFFFF)
#define TRM_TDCID(a)     ((a>>24)&0xF)
#define TRM_CHANID(a)    ((a>>21)&0x7)
#define TRM_HITTIME(a)   (a&0x1FFF)

// LTM
// LTM - LTM Data Header and Trailer 
typedef struct {
  unsigned slotId         :   4;
  unsigned eventWords     :  13;
  unsigned cycloneErr     :   1;
  unsigned fault          :   6;
  unsigned mbz0           :   4;
  unsigned dataId         :   4;
} __attribute__((__packed__)) ltmDataHeader_t;
#define HEAD_TAG(x)       ( ((x) >> 28) & 0xF )
#define HEAD_FAULTFLAG(x) ( ((x) >> 18) & 0x1 )
#define HEAD_CYCSTATUS(x) ( ((x) >> 17) & 0x1 )
#define LTM_EVENTSIZE(x)  ( ((x) >>  4) & 0x1FFF)        // actual event size
#define HEAD_EVENTSIZE(x) ( ((x) >>  4) & 0x1FFF)
#define HEAD_GEOADDR(x)   ( ((x)      ) & 0xF)
#define LTM_HEADER       TOF_HEADER

typedef struct {
  unsigned slotId         :   4;
  unsigned eventCRC       :  12;
  unsigned eventCnt       :  12;
  unsigned dataId         :   4;
} __attribute__((__packed__)) ltmDataTrailer_t;
#define TAIL_TAG(x)      ( ((x) >> 28) & 0xF )
#define TAIL_EVENTNUM(x) ( ((x) >> 16) & 0xFFF )
#define TAIL_EVENTCRC(x) ( ((x) >>  4) & 0xFFF )
#define TAIL_GEOADDR(x)  ( ((x)      ) & 0xF)
#define LTM_TRAILER      TOF_TRAILER

typedef struct {
  uint8_t pdl0            :   8;
  uint8_t pdl1            :   8;
  uint8_t pdl2            :   8;
  uint8_t pdl3            :   8;
} __attribute__((__packed__)) ltmPdlWord_t;

typedef struct {
  uint16_t adc0           :   10;
  uint16_t adc1           :   10;
  uint16_t adc2           :   10;
  uint8_t  mbz            :    2;
} __attribute__((__packed__)) ltmAdcWord_t;

typedef struct {
  uint32_t header;
  uint32_t pdlData[12];
  //  48 PDL values        12 words
  uint32_t adcData[36];
  //  16 Low Voltages       5 words  + 10 bit
  //  16 Thresholds         5 words  + 10 bit
  //   8 FEAC GND           2 words  + 10 bit
  //   8 FEAC Temp          2 words  + 10 bit
  //  12 LTM  Temp:         4 words
  //  48 OR trigger rates: 16 words
  //                       34 words + 2 words = 36 words
  uint32_t trailer;
} __attribute__((__packed__)) ltmPackedEvent_t;
#define LTM_EVSIZE         sizeof(ltmPackedEvent_t)          // fixed expected event size
#define PDL_FIELD(x,n)     ( ((x) >> ((n) * 8)) & 0xFF )
#define V_FIELD(x,n)       ( ((x) >> ((n) * 10)) & 0x3FF )
#define T_FIELD(x,n)       ( ((x) >> ((n) * 10)) & 0x3FF )
#define OR_FIELD(x,n)      ( ((x) >> ((n) * 10)) & 0x3FF )


#define ltmint unsigned int    //si puo' portarlo a uint16_t rendendo la struttura piu' piccola, da verificare se non ci sono overflow
typedef struct {
  ltmint   TagHead;
  ltmint   FaultFlag;
  ltmint   CycStatus;
  ltmint   EventSize;
  ltmint   HeadGeo;
  ltmint   PdlDelay[48];
  ltmint   Vlv[16];
  ltmint   Vth[16];
  ltmint   GndFeac[8];
  ltmint   FeacTemp[8];
  ltmint   LocalTemp[12];
  ltmint   OrRate[48];
  ltmint   EventNum;
  ltmint   EventCrc;
  ltmint   TailGeo;
  ltmint   TagTail;
} ltmEvent_t;


#endif
