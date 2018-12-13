/*
 * PRS_BPA.c
 *
 *  Created on: 12 Sep 2018
 *      Author: JULIAN MORTIMER
 */
#include "include.h"

shell PrsBPAShell;

PrsPhi txPrsPhi;


extern cplx RxPRSTdCorFT      [ SYS_MAX_CARRIERS ];
extern cplx RxPRSFdCordeltatp [ SYS_MAX_CARRIERS ];

static void ClearData( PrsBPA *pd );
static double PrsPhaseError( PrsBPA *pd, cplx *p, u32 i );
static PrsPhase PrsPhiPhase( PrsBPA *pd, u32 n );
static void PrsPhiInit ( PrsBPA *pd );

void CMatDump      ( cplx   *m   , u32 nCol, u32 nRow, char name[]  );
void CRowDump      ( cplx   *m   , u32 ncol, char name[] );
void CColDump      ( cplx   *m   , u32 nRow, char name[] );
void DMatDump      ( double *m   , u32 nCol, u32 nRow, char name[]  );
void DRowDump      ( double *m   , u32 ncol, char name[] );
void DColDump      ( double *m   , u32 nRow, char name[] );
void SMatDump      ( s32    *m   , u32 nCol, u32 nRow, char name[]  );
void SRowDump      ( s32    *m   , u32 ncol, char name[] );
void SColDump      ( s32    *m   , u32 nRow, char name[] );
void UMatDump      ( u32    *m   , u32 nCol, u32 nRow, char name[]  );
void URowDump      ( u32    *m   , u32 ncol, char name[] );
void UColDump      ( u32    *m   , u32 nRow, char name[] );


double SigmaYFinal  = 0.0;
double SigmaXYFinal = 0.0;
cplx   RxPrsTDCorrDfpp [ SYS_MAX_CARRIERS ];
cplx   RxPrsFDCorrDfpp [ SYS_MAX_CARRIERS ];
double RxPrsFDFinalCorrPhaseErr [ SYS_MAX_CARRIERS ];

const  double FrqCorrFactor       [ SYS_N_CHAN_PRSBPA ] = { -0.20, -0.15, -0.10, -0.05, 0.00, 0.05, 0.10, 0.15, 0.20 };

static s32 BPARowIndex            = 0;
static s32 ridx                   = 0;

static double SigmaErrPhiCIR     = 0.0;
static double Theta0CIR          = 0.0;
//static double ErrPhiCIR          [ SYS_MAX_CARRIERS  ];
//static cplx   RxPrsFDCIR         [ SYS_MAX_CARRIERS  ];

static cplx   PRSBuf             [ SYS_MAX_CARRIERS  ];

static cplx   TxPrs              [ SYS_MAX_CARRIERS  ];
static double TxPrsPhase         [ SYS_MAX_CARRIERS  ];
static cplx   RxPrsTD            [ SYS_MAX_CARRIERS  ];
static cplx   RxPrsTDCorr        [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static cplx   RxPrsFD            [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static cplx   RxPrsFDCorr        [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static cplx   RxPrsFDFinalCorr   [ SYS_MAX_CARRIERS  ];
static cplx   RxPrsTDFinalCorr   [ SYS_MAX_CARRIERS  ];
static double RxPrsPhase         [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static double RxPrsErrPhase      [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static s32    sampleIdx1         [ SYS_MAX_CARRIERS  ];
static s32    sampleIdx2         [ SYS_MAX_CARRIERS  ];
static u32    nSams= 0;

static double YA                 [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static double MeanYA             [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double NormYA             [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static double SigmaYA            [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double SigmaY2A           [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double SigmaXYA           [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };

static double YB                 [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static double MeanYB             [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double NormYB             [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static double SigmaYB            [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double SigmaY2B           [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double SigmaXYB           [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };

static double Y                  [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static double MeanY              [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double NormY              [ SYS_N_CHAN_PRSBPA + 1 ][ SYS_MAX_CARRIERS  ];
static double SigmaY             [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double SigmaY2            [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };
static double SigmaXY            [ SYS_N_CHAN_PRSBPA + 1 ] = { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 };

static double X                  [ SYS_MAX_CARRIERS  ];
static double MeanX              = 0.0;
static double NormX              [ SYS_MAX_CARRIERS  ];
static double SigmaX             = 0.0;
static double SigmaX2            = 0.0;

static cplx   PRSBufRot          [ SYS_MAX_CARRIERS  ];
static cplx   RxPrsBufRot        [ SYS_MAX_CARRIERS  ];
static DemodData DmodRxPrs4QAM   [ SYS_MAX_CARRIERS  ];
static DemodData DmodRxPrs16QAM  [ SYS_MAX_CARRIERS  ];
static DemodData DmodRxPrs64QAM  [ SYS_MAX_CARRIERS  ];
static DemodData DmodPRS4QAM     [ SYS_MAX_CARRIERS  ];
static DemodData DmodPRS16QAM    [ SYS_MAX_CARRIERS  ];
static DemodData DmodPRS64QAM    [ SYS_MAX_CARRIERS  ];
double BerQPSK                   = 0.0;
double Ber4QAM                   = 0.0;
double Ber16QAM                  = 0.0;
double Ber64QAM                  = 0.0;
double Qfr4QAM                   = 0.0;
double Qfr16QAM                  = 0.0;
double Qfr64QAM                  = 0.0;




// =================================
// Boilerplate Function Declarations
// =================================
void PrsBPAInit(
    PrsBPA *pd,
    const char *Name,
    u32        BaseAddr,
    SysCtrl    *pSysCtrl,
    SysDvce    *pSysDvce,
    SysDesc    *pSysDesc,
    SysPtrs    *pSysPtrs,
    SysData    *pSysData,
    PrsDesc    *pPrsBPADesc,
    PrsBPAData *pPrsBPAData
    );

static void SetParams    ( PrsBPA *pd );
static void SysDvceDump  ( PrsBPA *pd );
static void SysDescDump  ( PrsBPA *pd );
static void SysDataDump  ( PrsBPA *pd );
static void DvcDataInit  ( PrsBPA *pd );
static void DvcDataUpd   ( PrsBPA *pd );
static void DvcDescDump  ( PrsBPA *pd );
static void DvcDataDump  ( PrsBPA *pd );



// static non-member functions
static void ReadPRSData( PrsBPA *pd );
static void CopyPRSPhase( PrsBPA *pd );
static void CalcDelta( PrsBPA *pd, s32 ridx );
static void CalcPhaseError( PrsBPA *pd );
static void FinalCorr( PrsBPA *pd );
static void CalcLinReg( PrsBPA *pd );
static void CalcCorr( PrsBPA *pd, u32 cidx, double freqCorrFact, double timeCorrFact );
//static void CalcBER( PrsBPA *pd, s32 ridx );

// =================================================
// Device Structure Member Functions (public access)
// =================================================
// Insert device-specific member function prototypes here
// Example: static inline void Start         ( PrsBPA *pd ) { hwWriteCtrlReg( SYSDVC( BaseAddr ), PRSBPA_CTRL_REG << 2, PRSBPA_START ); }
// Example: static void        WriteBuf      ( PrsBPA *pd, u32 addr, u32 data );
static void Dump               ( PrsBPA *pd );
static void DumpCorr           ( PrsBPA *pd );
static void DumpCorrSymbFd     ( PrsBPA *pd );
static void DumpCorrSymbTd     ( PrsBPA *pd );
static void CalcDeltas         ( PrsBPA *pd );

// =================================================
// Device Shell Commands
// =================================================

static inline void ShCalcDeltas            ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CalcDeltas( pd ); }
static inline void DumpRxPrsTD             ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CMatDump( &RxPrsTD          [ 0 ], 0                , SYSPAR( nFFT ), "Rx PRS time domain"                 ); }
static inline void DumpRxPrsTDCorr         ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CMatDump( &RxPrsTDCorr [ 0 ][ 0 ], SYS_N_CHAN_PRSBPA, SYSPAR( nFFT ), "Rx PRS time domain corrected"       ); }
static inline void DumpRxPrsFD             ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CMatDump( &RxPrsFD     [ 0 ][ 0 ], SYS_N_CHAN_PRSBPA, SYSPAR( nFFT ), "Rx PRS frequency domain"            ); }
static inline void DumpRxPrsFDCorr         ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CMatDump( &RxPrsFDCorr [ 0 ][ 0 ], SYS_N_CHAN_PRSBPA, SYSPAR( nFFT ), "Rx PRS frequency domain corrected"  ); }
static inline void DumpRxPrsPhase          ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; DMatDump( &RxPrsPhase       [ 0 ][ 0 ], SYS_N_CHAN_PRSBPA, SYSPAR( nFFT ), "Rx PRS phase"                       ); }
static inline void DumpRxPrsErrPhase       ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; DMatDump( &RxPrsErrPhase    [ 0 ][ 0 ], SYS_N_CHAN_PRSBPA, SYSPAR( nFFT ), "Rx PRS phase error"                 ); }
static inline void DumpRxPrsFDFinalCorr    ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CMatDump( &RxPrsFDFinalCorr      [ 0 ], 0                , SYSPAR( nFFT ), "Rx PRS freq domain final Corr"      ); }
static inline void DumpRxPrsTDFinalCorr    ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CMatDump( &RxPrsTDFinalCorr      [ 0 ], 0                , SYSPAR( nFFT ), "Rx PRS time domain final Corr"      ); }
static inline void DumpTxPrs               ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; CMatDump( &TxPrs                 [ 0 ], 0                , SYSPAR( nFFT ), "Tx PRS"                             ); }
static inline void DumpTxPrsPhase          ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; DMatDump( &TxPrsPhase            [ 0 ], 0                , SYSPAR( nFFT ), "Tx PRS phase"                       ); }
static inline void DumpX                   ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; DMatDump( &X                     [ 0 ], 0                , SYSPAR( nFFT ), "Linear interpolation X"             ); }
static inline void DumpNormX               ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; DMatDump( &NormX                 [ 0 ], 0                , SYSPAR( nFFT ), "Linear interpolation X - mean( X )" ); }
static inline void DumpSampleIdx1          ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; SMatDump( &sampleIdx1            [ 0 ], 0                , SYSPAR( nFFT ), "Sample index 1"                     ); }
static inline void DumpSampleIdx2          ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; SMatDump( &sampleIdx2            [ 0 ], 0                , SYSPAR( nFFT ), "Sample index 2"                     ); }

static inline void DumpY                   ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; DMatDump( &Y                [ 0 ][ 0 ], SYS_N_CHAN_PRSBPA, SYSPAR( nFFT ), "Y"                                  ); }
static inline void DumpNormY               ( shell *psh ) { PrsBPA *pd = &RxPrsBPA; DMatDump( &NormY            [ 0 ][ 0 ], SYS_N_CHAN_PRSBPA, SYSPAR( nFFT ), "NormY"                              ); }
static inline void DumpMeanY               ( shell *psh ) {                         DMatDump( &MeanY                 [ 0 ], SYS_N_CHAN_PRSBPA, 0             , "Linear interpolation Y"             ); }
static inline void DumpSigmaY              ( shell *psh ) {                         DMatDump( &SigmaY                [ 0 ], SYS_N_CHAN_PRSBPA, 0             , "Linear interpolation sigma Y"       ); }
static inline void DumpSigmaY2             ( shell *psh ) {                         DMatDump( &SigmaY2               [ 0 ], SYS_N_CHAN_PRSBPA, 0             , "Linear interpolation sigma Y^2"     ); }
static inline void DumpSigmaXY             ( shell *psh ) {                         DMatDump( &SigmaXY               [ 0 ], SYS_N_CHAN_PRSBPA, 0             , "Linear interpolation Sigma XY"      ); }
static        void DumpChanRes             ( shell *psh );

shellCommandDef PrsBPACmdDef[ ] = {
    { "all"  , ""           ,  0, "",                                                                                                 NULL },
    { "all"  , "q"          ,  0, "                                        Exit this shell"                        , shellConsoleExit      },
    { "all"  , ""           ,  0, "",                                                                                                 NULL },
    { "all"  , "Calc"       ,  0, "                                        Calculate deltas"                       , ShCalcDeltas          },
    { "all"  , "RxPTD"      ,  0, "                                        Dump Rx PRS Time Domain"                , DumpRxPrsTD           },
    { "all"  , "RxPTDC"     ,  0, "                                        Dump Rx PRS Time Domain Corrected"      , DumpRxPrsTDCorr       },
    { "all"  , "RxPFD"      ,  0, "                                        Dump Rx PRS Freq Domain"                , DumpRxPrsFD           },
    { "all"  , "RxPFDC"     ,  0, "                                        Dump Rx PRS Freq Domain Corrected"      , DumpRxPrsFDCorr       },
    { "all"  , "RxPPh"      ,  0, "                                        Dump Rx PRS Phase"                      , DumpRxPrsPhase        },
    { "all"  , ""           ,  0, "",                                                                                                 NULL },
    { "all"  , "ErrPh"      ,  0, "                                        Dump Phase Error"                       , DumpRxPrsErrPhase     },
    { "all"  , ""           ,  0, "",                                                                                                 NULL },
    { "all"  , "RxFDFinC"   ,  0, "                                        Dump Rx PRS Final Corr Freq Domain"     , DumpRxPrsFDFinalCorr  },
    { "all"  , "RxTDFinC"   ,  0, "                                        Dump Rx PRS Final Corr Time Domain"     , DumpRxPrsTDFinalCorr  },
    { "all"  , "TxP"        ,  0, "                                        Dump Tx PRS"                            , DumpTxPrs             },
    { "all"  , "TxPPh"      ,  0, "                                        Dump Tx PRS Phase"                      , DumpTxPrsPhase        },
    { "all"  , ""           ,  0, "",                                                                                                 NULL },
    { "all"  , "X"          ,  0, "                                        Dump X"                                 , DumpX                 },
    { "all"  , "NormX"      ,  0, "                                        Dump X - mean( x )"                     , DumpNormX             },
    { "all"  , ""           ,  0, "",                                                                                                 NULL },
    { "all"  , "Y"          ,  0, "                                        Dump Y"                                 , DumpY                 },
    { "all"  , "MeanY"      ,  0, "                                        Dump Mean( Y )"                         , DumpMeanY             },
    { "all"  , "NormY"      ,  0, "                                        Dump Y  - mean( Y )"                    , DumpNormY             },
    { "all"  , "SigY"       ,  0, "                                        Dump Sigma Y"                           , DumpSigmaY            },
    { "all"  , "SigXY"      ,  0, "                                        Dump Sigma XY"                          , DumpSigmaXY           },
    { "all"  , "SigY2"      ,  0, "                                        Dump Sigma Y^2b"                        , DumpSigmaY2           },
    { "all"  , ""           ,  0, "",                                                                                                 NULL },
    { "all"  , "SI1"        ,  0, "                                        Dump Sample Index 1"                    , DumpSampleIdx1        },
    { "all"  , "SI2"        ,  0, "                                        Dump Sample Index 2"                    , DumpSampleIdx2        },
    { "all"  , "CRes"       ,  0, "                                        Dump Chan Results"                      , DumpChanRes           },
    { "\0"                                                                                                    }
};


// Declare init structure here with member functions
PrsBPA PrsBPAInitStr = {
    NULL,              // SysDvce        *pSysDvce;
    NULL,              // PrsDesc        *pDvcDesc;
    NULL,              // PrsBPAData     *pDvcData;
    Dump,              // void (* Dump           ) ( PrsBPA *pd );
    DumpCorr,          // void (* DumpCorr       ) ( PrsBPA *pd );
    DumpCorrSymbFd,    // void (* DumpCorrSymbFd ) ( PrsBPA *pd, u32 offs );
    DumpCorrSymbTd,    // void (* DumpCorrSymbTd ) ( PrsBPA *pd, u32 offs );
    CalcDeltas         // void (* CalcDeltas     ) ( PrsBPA *pd );
};

//===================
// Initialize Device
//===================
void PrsBPAInit( PrsBPA *pd, const char *Name, u32 BaseAddr, SysCtrl *pSysCtrl, SysDvce *pSysDvce, SysDesc *pSysDesc, SysPtrs *pSysPtrs, SysData *pSysData, PrsDesc *pDvcDesc, PrsBPAData *pDvcData )
{
    *pd             = PrsBPAInitStr;
    pd->pSysDvce    = pSysDvce;
    SysDvceInit(
        pd->pSysDvce,
        Name,
        pSysCtrl,
        pSysDesc,
        pSysPtrs,
        pSysData,
        NULL,
        BaseAddr,
        BPA_HW_INFO_REG,
        BPA_CTRL_REG,
        BPA_INFO_REG,
        BPA_STAT_REG,
        BPA_RESET,
        BPA_INT_ACK,
        0,
        0,
        0,
        0,
        0,
        BPA_TX_DATA_CTR_REG,
        BPA_TX_SYMB_CTR_REG,
        BPA_TX_FRAME_CTR_REG,
        BPA_TX_BLOCK_CTR_REG,
        0,
        0
        );
    pd->pDvcDesc  = pDvcDesc;
    pd->pDvcData  = pDvcData;
    DvcDataInit( pd );
    SYSRESET( pd );
    SetParams( pd );
    txPrsPhi.init = false;
    txPrsPhi.Initialise = PrsPhiInit;
    txPrsPhi.Phase      = PrsPhiPhase;
}

//========================
// Dump Device to Console
//========================
static void Dump( PrsBPA *pd ) {
    cprintf( "\n" );
    SysDvceDump( pd );
    SysDescDump( pd );
    DvcDescDump( pd );
    SysDataDump( pd );
    DvcDataDump( pd );
    cprintf( "\n" );
}

// End of boilerplate code
//========================
// Device-specific code
//========================
static void SetParams( PrsBPA *pd )
{
// Set PL device slave regs here
// Example SYSWRSLVREG( pd, PRSBPA_BOB_REG,    SYSPAR( Bob   ));
// Example SYSWRSLVREG( pd, PRSBPA_ALICE_REG , SYSPAR( Alice ));
}

static void DvcDataInit( PrsBPA *pd )
{
// Initialise DvcData members here
// Example: DVCDAT( Bob ) = 0;
}

static void DvcDataUpd( PrsBPA *pd )
{
// Update DvcData members here
// Example: DVCDAT( Bob ) = SYSRDSLVREG( pd, PRSBPA_BOB_REG );
}

static void DvcDataDump( PrsBPA *pd )
{
    DvcDataUpd( pd );
// Insert device-specific SysDesc members here
// Example: cprintf("\nBob  : %u", toUint( DVCDAT( Bob )) );
}

static void DvcDescDump( PrsBPA *pd )
{
// Insert device-specific PrsBPADesc members here
// Example: cprintf("\nAlice: %u", toUint( SYSPAR( Alice )) );
}

static void SysDvceDump( PrsBPA *pd )
{
    SYSDVCEDUMP( pd );
}

static void SysDataDump( PrsBPA *pd )
{
    SYSDATADUMP( pd );
}

static void SysDescDump( PrsBPA *pd )
{
// Insert device-specific PrsBPADesc members here
// Example: cprintf("\nAlice: %u", toUint( SYSPAR( Alice )) );
}


// Insert device-specific code here
//======================================
// Device-specific non member functions
//======================================
// Example: static inline void EnterAdmin    ( PrsBPA *pd ) { hwWriteCtrlReg( SYSDVC( BaseAddr ), PRSBPA_CTRL_REG << 2, PRSBPA_ENTER_ADMIN ); }

//=================================
// Device-specific member functions
//=================================

// Example:
// static u32 ReadBuf( PrsBPA *pd, u32 addr )
// {
//     return ( SYSPTR( pBuf[ addr ] ));
// }

static void ClearData( PrsBPA * pd )
{
    BPARowIndex        = 0;
    ridx               = 0;
    nSams              = 0;

    SigmaErrPhiCIR     = 0.0;
    Theta0CIR          = 0.0;


//    ( void ) memsetd( ( void * ) ErrPhiCIR        , 0.0, SIZE( ErrPhiCIR        , double ) );
//    ( void ) memsetc( ( void * ) RxPrsFDCIR       , 0.0, SIZE( RxPrsFDCIR       , cplx   ) );
    ( void ) memsetc( ( void * ) PRSBuf           , 0.0, SIZE( PRSBuf           , cplx   ) );
    ( void ) memsetc( ( void * ) PRSBufRot        , 0.0, SIZE( PRSBufRot        , cplx   ) );
    ( void ) memsetc( ( void * ) RxPrsBufRot      , 0.0, SIZE( RxPrsBufRot      , cplx   ) );
    ( void ) memsetc( ( void * ) TxPrs            , 0.0, SIZE( TxPrs            , cplx   ) );
    ( void ) memsetd( ( void * ) TxPrsPhase       , 0.0, SIZE( TxPrsPhase       , double ) );
    ( void ) memsetc( ( void * ) RxPrsTD          , 0.0, SIZE( RxPrsTD          , cplx   ) );
    ( void ) memsetc( ( void * ) RxPrsTDCorr      , 0.0, SIZE( RxPrsTDCorr      , cplx   ) );
    ( void ) memsetc( ( void * ) RxPrsFD          , 0.0, SIZE( RxPrsFD          , cplx   ) );
    ( void ) memsetc( ( void * ) RxPrsFDCorr      , 0.0, SIZE( RxPrsFDCorr      , cplx   ) );
    ( void ) memsetc( ( void * ) RxPrsFDFinalCorr , 0.0, SIZE( RxPrsFDFinalCorr , cplx   ) );
    ( void ) memsetc( ( void * ) RxPrsTDFinalCorr , 0.0, SIZE( RxPrsTDFinalCorr , cplx   ) );
    ( void ) memsetd( ( void * ) RxPrsPhase       , 0.0, SIZE( RxPrsPhase       , double ) );
    ( void ) memsetd( ( void * ) RxPrsErrPhase    , 0.0, SIZE( RxPrsErrPhase    , double ) );
    ( void ) memsetd( ( void * ) NormX            , 0.0, SIZE( NormX            , double ) );
    ( void ) memset ( ( void * ) sampleIdx1, 0    , sizeof( sampleIdx1 ) );
    ( void ) memset ( ( void * ) sampleIdx2, 0    , sizeof( sampleIdx2 ) );


    ( void ) memsetd( ( void * ) &X         [ 0 ] , 0.0, SIZE( X                , double ) );
    MeanX   = 0.0;
    SigmaX  = 0.0;
    SigmaX2 = 0.0;
    ( void ) memsetd( ( void * ) &NormX     [ 0 ] , 0.0, SIZE( NormX            , double ) );
    ( void ) memsetd( ( void * ) &YA        [ 0 ] , 0.0, SIZE( YA               , double ) );
    ( void ) memsetd( ( void * ) &MeanYA    [ 0 ] , 0.0, SIZE( MeanYA           , double ) );
    ( void ) memsetd( ( void * ) &NormYA    [ 0 ] , 0.0, SIZE( NormYA           , double ) );
    ( void ) memsetd( ( void * ) &SigmaYA   [ 0 ] , 0.0, SIZE( SigmaYA          , double ) );
    ( void ) memsetd( ( void * ) &SigmaY2A  [ 0 ] , 0.0, SIZE( SigmaY2A         , double ) );
    ( void ) memsetd( ( void * ) &SigmaXYA  [ 0 ] , 0.0, SIZE( SigmaXYA         , double ) );
    ( void ) memsetd( ( void * ) &YB        [ 0 ] , 0.0, SIZE( YB               , double ) );
    ( void ) memsetd( ( void * ) &MeanYB    [ 0 ] , 0.0, SIZE( MeanYB           , double ) );
    ( void ) memsetd( ( void * ) &NormYB    [ 0 ] , 0.0, SIZE( NormYB           , double ) );
    ( void ) memsetd( ( void * ) &SigmaYB   [ 0 ] , 0.0, SIZE( SigmaYB          , double ) );
    ( void ) memsetd( ( void * ) &SigmaY2B  [ 0 ] , 0.0, SIZE( SigmaY2B         , double ) );
    ( void ) memsetd( ( void * ) &SigmaXYB  [ 0 ] , 0.0, SIZE( SigmaXYB         , double ) );
    ( void ) memsetd( ( void * ) &Y         [ 0 ] , 0.0, SIZE( Y                , double ) );
    ( void ) memsetd( ( void * ) &MeanY     [ 0 ] , 0.0, SIZE( MeanY            , double ) );
    ( void ) memsetd( ( void * ) &NormY     [ 0 ] , 0.0, SIZE( NormY            , double ) );
    ( void ) memsetd( ( void * ) &SigmaY    [ 0 ] , 0.0, SIZE( SigmaY           , double ) );
    ( void ) memsetd( ( void * ) &SigmaY2   [ 0 ] , 0.0, SIZE( SigmaY2          , double ) );
    ( void ) memsetd( ( void * ) &SigmaXY   [ 0 ] , 0.0, SIZE( SigmaXY          , double ) );

    ( void ) memset ( ( void * ) DmodRxPrs4QAM    , 0, sizeof( DmodRxPrs4QAM   ) );
    ( void ) memset ( ( void * ) DmodRxPrs16QAM   , 0, sizeof( DmodRxPrs16QAM  ) );
    ( void ) memset ( ( void * ) DmodRxPrs64QAM   , 0, sizeof( DmodRxPrs64QAM  ) );
    ( void ) memset ( ( void * ) DmodPRS4QAM      , 0, sizeof( DmodPRS4QAM     ) );
    ( void ) memset ( ( void * ) DmodPRS16QAM     , 0, sizeof( DmodPRS16QAM    ) );
    ( void ) memset ( ( void * ) DmodPRS64QAM     , 0, sizeof( DmodPRS64QAM    ) );

    BerQPSK  = 0.0;
    Ber4QAM  = 0.0;
    Ber16QAM = 0.0;
    Ber64QAM = 0.0;
    Qfr4QAM  = 0.0;
    Qfr16QAM = 0.0;
    Qfr64QAM = 0.0;
}


static void ReadPRSData( PrsBPA *pd )
{
    u32 nFFT = SYSPAR( nFFT );
    for ( int i = 0; i < nFFT; i++ )
    {
        RxPrsTD [ i ] = SYSPTR( pRxPRSTdCorFT [ i ] );
    }
}

static void CopyPRSPhase( PrsBPA *pd )
{
    s32 j    = 0;
    u32 nFFT = SYSPAR( nFFT );
    for ( u32 i = 0; i < nFFT; i++ )
    {
        u32 u           = SYSPTR( pTxSourceBuf[ i ] );
        if( u ) {
            sampleIdx1 [ i ] = i;
            sampleIdx2 [ i ] = ( i < nFFT / 2 ? i : i - nFFT );
            Cplx32 zu       = U32toCplx32( u );
            cplx z          = Cplx32toCplx( zu );
            TxPrs      [ i ] = z;
            TxPrsPhase [ i ] = carg ( z );
            j++;
        }
        else
        {
            sampleIdx1 [ i ] = -1;
            sampleIdx2 [ i ] = 0;
            TxPrs      [ i ] = 0.0;
            TxPrsPhase [ i ] = 0.0;
        }
    }
    nSams = j;
}

static void CalcPhaseError( PrsBPA *pd )
{
    u32 nFFT      = SYSPAR( nFFT );
    double nFFTd  = ( double ) nFFT;
    double nSamsd = ( double ) nSams;
    u32 j = 0;

    MeanX = 0.0; SigmaX = 0.0; SigmaX2 = 0.0;
    for ( u32 i = 0; i < nFFT; i++ )
    {
        if ( sampleIdx1 [ i ] >= 0 )
        {
            X [ j ] = ( double ) sampleIdx2 [ i ];
            SigmaX += X [ j ];
            j++;
        }
    }
    MeanX   = SigmaX / nSamsd;

    j = 0;
    for ( u32 i = 0; i < nFFT; i++ )
    {
        if ( sampleIdx1 [ i ] >= 0 )
        {
            NormX [ j ] = X [ j ] - MeanX;
            SigmaX  += NormX [ j ];
            SigmaX2 += NormX [ j ] * NormX [ j ];
            j++;
        }
    }

    ridx = 0;
    for ( u32 i = 0; i < SYS_N_CHAN_PRSBPA; i++ )
    {
        double freqCorrFact =  2.0 * M_PI * ( double ) FrqCorrFactor[ i ] / nFFTd;
        CalcCorr( pd, i, freqCorrFact, 0.0 );
        if ( SigmaY2 [ i ] < SigmaY2 [ ridx ] ) {
            ridx = i;
        }
    }
    BPARowIndex = ridx - ( SYS_N_CHAN_PRSBPA - 1 ) / 2;

}


static void FinalCorr( PrsBPA *pd )
{
    u32    nFFT  = SYSPAR( nFFT );
    double nFFTd = ( double ) nFFT;
    double deltafpp = DVCPAR( deltafpp );
    double   freqCorrFact = 2.0 * M_PI * deltafpp / nFFTd;
    CalcCorr( pd, SYS_N_CHAN_PRSBPA, freqCorrFact, 0.0 );
    fft( RxPrsFDCorrDfpp, RxPrsTDCorr [ SYS_N_CHAN_PRSBPA ], nFFT );

    CalcLinReg( pd );
    DVCPAR( theta0 ) = -DVCPAR( alpha );
    double theta0 = DVCPAR( theta0 );
    cplx phaseCorr = cexp( I * theta0 );
    for ( int i = 0; i < nFFT; i++ )
    {
        RxPrsFDFinalCorr [ i ]    = RxPrsFDCorrDfpp [ i ] * phaseCorr;
    }
    double SigmaA     = 0.0;
    double GainCorr   = 0.0;
    for ( int i = 0; i < nFFT; i++ )
    {
        if ( sampleIdx1 [ i ] >= 0 ) {
            SigmaA += cabs( RxPrsFDFinalCorr [ i ] );
        }
    }
    GainCorr = ( double ) nSams / SigmaA;
    for ( int i = 0; i < nFFT; i++ )
    {
        RxPrsFDFinalCorr [ i ] *= GainCorr / nFFTd;
    }
    ifft( RxPrsTDFinalCorr, RxPrsFDFinalCorr, nFFT );
}

// The PrsPHI Object is not currently used.
PrsPhase PrsPhiPhase( PrsBPA *pd, u32 n ) {
    PrsPhi *ps = pd->pPrsPhi;
    if (! ps->init ) {
        ps->Initialise( pd );
    }
    return ( ps->phase [ n ] );
}

void PrsPhiInit ( PrsBPA *pd )
{
    u32 nFFT = SYSPAR( nFFT );
    PrsPhi *ps = pd->pPrsPhi;
    if ( ps->init == false )
    {
        for ( int n = 0; n < nFFT; n++ )
        {
            u32 u = SYSPTR( pTxSourceBuf [ n ] );
            if        ( u == 0 ) {
                ps->phase [ n ] = PHI_UNDEF;
            } else if ( u & 0x00008000 ) {
                ps->phase [ n ] = PHI_PI;
            } else if ( u & 0x00007FFF ) {
                ps->phase [ n ] = PHI_ZERO;
            } else if ( u & 0x80000000 ) {
                ps->phase [ n ] = PHI_3_PI_BY_2;
            } else if ( u & 0x7FFF0000 ) {
                ps->phase [ n ] = PHI_PI_BY_2;
            }
        }
        ps->init = true;
    }

}


static double PrsPhaseError( PrsBPA *pd, cplx *p, u32 i )
{
    cplx z = 0.0;
    txPrsPhi.Initialise( pd );
    switch ( txPrsPhi.Phase( pd, i ) )
    {
    case PHI_ZERO :
        z = p [ i ];
        break;
    case PHI_PI_BY_2 :
        z = cimag( p [ i ] );
        break;
    case PHI_PI :
        z = I * cimag( p [ i ] ) - creal( p [ i ] );
        break;
    case PHI_3_PI_BY_2 :
        z = - cimag( p [ i ] );
        break;
    default:
        return ( 0 );
    }
    return( carg( z ) > 0 ? carg( z ) : 2 * M_PI + carg( z ) );
}
// End of PrsPhi object


static void CalcCorr( PrsBPA *pd, u32 cidx, double freqCorrFact, double timeCorrFact )
{
    u32    nFFT  = SYSPAR( nFFT );

    for ( u32 i = 0; i < nFFT; i ++ )
    {
        cplx freqCorr = cexp( I * freqCorrFact * ( double )( i + 1 ) );
        RxPrsTDCorr [ cidx ][ i ] = freqCorr * RxPrsTD[ i ];
    }
    fft( RxPrsFD[ cidx ], RxPrsTDCorr[ cidx ], nFFT );

    double SYA      = 0.0;
    double SYB      = 0.0;
    double ErrPhase = 0.0;


    u32 j = 0;
    for ( int i = 0; i < nFFT; i ++) {
        if ( sampleIdx1 [ i ] >= 0 ) {
            cplx timeCorr    = cexp( I * timeCorrFact * ( double ) sampleIdx2[ i ] );
            RxPrsFDCorr [ cidx ][ i ]  = timeCorr * RxPrsFD [ cidx ][ i ];
            RxPrsPhase  [ cidx ][ i ]  = carg( RxPrsFDCorr  [ cidx ][ i ] );
            ErrPhase = RxPrsPhase[ cidx ][ i ] - TxPrsPhase [ i ];
            YA [ cidx ][ j ] = ErrPhase;
            if ( YA [ cidx ][ j ] > M_PI ) {
                YA [ cidx ][ j ] = YA [ cidx ][ j ] - 2.0 * M_PI;
            }
            if ( YA [ cidx ][ j ] <  -M_PI ) {
                YA [ cidx ][ j ] = YA [ cidx ][ j ] + 2.0 * M_PI;
            }
            SYA += YA [ cidx ][ j ];

            YB [ cidx ][ j ] = ErrPhase;
            if ( YB [ cidx ][ j ] < 0 ) {
                YB [ cidx ][ j ] = YB [ cidx ][ j ] + 2.0 * M_PI;
            }
            if ( YB [ cidx ][ j ] >  ( 2 * M_PI ) ) {
                YB [ cidx ][ j ] = YB [ cidx ][ j ] - 2.0 * M_PI;
            }
            SYB += YB [ cidx ][ j ];

            j++;
        }
    }


    MeanYA    [ cidx ] = SYA / ( double ) nSams;
    MeanYB    [ cidx ] = SYB / ( double ) nSams;
    for ( u32 j = 0; j < nSams; j++ ) {
        NormYA   [ cidx ][ j ] = YA [ cidx ][ j ] - MeanYA [ cidx ];
        SigmaYA  [ cidx ] +=     YA [ cidx ][ j ];
        SigmaY2A [ cidx ] += NormYA [ cidx ][ j ] * NormYA [ cidx ][ j ];
        SigmaXYA [ cidx ] += NormYA [ cidx ][ j ] * NormX [ j ];
        NormYB   [ cidx ][ j ] = YB [ cidx ][ j ] - MeanYB [ cidx ];
        SigmaYB  [ cidx ] +=     YB [ cidx ][ j ];
        SigmaY2B [ cidx ] += NormYB [ cidx ][ j ] * NormYB [ cidx ][ j ];
        SigmaXYB [ cidx ] += NormYB [ cidx ][ j ] * NormX [ j ];
    }

    for ( u32 j = 0; j < nSams; j++ ) {
        if ( SigmaY2A [ cidx ] < SigmaY2B [ cidx ] ) {
            Y        [ cidx ][ j ] = YA     [ cidx ][ j ];
            MeanY    [ cidx ]      = MeanYA [ cidx ];
            NormY    [ cidx ][ j ] = NormYA [ cidx ][ j ];
        } else {
            Y        [ cidx ][ j ] = YB     [ cidx ][ j ];
            MeanY    [ cidx ]      = MeanYB [ cidx ];
            NormY    [ cidx ][ j ] = NormYB [ cidx ][ j ];
        }
    }

    for ( u32 j = 0; j < nSams; j++ ) {
        SigmaY   [ cidx ] +=     Y [ cidx ][ j ];
        SigmaY2  [ cidx ] += NormY [ cidx ][ j ] * NormY [ cidx ][ j ];
        SigmaXY  [ cidx ] += NormY [ cidx ][ j ] * NormX [ j ];
    }
}

static void CalcDelta( PrsBPA *pd, s32 ridx )
{
    if ( ridx == 0 )
    {
        DVCPAR( deltafpp ) = FrqCorrFactor [ 0 ];
        DVCPAR( theta0   ) = MeanY [ 0 ];
    }
    else if ( ridx == SYS_N_CHAN_PRSBPA - 1 )
    {
        DVCPAR( deltafpp ) = FrqCorrFactor [ SYS_N_CHAN_PRSBPA - 1 ];
        DVCPAR( theta0   ) = MeanY [ SYS_N_CHAN_PRSBPA - 1 ];
    }
    else
    {
        double A = SigmaY2 [ ridx - 1 ];
        double B = SigmaY2 [ ridx ];
        double C = SigmaY2 [ ridx + 1 ];
        double R = ( A - C ) / ( 2 * ( A + C - 2 * B ));
        DVCPAR( deltafpp ) = FrqCorrFactor [ ridx ] + R * ( FrqCorrFactor [ ridx + 1 ] - FrqCorrFactor [ ridx ] );
        Theta0CIR = -MeanY[ ( SYS_N_CHAN_PRSBPA - 1 ) / 2 ];
    }
}

static void CalcLinReg( PrsBPA *pd )
{
    double beta   = SigmaX * SigmaY [ SYS_N_CHAN_PRSBPA ] / SigmaX2;
    double alpha  = MeanY [ SYS_N_CHAN_PRSBPA ] - beta;
    DVCPAR( beta ) = beta;
    DVCPAR( deltatpp ) = beta;
    DVCPAR( alpha ) = alpha;
}

void CalcDeltas( PrsBPA *pd )
{
    ClearData( pd );
    ReadPRSData( pd );
    CopyPRSPhase( pd );
    CalcPhaseError( pd );
    CalcDelta  ( pd, ridx );
    FinalCorr  ( pd );
    DumpCorr   ( pd );
}


void DumpCorr( PrsBPA *pd )
{
    cprintf( "\n" );
    cprintf( "________________________________________________________\n" );
    cprintf( "for developer use:\n" );
    cprintf( "Sigma X            = %g\n", SigmaX  );
    cprintf( "Mean  X            = %g\n", MeanX   );
    cprintf( "Sigma X^2          = %g\n", SigmaX2 );
    cprintf( "Sigma Y            = %g\n", SigmaY  [ SYS_N_CHAN_PRSBPA ] );
    cprintf( "Mean  Y            = %g\n", MeanY   [ SYS_N_CHAN_PRSBPA ] );
    cprintf( "Sigma Y^2          = %g\n", SigmaY2 [ SYS_N_CHAN_PRSBPA ] );
    cprintf( "Sigma XY           = %g\n", SigmaXY [ SYS_N_CHAN_PRSBPA ] );
    cprintf( "BPA Row Index      = %i\n", toInt( BPARowIndex ) );
    cprintf( "________________________________________________________\n" );
    cprintf( "\n" );
    cprintf( "========================\n" );
    cprintf( "PRS CIR/BPA Synchronizer\n" );
    cprintf( "========================\n" );
    cprintf( "NFFT               = %u\n",   toUint( SYSPAR( nFFT  ) ) );
    cprintf( "NCPre              = %u\n",   toUint( SYSPAR( nCPre ) ) );
    cprintf( "Frequency          = %s\n",   RFFstrs [ SYSPAR( TxRxFreq  ) ] );
    cprintf( "Modulation         = %s\n",   Modstrs [ SYSPAR( ModType   ) ] );
    cprintf( "Bandwidth          = %u%%\n", toUint( SYSPAR( BWPercent ) ) );
    cprintf( "Soft decision bits = %u\n",   SYS_N_SOFT_BITS );
    cprintf( "\n" );
    cprintf( "DeltaT             = %i\n",   toInt( DVCPAR( DeltaT   ) ) );
    cprintf( "deltat'            = %g\n",   DVCPAR( deltatp  ) );
    cprintf( "deltat''           = %g\n",   DVCPAR( deltatpp ) );
    cprintf( "DeltaF             = %i\n",   toInt( DVCPAR( DeltaF   ) ) );
    cprintf( "deltaf'            = %g\n",   DVCPAR( deltafp  ) );
    cprintf( "deltaf''           = %g\n",   DVCPAR( deltafpp ) );
    cprintf( "theta0             = %g deg\n", DVCPAR( theta0 ) * 180.0 / M_PI );
    cprintf( "theta0CIR          = %g deg\n", Theta0CIR * 180.0 / M_PI );
    cprintf( "alpha              = %g\n",   DVCPAR( alpha  ) );
    cprintf( "beta               = %g\n",   DVCPAR( beta   ) );
    cprintf( "Combined delta f   = %g\n",   DVCPAR( deltafp ) + DVCPAR( deltafpp ));
    cprintf( "Sigma Error^2      = %g\n",   SigmaY2 [ SYS_N_CHAN_PRSBPA ] );
    cprintf( "\n" );
}

static void DumpCorrSymbFd ( PrsBPA *pd )
{
    DumpCplx( RxPrsFDFinalCorr, SYSPAR( nFFT ) );
}

static void DumpCorrSymbTd ( PrsBPA *pd )
{
    DumpCplx( RxPrsTDFinalCorr, SYSPAR( nFFT ) );
}


void DMatDump ( double *m, u32 nCol, u32 nRow, char name[]  )
{
    if      ( !nCol ) {
        DColDump( m, nRow, name );
    } else if ( !nRow ) {
        DRowDump( m, nCol, name );
    } else {
        cprintf( "\n" );
        if ( strlen( name ) ) {
            cprintf( "\n%s\n", name );
        }
        double *p = m;
        for ( int i = 0; i < nRow; i++ ) {
            cprintf( "%-5i ", toInt( i ) );
            for ( int j = 0; j < nCol; j++ ) {
                cprintf( " %8.5g", *p++ );
            }
            cprintf( "\n" );
            if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
                break;
            }
        }
    }
    cprintf( "\n" );
}

void DRowDump( double *m, u32 nCol, char name[] )
{
    cprintf( "\n" );
    if ( strlen( name ) ) {
        cprintf( "%s  ", name );
    }
    for( int i = 0; i < nCol; i++ ) {
        cprintf( "%8.5g  ", m[ i ] );
    }
    cprintf( "\n" );
}

void DColDump( double *m, u32 nRow, char name[] )
{
    cprintf( "\n" );
    if ( strlen( name ) ) {
        cprintf( "\n%s\n", name );
    }
    for ( int i = 0; i < nRow; i++ )
    {
        cprintf( "%-5i  %8.5g\n", toInt( i ), m[ i ] );
        if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
            break;
        }
    }
    cprintf( "\n" );
}

void CMatDump ( cplx *m, u32 nCol, u32 nRow, char name[]  )
{
    if      ( !nCol ) {
        CColDump( m, nRow, name );
    } else if ( !nRow ) {
        CRowDump( m, nCol, name );
    } else {
        cprintf( "\n" );
        if ( strlen( name ) ) {
            cprintf( "\n%s\n", name );
        }
        cplx *p = m;
        for ( int i = 0; i < nRow; i++ ) {
            cprintf( "%-5i", toInt( i ) );
            for ( int j = 0; j < nCol; j++ ) {
                cprintf( "  %8.5g  %8.5g", creal( *p ), cimag( *p ) );
                p++;
            }
            cprintf( "\n" );
            if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
                break;
            }
        }
    }
    cprintf( "\n" );
}

void CRowDump( cplx *m, u32 nCol, char name[] )
{
    cprintf( "\n" );
    if ( strlen( name ) ) {
        cprintf( "%s\n", name );
    }
    for( int i = 0; i < nCol; i++ ) {
        cprintf( "%8.5g %8.5g ", creal( m[ i ]), cimag( m[ i ]) );
    }
    cprintf( "\n" );
}

void CColDump( cplx *m, u32 nRow, char name[] )
{
    cprintf( "\n" );
    if ( strlen( name ) ) {
        cprintf( "%s\n", name );
    }
    for ( int i = 0; i < nRow; i++ )
    {
        cprintf( "%-5i  %8.5g  %8.5g\n", toInt( i ), creal( m[ i ]), cimag( m[ i ]) );
        if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
            break;
        }
    }
    cprintf( "\n" );
}

void SMatDump ( s32 *m, u32 nCol, u32 nRow, char name[]  )
{
    if        ( !nCol ) {
        SColDump( m, nRow, name );
    } else if ( !nRow ) {
        SRowDump( m, nCol, name );
    } else {
        cprintf( "\n" );
        if ( strlen( name ) ) {
            cprintf( "%s\n", name );
        }
        s32 *p = m;
        for ( int i = 0; i < nRow; i++ ) {
            cprintf( "%-5i", toInt( i ) );
            for ( int j = 0; j < nCol; j++ ) {
                cprintf( "  %-10i", toInt( *p ) );
            }
            cprintf( "\n" );
            if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
                break;
            }
        }
    }
    cprintf( "\n" );
}

void SRowDump( s32 *m, u32 nCol, char name[] )
{
    cprintf( "\n" );
    if ( strlen( name ) ) {
        cprintf( "%s ", name );
    }
    for( int i = 0; i < nCol; i++ ) {
        cprintf( "%-10i ", toInt( m[ i ] ) );
    }
    cprintf( "\n" );
}

void SColDump( s32 *m, u32 nRow, char name[] )
{
    if ( strlen( name ) ) {
        cprintf( "\n%s", name );
    }
    for ( int i = 0; i < nRow; i++ )
    {
        cprintf( "\n%-5i %-10i", toInt( i ), toInt( m[ i ] ) );
        if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
            break;
        }
    }
    cprintf( "\n" );
}


void UMatDump ( u32 *m, u32 nCol, u32 nRow, char name[]  )
{
    if        ( !nCol ) {
        UColDump( m, nRow, name );
    } else if ( !nRow ) {
        URowDump( m, nCol, name );
    } else {
        if ( strlen( name )) {
            cprintf( "\n%s", name );
        }
        u32 *p = m;
        for ( int i = 0; i < nRow; i++ ) {
            cprintf( "\n%-5i ", toInt( i ) );
            for ( int j = 0; j < nCol; j++ ) {
                cprintf( " %-10u", toUint( *p++ ) );
            }
            if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
                break;
            }
        }
    }
    cprintf( "\n" );
}

void URowDump( u32 *m, u32 nCol, char name[] )
{
    if ( strlen( name ) ) {
        cprintf( "\n%s", name );
    }
    for( int i = 0; i < nCol; i++ ) {
        cprintf( "%-10u ", toUint( m[ i ] ) );
    }
    cprintf( "\n" );
}

void UColDump( u32 *m, u32 nRow, char name[] )
{
    if ( strlen( name ) ) {
        cprintf( "\n%s", name );
    }
    for ( int i = 0; i < nRow; i++ )
    {
        cprintf( "\n%-5u %-10u", toInt( i ), toUint( m[ i ] ) );
        if ( ( ( i + 1 ) % 32 == 0 ) && ( pause( "" ) == CC_ESC ) ) {
            break;
        }
    }
    cprintf( "\n" );
}

void DumpChanRes( shell *psh )
{
    cprintf( "\n" );
    DRowDump( MeanY    , SYS_N_CHAN_PRSBPA, "Mean Y   " );
    DRowDump( SigmaY   , SYS_N_CHAN_PRSBPA, "Sigma Y  " );
    DRowDump( SigmaY2  , SYS_N_CHAN_PRSBPA, "Sigma Y2 " );
    DRowDump( SigmaXY  , SYS_N_CHAN_PRSBPA, "Sigma XY " );
    cprintf( "\nMean  X      : %g", MeanX               );
    cprintf( "\nSigma X      : %g", SigmaX              );
    cprintf( "\nSigma X^2    : %g", SigmaX2             );
    cprintf( "\nRow Idx      : %u", toUint( BPARowIndex ) );
    cprintf( "\n" );
}

