
C***********************************************************************
C   Portions of Models-3/CMAQ software were developed or based on      *
C   information from various groups: Federal Government employees,     *
C   contractors working on a United States Government contract, and    *
C   non-Federal sources (including research institutions).  These      *
C   research institutions have given the Government permission to      *
C   use, prepare derivative works, and distribute copies of their      *
C   work in Models-3/CMAQ to the public and to permit others to do     *
C   so.  EPA therefore grants similar permissions for use of the       *
C   Models-3/CMAQ software, but users are requested to provide copies  *
C   of derivative works to the Government without restrictions as to   *
C   use by others.  Users are responsible for acquiring their own      *
C   copies of commercial software associated with Models-3/CMAQ and    *
C   for complying with vendor requirements.  Software copyrights by    *
C   the MCNC Environmental Modeling Center are used with their         *
C   permissions subject to the above restrictions.                     *
C***********************************************************************

C RCS file, release, date & time of last delta, author, state, [and locker]
C $Header: /project/yoj/arc/CCTM/src/aero/aero5/Attic/AERO_INFO.f,v 1.1 2010/07/20 11:55:06 yoj Exp $

C what(1) key, module and SID; SCCS file; date and time of last delta:
C %W% %P% %G% %U%

C:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
c  MODULE AERO_INFO contains what was formerlly in include files
c     AEROSTUFF.EXT AND AERO_internal.EXT as well subroutines used in
c     the fifth version (AE5) of the modal aerosol dynamics model.
c
c                                 Coded by Dr. Francis S. Binkowski
c                                          fzb@hpcc.epa.gov
c
c
C  CONTAINS: Fundamental constants for air quality modeling
c            Subroutines for coagulation, mode merging, and aerosol 
c             size distribution calculations
c
C  DEPENDENT UPON:  none
c
C  REVISION HISTORY:
c
C    Adapted 6/92 by CJC from ROM's PI.EXT.
C
C    Revised 3/1/93 John McHenry to include constants needed by
C    LCM aqueous chemistry
C    Revised 9/93 by John McHenry to include additional constants
C    needed for FMEM clouds and aqueous chemistry
C
C    Revised 3/4/96 by Dr. Francis S. Binkowski to reflect current
C    Models3 view that MKS units should be used wherever possible,
C    and that sources be documentated. Some variables have been added
C    names changed, and values revised.
C
C    Revised 3/7/96 to have universal gas constant input and compute
C    gas constant is chemical form. TWOPI is now calculated rather
C    than input.
C
C    Revised 3/13/96 to group declarations and parameter statements.
C
C    Revised 9/13/96 to include more physical constants.
C    Revised 12/24/96 eliminate silly EPSILON, AMISS
C
C    Revised 1/6/97 to eliminate most derived constants
C
C    FSB 5/13/98 changed SGINICO from 2.5 to 2.2
C
C    Revised 6/4/05 by Uma Shankar & Prakash Bhave to add CBLK indices
C    needed for sea-salt chemistry; removed VSEAS index; added variables
C    needed for new TRANSFER subroutine
C
C    Revised 9/7/07 by Sergey L. Napelenok to add 19 CBLK and 5 VAPOR
C    indices needed for new SOA module (e.g., VTOL1J, VORGCJ, VBENZ1)
C    and to remove 4 CBLK and 3 VAPOR indices associated with the old 
C    SOA module (e.g., VORGAI, VCRESL)

C    Revised 3/12/08 by Golam Sarwar to add a heterogeneous reaction producing HONO 

C REFERENCES:
C
C      CRC76,        "CRC Handbook of Chemistry and Physics (76th Ed)",
C                     CRC Press, 1995
C      Hobbs, P.V.   "Basic Physical Chemistry for the Atmospheric 
C                     Sciences", Cambridge Univ. Press, 206 pp, 1995.
C      Snyder, J.P., "Map Projections-A Working Manual, U.S. Geological 
C                     Survey Paper 1395 U.S.GPO, Washington, DC, 1987.
C      Stull, R. B., "An Introduction to Boundary Layer Meteorology", 
C                     Kluwer, Dordrecht, 1988

      MODULE AERO_INFO
      
      IMPLICIT NONE

C *** set up indices for the array CBLK

      INTEGER   VSO4AJ    !   Accumulation mode sulfate aerosol
                          !   concentration

      INTEGER   VSO4AI    !   Aitken mode sulfate concentraton

      INTEGER   VNH4AJ    !   Accumulation mode aerosol ammonium
                          !   concentation

      INTEGER   VNH4AI    !   Aitken mode ammonium concentration

      INTEGER   VNO3AJ    !   Accumulation mode aerosol nitrate
                          !   concentration

      INTEGER   VNO3AI    !   Aitken mode nitrate concentration

      INTEGER   VALKJ     !   Accumulation mode SOA from "long" alkanes
                          !   (single semi-volatile product: SV_ALK)

      INTEGER   VXYL1J    !   Accumulation mode SOA from low-yield arom 
                          !   (1st semi-volatile product: SV_XYL1)

      INTEGER   VXYL2J    !   Accumulation mode SOA from low-yield arom 
                          !   (2nd semi-volatile product: SV_XYL2)

      INTEGER   VXYL3J    !   Accumulation mode SOA from low-yield arom 
                          !   (non-volatile product) 

      INTEGER   VTOL1J    !   Accumulation mode SOA from high-yield arom
                          !   (1st semi-volatile product: SV_TOL1)

      INTEGER   VTOL2J    !   Accumulation mode SOA from high-yield arom  
                          !   (2nd semi-volatile product: SV_TOL2)

      INTEGER   VTOL3J    !   Accumulation mode SOA from high-yield arom
                          !   (non-volatile product)

      INTEGER   VBNZ1J    !   Accumulation mode SOA from benzene
                          !   (1st semi-volatile product: SV_BNZ1)

      INTEGER   VBNZ2J    !   Accumulation mode SOA from benzene
                          !   (2nd semi-volatile product: SV_BNZ2)

      INTEGER   VBNZ3J    !   Accumulation mode SOA from benzene
                          !   (non-volatile product)

      INTEGER   VTRP1J    !   Accumulation mode SOA from monoterpenes
                          !   (1st semi-volatile product: SV_TRP1)

      INTEGER   VTRP2J    !   Accumulation mode SOA from monoterpenes  
                          !   (2nd semi-volatile product: SV_TRP2)

      INTEGER   VISO1J    !   Accumulation mode SOA from isoprene
                          !   (1st semi-volatile product: SV_ISO1)

      INTEGER   VISO2J    !   Accumulation mode SOA from isoprene  
                          !   (2nd semi-volatile product: SV_ISO2)

      INTEGER   VISO3J    !   Accumulation mode SOA from isoprene
                          !   (acid-catalyzed non-volatile product)

      INTEGER   VSQTJ     !   Accumulation mode SOA from sesquiterpenes
                          !   (single semi-volatile product: SV_SQT)
                          
      INTEGER   VOLGAJ    !   Accum mode anthropogenic organic oligomers

      INTEGER   VOLGBJ    !   Accum mode biogenic organic oligomers

      INTEGER   VORGCJ    !   Accumulation mode SOA produced in clouds

      INTEGER   VORGPAJ   !   Accumulation mode primary anthropogenic
                          !   organic aerosol concentration

      INTEGER   VORGPAI   !   Aitken mode primary anthropogenic
                          !   organic aerosol concentration

      INTEGER   VECJ      !   Accumulation mode elemental carbon

      INTEGER   VECI      !   Aitken mode elemental carbon

      INTEGER   VP25AJ    !   Accumulation mode primary PM2.5
                          !   concentration

      INTEGER   VP25AI    !   Aitken mode primary PM2.5 concentration

      INTEGER   VANTHA    !   coarse mode anthropogenic aerosol
                          !   concentration

      INTEGER   VSOILA    !   coarse mode soil-derived aerosol
                          !   concentration

      INTEGER   VAT0      !   Aitken mode number concentration

      INTEGER   VAC0      !   accum  mode number concentration

      INTEGER   VCO0      !   coarse mode number concentration

      INTEGER   VSURFAT   !   Index for Aitken mode surface area

      INTEGER   VSURFAC   !   Index for accumulatin mode surface area

      INTEGER   VSURFCO   !   Index for coarse mode surface area

      INTEGER   VAT2      !   Aitken mode mode 2nd moment
                          !   concentration

      INTEGER   VAC2      !   accumulation mode 2nd moment
                          !   concentration

      INTEGER   VCO2      !   Coarse mode 2nd moment
                          !   concentration

      INTEGER   VH2OAJ    !   Accumulation mode aerosol water
                          !   concentration

      INTEGER   VH2OAI    !   Aitken mode aerosol water
                          !   concentration

      INTEGER   VNAJ      !   Accumulation mode sodium

      INTEGER   VNAI      !   Aitken mode sodium

      INTEGER   VCLJ      !   Accumulation mode chloride

      INTEGER   VCLI      !   Aitken mode chloride

      INTEGER   VNAK      !   Coarse mode sodium

      INTEGER   VCLK      !   Coarse mode chloride

      INTEGER   VSO4K     !   Coarse mode sulfate

      INTEGER   VNO3K     !   Coarse mode nitrate

      INTEGER   VNH4K     !   coarse mode ammonium

      INTEGER   VH2OK     !   Coarse mode water
      
      INTEGER   VAT3      !   Aitken mode 3rd moment concentration

      INTEGER   VAC3      !   accumulation mode 3rd moment
                          !   concentration

      INTEGER   VCO3      !   coarse mode 3rd moment concentration

      INTEGER   VSULF     !   sulfuric acid vapor concentration

      INTEGER   VHNO3     !   nitric acid vapor concentration

      INTEGER   VNH3      !   ammonia gas concentration

      INTEGER   VHCL      !   hydrochloric acid vapor concentration

      INTEGER   VN2O5     !   N2O5 gas concentration
      
      INTEGER   VNO2      !  NO2 gas concentration

      INTEGER   VHONO     !  HONO gas concentration

      INTEGER   VSGAT     !  Aitken mode standard deviation

      INTEGER   VSGAC     !  Accumulation mode standard deviation

      INTEGER   VSGCO     !  Coarse mode geometric standard deviaton

      INTEGER   VDGAT     !  Aitken mode mean diameter

      INTEGER   VDGAC     !  accumulation mode mean diameter

      INTEGER   VDGCO     !  coarse mode mean diameter

      INTEGER   VHPLUSJ   !  hydrogen ion concentration in accumulation mode

      INTEGER   VHPLUSI   !  hydrogen ion concentration in Aitken mode

      INTEGER   VHPLUSK   !  hydrogen ion concentration in coarse mode

c *** indices for vapor-phase SVOCs in the CBLK array
       
      INTEGER   VVALK     !   semi-volatile alkane oxidation product
      
      INTEGER   VVXYL1    !   1st semi-volatile xylene oxidation product
      
      INTEGER   VVXYL2    !   2nd semi-volatile xylene oxidation product
      
      INTEGER   VVTOL1    !   1st semi-volatile toluene oxidation prod
      
      INTEGER   VVTOL2    !   2nd semi-volatile toluene oxidation prod
      
      INTEGER   VVBNZ1    !   1st semi-volatile benzene oxidation prod

      INTEGER   VVBNZ2    !   2nd semi-volatile benzene oxidation prod

      INTEGER   VVTRP1    !   1st semi-volatile terpene oxidation prod
      
      INTEGER   VVTRP2    !   2nd semi-volatile terpene oxidation prod

      INTEGER   VVISO1    !   1st semi-volatile isoprene oxidation prod

      INTEGER   VVISO2    !   2nd semi-volatile isoprene oxidation prod

      INTEGER   VVSQT     !   semi-volatile sesquiterpene oxidation prod


C...Geometric Constants:

      REAL*8      PI       ! PI (single precision 3.141593)
      PARAMETER ( PI = 3.14159265358979324D0 )

C...Fundamental Constants: ( Source: CRC76, pp 1-1 to 1-6)

      REAL        AVO      ! Avogadro's Constant [ 1/mol ]
      PARAMETER ( AVO = 6.0221367E23 )

      REAL        RGASUNIV ! universal gas constant [ J/mol-K ]
      PARAMETER ( RGASUNIV = 8.314510 )

      REAL        STDATMPA ! standard atmosphere  [ Pa ]
      PARAMETER ( STDATMPA = 101325.0 )

      REAL        STDTEMP  ! Standard Temperature [ K ]
      PARAMETER ( STDTEMP = 273.15 )

      REAL        STFBLZ   ! Stefan-Boltzmann [ W/(m**2 K**4) ]
      PARAMETER ( STFBLZ = 5.67051E-8 )

C...Atmospheric Constants:

      REAL        MWAIR    ! mean molecular weight for dry air [ g/mol ]
                           ! 78.06%  N2, 21% O2 and 0.943% A on a mole
                           ! fraction basis. ( Source : Hobbs, 1995) pp 69-70.
      PARAMETER ( MWAIR = 28.9628 )

      REAL        MWWAT    ! mean molecular weight for water vapor [ g/mol ]
      PARAMETER ( MWWAT = 18.0153 )

C...mathematical constants:

      REAL        TWOPI    ! 2 * PI
      PARAMETER ( TWOPI = 2.0 * PI )

      REAL        PI6      ! PI/6
      PARAMETER ( PI6 = PI / 6.0 )

      REAL        PI180    ! degrees-to-radians:  PI/180
      PARAMETER ( PI180 = PI / 180.0 )

      REAL        RPI180  ! radians-to-degrees:  180/PI
      PARAMETER ( RPI180 = 180.0 / PI )

      REAL        THREEPI  !  3*PI
      PARAMETER ( THREEPI = 3.0 * PI )

      REAL        F6DPI    !  6/PI
      PARAMETER ( F6DPI = 6.0 / PI )

      REAL        F6DPI9   !  1.0e9 * 6/PI
      PARAMETER ( F6DPI9 = 1.0E9 * F6DPI )

      REAL        F6DPIM9  ! 1.0e-9 * 6/PI
      PARAMETER ( F6DPIM9 = 1.0E-9 * F6DPI )

      REAL        SQRTPI   !  SQRT( PI )
      PARAMETER ( SQRTPI = 1.7724539 )

      REAL        SQRT2    !  SQRT( 2 )
      PARAMETER ( SQRT2 = 1.4142135623731 )

      REAL        LGSQT2   !  ln( sqrt( 2 ) )
      PARAMETER ( LGSQT2 = 0.34657359027997 )

      REAL        DLGSQT2  !  1/ln( sqrt( 2 ) )
      PARAMETER ( DLGSQT2 = 1.0 / LGSQT2 )

      REAL        ONE3     !  1/3
      PARAMETER ( ONE3 = 1.0 / 3.0 )

      REAL        TWO3     !  2/3
      PARAMETER ( TWO3 = 2.0 / 3.0 )

C...physical constants:

      REAL        BOLTZ    ! Boltzmann's Constant [ J / K]
      PARAMETER ( BOLTZ = RGASUNIV / AVO )

C...component densities [ kg/m**3 ]

      REAL        RHOSO4   !  bulk density of aerosol sulfate
      PARAMETER ( RHOSO4 = 1.8e3 )

      REAL        RHONH4   !  bulk density of aerosol ammonium
      PARAMETER ( RHONH4 = 1.8e3 )

      REAL        RHONO3   ! bulk density of aerosol nitrate
      PARAMETER ( RHONO3 = 1.8e3 )

      REAL        RHOH2O   !  bulk density of aerosol water
      PARAMETER ( RHOH2O = 1.0e3 )

      REAL        RHOORG   ! bulk density for aerosol organics
      PARAMETER ( RHOORG = 2.0e3 )

      REAL        RHOSOIL  ! bulk density for aerosol soil dust
      PARAMETER ( RHOSOIL = 2.6e3 )

      REAL        RHOSEAS  ! bulk density for marine aerosol
      PARAMETER ( RHOSEAS = 2.2e3 )

      REAL        RHOANTH  ! bulk density for anthropogenic aerosol
      PARAMETER ( RHOANTH = 2.2e3 )

C...Factors for converting aerosol mass concentration [ ug m**-3] to
C...   to 3rd moment concentration [ m**3 m^-3]

      REAL        SO4FAC
      PARAMETER ( SO4FAC = F6DPIM9 / RHOSO4 )

      REAL        NH4FAC
      PARAMETER ( NH4FAC = F6DPIM9 / RHONH4 )

      REAL        H2OFAC
      PARAMETER ( H2OFAC = F6DPIM9 / RHOH2O )

      REAL        NO3FAC
      PARAMETER ( NO3FAC = F6DPIM9 / RHONO3 )

      REAL        ORGFAC
      PARAMETER ( ORGFAC = F6DPIM9 / RHOORG )

      REAL        SOILFAC
      PARAMETER ( SOILFAC = F6DPIM9 / RHOSOIL )

      REAL        SEASFAC
      PARAMETER ( SEASFAC = F6DPIM9 / RHOSEAS )

      REAL        ANTHFAC
      PARAMETER ( ANTHFAC = F6DPIM9 / RHOANTH )

      REAL        P0       !  starting standard surface pressure [ Pa ]
      PARAMETER ( P0 = 101325.0 )

      REAL        T0       !  starting standard surface temperature [ K ]
      PARAMETER ( T0 = 288.15 )

      REAL        SGINIAT   !  initial sigma-G for Aitken mode
      PARAMETER ( SGINIAT = 1.70 )

      REAL        SGINIAC   !  initial sigma-G for accumulation mode
      PARAMETER ( SGINIAC = 2.00 )

      REAL        SGINICO   ! initial sigma-G for coarse mode
      PARAMETER ( SGINICO = 2.2 )

      REAL        DGINIAT   !  initial mean diameter for 
                            ! Aitken mode [ m ]
      PARAMETER ( DGINIAT = 0.01E-6 )

      REAL        DGINIAC   !  initial mean diameter for 
                            ! accumulation mode [ m ]
      PARAMETER ( DGINIAC = 0.07E-6 )

      REAL        DGINICO    ! initial mean diameter for 
                             ! coarse mode [ m ]
      PARAMETER ( DGINICO = 1.0E-6 )

C... PARAMETERS used in partitioning volatile inorganics (subroutine VOLINORG)

C *** molecular weights, hardcoded to match values in mechanism files

      REAL        MWNO3            ! molecular weight for NO3
      PARAMETER ( MWNO3  = 62.0 )

      REAL        MWHNO3           ! molecular weight for HNO3
      PARAMETER ( MWHNO3 = 63.0 )

      REAL        MWSO4            ! molecular weight for SO4
      PARAMETER ( MWSO4  = 96.0 )

      REAL        MWH2SO4          ! molecular weight for H2SO4
      PARAMETER ( MWH2SO4  = 98.0 )

      REAL        MWNH3            ! molecular weight for NH3
      PARAMETER ( MWNH3  = 17.0 )

      REAL        MWNH4            ! molecular weight for NH4
      PARAMETER ( MWNH4  = 18.0 )

      REAL        MWN2O5           ! molecular weight for N2O5
      PARAMETER ( MWN2O5 = 108.0 )

      REAL        MWNA             ! molecular weight for Na
      PARAMETER ( MWNA   =  23.0 )

      REAL        MWCL             ! molecular weight for Cl
      PARAMETER ( MWCL   =  35.0 )

      REAL        MWHCL            ! molecular weight for HCl
      PARAMETER ( MWHCl  =  36.5 )

      REAL        MWNO2
      PARAMETER ( MWNO2  = 46.0 )  ! molecular weight for NO2

      REAL        MWHONO
      PARAMETER ( MWHONO = 47.0 )  ! molecular weight for HONO

C *** conversion factors for thermodynamics vars

      REAL        FAERNH4          ! for ug  -> mole
      PARAMETER ( FAERNH4  = 1.0E-6 / MWNH4 )

      REAL        FAERNO3          ! for ug  -> mole
      PARAMETER ( FAERNO3  = 1.0E-6 / MWNO3 )

      REAL        FAERNH3          ! for ug  -> mole
      PARAMETER ( FAERNH3  = 1.0E-6 / MWNH3 )

      REAL        FAERHNO3         ! for ug  -> mole
      PARAMETER ( FAERHNO3 = 1.0E-6 / MWHNO3 )

      REAL        FAERH2SO4        ! for ug  -> mole
      PARAMETER ( FAERH2SO4 = 1.0E-6 / MWH2SO4 )

      REAL        FAERN2O5         ! for ug  -> mole
      PARAMETER ( FAERN2O5 = 1.0E-6 / MWN2O5 )

      REAL        FAERNO2
      PARAMETER ( FAERNO2  = 1.0E-6 / MWNO2 )  ! for ug  -> mole

      REAL        FAERHONO 
      PARAMETER ( FAERHONO = 1.0E-6 / MWHONO ) ! for ug  -> mole

      REAL        FAERSO4          ! for ug  -> mole
      PARAMETER ( FAERSO4  = 1.0E-6 / MWSO4 )

      REAL        FAERH2O          ! for ug  -> mole
      PARAMETER ( FAERH2O  = 1.0E-6 / MWWAT )

      REAL        FAERNA           ! for ug  -> mole
      PARAMETER ( FAERNA   = 1.0E-6 / MWNA  )

      REAL        FAERCL           ! for ug  -> mole
      PARAMETER ( FAERCL   = 1.0E-6 / MWCL  )

      REAL        FAERHCL          ! for ug  -> mole
      PARAMETER ( FAERHCL  = 1.0E-6 / MWHCL )

      REAL        DFNH3           ! for mole  -> ug
      PARAMETER ( DFNH3    = 1.0 / FAERNH3 )

      REAL        DFHNO3           ! for mole  -> ug
      PARAMETER ( DFHNO3   = 1.0 / FAERHNO3 )

      REAL        DFNO2 
      PARAMETER ( DFNO2  = 1.0 / FAERNO2 )     ! for mole  -> ug

      REAL        DFHONO
      PARAMETER ( DFHONO = 1.0 / FAERHONO )    ! for mole  -> ug

      REAL        DFHCL           ! for mole  -> ug
      PARAMETER ( DFHCL    = 1.0 / FAERHCL )

      REAL        DFH2O            ! for mole  -> ug
      PARAMETER ( DFH2O    = 1.0 / FAERH2O )

      REAL        DFNH4            ! for mole  -> ug
      PARAMETER ( DFNH4    = 1.0 / FAERNH4 )

      REAL        DFNO3            ! for mole  -> ug
      PARAMETER ( DFNO3    = 1.0 / FAERNO3 )

      REAL        DFCL            ! for mole  -> ug
      PARAMETER ( DFCL     = 1.0 / FAERCL  )

C...Variables used in partitioning of volatile inorganics

      INTEGER   NMODES          ! no. of chemically active aerosol modes 
      PARAMETER (NMODES = 3)    
                                
      INTEGER   NVOLINORG       ! no. of volatile inorganic spcs
      PARAMETER (NVOLINORG = 3) ! NH4, Cl, NO3
      INTEGER   NINORG          
      PARAMETER (NINORG = NVOLINORG + 3) ! add SO4, Na, and H+

      INTEGER         KNH4           ! index for inorganic species  NH4
      INTEGER         KNO3           !     "         "      "       NO3
      INTEGER         KCL            !     "         "      "       Cl
      INTEGER         KSO4           !     "         "      "       SO4
      INTEGER         KNA            !     "         "      "       Na
      INTEGER         KHP            !     "         "      "       H+

      PARAMETER (KNH4 = 1, KNO3 = 2, KCL  = 3,
     $           KSO4 = 4, KNA = 5, KHP = 6)

      CONTAINS

c //////////////////////////////////////////////////////////////////
c  FUNCTION GETAF returns the value of "Xnum" in Equations 10a and 10c
c   of Binkowski and Roselle (2003), given the number concentrations, 
c   median diameters, and natural logs of the geometric standard
c   deviations, in two lognormal modes.  The value returned by GETAF 
c   is used subsequently in the mode merging calculations:
c         GETAF = ln( Dij / Dgi ) / ( SQRT2 * ln(Sgi) )
c   where Dij is the diameter of intersection,
c         Dgi is the median diameter of the smaller size mode, and
c         Sgi is the geometric standard deviation of smaller mode.
c   A quadratic equation is solved to obtain GETAF, following the 
c   method of Press et al.
c  
c  REFERENCES:
c   1. Binkowski, F.S. and S.J. Roselle, Models-3 Community 
c      Multiscale Air Quality (CMAQ) model aerosol component 1:
c      Model Description.  J. Geophys. Res., Vol 108, No D6, 4183
c      doi:10.1029/2001JD001409, 2003.
c   2. Press, W.H., S.A. Teukolsky, W.T. Vetterling, and B.P. 
c      Flannery, Numerical Recipes in Fortran 77 - 2nd Edition.  
c      Cambridge University Press, 1992.

      real function getaf(ni,nj,dgni,dgnj,xlsgi,xlsgj,sqrt2)
      implicit none
      real AA,BB,CC,DISC,QQ,alfa,L, yji
      real ni,nj,dgni,dgnj,xlsgi,xlsgj,sqrt2

c *** Store intermediate values used for the quadratic solution 
c     to reduce computational burden
      alfa = xlsgi / xlsgj
      yji = log(dgnj/dgni)/(sqrt2 * xlsgi)
      L = log( alfa * nj / ni)

c *** Calculate quadratic equation coefficients & discriminant
      AA = 1.0 - alfa * alfa
      BB = 2.0 * yji * alfa * alfa
      CC = L - yji * yji * alfa * alfa
      DISC = BB*BB - 4.0 * AA * CC

c *** If roots are imaginary, return a negative GETAF value so that no
c     mode merging takes place.
      if( DISC .lt. 0.0) then
        getaf = - 5.0       ! error in intersection
        return
      end if

c *** Equation 5.6.4 of Press et al.
      QQ = -0.5 * (BB + sign(1.0,BB) * sqrt(DISC) )

c *** Return solution of the quadratic equation that corresponds to a
c     diameter of intersection lying between the median diameters of
c     the 2 modes.
      getaf = CC / QQ       ! See Equation 5.6.5 of Press et al.
      
      return
      end  function getaf


c //////////////////////////////////////////////////////////////////
c  SUBROUTINE GETPAR calculates the 3rd moments (M3), masses, aerosol
c   densities, and geometric mean diameters (Dg) of all 3 modes, and the 
c   natural logs of geometric standard deviations (Sg) of the 
c   Aitken and accumulation modes.
c
c   The input logical variable, M3_WET_FLAG, dictates whether the 
c   calculations in GETPAR are to assume that the aerosol is "wet" or
c   "dry."  In the present context, a "wet" aerosol consists of all
c   chemical components of the aerosol.  A "dry" aerosol excludes 
c   particle-bound water and also excludes secondary organic aerosol.
c
c   NOTE! 2nd moment concentrations (M2) are passed into GETPAR in the 
c   CBLK array and are modified within GETPAR only in the event that
c   the Sg value of a given mode has gone outside of the acceptable
c   range (1.05 to 2.50).  The GETPAR calculations implicitly assume
c   that the input value of M2 is consistent with the input value of
c   M3_WET_FLAG.  If, for example, the input M2 value was calculated
c   for a "dry" aerosol and the M3_WET_FLAG is .TRUE., GETPAR would
c   incorrectly adjust the M2 concentrations!
c
c  KEY SUBROUTINES/FUNCTIONS CALLED:  NONE
c
c  REVISION HISTORY:
C   US & CJC 3/95 adapted from EAM2's MODPAR and INIT3
C   FSB 07/23/96 use COMMON blocks and small blocks instead of large 3-d
C       arrays, and assume a fixed std.
c   FSB 12/06/96 include coarse mode
c   FSB 01/10/97 have arrays passed in call vector
C   FSB 01/04/99 use a variable geometric standard deviation in Aitken 
c       and accumulation modes using the 2nd moment
c   FSB 07/22/99 changed minimum sigma_g from 1.1 to 1.05, following
c       suggestion from Dr. Ingmar Ackermann
c   FSB 12/09/99 eliminate arrays
c   SJR 12/12/03 remove SOA from "dry" aerosol distribution
c   PVB 01/08/04 transfer new DGATK, DGACC, SGATK, and SGACC to CBLK
c   US & PVB 06/04/05 add sea salt species to the calculation of modal
c       third moments and mass concentrations
c   SLN 09/07/07 removed Aitken-mode SOA, added new SOA species
c   PVB 10/24/07 updated defn of DRY aerosol to include nonvolatile SOA
c   DCW 01/07/08 rearranged calculation of wet 3rd moments to avoid NaN
c       on some compilers (using the M3AUGM variable)
c   JTK 4/24/08 added 'LIMIT_Sg' argument. When LIMIT_Sg = T, the 
c       standard deviations are fixed to their
c       input value (the approach could be modified to limit the change
c       in Sg to a percentage of its input value)
c
c  REFERENCES:
c   1. Binkowski, F.S. Aerosols in Models-3 CMAQ, Chapter 10 of Science
c      Algorithms of the EPA Models-3 Community Multiscale Air Quality
c      (CMAQ) Modeling System, EPA/R-99/030, March 1999.
c      Available at: http://www.epa.gov/asmdnerl/models3
c        
c   2. Binkowski, F.S. and S.J. Roselle, Models-3 Community 
c      Multiscale Air Quality (CMAQ) model aerosol component 1:
c      Model Description.  J. Geophys. Res., Vol 108, No D6, 4183
c      doi:10.1029/2001JD001409, 2003.

      SUBROUTINE GETPAR(  NSPCSDA, CBLK,
     &                    PMASSAT, PMASSAC, PMASSCO,
     &                    PDENSAT, PDENSAC, PDENSCO,
     &                    DGATK, DGACC, DGCOR,
     &                    XXLSGAT, XXLSGAC, XXLSGCO,
     &                    M3_WET_FLAG, LIMIT_Sg    )

      IMPLICIT NONE

c    Input variables

      INTEGER NSPCSDA       ! number of species in CBLK
      REAL CBLK( NSPCSDA  ) ! main array of variables, also output
      LOGICAL LIMIT_Sg      ! fix crse and acc Sg's to the input value?

c    Output variables

      REAL PMASSAT   ! Aitken mode mass concentration: [ ug / m**3 ]
      REAL PMASSAC   ! accumulation mode mass conc:    [ ug / m**3 ]
      REAL PMASSCO   ! coarse mode mass concentration: [ ug / m**3 ]

      REAL PDENSAT   ! Aitken mode avg particle density [ kg / m**3 ]
      REAL PDENSAC   ! accumulation mode particle density [ kg / m**3 ]
      REAL PDENSCO   ! coarse mode particle density [ kg / m**3 ]

      REAL DGATK     ! Aitken mode geometric mean diameter [ m ]
      REAL DGACC     ! accumulation mode geometric mean diameter [ m ]
      REAL DGCOR     ! coarse mode geometric mean diameter [ m ]

      REAL XXLSGAT   ! Aitken mode log of geometric standard deviation
      REAL XXLSGAC   ! accumulation mode log of geometric std deviation
      REAL XXLSGCO   ! coarse mode log of geometric std deviation

      LOGICAL M3_WET_FLAG ! TRUE  = include H2O and SOA in 3rd moment
                          ! FALSE = exclude H2O and SOA from 3rd moment

C *** INTERNAL

      CHARACTER*16  PNAME
       PARAMETER( PNAME = 'GETPAR          ')

      REAL*8 XXM0, XXM2, XXM3 ! temporary storage of moment conc's
      REAL*8 XFSUM            ! (ln(M0)+2ln(M3))/3; used in Sg calcs
      REAL*8 LXFM2            ! ln(M2); used in Sg calcs
      REAL*8 L2SGAT, L2SGAC, L2SGCO   ! square of ln(Sg); used in diameter calcs
      REAL   ESAT36, ESAC36, ESCO36   ! exp(4.5*L2SG); used in diameter calcs

      REAL   M3AUGM           ! temp variable for wet 3rd moment calcs

      REAL*8 ONE3D
       PARAMETER( ONE3D = 1.0D0 / 3.0D0 )
      REAL*8 TWO3D
       PARAMETER( TWO3D = 2.0D0 * ONE3D )

      REAL        CONMIN  ! minimum concentration [ ug/m**3 ]
       PARAMETER ( CONMIN = 1.0E-30 )
      REAL        DGMIN   ! minimum particle diameter [ m ]
       PARAMETER ( DGMIN = 1.0E-09 )
      REAL        DENSMIN ! minimum particle density [ kg/m**3 ]
       PARAMETER ( DENSMIN = 1.0E03 )

      REAL*8 MINL2SGCO, MAXL2SGCO ! min/max value of ln(Sg)**2 for coarse mode
      REAL*8 MINL2SGAC, MAXL2SGAC ! min/max value of ln(Sg)**2 for accum mode
      REAL*8 MINL2SGAT, MAXL2SGAT ! min/max value of ln(Sg)**2 for aitken mode

      REAL*8 MINL2SG ! minimum value of ln(Sg)**2  for Aitken & LIMIT_Sg = F
       PARAMETER( MINL2SG = 2.380480480d-03 ) ! minimum sigma_g = 1.05
      REAL*8 MAXL2SG ! maximum value of ln(Sg)**2  for Aitken & LIMIT_Sg = F
       PARAMETER( MAXL2SG = 8.39588705d-1 )   ! maximum sigma_g = 2.5

c ------------------ *** Begin solution code *** ----------------------

C *** Set bounds for ln(Sg)**2

      IF (LIMIT_Sg == .TRUE.) THEN
        MINL2SGCO = XXLSGCO**2
        MAXL2SGCO = XXLSGCO**2
        MINL2SGAC = XXLSGAC**2
        MAXL2SGAC = XXLSGAC**2
        MINL2SGAT = XXLSGAT**2
        MAXL2SGAT = XXLSGAT**2
      ELSE
        MINL2SGCO = MINL2SG
        MAXL2SGCO = MAXL2SG
        MINL2SGAC = MINL2SG
        MAXL2SGAC = MAXL2SG
        MINL2SGAT = MINL2SG
        MAXL2SGAT = MAXL2SG
      ENDIF

C *** Calculate aerosol 3rd moment concentrations [ m**3 / m**3 ]

      CBLK( VAT3 ) = MAX( CONMIN,
     &       ( SO4FAC  * CBLK(  VSO4AI)  +
     &         NH4FAC  * CBLK(  VNH4AI)  +
     &         NO3FAC  * CBLK(  VNO3AI)  +
     &         ORGFAC  * CBLK(  VORGPAI) +
     &         ANTHFAC * CBLK(  VP25AI) +
     &         ANTHFAC * CBLK(  VECI) +
     &         SEASFAC * CBLK(  VNAI) +
     &         SEASFAC * CBLK(  VCLI) ) )

      CBLK( VAC3 ) = MAX( CONMIN,
     &       ( SO4FAC  * CBLK(  VSO4AJ)   +
     &         NH4FAC  * CBLK(  VNH4AJ)   +
     &         NO3FAC  * CBLK(  VNO3AJ)   +
     &         ORGFAC  * CBLK(  VORGPAJ)  +
     &         ORGFAC  * CBLK(  VXYL3J)  +
     &         ORGFAC  * CBLK(  VTOL3J)  +
     &         ORGFAC  * CBLK(  VBNZ3J)  +
     &         ORGFAC  * CBLK(  VISO3J)  +
     &         ORGFAC  * CBLK(  VOLGAJ)  +
     &         ORGFAC  * CBLK(  VOLGBJ)  +
     &         ORGFAC  * CBLK(  VORGCJ)  +
     &         ANTHFAC * CBLK(  VP25AJ)  +
     &         ANTHFAC * CBLK(  VECJ) +
     &         SEASFAC * CBLK(  VNAJ) +
     &         SEASFAC * CBLK(  VCLJ) )   )

      CBLK( VCO3 ) = MAX( CONMIN,
     &       ( SO4FAC  * CBLK(  VSO4K)  +
     &         NH4FAC  * CBLK(  VNH4K)  +
     &         NO3FAC  * CBLK(  VNO3K)  +
     $         SOILFAC * CBLK(  VSOILA) +
     &         ANTHFAC * CBLK(  VANTHA) +
     &         SEASFAC * CBLK(  VNAK)   +
     &         SEASFAC * CBLK(  VCLK)   ) )

C *** Add water and SOA to third moment if M3_WET_FLAG is .true.
C     (assume no SOA in coarse mode)

      IF( M3_WET_FLAG ) THEN

        M3AUGM       = H2OFAC * CBLK( VH2OAI )
        CBLK( VAT3 ) = CBLK( VAT3 ) + M3AUGM

        M3AUGM       = H2OFAC * CBLK( VH2OAJ )
     &               + ORGFAC * CBLK( VALKJ )
     &               + ORGFAC * CBLK( VXYL1J ) 
     &               + ORGFAC * CBLK( VXYL2J )
     &               + ORGFAC * CBLK( VTOL1J )
     &               + ORGFAC * CBLK( VTOL2J )
     &               + ORGFAC * CBLK( VBNZ1J )
     &               + ORGFAC * CBLK( VBNZ2J )
     &               + ORGFAC * CBLK( VTRP1J )
     &               + ORGFAC * CBLK( VTRP2J )
     &               + ORGFAC * CBLK( VISO1J )
     &               + ORGFAC * CBLK( VISO2J )
     &               + ORGFAC * CBLK( VSQTJ )
        CBLK( VAC3 ) = CBLK( VAC3 ) + M3AUGM

        M3AUGM       = H2OFAC * CBLK( VH2OK )
        CBLK( VCO3 ) = CBLK( VCO3 ) + M3AUGM

      END IF ! check on M3_WET_FLAG


C *** Calculate modal mass concentrations [ ug/m**3 ]

      PMASSAT = MAX( CONMIN,
     &        ( CBLK( VSO4AI )  +
     &          CBLK( VNH4AI )  +
     &          CBLK( VNO3AI )  +
     &          CBLK( VORGPAI ) +
     &          CBLK( VP25AI )  +
     &          CBLK( VECI )  +
     &          CBLK( VNAI )  +
     &          CBLK( VCLI ) ) )

      PMASSAC = MAX( CONMIN,
     &        ( CBLK( VSO4AJ )  +
     &          CBLK( VNH4AJ )  +
     &          CBLK( VNO3AJ )  +
     &          CBLK( VORGPAJ ) +
     &          CBLK( VXYL3J )  +
     &          CBLK( VTOL3J )  +
     &          CBLK( VBNZ3J )  +
     &          CBLK( VISO3J )  +
     &          CBLK( VOLGAJ )  +
     &          CBLK( VOLGBJ )  +
     &          CBLK( VORGCJ )  +
     &          CBLK( VP25AJ )  +
     &          CBLK( VECJ )  +
     &          CBLK( VNAJ )  +
     &          CBLK( VCLJ ) ) )

      PMASSCO = MAX( CONMIN,
     &        ( CBLK(  VSO4K )  +
     &          CBLK(  VNH4K )  +
     &          CBLK(  VNO3K )  +
     $          CBLK(  VSOILA)  +
     &          CBLK(  VANTHA)  +
     &          CBLK(  VNAK)    +
     &          CBLK(  VCLK)  ) )

C *** Add water and SOA to third moment if M3_WET_FLAG is .true.
C     assume no SOA is in coarse mode

      IF( M3_WET_FLAG ) THEN

        PMASSAT = PMASSAT
     &          + CBLK( VH2OAI )
        PMASSAC = PMASSAC
     &          + CBLK( VH2OAJ )
     &          + CBLK( VALKJ )
     &          + CBLK( VXYL1J )
     &          + CBLK( VXYL2J )
     &          + CBLK( VTOL1J )
     &          + CBLK( VTOL2J )
     &          + CBLK( VBNZ1J )
     &          + CBLK( VBNZ2J )
     &          + CBLK( VTRP1J )
     &          + CBLK( VTRP2J )
     &          + CBLK( VISO1J )
     &          + CBLK( VISO2J )
     &          + CBLK( VSQTJ )
        PMASSCO = PMASSCO
     &          + CBLK( VH2OK  )

      END IF  ! check on M3_WET_FLAG


C *** Calculate modal average particle densities [ kg m**-3 ]

      PDENSAT = MAX( DENSMIN,
     &               ( F6DPIM9 * PMASSAT / CBLK( VAT3) ) )
      PDENSAC = MAX( DENSMIN,
     &               ( F6DPIM9 * PMASSAC / CBLK( VAC3) ) )
      PDENSCO = MAX( DENSMIN,
     &               ( F6DPIM9 * PMASSCO / CBLK( VCO3) ) )


C *** Calculate geometric standard deviations as follows:
c        ln^2(Sg) = 1/3*ln(M0) + 2/3*ln(M3) - ln(M2)
c     NOTES: 
c      1. Equation 10-5a of [Binkowski:1999] and Equation 5a of 
c         [Binkowski&Roselle:2003] contain typographical errors.
c      2. If the square of the logarithm of the geometric standard
c         deviation is out of an acceptable range, reset this value and
c         adjust the second moments to be consistent with this value.
c         In this manner, M2 is artificially increased when Sg exceeds
c         the maximum limit.  M2 is artificially decreased when Sg falls
c         below the minimum limit.

C *** Aitken Mode:

      XXM0 = CBLK( VAT0 )
      XXM2 = CBLK( VAT2 )
      XXM3 = CBLK( VAT3 )

      XFSUM =
     &   ONE3D * LOG( XXM0 )    +
     &   TWO3D * LOG( XXM3 )

      LXFM2 = LOG( XXM2 )
      L2SGAT =  XFSUM - LXFM2

      IF( L2SGAT .LT. MINL2SGAT ) THEN

       L2SGAT = MINL2SGAT
       LXFM2 = XFSUM - L2SGAT
       CBLK( VAT2 ) = EXP ( LXFM2 )

      ELSE IF ( L2SGAT .GT. MAXL2SGAT ) THEN

       L2SGAT =  MAXL2SGAT
       LXFM2 = XFSUM - L2SGAT
       CBLK( VAT2 ) = EXP ( LXFM2 )

      END IF ! test on L2SGAT

      ESAT36 = EXP( 4.5 * L2SGAT)
      XXLSGAT = SQRT( L2SGAT )

C *** accumulation mode:

      XXM0 = CBLK( VAC0 )
      XXM2 = CBLK( VAC2 )
      XXM3 = CBLK( VAC3 )

      XFSUM =
     &   ONE3D * LOG( XXM0 )    +
     &   TWO3D * LOG( XXM3 )

      LXFM2 = LOG( XXM2 )
      L2SGAC =  XFSUM - LXFM2

      IF( L2SGAC .LT. MINL2SGAC ) THEN

         L2SGAC = MINL2SGAC
         LXFM2 = XFSUM - L2SGAC
         CBLK(   VAC2 ) = EXP ( LXFM2 )

      ELSE IF ( L2SGAC .GT. MAXL2SGAC ) THEN

         L2SGAC =  MAXL2SGAC
         LXFM2 = XFSUM - L2SGAC
         CBLK( VAC2 ) = EXP ( LXFM2 )

      END IF ! test on L2SGAC

      ESAC36 = EXP( 4.5 * L2SGAC)
      XXLSGAC = SQRT( L2SGAC )

C *** coarse mode:

      XXM0 = CBLK( VCO0 )
      XXM2 = CBLK( VCO2 )
      XXM3 = CBLK( VCO3 )

      XFSUM =
     &   ONE3D * LOG( XXM0 )    +
     &   TWO3D * LOG( XXM3 )

      LXFM2 = LOG( XXM2 )
      L2SGCO =  XFSUM - LXFM2

      IF( L2SGCO .LT. MINL2SGCO ) THEN

        L2SGCO = MINL2SGCO
        LXFM2 = XFSUM - L2SGCO
        CBLK(   VCO2 ) = EXP ( LXFM2 )

      ELSE IF ( L2SGCO .GT. MAXL2SGCO ) THEN

        L2SGCO =  MAXL2SGCO
        LXFM2 = XFSUM - L2SGCO
        CBLK( VCO2 ) = EXP ( LXFM2 )

      END IF ! test on L2SGCO

      ESCO36 = EXP( 4.5 * L2SGCO)
      XXLSGCO = SQRT( L2SGCO )

C *** Calculate geometric mean diameters [ m ] using Equation 10-5b
c     of [Binkowski:1999] and Equation 5b of [Binkowski&Roselle:2003]
c        Dg^3  =  M3 / ( M0 * exp(4.5*ln^2(Sg)) )

      DGATK = MAX( DGMIN, (  CBLK( VAT3 ) /
     &           ( CBLK( VAT0 ) * ESAT36 ) ) ** ONE3 )

      DGACC  = MAX( DGMIN, (  CBLK( VAC3 ) /
     &           ( CBLK( VAC0 ) * ESAC36 ) ) ** ONE3 )

      DGCOR  = MAX( DGMIN, (  CBLK( VCO3) /
     &           ( CBLK( VCO0) * ESCO36) ) ** ONE3  )

C *** Update CBLK values of Dg and Sg

      CBLK( VSGAT ) = EXP( XXLSGAT )
      CBLK( VSGAC ) = EXP( XXLSGAC )
      CBLK( VSGCO ) = EXP( XXLSGCO )

      CBLK( VDGAT ) = DGATK
      CBLK( VDGAC ) = DGACC
      CBLK( VDGCO ) = DGCOR

      RETURN

      END  SUBROUTINE GETPAR

c //////////////////////////////////////////////////////////////////
c  SUBROUTINE INLET25 calculates the volume fraction of a given 
c   aerosol mode that would enter a sharp-cut PM2.5 inlet, using
c   equations from Jiang et al (2005).
c
c  KEY SUBROUTINES CALLED: none
c
c  KEY FUNCTIONS CALLED:  ERF
c
c  REVISION HISTORY:
c    Coded Jul 2005 by Prakash Bhave
c          Apr 2008 J.Kelly: corrected equation for Dst25 calculation
c
c  REFERENCES:
c   1. Jiang, W., Smyth, S., Giroux, E., Roth, H., Yin, D., Differences
c   between CMAQ fine mode particle and PM2.5 concentrations and their
c   impact on model performance evaluation in the Lower Fraser Valley,
c   Atmos. Environ., 40:4973-4985, 2006.

c   2. Meng, Z., Seinfeld, J.H., On the source of the submicrometer
c   droplet mode of urban and regional aerosols, Aerosol Sci. and 
c   Technology, 20:253-265, 1994.
c
      SUBROUTINE INLET25 ( DGN, XXLSG, RHOP, INFRAC )

      IMPLICIT NONE
      
c    Input variables
      REAL   DGN     ! geometric mean Stokes diameter by number [ m ]
      REAL   XXLSG   ! natural log of geometric standard deviation
      REAL   RHOP    ! average particle density [ kg/m**3 ]
      
c    Output variable
      REAL   INFRAC  ! fraction of particulate volume transmitted through inlet

c    Internal variables
      REAL DCA25     ! aerodynamic diameter cut point [ um ]
       PARAMETER ( DCA25 = 2.5 )
      REAL B         ! Cunningham slip-correction approximation param [ um ]
       PARAMETER ( B = 0.21470 )
      REAL DST25     ! Stokes diameter equivalent of DCA25
      REAL DG        ! DGN converted to [ um ]
      REAL ERFARG    ! argument of ERF, from Step#6 of Jiang et al. (2005)

c *** Error function approximation, from Meng & Seinfeld (1994)
      REAL        ERF        ! Error function
      REAL        XX         ! dummy argument for ERF
      ERF(XX)  = SIGN(1.0,XX) * SQRT(1.0 - EXP( -4.0 * XX * XX / PI ) )

c ------------------ *** Begin solution code *** ----------------------

c *** Convert 2.5um size cut to its equivalent Stokes diameter using
c     equation 2 of Jiang et al. (2006). Note: the equation in Step 5
c     of this paper has a typo (i.e., eq. 2 is correct).

      DST25 = 0.5 * ( SQRT( B**2 + 4.0 * DCA25 *
     &                     (DCA25 + B) * 1.0E+03 / RHOP ) - B )

c *** Calculate mass fraction with Dca < 2.5um, using ERF approximation
c      from Meng & Seinfeld (1994) and modified form of Fk(X) equation
c      in Step#6 of Jiang et al. (2005).

      DG = DGN * 1.0E+06
      ERFARG = ( LOG(DST25) - LOG(DG) ) / (SQRT2 * XXLSG) - 3. * XXLSG /
     &           SQRT2
      INFRAC = 0.5 * ( 1.0 + ERF( ERFARG ) )

      END  SUBROUTINE INLET25


c //////////////////////////////////////////////////////////////////
c  SUBROUTINE INTRACOAG_GH does Gauss-Hermite numerical quadrature
c   to calculate intramodal coagulation rates for number and second moment
c
c FSB This version runs in real*8 arithmetic
c
c *** this version calculates the coagulation coefficients
c     using the harmonic mean approach for both fm and nc cases.
c *** does gauss-hermite quadrature for intra-modal
c      coagulation integrals for 2nd moment
c     for a lognormal distribution
c      defined by dg,xlnsig,
c *** dg and xlnsig are the geometric mean diameters (meters)
c      and the logarithms of the
c     geometric standard deviations (dimensionless)
c     whose meaning is defined below at the end of the routine
c     ghxi, ghwi are the gauss-hermite weights and n is one-half the
c     number of abscissas, since an even number of abscissas is used

      subroutine intracoag_gh(lamda,kfm,knc,dg,xlnsig, quads11, quadn11)

      implicit none
      integer i,j
      real*8 lamda ! mean free path
      real*8 kfm, knc
      real dg, xlnsig
      real*8 quads11, quadn11
      real*8 pi
       parameter( pi = 3.14159265358979324d0)
      real*8 two3rds
       parameter( two3rds = 2.0d0 /  3.0d0 )
      real*8 sqrt2
       parameter(sqrt2 = 1.414213562373095d0 )
      real*8 sum1sfm, sum2sfm, sum1nfm, sum2nfm
      real*8 sum1snc, sum2snc, sum1nnc, sum2nnc
      real*8 xi, wxi, xf, dp1p,dp1m,dp1psq,dp1msq
      real*8 v1p,v1m, a2p,a2m,v2p,v2m
      real*8 yi,wyi,yf,dp2p,dp2m,dp2psq,dp2msq
      real*8 dspp,dsmp,dspm, dsmm
      real*8 bppfm,bmpfm,bpmfm,bmmfm
      real*8 bppnc,bmpnc,bpmnc,bmmnc
      real*8 xx1, xx2
      real*8 xbsfm, xbsnc, xbnfm, xbnnc
      real*8 betafm, betanc

       real*8     A               ! approx Cunningham corr. factor
       parameter( A = 1.246D0 )

       real*8     twoA
       parameter( twoA = 2.0d0 * A )

c *** Has a fixed number of Gauss-Herimite abscissas (n)
      integer n    ! one-half the number of abscissas
      parameter ( n = 5 )
      real*8 ghxi(n) ! Gauss-Hermite abscissas
      real*8 ghwi(n) ! Gauss-Hermite weights

C ** Values from Table 25.10 (page 924) of Abramowitz and Stegun,
c    Handbook of Mathematical Functions, National Bureau of Standards,
c  December 1965.

C    breaks in number to facilitate comparison with printed table

c *** tests show that 10 point is adquate.

      data ghxi/0.34290 13272 23705D0,
     &          1.03661 08297 89514D0,
     &          1.75668 36492 99882D0,
     &          2.53273 16742 32790D0,
     &          3.43615 91188 37738D0/,


     1     ghwi/6.10862 63373 53D-1,
     &          2.40138 61108 23D-1,
     &          3.38743 94455 48D-2,
     &          1.34364 57467 81D-3,
     &          7.64043 28552 33D-6/

C *** The following expressions are from Binkowski & Shanker
c     Jour. Geophys. Research. Vol. 100,no. d12, pp 26,191-26,209
c     December 20, 1995
C ***  for Free Molecular Eq. A5
        betafm(xx1, xx2) = kfm *
     &       sqrt(1.D0 / xx1**3  + 1.D0 / xx2**3 ) * (xx1 + xx2)**2

C ***  for Near Continuum  Eq. A6
        betanc(xx1, xx2) =  knc * (xx1 + xx2) *
     &                       ( 1.0D0 / xx1 + 1.0D0 / xx2  +
     &                     twoA * lamda * ( 1.0D0 / xx1 ** 2
     &                                    + 1.0D0 / xx2 **2 ) )


      sum1sfm = 0.D0
      sum1snc = 0.D0

      sum1nfm = 0.D0
      sum1nnc = 0.D0
      do 1 i=1,n

        sum2sfm = 0.D0
        sum2snc = 0.D0
        sum2nfm = 0.D0
        sum2nnc = 0.D0

        xi = ghxi(i)
        wxi = ghwi(i)
        xf = exp( sqrt2 * xi *xlnsig)
        dp1p = dg*xf
        dp1m = dg/xf
        dp1psq = dp1p*dp1p
        dp1msq = dp1m*dp1m
        v1p = dp1p*dp1psq
        v1m = dp1m*dp1msq
      do 11 j=1,n
        yi = ghxi(j)
        wyi = ghwi(j)
        yf = exp( sqrt2 * yi * xlnsig)
        dp2p = dg*yf
        dp2m = dg/yf
        dp2psq = dp2p*dp2p
        dp2msq = dp2m*dp2m
        a2p = dp2psq
        a2m = dp2msq
        v2p =  dp2p*dp2psq
        v2m =dp2m*dp2msq
        dspp = 0.5D0*(v1p+v2p)**two3rds - a2p
        dsmp = 0.5D0*(v1m+v2p)**two3rds - a2p
        dspm = 0.5D0*(v1p+v2m)**two3rds - a2m
        dsmm = 0.5D0*(v1m+v2m)**two3rds - a2m

        bppfm = betafm(dp1p,dp2p)
        bmpfm = betafm(dp1m,dp2p)
        bpmfm = betafm(dp1p,dp2m)
        bmmfm = betafm(dp1m,dp2m)

        bppnc = betanc(dp1p,dp2p)
        bmpnc = betanc(dp1m,dp2p)
        bpmnc = betanc(dp1p,dp2m)
        bmmnc = betanc(dp1m,dp2m)

        sum2sfm = sum2sfm + wyi*(dspp * bppfm + dspm * bpmfm
     &               +   dsmp * bmpfm + dsmm * bmmfm )

        sum2nfm = sum2nfm + wyi*(bppfm + bmpfm + bpmfm + bmmfm)

        sum2snc = sum2snc + wyi*(dspp * bppnc + dspm * bpmnc
     &               +   dsmp * bmpnc + dsmm * bmmnc )
        sum2nnc = sum2nnc + wyi*(bppnc + bmpnc + bpmnc + bmmnc)

   11 continue
      sum1sfm = sum1sfm + wxi * sum2sfm
      sum1nfm = sum1nfm + wxi * sum2nfm

      sum1snc = sum1snc + wxi * sum2snc
      sum1nnc = sum1nnc + wxi * sum2nnc

    1 continue

      xbsfm   = -sum1sfm  / pi
      xbsnc   = -sum1snc  / pi

      quads11 =  xbsfm * xbsnc / ( xbsfm + xbsnc )

c *** quads11 is the intra-modal coagulation term for 2nd moment

      xbnfm   = 0.5D0 * sum1nfm  / pi
      xbnnc   = 0.5D0 * sum1nnc  / pi


      quadn11 =  xbnfm * xbnnc / ( xbnfm + xbnnc )

c *** quadn11 is the intra-modal coagulation term for number


      return
      end subroutine intracoag_gh 


c //////////////////////////////////////////////////////////////////
c  SUBROUTINE INTERCOAG_GH does Gauss-Hermite numerical quadrature
c   to calculate intermodal coagulation for number, 2nd, and 3rd moment
c
c FSB This version runs in real*8 arithmetic
c
c *** this version calculates the coagulation coefficients
c     using the harmonic mean approach for both fm and nc cases.
c *** does gauss-hermite quadrature for inter-modal
c      coagulation integrals for 2nd moment
c     for two lognormal distributions
c      defined by dg1,xlnsig1, dg2,xlnsig2
c *** dg and xlnsig are the geometric mean diameters (meters)
c      and the logarithms of the
c     geometric standard deviations (dimensionless)
c     whose meaning is defined below at the end of the routine
c     ghxi, ghwi are the gauss-hermite weights and n is one-half the
c     number of abscissas, since an even number of abscissas is used

      subroutine intercoag_gh(lamda,kfm,knc, dg1,dg2,
     &               xlnsig1,xlnsig2,
     &               quads12, quads21, quadn12, quadv12)

      implicit none
      integer i,j
      real*8 lamda ! mean free path
      real*8 kfm, knc
      real dg1, xlnsig1, dg2, xlnsig2
      real*8 quads12, quads21, quadn12, quadv12
      real*8 pi
       parameter( pi = 3.14159265358979324d0)
      real*8 two3rds
       parameter( two3rds = 2.0d0 /  3.0d0 )
      real*8 sqrt2
       parameter(sqrt2 = 1.414213562373095d0 )
      real*8 sum1s12fm, sum1s21fm, sum2s12fm, sum2s21fm
      real*8 sum1nfm, sum2nfm
      real*8 sum1vfm, sum2vfm
      real*8 sum1s12nc, sum1s21nc, sum2s12nc, sum2s21nc
      real*8 sum1nnc, sum2nnc
      real*8 sum1vnc, sum2vnc
      real*8 xi, wxi,xf, dp1p, dp1m, dp1psq, dp1msq
      real*8 a1p, a1m, v1p, v1m
      real*8 a2p, a2m, v2p, v2m
      real*8 yi, wyi, yf, dp2p, dp2m, dp2psq, dp2msq
      real*8 dspp, dsmp, dspm, dsmm
      real*8 bppfm, bmpfm, bpmfm, bmmfm
      real*8 bppnc, bmpnc, bpmnc, bmmnc
      real*8 xx1, xx2
      real*8 xbsfm, xbsnc, xbnfm, xbnnc, xbvfm, xbvnc
      real*8 betafm, betanc

       real*8     A               ! approx Cunningham corr. factor
       parameter( A = 1.246D0 )

       real*8     twoA
       parameter( twoA = 2.0d0 * A )

c *** Has a fixed number of Gauss-Herimite abscissas (n)
      integer n    ! one-half the number of abscissas
      parameter ( n = 5 )
      real*8 ghxi(n) ! Gauss-Hermite abscissas
      real*8 ghwi(n) ! Gauss-Hermite weights

C ** Values from Table 25.10 (page 924) of Abramowitz and Stegun,
c    Handbook of Mathematical Functions, National Bureau of Standards,
c  December 1965.

C    breaks in number to facilitate comparison with printed table

c *** tests show that 10 point is adquate.

      data ghxi/0.34290 13272 23705D0,
     &          1.03661 08297 89514D0,
     &          1.75668 36492 99882D0,
     &          2.53273 16742 32790D0,
     &          3.43615 91188 37738D0/,


     1     ghwi/6.10862 63373 53D-1,
     &          2.40138 61108 23D-1,
     &          3.38743 94455 48D-2,
     &          1.34364 57467 81D-3,
     &          7.64043 28552 33D-6/


C *** The following expressions are from Binkowski & Shanker
c     Jour. Geophys. Research. Vol. 100,no. d12, pp 26,191-26,209
c     December 20, 1995

C ***  for Free Molecular Eq. A5
        betafm(xx1, xx2) = kfm *
     &       sqrt(1.D0 / xx1**3  + 1.D0 / xx2**3 ) * (xx1 + xx2)**2

C ***  for Near Continuum  Eq. A6
        betanc(xx1, xx2) =  knc * (xx1 + xx2) *
     &                       ( 1.0D0 / xx1 + 1.0D0 / xx2  +
     &                     twoA * lamda * ( 1.0D0 / xx1 ** 2
     &                                    + 1.0D0 / xx2 **2 ) )

      sum1s12fm = 0.D0
      sum1s12nc = 0.D0
      sum1s21fm = 0.D0
      sum1s21nc = 0.D0
      sum1vnc = 0.D0
      sum1vfm = 0.D0
      sum1nfm = 0.D0
      sum1nnc = 0.D0
      do 1 i=1,n

        sum2s12fm = 0.D0
        sum2s12nc = 0.D0
        sum2s21fm = 0.D0
        sum2s21nc = 0.D0
        sum2nfm = 0.D0
        sum2nnc = 0.D0
        sum2vnc = 0.D0
        sum2vfm = 0.D0
        xi = ghxi(i)
        wxi = ghwi(i)
        xf = exp( sqrt2 * xi *xlnsig1)
        dp1p = dg1*xf
        dp1m = dg1/xf
        dp1psq = dp1p*dp1p
        dp1msq = dp1m*dp1m
        a1p = dp1psq
        a1m = dp1msq
        v1p = dp1p*dp1psq
        v1m = dp1m*dp1msq

      do 11 j=1,n
        yi  = ghxi(j)
        wyi = ghwi(j)
        yf = exp( sqrt2 * yi * xlnsig2)
        dp2p = dg2*yf
        dp2m = dg2/yf
        dp2psq = dp2p*dp2p
        dp2msq = dp2m*dp2m
        a2p  = dp2psq
        a2m  = dp2msq
        v2p  =  dp2p*dp2psq
        v2m  = dp2m*dp2msq
        dspp = (v1p+v2p)**two3rds - a2p
        dsmp = (v1m+v2p)**two3rds - a2p
        dspm = (v1p+v2m)**two3rds - a2m
        dsmm = (v1m+v2m)**two3rds - a2m

        bppfm = betafm(dp1p,dp2p)
        bmpfm = betafm(dp1m,dp2p)
        bpmfm = betafm(dp1p,dp2m)
        bmmfm = betafm(dp1m,dp2m)

        bppnc = betanc(dp1p,dp2p)
        bmpnc = betanc(dp1m,dp2p)
        bpmnc = betanc(dp1p,dp2m)
        bmmnc = betanc(dp1m,dp2m)


        sum2s12fm = sum2s12fm + wyi*(a1p * bppfm + a1p * bpmfm
     &               +   a1m * bmpfm + a1m * bmmfm )

        sum2s21fm = sum2s21fm + wyi*(dspp * bppfm + dspm * bpmfm
     &               +   dsmp * bmpfm + dsmm * bmmfm )


        sum2s12nc = sum2s12nc + wyi*(a1p * bppnc + a1p * bpmnc
     &               +   a1m * bmpnc + a1m * bmmnc )

        sum2s21nc = sum2s21nc + wyi*(dspp * bppnc + dspm * bpmnc
     &               +   dsmp * bmpnc + dsmm * bmmnc )

        sum2nfm = sum2nfm + wyi*(bppfm + bmpfm + bpmfm + bmmfm)

        sum2nnc = sum2nnc + wyi*(bppnc + bmpnc + bpmnc + bmmnc)

        sum2vfm = sum2vfm + wyi*(v1p*(bppfm + bpmfm) +
     &                           v1m*(bmpfm + bmmfm) )

        sum2vnc = sum2vnc + wyi*(v1p*(bppnc + bpmnc) +
     &                           v1m*(bmpnc + bmmnc) )

   11 continue

      sum1s12fm = sum1s12fm + wxi * sum2s12fm
      sum1s21fm = sum1s21fm + wxi * sum2s21fm
      sum1nfm   = sum1nfm + wxi * sum2nfm
      sum1vfm   = sum1vfm + wxi * sum2vfm

      sum1s12nc = sum1s12nc + wxi * sum2s12nc
      sum1s21nc = sum1s21nc + wxi * sum2s21nc
      sum1nnc   = sum1nnc + wxi * sum2nnc
      sum1vnc   = sum1vnc + wxi * sum2vnc

    1 continue

C *** Second moment intermodal coagulation coefficients

c FSB NOTE: the transfer of second moment is not symmetric.
c     See equations A3 & A4 of Binkowski & Shankar (1995)

c ***  to accumulation mode from Aitken mode

      xbsfm   = sum1s21fm  / pi
      xbsnc   = sum1s21nc  / pi

      quads21 =  xbsfm * xbsnc / ( xbsfm + xbsnc )

c *** from Aitken mode to accumulation mode

      xbsfm   = sum1s12fm  / pi
      xbsnc   = sum1s12nc  / pi

      quads12 =  xbsfm * xbsnc / ( xbsfm + xbsnc )



      xbnfm   = sum1nfm  / pi
      xbnnc   = sum1nnc  / pi

      quadn12 =  xbnfm * xbnnc / ( xbnfm + xbnnc )

c *** quadn12 is the intermodal coagulation coefficient for number


       xbvfm = sum1vfm / pi
       xbvnc = sum1vnc / pi

       quadv12 = xbvfm * xbvnc / ( xbvfm + xbvnc )

c *** quadv12 is the intermodal coagulation coefficient for 3rd moment

      return
      end subroutine intercoag_gh 

c //////////////////////////////////////////////////////////////////
c  SUBROUTINE GETCOAGS calculates the coagulation rates using a new 
c     approximate algorithm for the 2nd moment.  The 0th and 3rd moments
C     are done by analytic expressions from Whitby et al. (1991).  The
c     correction factors are also similar to those from Whitby et al. 
c     (1991), but are derived from the Gauss-Hermite numerical 
c     quadratures used by Binkowski and Roselle (2003).
c
c     Called from AEROSTEP as:
c     CALL GETCOAGS( LAMDA, KFMATAC, KFMAT, KFMAC, KNC,
c                    DGAT,DGAC, SGATK, SGACC, XXLSGAT,XXLSGAC, 
c                    BATAT(2), BATAT(1), BACAC(2), BACAC(1),
c                    BATAC(2), BACAT(2), BATAC(1), c3ij )
c     where ALL input and outputs are REAL*8
c
c  REVISION HISTORY:
c   FSB 08/25/03 Coded by Dr. Francis S. Binkowksi
c
c   FSB 08/25/04 Added in-line documentation
c
c  REFERENCES:
c   1. Whitby, E. R., P. H. McMurry, U. Shankar, and F. S. Binkowski,
c   Modal Aerosol Dynamics Modeling, Rep. 600/3-91/020, Atmospheric 
c   Research and Exposure Assessment Laboratory, 
c   U.S. Environmental Protection Agency, Research Triangle Park, N.C., 
c   (NTIS PB91-161729/AS), 1991
c
c   2. Binkowski, F.S. an U. Shankar, The Regional Particulate Matter
c   Model 1. Model decsription and preliminary Results, Journal of
c   Geophysical Research, 100, D12, pp 26,191-26,209, 
c   December 20, 1995.
c
c   3. Binkowski, F.S. and S.J. Roselle, Models-3 Community 
c      Multiscale Air Quality (CMAQ) model aerosol component 1:
c      Model Description.  J. Geophys. Res., Vol 108, No D6, 4183
c      doi:10.1029/2001JD001409, 2003.


      SUBROUTINE GETCOAGS( LAMDA, KFMATAC, KFMAT, KFMAC, KNC, 
     &                     DGATK, DGACC, SGATK, SGACC, XXLSGAT,XXLSGAC, 
     &                     QS11, QN11, QS22, QN22, 
     &                     QS12, QS21, QN12, QV12 )

      IMPLICIT NONE
      
      REAL*8    LAMDA     ! mean free path [ m ]

C *** coefficients for Free Molecular regime
      REAL*8    KFMAT     ! Aitken mode
      REAL*8    KFMAC     ! accumulation mode 
      REAL*8    KFMATAC   ! Aitken to accumulation mode

      REAL*8    KNC   ! coefficient for Near Continnuum regime

C *** modal geometric mean diameters: [ m ]

      REAL*8 DGATK          ! Aitken mode
      REAL*8 DGACC          ! accumulation mode

C *** modal geometric standard deviation

      REAL*8 SGATK          ! Atken mode
      REAL*8 SGACC          ! accumulation mode

c *** natural log of modal geometric standard deviation

      REAL*8 XXLSGAT         ! Aitken mode
      REAL*8 XXLSGAC         ! accumulation mode

c *** coagulation coefficients 
      REAL*8    QS11, QN11, QS22, QN22,
     &          QS12, QS21, QN12, QV12 

      INTEGER IBETA, N1, N2A, N2N ! indices for correction factors

      REAL*8  I1FM_AT
      REAL*8  I1NC_AT
      REAL*8  I1_AT
      
      REAL*8  I1FM_AC
      REAL*8  I1NC_AC
      REAL*8  I1_AC
      
      REAL*8  I1FM
      REAL*8  I1NC
      REAL*8  I1
      
      REAL*8 CONST II
      
      REAL*8    KNGAT, KNGAC
      REAL*8    ONE, TWO, HALF
       PARAMETER( ONE = 1.0D0, TWO = 2.0D0, HALF = 0.5D0 )      
      REAL*8    A
c       PARAMETER( A = 2.492D0)
      PARAMETER( A = 1.246D0)
      REAL      TWO3RDS
       PARAMETER( TWO3RDS = 2.D0 / 3.D0)
      
      REAL*8   SQRTTWO  !  sqrt(TWO)    
      REAL*8   DLGSQT2  !  1/ln( sqrt( 2 ) ) 

       
      REAL*8    ESAT01         ! Aitken mode exp( log^2( sigmag )/8 )
      REAL*8    ESAC01         ! accumulation mode exp( log^2( sigmag )/8 )

      REAL*8    ESAT04
      REAL*8    ESAC04

      REAL*8    ESAT05
      REAL*8    ESAC05

      REAL*8    ESAT08
      REAL*8    ESAC08

      REAL*8    ESAT09
      REAL*8    ESAC09

      REAL*8    ESAT16
      REAL*8    ESAC16
      
      REAL*8    ESAT20
      REAL*8    ESAC20
      
      REAL*8    ESAT24
      REAL*8    ESAC24
     
      REAL*8    ESAT25
      REAL*8    ESAC25
      
      REAL*8    ESAT36
      REAL*8    ESAC36

      REAL*8    ESAT49
      
      REAL*8    ESAT64
      REAL*8    ESAC64
            
      REAL*8    ESAT100
          
      REAL*8 DGAT2, DGAC2, DGAT3, DGAC3
      REAL*8 SQDGAT, SQDGAC 
      REAL*8 SQDGAT5, SQDGAC5
      REAL*8 SQDGAT7
      REAL*8 R, R2, R3, R4, R5, R6, R8
      REAL*8 RI1, RI2, RI3, RI4
      REAL*8 RAT      
      REAL*8 COAGFM0, COAGNC0
      REAL*8 COAGFM3, COAGNC3
      REAL*8 COAGFM_AT, COAGFM_AC
      REAL*8 COAGNC_AT, COAGNC_AC
      REAL*8 COAGATAT0
      REAL*8 COAGACAC0
      REAL*8 COAGATAT2
      REAL*8 COAGACAC2
      REAL*8 COAGATAC0, COAGATAC3 
      REAL*8 COAGATAC2
      REAL*8 COAGACAT2   
      REAL*8 XM2AT, XM3AT, XM2AC, XM3AC
       
c *** correction factors for coagulation rates      
      REAL  BM0( 10 )          ! M0 INTRAmodal FM - RPM values 
      REAL  BM0IJ( 10, 10, 10 ) ! M0 INTERmodal FM
      REAL  BM3I( 10, 10, 10 ) ! M3 INTERmodal FM- RPM values
      REAL  BM2II(10) ! M2 INTRAmodal FM 
      REAL  BM2IITT(10) ! M2 INTRAmodal total
      REAL  BM2IJ(10,10,10) ! M2 INTERmodal FM i to j
      REAL  BM2JI(10,10,10) ! M2 total INTERmodal  j from i
       
c *** populate the arrays for the correction factors.
       
C RPM 0th moment correction factors for UNIMODAL FM coagulation  rates      
      DATA      BM0  /            
     &      0.707106785165097, 0.726148960080488, 0.766430744110958,
     &      0.814106389441342, 0.861679526483207, 0.903600509090092,
     &      0.936578814219156, 0.960098926735545, 0.975646823342881,     
     &      0.985397173215326   /
     

C FSB new FM correction factors for M0 INTERmodal coagulation
      
      DATA (BM0IJ (  1,  1,IBETA), IBETA = 1,10) /
     &  0.628539,  0.639610,  0.664514,  0.696278,  0.731558,
     &  0.768211,  0.804480,  0.838830,  0.870024,  0.897248/
      DATA (BM0IJ (  1,  2,IBETA), IBETA = 1,10) /
     &  0.639178,  0.649966,  0.674432,  0.705794,  0.740642,
     &  0.776751,  0.812323,  0.845827,  0.876076,  0.902324/
      DATA (BM0IJ (  1,  3,IBETA), IBETA = 1,10) /
     &  0.663109,  0.673464,  0.697147,  0.727637,  0.761425,
     &  0.796155,  0.829978,  0.861419,  0.889424,  0.913417/
      DATA (BM0IJ (  1,  4,IBETA), IBETA = 1,10) /
     &  0.693693,  0.703654,  0.726478,  0.755786,  0.787980,
     &  0.820626,  0.851898,  0.880459,  0.905465,  0.926552/
      DATA (BM0IJ (  1,  5,IBETA), IBETA = 1,10) /
     &  0.727803,  0.737349,  0.759140,  0.786870,  0.816901,
     &  0.846813,  0.874906,  0.900060,  0.921679,  0.939614/
      DATA (BM0IJ (  1,  6,IBETA), IBETA = 1,10) /
     &  0.763461,  0.772483,  0.792930,  0.818599,  0.845905,
     &  0.872550,  0.897051,  0.918552,  0.936701,  0.951528/
      DATA (BM0IJ (  1,  7,IBETA), IBETA = 1,10) /
     &  0.799021,  0.807365,  0.826094,  0.849230,  0.873358,
     &  0.896406,  0.917161,  0.935031,  0.949868,  0.961828/
      DATA (BM0IJ (  1,  8,IBETA), IBETA = 1,10) /
     &  0.833004,  0.840514,  0.857192,  0.877446,  0.898147,
     &  0.917518,  0.934627,  0.949106,  0.960958,  0.970403/
      DATA (BM0IJ (  1,  9,IBETA), IBETA = 1,10) /
     &  0.864172,  0.870734,  0.885153,  0.902373,  0.919640,
     &  0.935494,  0.949257,  0.960733,  0.970016,  0.977346/
      DATA (BM0IJ (  1, 10,IBETA), IBETA = 1,10) /
     &  0.891658,  0.897227,  0.909343,  0.923588,  0.937629,
     &  0.950307,  0.961151,  0.970082,  0.977236,  0.982844/
      DATA (BM0IJ (  2,  1,IBETA), IBETA = 1,10) /
     &  0.658724,  0.670587,  0.697539,  0.731890,  0.769467,
     &  0.807391,  0.843410,  0.875847,  0.903700,  0.926645/
      DATA (BM0IJ (  2,  2,IBETA), IBETA = 1,10) /
     &  0.667070,  0.678820,  0.705538,  0.739591,  0.776758,
     &  0.814118,  0.849415,  0.881020,  0.908006,  0.930121/
      DATA (BM0IJ (  2,  3,IBETA), IBETA = 1,10) /
     &  0.686356,  0.697839,  0.723997,  0.757285,  0.793389,
     &  0.829313,  0.862835,  0.892459,  0.917432,  0.937663/
      DATA (BM0IJ (  2,  4,IBETA), IBETA = 1,10) /
     &  0.711425,  0.722572,  0.747941,  0.780055,  0.814518,
     &  0.848315,  0.879335,  0.906290,  0.928658,  0.946526/
      DATA (BM0IJ (  2,  5,IBETA), IBETA = 1,10) /
     &  0.739575,  0.750307,  0.774633,  0.805138,  0.837408,
     &  0.868504,  0.896517,  0.920421,  0.939932,  0.955299/
      DATA (BM0IJ (  2,  6,IBETA), IBETA = 1,10) /
     &  0.769143,  0.779346,  0.802314,  0.830752,  0.860333,
     &  0.888300,  0.913014,  0.933727,  0.950370,  0.963306/
      DATA (BM0IJ (  2,  7,IBETA), IBETA = 1,10) /
     &  0.798900,  0.808431,  0.829700,  0.855653,  0.882163,
     &  0.906749,  0.928075,  0.945654,  0.959579,  0.970280/
      DATA (BM0IJ (  2,  8,IBETA), IBETA = 1,10) /
     &  0.827826,  0.836542,  0.855808,  0.878954,  0.902174,
     &  0.923316,  0.941345,  0.955989,  0.967450,  0.976174/
      DATA (BM0IJ (  2,  9,IBETA), IBETA = 1,10) /
     &  0.855068,  0.862856,  0.879900,  0.900068,  0.919956,
     &  0.937764,  0.952725,  0.964726,  0.974027,  0.981053/
      DATA (BM0IJ (  2, 10,IBETA), IBETA = 1,10) /
     &  0.879961,  0.886755,  0.901484,  0.918665,  0.935346,
     &  0.950065,  0.962277,  0.971974,  0.979432,  0.985033/
      DATA (BM0IJ (  3,  1,IBETA), IBETA = 1,10) /
     &  0.724166,  0.735474,  0.761359,  0.794045,  0.828702,
     &  0.862061,  0.891995,  0.917385,  0.937959,  0.954036/
      DATA (BM0IJ (  3,  2,IBETA), IBETA = 1,10) /
     &  0.730416,  0.741780,  0.767647,  0.800116,  0.834344,
     &  0.867093,  0.896302,  0.920934,  0.940790,  0.956237/
      DATA (BM0IJ (  3,  3,IBETA), IBETA = 1,10) /
     &  0.745327,  0.756664,  0.782255,  0.814026,  0.847107,
     &  0.878339,  0.905820,  0.928699,  0.946931,  0.960977/
      DATA (BM0IJ (  3,  4,IBETA), IBETA = 1,10) /
     &  0.765195,  0.776312,  0.801216,  0.831758,  0.863079,
     &  0.892159,  0.917319,  0.937939,  0.954145,  0.966486/
      DATA (BM0IJ (  3,  5,IBETA), IBETA = 1,10) /
     &  0.787632,  0.798347,  0.822165,  0.850985,  0.880049,
     &  0.906544,  0.929062,  0.947218,  0.961288,  0.971878/
      DATA (BM0IJ (  3,  6,IBETA), IBETA = 1,10) /
     &  0.811024,  0.821179,  0.843557,  0.870247,  0.896694,
     &  0.920365,  0.940131,  0.955821,  0.967820,  0.976753/
      DATA (BM0IJ (  3,  7,IBETA), IBETA = 1,10) /
     &  0.834254,  0.843709,  0.864356,  0.888619,  0.912245,
     &  0.933019,  0.950084,  0.963438,  0.973530,  0.980973/
      DATA (BM0IJ (  3,  8,IBETA), IBETA = 1,10) /
     &  0.856531,  0.865176,  0.883881,  0.905544,  0.926290,
     &  0.944236,  0.958762,  0.969988,  0.978386,  0.984530/
      DATA (BM0IJ (  3,  9,IBETA), IBETA = 1,10) /
     &  0.877307,  0.885070,  0.901716,  0.920729,  0.938663,
     &  0.953951,  0.966169,  0.975512,  0.982442,  0.987477/
      DATA (BM0IJ (  3, 10,IBETA), IBETA = 1,10) /
     &  0.896234,  0.903082,  0.917645,  0.934069,  0.949354,
     &  0.962222,  0.972396,  0.980107,  0.985788,  0.989894/
      DATA (BM0IJ (  4,  1,IBETA), IBETA = 1,10) /
     &  0.799294,  0.809144,  0.831293,  0.858395,  0.885897,
     &  0.911031,  0.932406,  0.949642,  0.963001,  0.973062/
      DATA (BM0IJ (  4,  2,IBETA), IBETA = 1,10) /
     &  0.804239,  0.814102,  0.836169,  0.862984,  0.890003,
     &  0.914535,  0.935274,  0.951910,  0.964748,  0.974381/
      DATA (BM0IJ (  4,  3,IBETA), IBETA = 1,10) /
     &  0.815910,  0.825708,  0.847403,  0.873389,  0.899185,
     &  0.922275,  0.941543,  0.956826,  0.968507,  0.977204/
      DATA (BM0IJ (  4,  4,IBETA), IBETA = 1,10) /
     &  0.831348,  0.840892,  0.861793,  0.886428,  0.910463,
     &  0.931614,  0.948993,  0.962593,  0.972872,  0.980456/
      DATA (BM0IJ (  4,  5,IBETA), IBETA = 1,10) /
     &  0.848597,  0.857693,  0.877402,  0.900265,  0.922180,
     &  0.941134,  0.956464,  0.968298,  0.977143,  0.983611/
      DATA (BM0IJ (  4,  6,IBETA), IBETA = 1,10) /
     &  0.866271,  0.874764,  0.892984,  0.913796,  0.933407,
     &  0.950088,  0.963380,  0.973512,  0.981006,  0.986440/
      DATA (BM0IJ (  4,  7,IBETA), IBETA = 1,10) /
     &  0.883430,  0.891216,  0.907762,  0.926388,  0.943660,
     &  0.958127,  0.969499,  0.978070,  0.984351,  0.988872/
      DATA (BM0IJ (  4,  8,IBETA), IBETA = 1,10) /
     &  0.899483,  0.906505,  0.921294,  0.937719,  0.952729,
     &  0.965131,  0.974762,  0.981950,  0.987175,  0.990912/
      DATA (BM0IJ (  4,  9,IBETA), IBETA = 1,10) /
     &  0.914096,  0.920337,  0.933373,  0.947677,  0.960579,
     &  0.971111,  0.979206,  0.985196,  0.989520,  0.992597/
      DATA (BM0IJ (  4, 10,IBETA), IBETA = 1,10) /
     &  0.927122,  0.932597,  0.943952,  0.956277,  0.967268,
     &  0.976147,  0.982912,  0.987882,  0.991450,  0.993976/
      DATA (BM0IJ (  5,  1,IBETA), IBETA = 1,10) /
     &  0.865049,  0.872851,  0.889900,  0.909907,  0.929290,
     &  0.946205,  0.959991,  0.970706,  0.978764,  0.984692/
      DATA (BM0IJ (  5,  2,IBETA), IBETA = 1,10) /
     &  0.868989,  0.876713,  0.893538,  0.913173,  0.932080,
     &  0.948484,  0.961785,  0.972080,  0.979796,  0.985457/
      DATA (BM0IJ (  5,  3,IBETA), IBETA = 1,10) /
     &  0.878010,  0.885524,  0.901756,  0.920464,  0.938235,
     &  0.953461,  0.965672,  0.975037,  0.982005,  0.987085/
      DATA (BM0IJ (  5,  4,IBETA), IBETA = 1,10) /
     &  0.889534,  0.896698,  0.912012,  0.929395,  0.945647,
     &  0.959366,  0.970227,  0.978469,  0.984547,  0.988950/
      DATA (BM0IJ (  5,  5,IBETA), IBETA = 1,10) /
     &  0.902033,  0.908713,  0.922848,  0.938648,  0.953186,
     &  0.965278,  0.974729,  0.981824,  0.987013,  0.990746/
      DATA (BM0IJ (  5,  6,IBETA), IBETA = 1,10) /
     &  0.914496,  0.920599,  0.933389,  0.947485,  0.960262,
     &  0.970743,  0.978839,  0.984858,  0.989225,  0.992348/
      DATA (BM0IJ (  5,  7,IBETA), IBETA = 1,10) /
     &  0.926281,  0.931761,  0.943142,  0.955526,  0.966600,
     &  0.975573,  0.982431,  0.987485,  0.991128,  0.993718/
      DATA (BM0IJ (  5,  8,IBETA), IBETA = 1,10) /
     &  0.937029,  0.941877,  0.951868,  0.962615,  0.972112,
     &  0.979723,  0.985488,  0.989705,  0.992725,  0.994863/
      DATA (BM0IJ (  5,  9,IBETA), IBETA = 1,10) /
     &  0.946580,  0.950819,  0.959494,  0.968732,  0.976811,
     &  0.983226,  0.988047,  0.991550,  0.994047,  0.995806/
      DATA (BM0IJ (  5, 10,IBETA), IBETA = 1,10) /
     &  0.954909,  0.958581,  0.966049,  0.973933,  0.980766,
     &  0.986149,  0.990166,  0.993070,  0.995130,  0.996577/
      DATA (BM0IJ (  6,  1,IBETA), IBETA = 1,10) /
     &  0.914182,  0.919824,  0.931832,  0.945387,  0.957999,
     &  0.968606,  0.976982,  0.983331,  0.988013,  0.991407/
      DATA (BM0IJ (  6,  2,IBETA), IBETA = 1,10) /
     &  0.917139,  0.922665,  0.934395,  0.947580,  0.959792,
     &  0.970017,  0.978062,  0.984138,  0.988609,  0.991843/
      DATA (BM0IJ (  6,  3,IBETA), IBETA = 1,10) /
     &  0.923742,  0.928990,  0.940064,  0.952396,  0.963699,
     &  0.973070,  0.980381,  0.985866,  0.989878,  0.992768/
      DATA (BM0IJ (  6,  4,IBETA), IBETA = 1,10) /
     &  0.931870,  0.936743,  0.946941,  0.958162,  0.968318,
     &  0.976640,  0.983069,  0.987853,  0.991330,  0.993822/
      DATA (BM0IJ (  6,  5,IBETA), IBETA = 1,10) /
     &  0.940376,  0.944807,  0.954004,  0.963999,  0.972928,
     &  0.980162,  0.985695,  0.989779,  0.992729,  0.994833/
      DATA (BM0IJ (  6,  6,IBETA), IBETA = 1,10) /
     &  0.948597,  0.952555,  0.960703,  0.969454,  0.977181,
     &  0.983373,  0.988067,  0.991507,  0.993977,  0.995730/
      DATA (BM0IJ (  6,  7,IBETA), IBETA = 1,10) /
     &  0.956167,  0.959648,  0.966763,  0.974326,  0.980933,
     &  0.986177,  0.990121,  0.992993,  0.995045,  0.996495/
      DATA (BM0IJ (  6,  8,IBETA), IBETA = 1,10) /
     &  0.962913,  0.965937,  0.972080,  0.978552,  0.984153,
     &  0.988563,  0.991857,  0.994242,  0.995938,  0.997133/
      DATA (BM0IJ (  6,  9,IBETA), IBETA = 1,10) /
     &  0.968787,  0.971391,  0.976651,  0.982148,  0.986869,
     &  0.990560,  0.993301,  0.995275,  0.996675,  0.997657/
      DATA (BM0IJ (  6, 10,IBETA), IBETA = 1,10) /
     &  0.973822,  0.976047,  0.980523,  0.985170,  0.989134,
     &  0.992215,  0.994491,  0.996124,  0.997277,  0.998085/
      DATA (BM0IJ (  7,  1,IBETA), IBETA = 1,10) /
     &  0.947410,  0.951207,  0.959119,  0.967781,  0.975592,
     &  0.981981,  0.986915,  0.990590,  0.993266,  0.995187/
      DATA (BM0IJ (  7,  2,IBETA), IBETA = 1,10) /
     &  0.949477,  0.953161,  0.960824,  0.969187,  0.976702,
     &  0.982831,  0.987550,  0.991057,  0.993606,  0.995434/
      DATA (BM0IJ (  7,  3,IBETA), IBETA = 1,10) /
     &  0.954008,  0.957438,  0.964537,  0.972232,  0.979095,
     &  0.984653,  0.988907,  0.992053,  0.994330,  0.995958/
      DATA (BM0IJ (  7,  4,IBETA), IBETA = 1,10) /
     &  0.959431,  0.962539,  0.968935,  0.975808,  0.981882,
     &  0.986759,  0.990466,  0.993190,  0.995153,  0.996552/
      DATA (BM0IJ (  7,  5,IBETA), IBETA = 1,10) /
     &  0.964932,  0.967693,  0.973342,  0.979355,  0.984620,
     &  0.988812,  0.991974,  0.994285,  0.995943,  0.997119/
      DATA (BM0IJ (  7,  6,IBETA), IBETA = 1,10) /
     &  0.970101,  0.972517,  0.977428,  0.982612,  0.987110,
     &  0.990663,  0.993326,  0.995261,  0.996644,  0.997621/
      DATA (BM0IJ (  7,  7,IBETA), IBETA = 1,10) /
     &  0.974746,  0.976834,  0.981055,  0.985475,  0.989280,
     &  0.992265,  0.994488,  0.996097,  0.997241,  0.998048/
      DATA (BM0IJ (  7,  8,IBETA), IBETA = 1,10) /
     &  0.978804,  0.980591,  0.984187,  0.987927,  0.991124,
     &  0.993617,  0.995464,  0.996795,  0.997739,  0.998403/
      DATA (BM0IJ (  7,  9,IBETA), IBETA = 1,10) /
     &  0.982280,  0.983799,  0.986844,  0.989991,  0.992667,
     &  0.994742,  0.996273,  0.997372,  0.998149,  0.998695/
      DATA (BM0IJ (  7, 10,IBETA), IBETA = 1,10) /
     &  0.985218,  0.986503,  0.989071,  0.991711,  0.993945,
     &  0.995669,  0.996937,  0.997844,  0.998484,  0.998932/
      DATA (BM0IJ (  8,  1,IBETA), IBETA = 1,10) /
     &  0.968507,  0.970935,  0.975916,  0.981248,  0.985947,
     &  0.989716,  0.992580,  0.994689,  0.996210,  0.997297/
      DATA (BM0IJ (  8,  2,IBETA), IBETA = 1,10) /
     &  0.969870,  0.972210,  0.977002,  0.982119,  0.986619,
     &  0.990219,  0.992951,  0.994958,  0.996405,  0.997437/
      DATA (BM0IJ (  8,  3,IBETA), IBETA = 1,10) /
     &  0.972820,  0.974963,  0.979339,  0.983988,  0.988054,
     &  0.991292,  0.993738,  0.995529,  0.996817,  0.997734/
      DATA (BM0IJ (  8,  4,IBETA), IBETA = 1,10) /
     &  0.976280,  0.978186,  0.982060,  0.986151,  0.989706,
     &  0.992520,  0.994636,  0.996179,  0.997284,  0.998069/
      DATA (BM0IJ (  8,  5,IBETA), IBETA = 1,10) /
     &  0.979711,  0.981372,  0.984735,  0.988263,  0.991309,
     &  0.993706,  0.995499,  0.996801,  0.997730,  0.998389/
      DATA (BM0IJ (  8,  6,IBETA), IBETA = 1,10) /
     &  0.982863,  0.984292,  0.987172,  0.990174,  0.992750,
     &  0.994766,  0.996266,  0.997352,  0.998125,  0.998670/
      DATA (BM0IJ (  8,  7,IBETA), IBETA = 1,10) /
     &  0.985642,  0.986858,  0.989301,  0.991834,  0.993994,
     &  0.995676,  0.996923,  0.997822,  0.998460,  0.998910/
      DATA (BM0IJ (  8,  8,IBETA), IBETA = 1,10) /
     &  0.988029,  0.989058,  0.991116,  0.993240,  0.995043,
     &  0.996440,  0.997472,  0.998214,  0.998739,  0.999108/
      DATA (BM0IJ (  8,  9,IBETA), IBETA = 1,10) /
     &  0.990046,  0.990912,  0.992640,  0.994415,  0.995914,
     &  0.997073,  0.997925,  0.998536,  0.998968,  0.999271/
      DATA (BM0IJ (  8, 10,IBETA), IBETA = 1,10) /
     &  0.991732,  0.992459,  0.993906,  0.995386,  0.996633,
     &  0.997592,  0.998296,  0.998799,  0.999154,  0.999403/
      DATA (BM0IJ (  9,  1,IBETA), IBETA = 1,10) /
     &  0.981392,  0.982893,  0.985938,  0.989146,  0.991928,
     &  0.994129,  0.995783,  0.996991,  0.997857,  0.998473/
      DATA (BM0IJ (  9,  2,IBETA), IBETA = 1,10) /
     &  0.982254,  0.983693,  0.986608,  0.989673,  0.992328,
     &  0.994424,  0.995998,  0.997146,  0.997969,  0.998553/
      DATA (BM0IJ (  9,  3,IBETA), IBETA = 1,10) /
     &  0.984104,  0.985407,  0.988040,  0.990798,  0.993178,
     &  0.995052,  0.996454,  0.997474,  0.998204,  0.998722/
      DATA (BM0IJ (  9,  4,IBETA), IBETA = 1,10) /
     &  0.986243,  0.987386,  0.989687,  0.992087,  0.994149,
     &  0.995765,  0.996971,  0.997846,  0.998470,  0.998913/
      DATA (BM0IJ (  9,  5,IBETA), IBETA = 1,10) /
     &  0.988332,  0.989313,  0.991284,  0.993332,  0.995082,
     &  0.996449,  0.997465,  0.998200,  0.998723,  0.999093/
      DATA (BM0IJ (  9,  6,IBETA), IBETA = 1,10) /
     &  0.990220,  0.991053,  0.992721,  0.994445,  0.995914,
     &  0.997056,  0.997902,  0.998513,  0.998947,  0.999253/
      DATA (BM0IJ (  9,  7,IBETA), IBETA = 1,10) /
     &  0.991859,  0.992561,  0.993961,  0.995403,  0.996626,
     &  0.997574,  0.998274,  0.998778,  0.999136,  0.999387/
      DATA (BM0IJ (  9,  8,IBETA), IBETA = 1,10) /
     &  0.993250,  0.993837,  0.995007,  0.996208,  0.997223,
     &  0.998007,  0.998584,  0.998999,  0.999293,  0.999499/
      DATA (BM0IJ (  9,  9,IBETA), IBETA = 1,10) /
     &  0.994413,  0.994903,  0.995878,  0.996876,  0.997716,
     &  0.998363,  0.998839,  0.999180,  0.999421,  0.999591/
      DATA (BM0IJ (  9, 10,IBETA), IBETA = 1,10) /
     &  0.995376,  0.995785,  0.996597,  0.997425,  0.998121,
     &  0.998655,  0.999048,  0.999328,  0.999526,  0.999665/
      DATA (BM0IJ ( 10,  1,IBETA), IBETA = 1,10) /
     &  0.989082,  0.989991,  0.991819,  0.993723,  0.995357,
     &  0.996637,  0.997592,  0.998286,  0.998781,  0.999132/
      DATA (BM0IJ ( 10,  2,IBETA), IBETA = 1,10) /
     &  0.989613,  0.990480,  0.992224,  0.994039,  0.995594,
     &  0.996810,  0.997717,  0.998375,  0.998845,  0.999178/
      DATA (BM0IJ ( 10,  3,IBETA), IBETA = 1,10) /
     &  0.990744,  0.991523,  0.993086,  0.994708,  0.996094,
     &  0.997176,  0.997981,  0.998564,  0.998980,  0.999274/
      DATA (BM0IJ ( 10,  4,IBETA), IBETA = 1,10) /
     &  0.992041,  0.992716,  0.994070,  0.995470,  0.996662,
     &  0.997591,  0.998280,  0.998778,  0.999133,  0.999383/
      DATA (BM0IJ ( 10,  5,IBETA), IBETA = 1,10) /
     &  0.993292,  0.993867,  0.995015,  0.996199,  0.997205,
     &  0.997985,  0.998564,  0.998981,  0.999277,  0.999487/
      DATA (BM0IJ ( 10,  6,IBETA), IBETA = 1,10) /
     &  0.994411,  0.994894,  0.995857,  0.996847,  0.997685,
     &  0.998334,  0.998814,  0.999159,  0.999404,  0.999577/
      DATA (BM0IJ ( 10,  7,IBETA), IBETA = 1,10) /
     &  0.995373,  0.995776,  0.996577,  0.997400,  0.998094,
     &  0.998630,  0.999026,  0.999310,  0.999512,  0.999654/
      DATA (BM0IJ ( 10,  8,IBETA), IBETA = 1,10) /
     &  0.996181,  0.996516,  0.997181,  0.997861,  0.998435,
     &  0.998877,  0.999202,  0.999435,  0.999601,  0.999717/
      DATA (BM0IJ ( 10,  9,IBETA), IBETA = 1,10) /
     &  0.996851,  0.997128,  0.997680,  0.998242,  0.998715,
     &  0.999079,  0.999346,  0.999538,  0.999673,  0.999769/
      DATA (BM0IJ ( 10, 10,IBETA), IBETA = 1,10) /
     &  0.997402,  0.997632,  0.998089,  0.998554,  0.998945,
     &  0.999244,  0.999464,  0.999622,  0.999733,  0.999811/


C RPM....   3rd moment nuclei mode corr. fac. for bimodal FM coag rate
       
       DATA (BM3I( 1, 1,IBETA ), IBETA=1,10)/
     + 0.70708,0.71681,0.73821,0.76477,0.79350,0.82265,0.85090,0.87717,
     + 0.90069,0.92097/
       DATA (BM3I( 1, 2,IBETA ), IBETA=1,10)/
     + 0.72172,0.73022,0.74927,0.77324,0.79936,0.82601,0.85199,0.87637,
     + 0.89843,0.91774/
       DATA (BM3I( 1, 3,IBETA ), IBETA=1,10)/
     + 0.78291,0.78896,0.80286,0.82070,0.84022,0.85997,0.87901,0.89669,
     + 0.91258,0.92647/
       DATA (BM3I( 1, 4,IBETA ), IBETA=1,10)/
     + 0.87760,0.88147,0.89025,0.90127,0.91291,0.92420,0.93452,0.94355,
     + 0.95113,0.95726/
       DATA (BM3I( 1, 5,IBETA ), IBETA=1,10)/
     + 0.94988,0.95184,0.95612,0.96122,0.96628,0.97085,0.97467,0.97763,
     + 0.97971,0.98089/
       DATA (BM3I( 1, 6,IBETA ), IBETA=1,10)/
     + 0.98318,0.98393,0.98551,0.98728,0.98889,0.99014,0.99095,0.99124,
     + 0.99100,0.99020/
       DATA (BM3I( 1, 7,IBETA ), IBETA=1,10)/
     + 0.99480,0.99504,0.99551,0.99598,0.99629,0.99635,0.99611,0.99550,
     + 0.99450,0.99306/
       DATA (BM3I( 1, 8,IBETA ), IBETA=1,10)/
     + 0.99842,0.99848,0.99858,0.99861,0.99850,0.99819,0.99762,0.99674,
     + 0.99550,0.99388/
       DATA (BM3I( 1, 9,IBETA ), IBETA=1,10)/
     + 0.99951,0.99951,0.99949,0.99939,0.99915,0.99872,0.99805,0.99709,
     + 0.99579,0.99411/
       DATA (BM3I( 1,10,IBETA ), IBETA=1,10)/
     + 0.99984,0.99982,0.99976,0.99962,0.99934,0.99888,0.99818,0.99719,
     + 0.99587,0.99417/
       DATA (BM3I( 2, 1,IBETA ), IBETA=1,10)/
     + 0.72957,0.73993,0.76303,0.79178,0.82245,0.85270,0.88085,0.90578,
     + 0.92691,0.94415/
       DATA (BM3I( 2, 2,IBETA ), IBETA=1,10)/
     + 0.72319,0.73320,0.75547,0.78323,0.81307,0.84287,0.87107,0.89651,
     + 0.91852,0.93683/
       DATA (BM3I( 2, 3,IBETA ), IBETA=1,10)/
     + 0.74413,0.75205,0.76998,0.79269,0.81746,0.84258,0.86685,0.88938,
     + 0.90953,0.92695/
       DATA (BM3I( 2, 4,IBETA ), IBETA=1,10)/
     + 0.82588,0.83113,0.84309,0.85825,0.87456,0.89072,0.90594,0.91972,
     + 0.93178,0.94203/
       DATA (BM3I( 2, 5,IBETA ), IBETA=1,10)/
     + 0.91886,0.92179,0.92831,0.93624,0.94434,0.95192,0.95856,0.96409,
     + 0.96845,0.97164/
       DATA (BM3I( 2, 6,IBETA ), IBETA=1,10)/
     + 0.97129,0.97252,0.97515,0.97818,0.98108,0.98354,0.98542,0.98665,
     + 0.98721,0.98709/
       DATA (BM3I( 2, 7,IBETA ), IBETA=1,10)/
     + 0.99104,0.99145,0.99230,0.99320,0.99394,0.99439,0.99448,0.99416,
     + 0.99340,0.99217/
       DATA (BM3I( 2, 8,IBETA ), IBETA=1,10)/
     + 0.99730,0.99741,0.99763,0.99779,0.99782,0.99762,0.99715,0.99636,
     + 0.99519,0.99363/
       DATA (BM3I( 2, 9,IBETA ), IBETA=1,10)/
     + 0.99917,0.99919,0.99921,0.99915,0.99895,0.99856,0.99792,0.99698,
     + 0.99570,0.99404/
       DATA (BM3I( 2,10,IBETA ), IBETA=1,10)/
     + 0.99973,0.99973,0.99968,0.99955,0.99928,0.99883,0.99814,0.99716,
     + 0.99584,0.99415/
       DATA (BM3I( 3, 1,IBETA ), IBETA=1,10)/
     + 0.78358,0.79304,0.81445,0.84105,0.86873,0.89491,0.91805,0.93743,
     + 0.95300,0.96510/
       DATA (BM3I( 3, 2,IBETA ), IBETA=1,10)/
     + 0.76412,0.77404,0.79635,0.82404,0.85312,0.88101,0.90610,0.92751,
     + 0.94500,0.95879/
       DATA (BM3I( 3, 3,IBETA ), IBETA=1,10)/
     + 0.74239,0.75182,0.77301,0.79956,0.82809,0.85639,0.88291,0.90658,
     + 0.92683,0.94350/
       DATA (BM3I( 3, 4,IBETA ), IBETA=1,10)/
     + 0.78072,0.78758,0.80317,0.82293,0.84437,0.86589,0.88643,0.90526,
     + 0.92194,0.93625/
       DATA (BM3I( 3, 5,IBETA ), IBETA=1,10)/
     + 0.87627,0.88044,0.88981,0.90142,0.91357,0.92524,0.93585,0.94510,
     + 0.95285,0.95911/
       DATA (BM3I( 3, 6,IBETA ), IBETA=1,10)/
     + 0.95176,0.95371,0.95796,0.96297,0.96792,0.97233,0.97599,0.97880,
     + 0.98072,0.98178/
       DATA (BM3I( 3, 7,IBETA ), IBETA=1,10)/
     + 0.98453,0.98523,0.98670,0.98833,0.98980,0.99092,0.99160,0.99179,
     + 0.99145,0.99058/
       DATA (BM3I( 3, 8,IBETA ), IBETA=1,10)/
     + 0.99534,0.99555,0.99597,0.99637,0.99662,0.99663,0.99633,0.99569,
     + 0.99465,0.99318/
       DATA (BM3I( 3, 9,IBETA ), IBETA=1,10)/
     + 0.99859,0.99864,0.99872,0.99873,0.99860,0.99827,0.99768,0.99679,
     + 0.99555,0.99391/
       DATA (BM3I( 3,10,IBETA ), IBETA=1,10)/
     + 0.99956,0.99956,0.99953,0.99942,0.99918,0.99875,0.99807,0.99711,
     + 0.99580,0.99412/
       DATA (BM3I( 4, 1,IBETA ), IBETA=1,10)/
     + 0.84432,0.85223,0.86990,0.89131,0.91280,0.93223,0.94861,0.96172,
     + 0.97185,0.97945/
       DATA (BM3I( 4, 2,IBETA ), IBETA=1,10)/
     + 0.82299,0.83164,0.85101,0.87463,0.89857,0.92050,0.93923,0.95443,
     + 0.96629,0.97529/
       DATA (BM3I( 4, 3,IBETA ), IBETA=1,10)/
     + 0.77870,0.78840,0.81011,0.83690,0.86477,0.89124,0.91476,0.93460,
     + 0.95063,0.96316/
       DATA (BM3I( 4, 4,IBETA ), IBETA=1,10)/
     + 0.76386,0.77233,0.79147,0.81557,0.84149,0.86719,0.89126,0.91275,
     + 0.93116,0.94637/
       DATA (BM3I( 4, 5,IBETA ), IBETA=1,10)/
     + 0.82927,0.83488,0.84756,0.86346,0.88040,0.89704,0.91257,0.92649,
     + 0.93857,0.94874/
       DATA (BM3I( 4, 6,IBETA ), IBETA=1,10)/
     + 0.92184,0.92481,0.93136,0.93925,0.94724,0.95462,0.96104,0.96634,
     + 0.97048,0.97348/
       DATA (BM3I( 4, 7,IBETA ), IBETA=1,10)/
     + 0.97341,0.97457,0.97706,0.97991,0.98260,0.98485,0.98654,0.98760,
     + 0.98801,0.98777/
       DATA (BM3I( 4, 8,IBETA ), IBETA=1,10)/
     + 0.99192,0.99229,0.99305,0.99385,0.99449,0.99486,0.99487,0.99449,
     + 0.99367,0.99239/
       DATA (BM3I( 4, 9,IBETA ), IBETA=1,10)/
     + 0.99758,0.99768,0.99787,0.99800,0.99799,0.99777,0.99727,0.99645,
     + 0.99527,0.99369/
       DATA (BM3I( 4,10,IBETA ), IBETA=1,10)/
     + 0.99926,0.99928,0.99928,0.99921,0.99900,0.99860,0.99795,0.99701,
     + 0.99572,0.99405/
       DATA (BM3I( 5, 1,IBETA ), IBETA=1,10)/
     + 0.89577,0.90190,0.91522,0.93076,0.94575,0.95876,0.96932,0.97751,
     + 0.98367,0.98820/
       DATA (BM3I( 5, 2,IBETA ), IBETA=1,10)/
     + 0.87860,0.88547,0.90052,0.91828,0.93557,0.95075,0.96319,0.97292,
     + 0.98028,0.98572/
       DATA (BM3I( 5, 3,IBETA ), IBETA=1,10)/
     + 0.83381,0.84240,0.86141,0.88425,0.90707,0.92770,0.94510,0.95906,
     + 0.96986,0.97798/
       DATA (BM3I( 5, 4,IBETA ), IBETA=1,10)/
     + 0.78530,0.79463,0.81550,0.84127,0.86813,0.89367,0.91642,0.93566,
     + 0.95125,0.96347/
       DATA (BM3I( 5, 5,IBETA ), IBETA=1,10)/
     + 0.79614,0.80332,0.81957,0.84001,0.86190,0.88351,0.90368,0.92169,
     + 0.93718,0.95006/
       DATA (BM3I( 5, 6,IBETA ), IBETA=1,10)/
     + 0.88192,0.88617,0.89565,0.90728,0.91931,0.93076,0.94107,0.94997,
     + 0.95739,0.96333/
       DATA (BM3I( 5, 7,IBETA ), IBETA=1,10)/
     + 0.95509,0.95698,0.96105,0.96583,0.97048,0.97460,0.97796,0.98050,
     + 0.98218,0.98304/
       DATA (BM3I( 5, 8,IBETA ), IBETA=1,10)/
     + 0.98596,0.98660,0.98794,0.98943,0.99074,0.99172,0.99227,0.99235,
     + 0.99192,0.99096/
       DATA (BM3I( 5, 9,IBETA ), IBETA=1,10)/
     + 0.99581,0.99600,0.99637,0.99672,0.99691,0.99687,0.99653,0.99585,
     + 0.99478,0.99329/
       DATA (BM3I( 5,10,IBETA ), IBETA=1,10)/
     + 0.99873,0.99878,0.99884,0.99883,0.99869,0.99834,0.99774,0.99684,
     + 0.99558,0.99394/
       DATA (BM3I( 6, 1,IBETA ), IBETA=1,10)/
     + 0.93335,0.93777,0.94711,0.95764,0.96741,0.97562,0.98210,0.98701,
     + 0.99064,0.99327/
       DATA (BM3I( 6, 2,IBETA ), IBETA=1,10)/
     + 0.92142,0.92646,0.93723,0.94947,0.96096,0.97069,0.97842,0.98431,
     + 0.98868,0.99186/
       DATA (BM3I( 6, 3,IBETA ), IBETA=1,10)/
     + 0.88678,0.89351,0.90810,0.92508,0.94138,0.95549,0.96693,0.97578,
     + 0.98243,0.98731/
       DATA (BM3I( 6, 4,IBETA ), IBETA=1,10)/
     + 0.83249,0.84124,0.86051,0.88357,0.90655,0.92728,0.94477,0.95880,
     + 0.96964,0.97779/
       DATA (BM3I( 6, 5,IBETA ), IBETA=1,10)/
     + 0.79593,0.80444,0.82355,0.84725,0.87211,0.89593,0.91735,0.93566,
     + 0.95066,0.96255/
       DATA (BM3I( 6, 6,IBETA ), IBETA=1,10)/
     + 0.84124,0.84695,0.85980,0.87575,0.89256,0.90885,0.92383,0.93704,
     + 0.94830,0.95761/
       DATA (BM3I( 6, 7,IBETA ), IBETA=1,10)/
     + 0.92721,0.93011,0.93647,0.94406,0.95166,0.95862,0.96460,0.96949,
     + 0.97326,0.97595/
       DATA (BM3I( 6, 8,IBETA ), IBETA=1,10)/
     + 0.97573,0.97681,0.97913,0.98175,0.98421,0.98624,0.98772,0.98860,
     + 0.98885,0.98847/
       DATA (BM3I( 6, 9,IBETA ), IBETA=1,10)/
     + 0.99271,0.99304,0.99373,0.99444,0.99499,0.99528,0.99522,0.99477,
     + 0.99390,0.99258/
       DATA (BM3I( 6,10,IBETA ), IBETA=1,10)/
     + 0.99782,0.99791,0.99807,0.99817,0.99813,0.99788,0.99737,0.99653,
     + 0.99533,0.99374/
       DATA (BM3I( 7, 1,IBETA ), IBETA=1,10)/
     + 0.95858,0.96158,0.96780,0.97460,0.98073,0.98575,0.98963,0.99252,
     + 0.99463,0.99615/
       DATA (BM3I( 7, 2,IBETA ), IBETA=1,10)/
     + 0.95091,0.95438,0.96163,0.96962,0.97688,0.98286,0.98751,0.99099,
     + 0.99353,0.99536/
       DATA (BM3I( 7, 3,IBETA ), IBETA=1,10)/
     + 0.92751,0.93233,0.94255,0.95406,0.96473,0.97366,0.98070,0.98602,
     + 0.98994,0.99278/
       DATA (BM3I( 7, 4,IBETA ), IBETA=1,10)/
     + 0.88371,0.89075,0.90595,0.92351,0.94028,0.95474,0.96642,0.97544,
     + 0.98220,0.98715/
       DATA (BM3I( 7, 5,IBETA ), IBETA=1,10)/
     + 0.82880,0.83750,0.85671,0.87980,0.90297,0.92404,0.94195,0.95644,
     + 0.96772,0.97625/
       DATA (BM3I( 7, 6,IBETA ), IBETA=1,10)/
     + 0.81933,0.82655,0.84279,0.86295,0.88412,0.90449,0.92295,0.93890,
     + 0.95215,0.96281/
       DATA (BM3I( 7, 7,IBETA ), IBETA=1,10)/
     + 0.89099,0.89519,0.90448,0.91577,0.92732,0.93820,0.94789,0.95616,
     + 0.96297,0.96838/
       DATA (BM3I( 7, 8,IBETA ), IBETA=1,10)/
     + 0.95886,0.96064,0.96448,0.96894,0.97324,0.97701,0.98004,0.98228,
     + 0.98371,0.98435/
       DATA (BM3I( 7, 9,IBETA ), IBETA=1,10)/
     + 0.98727,0.98786,0.98908,0.99043,0.99160,0.99245,0.99288,0.99285,
     + 0.99234,0.99131/
       DATA (BM3I( 7,10,IBETA ), IBETA=1,10)/
     + 0.99621,0.99638,0.99671,0.99700,0.99715,0.99707,0.99670,0.99599,
     + 0.99489,0.99338/
       DATA (BM3I( 8, 1,IBETA ), IBETA=1,10)/
     + 0.97470,0.97666,0.98064,0.98491,0.98867,0.99169,0.99399,0.99569,
     + 0.99691,0.99779/
       DATA (BM3I( 8, 2,IBETA ), IBETA=1,10)/
     + 0.96996,0.97225,0.97693,0.98196,0.98643,0.99003,0.99279,0.99482,
     + 0.99630,0.99735/
       DATA (BM3I( 8, 3,IBETA ), IBETA=1,10)/
     + 0.95523,0.95848,0.96522,0.97260,0.97925,0.98468,0.98888,0.99200,
     + 0.99427,0.99590/
       DATA (BM3I( 8, 4,IBETA ), IBETA=1,10)/
     + 0.92524,0.93030,0.94098,0.95294,0.96397,0.97317,0.98038,0.98582,
     + 0.98981,0.99270/
       DATA (BM3I( 8, 5,IBETA ), IBETA=1,10)/
     + 0.87576,0.88323,0.89935,0.91799,0.93583,0.95126,0.96377,0.97345,
     + 0.98072,0.98606/
       DATA (BM3I( 8, 6,IBETA ), IBETA=1,10)/
     + 0.83078,0.83894,0.85705,0.87899,0.90126,0.92179,0.93950,0.95404,
     + 0.96551,0.97430/
       DATA (BM3I( 8, 7,IBETA ), IBETA=1,10)/
     + 0.85727,0.86294,0.87558,0.89111,0.90723,0.92260,0.93645,0.94841,
     + 0.95838,0.96643/
       DATA (BM3I( 8, 8,IBETA ), IBETA=1,10)/
     + 0.93337,0.93615,0.94220,0.94937,0.95647,0.96292,0.96840,0.97283,
     + 0.97619,0.97854/
       DATA (BM3I( 8, 9,IBETA ), IBETA=1,10)/
     + 0.97790,0.97891,0.98105,0.98346,0.98569,0.98751,0.98879,0.98950,
     + 0.98961,0.98912/
       DATA (BM3I( 8,10,IBETA ), IBETA=1,10)/
     + 0.99337,0.99367,0.99430,0.99493,0.99541,0.99562,0.99551,0.99501,
     + 0.99410,0.99274/
       DATA (BM3I( 9, 1,IBETA ), IBETA=1,10)/
     + 0.98470,0.98594,0.98844,0.99106,0.99334,0.99514,0.99650,0.99749,
     + 0.99821,0.99872/
       DATA (BM3I( 9, 2,IBETA ), IBETA=1,10)/
     + 0.98184,0.98330,0.98624,0.98934,0.99205,0.99420,0.99582,0.99701,
     + 0.99787,0.99848/
       DATA (BM3I( 9, 3,IBETA ), IBETA=1,10)/
     + 0.97288,0.97498,0.97927,0.98385,0.98789,0.99113,0.99360,0.99541,
     + 0.99673,0.99766/
       DATA (BM3I( 9, 4,IBETA ), IBETA=1,10)/
     + 0.95403,0.95741,0.96440,0.97202,0.97887,0.98444,0.98872,0.99190,
     + 0.99421,0.99586/
       DATA (BM3I( 9, 5,IBETA ), IBETA=1,10)/
     + 0.91845,0.92399,0.93567,0.94873,0.96076,0.97079,0.97865,0.98457,
     + 0.98892,0.99206/
       DATA (BM3I( 9, 6,IBETA ), IBETA=1,10)/
     + 0.86762,0.87533,0.89202,0.91148,0.93027,0.94669,0.96013,0.97062,
     + 0.97855,0.98441/
       DATA (BM3I( 9, 7,IBETA ), IBETA=1,10)/
     + 0.84550,0.85253,0.86816,0.88721,0.90671,0.92490,0.94083,0.95413,
     + 0.96481,0.97314/
       DATA (BM3I( 9, 8,IBETA ), IBETA=1,10)/
     + 0.90138,0.90544,0.91437,0.92513,0.93602,0.94615,0.95506,0.96258,
     + 0.96868,0.97347/
       DATA (BM3I( 9, 9,IBETA ), IBETA=1,10)/
     + 0.96248,0.96415,0.96773,0.97187,0.97583,0.97925,0.98198,0.98394,
     + 0.98514,0.98559/
       DATA (BM3I( 9,10,IBETA ), IBETA=1,10)/
     + 0.98837,0.98892,0.99005,0.99127,0.99232,0.99306,0.99339,0.99328,
     + 0.99269,0.99161/
       DATA (BM3I(10, 1,IBETA ), IBETA=1,10)/
     + 0.99080,0.99158,0.99311,0.99471,0.99607,0.99715,0.99795,0.99853,
     + 0.99895,0.99925/
       DATA (BM3I(10, 2,IBETA ), IBETA=1,10)/
     + 0.98910,0.99001,0.99182,0.99371,0.99533,0.99661,0.99757,0.99826,
     + 0.99876,0.99912/
       DATA (BM3I(10, 3,IBETA ), IBETA=1,10)/
     + 0.98374,0.98506,0.98772,0.99051,0.99294,0.99486,0.99630,0.99736,
     + 0.99812,0.99866/
       DATA (BM3I(10, 4,IBETA ), IBETA=1,10)/
     + 0.97238,0.97453,0.97892,0.98361,0.98773,0.99104,0.99354,0.99538,
     + 0.99671,0.99765/
       DATA (BM3I(10, 5,IBETA ), IBETA=1,10)/
     + 0.94961,0.95333,0.96103,0.96941,0.97693,0.98303,0.98772,0.99119,
     + 0.99371,0.99551/
       DATA (BM3I(10, 6,IBETA ), IBETA=1,10)/
     + 0.90943,0.91550,0.92834,0.94275,0.95608,0.96723,0.97600,0.98263,
     + 0.98751,0.99103/
       DATA (BM3I(10, 7,IBETA ), IBETA=1,10)/
     + 0.86454,0.87200,0.88829,0.90749,0.92630,0.94300,0.95687,0.96785,
     + 0.97626,0.98254/
       DATA (BM3I(10, 8,IBETA ), IBETA=1,10)/
     + 0.87498,0.88048,0.89264,0.90737,0.92240,0.93642,0.94877,0.95917,
     + 0.96762,0.97429/
       DATA (BM3I(10, 9,IBETA ), IBETA=1,10)/
     + 0.93946,0.94209,0.94781,0.95452,0.96111,0.96704,0.97203,0.97602,
     + 0.97900,0.98106/
       DATA (BM3I(10,10,IBETA ), IBETA=1,10)/
     + 0.97977,0.98071,0.98270,0.98492,0.98695,0.98858,0.98970,0.99027,
     + 0.99026,0.98968/

c FSB FM correction for INTRAmodal M2 coagulation  
       DATA BM2II /
     &  0.707107,  0.720583,  0.745310,  0.748056,  0.696935,
     &  0.604164,  0.504622,  0.416559,  0.343394,  0.283641/

c *** total correction for INTRAmodal M2 coagulation

      DATA BM2IITT /
     &  1.000000,  0.907452,  0.680931,  0.409815,  0.196425,
     &  0.078814,  0.028473,  0.009800,  0.003322,  0.001129/


c FSB FM correction for M2 i to j coagulation

      DATA (BM2IJ (  1,  1,IBETA), IBETA = 1,10) /
     &  0.707107,  0.716828,  0.738240,  0.764827,  0.793610,
     &  0.822843,  0.851217,  0.877670,  0.901404,  0.921944/
      DATA (BM2IJ (  1,  2,IBETA), IBETA = 1,10) /
     &  0.719180,  0.727975,  0.747638,  0.772334,  0.799234,
     &  0.826666,  0.853406,  0.878482,  0.901162,  0.920987/
      DATA (BM2IJ (  1,  3,IBETA), IBETA = 1,10) /
     &  0.760947,  0.767874,  0.783692,  0.803890,  0.826015,
     &  0.848562,  0.870498,  0.891088,  0.909823,  0.926400/
      DATA (BM2IJ (  1,  4,IBETA), IBETA = 1,10) /
     &  0.830926,  0.836034,  0.847708,  0.862528,  0.878521,
     &  0.894467,  0.909615,  0.923520,  0.935959,  0.946858/
      DATA (BM2IJ (  1,  5,IBETA), IBETA = 1,10) /
     &  0.903643,  0.907035,  0.914641,  0.924017,  0.933795,
     &  0.943194,  0.951806,  0.959449,  0.966087,  0.971761/
      DATA (BM2IJ (  1,  6,IBETA), IBETA = 1,10) /
     &  0.954216,  0.956094,  0.960211,  0.965123,  0.970068,
     &  0.974666,  0.978750,  0.982277,  0.985268,  0.987775/
      DATA (BM2IJ (  1,  7,IBETA), IBETA = 1,10) /
     &  0.980546,  0.981433,  0.983343,  0.985568,  0.987751,
     &  0.989735,  0.991461,  0.992926,  0.994150,  0.995164/
      DATA (BM2IJ (  1,  8,IBETA), IBETA = 1,10) /
     &  0.992142,  0.992524,  0.993338,  0.994272,  0.995174,
     &  0.995981,  0.996675,  0.997257,  0.997740,  0.998137/
      DATA (BM2IJ (  1,  9,IBETA), IBETA = 1,10) /
     &  0.996868,  0.997026,  0.997361,  0.997742,  0.998106,
     &  0.998430,  0.998705,  0.998935,  0.999125,  0.999280/
      DATA (BM2IJ (  1, 10,IBETA), IBETA = 1,10) /
     &  0.998737,  0.998802,  0.998939,  0.999094,  0.999241,
     &  0.999371,  0.999481,  0.999573,  0.999648,  0.999709/
      DATA (BM2IJ (  2,  1,IBETA), IBETA = 1,10) /
     &  0.729600,  0.739948,  0.763059,  0.791817,  0.822510,
     &  0.852795,  0.881000,  0.905999,  0.927206,  0.944532/
      DATA (BM2IJ (  2,  2,IBETA), IBETA = 1,10) /
     &  0.727025,  0.737116,  0.759615,  0.787657,  0.817740,
     &  0.847656,  0.875801,  0.901038,  0.922715,  0.940643/
      DATA (BM2IJ (  2,  3,IBETA), IBETA = 1,10) /
     &  0.738035,  0.746779,  0.766484,  0.791340,  0.818324,
     &  0.845546,  0.871629,  0.895554,  0.916649,  0.934597/
      DATA (BM2IJ (  2,  4,IBETA), IBETA = 1,10) /
     &  0.784185,  0.790883,  0.806132,  0.825501,  0.846545,
     &  0.867745,  0.888085,  0.906881,  0.923705,  0.938349/
      DATA (BM2IJ (  2,  5,IBETA), IBETA = 1,10) /
     &  0.857879,  0.862591,  0.873238,  0.886539,  0.900645,
     &  0.914463,  0.927360,  0.939004,  0.949261,  0.958125/
      DATA (BM2IJ (  2,  6,IBETA), IBETA = 1,10) /
     &  0.925441,  0.928304,  0.934645,  0.942324,  0.950181,
     &  0.957600,  0.964285,  0.970133,  0.975147,  0.979388/
      DATA (BM2IJ (  2,  7,IBETA), IBETA = 1,10) /
     &  0.966728,  0.968176,  0.971323,  0.975027,  0.978705,
     &  0.982080,  0.985044,  0.987578,  0.989710,  0.991485/
      DATA (BM2IJ (  2,  8,IBETA), IBETA = 1,10) /
     &  0.986335,  0.986980,  0.988362,  0.989958,  0.991511,
     &  0.992912,  0.994122,  0.995143,  0.995992,  0.996693/
      DATA (BM2IJ (  2,  9,IBETA), IBETA = 1,10) /
     &  0.994547,  0.994817,  0.995391,  0.996046,  0.996677,
     &  0.997238,  0.997719,  0.998122,  0.998454,  0.998727/
      DATA (BM2IJ (  2, 10,IBETA), IBETA = 1,10) /
     &  0.997817,  0.997928,  0.998163,  0.998429,  0.998683,
     &  0.998908,  0.999099,  0.999258,  0.999389,  0.999497/
      DATA (BM2IJ (  3,  1,IBETA), IBETA = 1,10) /
     &  0.783612,  0.793055,  0.814468,  0.841073,  0.868769,
     &  0.894963,  0.918118,  0.937527,  0.953121,  0.965244/
      DATA (BM2IJ (  3,  2,IBETA), IBETA = 1,10) /
     &  0.772083,  0.781870,  0.803911,  0.831238,  0.859802,
     &  0.887036,  0.911349,  0.931941,  0.948649,  0.961751/
      DATA (BM2IJ (  3,  3,IBETA), IBETA = 1,10) /
     &  0.755766,  0.765509,  0.787380,  0.814630,  0.843526,
     &  0.871670,  0.897443,  0.919870,  0.938557,  0.953576/
      DATA (BM2IJ (  3,  4,IBETA), IBETA = 1,10) /
     &  0.763816,  0.772145,  0.790997,  0.814784,  0.840434,
     &  0.865978,  0.890034,  0.911671,  0.930366,  0.945963/
      DATA (BM2IJ (  3,  5,IBETA), IBETA = 1,10) /
     &  0.813597,  0.819809,  0.833889,  0.851618,  0.870640,
     &  0.889514,  0.907326,  0.923510,  0.937768,  0.950003/
      DATA (BM2IJ (  3,  6,IBETA), IBETA = 1,10) /
     &  0.886317,  0.890437,  0.899643,  0.910955,  0.922730,
     &  0.934048,  0.944422,  0.953632,  0.961624,  0.968444/
      DATA (BM2IJ (  3,  7,IBETA), IBETA = 1,10) /
     &  0.944565,  0.946855,  0.951872,  0.957854,  0.963873,
     &  0.969468,  0.974438,  0.978731,  0.982372,  0.985424/
      DATA (BM2IJ (  3,  8,IBETA), IBETA = 1,10) /
     &  0.976358,  0.977435,  0.979759,  0.982467,  0.985125,
     &  0.987540,  0.989642,  0.991425,  0.992916,  0.994150/
      DATA (BM2IJ (  3,  9,IBETA), IBETA = 1,10) /
     &  0.990471,  0.990932,  0.991917,  0.993048,  0.994142,
     &  0.995121,  0.995964,  0.996671,  0.997258,  0.997740/
      DATA (BM2IJ (  3, 10,IBETA), IBETA = 1,10) /
     &  0.996199,  0.996389,  0.996794,  0.997254,  0.997694,
     &  0.998086,  0.998420,  0.998699,  0.998929,  0.999117/
      DATA (BM2IJ (  4,  1,IBETA), IBETA = 1,10) /
     &  0.844355,  0.852251,  0.869914,  0.891330,  0.912823,
     &  0.932259,  0.948642,  0.961767,  0.971897,  0.979510/
      DATA (BM2IJ (  4,  2,IBETA), IBETA = 1,10) /
     &  0.831550,  0.839954,  0.858754,  0.881583,  0.904592,
     &  0.925533,  0.943309,  0.957647,  0.968779,  0.977185/
      DATA (BM2IJ (  4,  3,IBETA), IBETA = 1,10) /
     &  0.803981,  0.813288,  0.834060,  0.859400,  0.885285,
     &  0.909286,  0.930084,  0.947193,  0.960714,  0.971078/
      DATA (BM2IJ (  4,  4,IBETA), IBETA = 1,10) /
     &  0.781787,  0.791080,  0.811931,  0.837749,  0.864768,
     &  0.890603,  0.913761,  0.933477,  0.949567,  0.962261/
      DATA (BM2IJ (  4,  5,IBETA), IBETA = 1,10) /
     &  0.791591,  0.799355,  0.816916,  0.838961,  0.862492,
     &  0.885595,  0.907003,  0.925942,  0.942052,  0.955310/
      DATA (BM2IJ (  4,  6,IBETA), IBETA = 1,10) /
     &  0.844933,  0.850499,  0.863022,  0.878593,  0.895038,
     &  0.911072,  0.925939,  0.939227,  0.950765,  0.960550/
      DATA (BM2IJ (  4,  7,IBETA), IBETA = 1,10) /
     &  0.912591,  0.916022,  0.923607,  0.932777,  0.942151,
     &  0.951001,  0.958976,  0.965950,  0.971924,  0.976965/
      DATA (BM2IJ (  4,  8,IBETA), IBETA = 1,10) /
     &  0.959859,  0.961617,  0.965433,  0.969924,  0.974382,
     &  0.978472,  0.982063,  0.985134,  0.987716,  0.989865/
      DATA (BM2IJ (  4,  9,IBETA), IBETA = 1,10) /
     &  0.983377,  0.984162,  0.985844,  0.987788,  0.989681,
     &  0.991386,  0.992860,  0.994104,  0.995139,  0.995991/
      DATA (BM2IJ (  4, 10,IBETA), IBETA = 1,10) /
     &  0.993343,  0.993672,  0.994370,  0.995169,  0.995937,
     &  0.996622,  0.997209,  0.997700,  0.998106,  0.998439/
      DATA (BM2IJ (  5,  1,IBETA), IBETA = 1,10) /
     &  0.895806,  0.901918,  0.915233,  0.930783,  0.945768,
     &  0.958781,  0.969347,  0.977540,  0.983697,  0.988225/
      DATA (BM2IJ (  5,  2,IBETA), IBETA = 1,10) /
     &  0.885634,  0.892221,  0.906629,  0.923540,  0.939918,
     &  0.954213,  0.965873,  0.974951,  0.981794,  0.986840/
      DATA (BM2IJ (  5,  3,IBETA), IBETA = 1,10) /
     &  0.860120,  0.867858,  0.884865,  0.904996,  0.924724,
     &  0.942177,  0.956602,  0.967966,  0.976616,  0.983043/
      DATA (BM2IJ (  5,  4,IBETA), IBETA = 1,10) /
     &  0.827462,  0.836317,  0.855885,  0.879377,  0.902897,
     &  0.924232,  0.942318,  0.956900,  0.968222,  0.976774/
      DATA (BM2IJ (  5,  5,IBETA), IBETA = 1,10) /
     &  0.805527,  0.814279,  0.833853,  0.857892,  0.882726,
     &  0.906095,  0.926690,  0.943938,  0.957808,  0.968615/
      DATA (BM2IJ (  5,  6,IBETA), IBETA = 1,10) /
     &  0.820143,  0.827223,  0.843166,  0.863002,  0.883905,
     &  0.904128,  0.922585,  0.938687,  0.952222,  0.963255/
      DATA (BM2IJ (  5,  7,IBETA), IBETA = 1,10) /
     &  0.875399,  0.880208,  0.890929,  0.904065,  0.917699,
     &  0.930756,  0.942656,  0.953131,  0.962113,  0.969657/
      DATA (BM2IJ (  5,  8,IBETA), IBETA = 1,10) /
     &  0.934782,  0.937520,  0.943515,  0.950656,  0.957840,
     &  0.964516,  0.970446,  0.975566,  0.979905,  0.983534/
      DATA (BM2IJ (  5,  9,IBETA), IBETA = 1,10) /
     &  0.971369,  0.972679,  0.975505,  0.978797,  0.982029,
     &  0.984964,  0.987518,  0.989685,  0.991496,  0.992994/
      DATA (BM2IJ (  5, 10,IBETA), IBETA = 1,10) /
     &  0.988329,  0.988893,  0.990099,  0.991485,  0.992825,
     &  0.994025,  0.995058,  0.995925,  0.996643,  0.997234/
      DATA (BM2IJ (  6,  1,IBETA), IBETA = 1,10) /
     &  0.933384,  0.937784,  0.947130,  0.957655,  0.967430,
     &  0.975639,  0.982119,  0.987031,  0.990657,  0.993288/
      DATA (BM2IJ (  6,  2,IBETA), IBETA = 1,10) /
     &  0.926445,  0.931227,  0.941426,  0.952975,  0.963754,
     &  0.972845,  0.980044,  0.985514,  0.989558,  0.992498/
      DATA (BM2IJ (  6,  3,IBETA), IBETA = 1,10) /
     &  0.907835,  0.913621,  0.926064,  0.940308,  0.953745,
     &  0.965189,  0.974327,  0.981316,  0.986510,  0.990297/
      DATA (BM2IJ (  6,  4,IBETA), IBETA = 1,10) /
     &  0.879088,  0.886306,  0.901945,  0.920079,  0.937460,
     &  0.952509,  0.964711,  0.974166,  0.981265,  0.986484/
      DATA (BM2IJ (  6,  5,IBETA), IBETA = 1,10) /
     &  0.846500,  0.854862,  0.873189,  0.894891,  0.916264,
     &  0.935315,  0.951197,  0.963812,  0.973484,  0.980715/
      DATA (BM2IJ (  6,  6,IBETA), IBETA = 1,10) /
     &  0.828137,  0.836250,  0.854310,  0.876287,  0.898710,
     &  0.919518,  0.937603,  0.952560,  0.964461,  0.973656/
      DATA (BM2IJ (  6,  7,IBETA), IBETA = 1,10) /
     &  0.848595,  0.854886,  0.868957,  0.886262,  0.904241,
     &  0.921376,  0.936799,  0.950096,  0.961172,  0.970145/
      DATA (BM2IJ (  6,  8,IBETA), IBETA = 1,10) /
     &  0.902919,  0.906922,  0.915760,  0.926427,  0.937312,
     &  0.947561,  0.956758,  0.964747,  0.971525,  0.977175/
      DATA (BM2IJ (  6,  9,IBETA), IBETA = 1,10) /
     &  0.952320,  0.954434,  0.959021,  0.964418,  0.969774,
     &  0.974688,  0.979003,  0.982690,  0.985789,  0.988364/
      DATA (BM2IJ (  6, 10,IBETA), IBETA = 1,10) /
     &  0.979689,  0.980650,  0.982712,  0.985093,  0.987413,
     &  0.989502,  0.991308,  0.992831,  0.994098,  0.995142/
      DATA (BM2IJ (  7,  1,IBETA), IBETA = 1,10) /
     &  0.958611,  0.961598,  0.967817,  0.974620,  0.980752,
     &  0.985771,  0.989650,  0.992543,  0.994653,  0.996171/
      DATA (BM2IJ (  7,  2,IBETA), IBETA = 1,10) /
     &  0.954225,  0.957488,  0.964305,  0.971795,  0.978576,
     &  0.984144,  0.988458,  0.991681,  0.994034,  0.995728/
      DATA (BM2IJ (  7,  3,IBETA), IBETA = 1,10) /
     &  0.942147,  0.946158,  0.954599,  0.963967,  0.972529,
     &  0.979612,  0.985131,  0.989271,  0.992301,  0.994487/
      DATA (BM2IJ (  7,  4,IBETA), IBETA = 1,10) /
     &  0.921821,  0.927048,  0.938140,  0.950598,  0.962118,
     &  0.971752,  0.979326,  0.985046,  0.989254,  0.992299/
      DATA (BM2IJ (  7,  5,IBETA), IBETA = 1,10) /
     &  0.893419,  0.900158,  0.914598,  0.931070,  0.946584,
     &  0.959795,  0.970350,  0.978427,  0.984432,  0.988811/
      DATA (BM2IJ (  7,  6,IBETA), IBETA = 1,10) /
     &  0.863302,  0.871111,  0.888103,  0.907990,  0.927305,
     &  0.944279,  0.958245,  0.969211,  0.977540,  0.983720/
      DATA (BM2IJ (  7,  7,IBETA), IBETA = 1,10) /
     &  0.850182,  0.857560,  0.873890,  0.893568,  0.913408,
     &  0.931591,  0.947216,  0.960014,  0.970121,  0.977886/
      DATA (BM2IJ (  7,  8,IBETA), IBETA = 1,10) /
     &  0.875837,  0.881265,  0.893310,  0.907936,  0.922910,
     &  0.936977,  0.949480,  0.960154,  0.968985,  0.976111/
      DATA (BM2IJ (  7,  9,IBETA), IBETA = 1,10) /
     &  0.926228,  0.929445,  0.936486,  0.944868,  0.953293,
     &  0.961108,  0.968028,  0.973973,  0.978974,  0.983118/
      DATA (BM2IJ (  7, 10,IBETA), IBETA = 1,10) /
     &  0.965533,  0.967125,  0.970558,  0.974557,  0.978484,
     &  0.982050,  0.985153,  0.987785,  0.989982,  0.991798/
      DATA (BM2IJ (  8,  1,IBETA), IBETA = 1,10) /
     &  0.974731,  0.976674,  0.980660,  0.984926,  0.988689,
     &  0.991710,  0.994009,  0.995703,  0.996929,  0.997805/
      DATA (BM2IJ (  8,  2,IBETA), IBETA = 1,10) /
     &  0.972062,  0.974192,  0.978571,  0.983273,  0.987432,
     &  0.990780,  0.993333,  0.995218,  0.996581,  0.997557/
      DATA (BM2IJ (  8,  3,IBETA), IBETA = 1,10) /
     &  0.964662,  0.967300,  0.972755,  0.978659,  0.983921,
     &  0.988181,  0.991444,  0.993859,  0.995610,  0.996863/
      DATA (BM2IJ (  8,  4,IBETA), IBETA = 1,10) /
     &  0.951782,  0.955284,  0.962581,  0.970559,  0.977737,
     &  0.983593,  0.988103,  0.991454,  0.993889,  0.995635/
      DATA (BM2IJ (  8,  5,IBETA), IBETA = 1,10) /
     &  0.931947,  0.936723,  0.946751,  0.957843,  0.967942,
     &  0.976267,  0.982734,  0.987571,  0.991102,  0.993642/
      DATA (BM2IJ (  8,  6,IBETA), IBETA = 1,10) /
     &  0.905410,  0.911665,  0.924950,  0.939908,  0.953798,
     &  0.965469,  0.974684,  0.981669,  0.986821,  0.990556/
      DATA (BM2IJ (  8,  7,IBETA), IBETA = 1,10) /
     &  0.878941,  0.886132,  0.901679,  0.919688,  0.936970,
     &  0.951980,  0.964199,  0.973709,  0.980881,  0.986174/
      DATA (BM2IJ (  8,  8,IBETA), IBETA = 1,10) /
     &  0.871653,  0.878218,  0.892652,  0.909871,  0.927034,
     &  0.942592,  0.955836,  0.966604,  0.975065,  0.981545/
      DATA (BM2IJ (  8,  9,IBETA), IBETA = 1,10) /
     &  0.900693,  0.905239,  0.915242,  0.927232,  0.939335,
     &  0.950555,  0.960420,  0.968774,  0.975651,  0.981188/
      DATA (BM2IJ (  8, 10,IBETA), IBETA = 1,10) /
     &  0.944922,  0.947435,  0.952894,  0.959317,  0.965689,
     &  0.971529,  0.976645,  0.981001,  0.984641,  0.987642/
      DATA (BM2IJ (  9,  1,IBETA), IBETA = 1,10) /
     &  0.984736,  0.985963,  0.988453,  0.991078,  0.993357,
     &  0.995161,  0.996519,  0.997512,  0.998226,  0.998734/
      DATA (BM2IJ (  9,  2,IBETA), IBETA = 1,10) /
     &  0.983141,  0.984488,  0.987227,  0.990119,  0.992636,
     &  0.994632,  0.996137,  0.997238,  0.998030,  0.998595/
      DATA (BM2IJ (  9,  3,IBETA), IBETA = 1,10) /
     &  0.978726,  0.980401,  0.983819,  0.987450,  0.990626,
     &  0.993157,  0.995071,  0.996475,  0.997486,  0.998206/
      DATA (BM2IJ (  9,  4,IBETA), IBETA = 1,10) /
     &  0.970986,  0.973224,  0.977818,  0.982737,  0.987072,
     &  0.990546,  0.993184,  0.995124,  0.996523,  0.997521/
      DATA (BM2IJ (  9,  5,IBETA), IBETA = 1,10) /
     &  0.958579,  0.961700,  0.968149,  0.975116,  0.981307,
     &  0.986301,  0.990112,  0.992923,  0.994954,  0.996404/
      DATA (BM2IJ (  9,  6,IBETA), IBETA = 1,10) /
     &  0.940111,  0.944479,  0.953572,  0.963506,  0.972436,
     &  0.979714,  0.985313,  0.989468,  0.992483,  0.994641/
      DATA (BM2IJ (  9,  7,IBETA), IBETA = 1,10) /
     &  0.916127,  0.921878,  0.934003,  0.947506,  0.959899,
     &  0.970199,  0.978255,  0.984314,  0.988755,  0.991960/
      DATA (BM2IJ (  9,  8,IBETA), IBETA = 1,10) /
     &  0.893848,  0.900364,  0.914368,  0.930438,  0.945700,
     &  0.958824,  0.969416,  0.977603,  0.983746,  0.988262/
      DATA (BM2IJ (  9,  9,IBETA), IBETA = 1,10) /
     &  0.892161,  0.897863,  0.910315,  0.925021,  0.939523,
     &  0.952544,  0.963544,  0.972442,  0.979411,  0.984742/
      DATA (BM2IJ (  9, 10,IBETA), IBETA = 1,10) /
     &  0.922260,  0.925966,  0.934047,  0.943616,  0.953152,
     &  0.961893,  0.969506,  0.975912,  0.981167,  0.985394/
      DATA (BM2IJ ( 10,  1,IBETA), IBETA = 1,10) /
     &  0.990838,  0.991598,  0.993128,  0.994723,  0.996092,
     &  0.997167,  0.997969,  0.998552,  0.998969,  0.999265/
      DATA (BM2IJ ( 10,  2,IBETA), IBETA = 1,10) /
     &  0.989892,  0.990727,  0.992411,  0.994167,  0.995678,
     &  0.996864,  0.997751,  0.998396,  0.998858,  0.999186/
      DATA (BM2IJ ( 10,  3,IBETA), IBETA = 1,10) /
     &  0.987287,  0.988327,  0.990428,  0.992629,  0.994529,
     &  0.996026,  0.997148,  0.997965,  0.998551,  0.998967/
      DATA (BM2IJ ( 10,  4,IBETA), IBETA = 1,10) /
     &  0.982740,  0.984130,  0.986952,  0.989926,  0.992508,
     &  0.994551,  0.996087,  0.997208,  0.998012,  0.998584/
      DATA (BM2IJ ( 10,  5,IBETA), IBETA = 1,10) /
     &  0.975380,  0.977330,  0.981307,  0.985529,  0.989216,
     &  0.992147,  0.994358,  0.995975,  0.997136,  0.997961/
      DATA (BM2IJ ( 10,  6,IBETA), IBETA = 1,10) /
     &  0.963911,  0.966714,  0.972465,  0.978614,  0.984022,
     &  0.988346,  0.991620,  0.994020,  0.995747,  0.996974/
      DATA (BM2IJ ( 10,  7,IBETA), IBETA = 1,10) /
     &  0.947187,  0.951161,  0.959375,  0.968258,  0.976160,
     &  0.982540,  0.987409,  0.991000,  0.993592,  0.995441/
      DATA (BM2IJ ( 10,  8,IBETA), IBETA = 1,10) /
     &  0.926045,  0.931270,  0.942218,  0.954297,  0.965273,
     &  0.974311,  0.981326,  0.986569,  0.990394,  0.993143/
      DATA (BM2IJ ( 10,  9,IBETA), IBETA = 1,10) /
     &  0.908092,  0.913891,  0.926288,  0.940393,  0.953667,
     &  0.964987,  0.974061,  0.981038,  0.986253,  0.990078/
      DATA (BM2IJ ( 10, 10,IBETA), IBETA = 1,10) /
     &  0.911143,  0.915972,  0.926455,  0.938721,  0.950701,
     &  0.961370,  0.970329,  0.977549,  0.983197,  0.987518/


C FSB Total correction factor for M2 coagulation j from i

      DATA  (BM2JI( 1, 1,IBETA), IBETA = 1,10) /
     &  0.753466,  0.756888,  0.761008,  0.759432,  0.748675,
     &  0.726951,  0.693964,  0.650915,  0.600227,  0.545000/
      DATA  (BM2JI( 1, 2,IBETA), IBETA = 1,10) /
     &  0.824078,  0.828698,  0.835988,  0.838943,  0.833454,
     &  0.817148,  0.789149,  0.750088,  0.701887,  0.647308/
      DATA  (BM2JI( 1, 3,IBETA), IBETA = 1,10) /
     &  1.007389,  1.014362,  1.028151,  1.041011,  1.047939,
     &  1.045707,  1.032524,  1.007903,  0.972463,  0.927667/
      DATA  (BM2JI( 1, 4,IBETA), IBETA = 1,10) /
     &  1.246157,  1.255135,  1.274249,  1.295351,  1.313362,
     &  1.325187,  1.329136,  1.324491,  1.311164,  1.289459/
      DATA  (BM2JI( 1, 5,IBETA), IBETA = 1,10) /
     &  1.450823,  1.459551,  1.478182,  1.499143,  1.518224,
     &  1.533312,  1.543577,  1.548882,  1.549395,  1.545364/
      DATA  (BM2JI( 1, 6,IBETA), IBETA = 1,10) /
     &  1.575248,  1.581832,  1.595643,  1.610866,  1.624601,
     &  1.635690,  1.643913,  1.649470,  1.652688,  1.653878/
      DATA  (BM2JI( 1, 7,IBETA), IBETA = 1,10) /
     &  1.638426,  1.642626,  1.651293,  1.660641,  1.668926,
     &  1.675571,  1.680572,  1.684147,  1.686561,  1.688047/
      DATA  (BM2JI( 1, 8,IBETA), IBETA = 1,10) /
     &  1.669996,  1.672392,  1.677283,  1.682480,  1.687028,
     &  1.690651,  1.693384,  1.695372,  1.696776,  1.697734/
      DATA  (BM2JI( 1, 9,IBETA), IBETA = 1,10) /
     &  1.686148,  1.687419,  1.689993,  1.692704,  1.695057,
     &  1.696922,  1.698329,  1.699359,  1.700099,  1.700621/
      DATA  (BM2JI( 1,10,IBETA), IBETA = 1,10) /
     &  1.694364,  1.695010,  1.696313,  1.697676,  1.698853,
     &  1.699782,  1.700482,  1.700996,  1.701366,  1.701631/
      DATA  (BM2JI( 2, 1,IBETA), IBETA = 1,10) /
     &  0.783166,  0.779369,  0.768044,  0.747572,  0.716709,
     &  0.675422,  0.624981,  0.567811,  0.507057,  0.445975/
      DATA  (BM2JI( 2, 2,IBETA), IBETA = 1,10) /
     &  0.848390,  0.847100,  0.840874,  0.826065,  0.800296,
     &  0.762625,  0.713655,  0.655545,  0.591603,  0.525571/
      DATA  (BM2JI( 2, 3,IBETA), IBETA = 1,10) /
     &  1.039894,  1.043786,  1.049445,  1.049664,  1.039407,
     &  1.015322,  0.975983,  0.922180,  0.856713,  0.783634/
      DATA  (BM2JI( 2, 4,IBETA), IBETA = 1,10) /
     &  1.345995,  1.356064,  1.376947,  1.398304,  1.412685,
     &  1.414611,  1.400652,  1.369595,  1.322261,  1.260993/
      DATA  (BM2JI( 2, 5,IBETA), IBETA = 1,10) /
     &  1.675575,  1.689859,  1.720957,  1.756659,  1.788976,
     &  1.812679,  1.824773,  1.824024,  1.810412,  1.784630/
      DATA  (BM2JI( 2, 6,IBETA), IBETA = 1,10) /
     &  1.919835,  1.933483,  1.962973,  1.996810,  2.028377,
     &  2.054172,  2.072763,  2.083963,  2.088190,  2.086052/
      DATA  (BM2JI( 2, 7,IBETA), IBETA = 1,10) /
     &  2.064139,  2.074105,  2.095233,  2.118909,  2.140688,
     &  2.158661,  2.172373,  2.182087,  2.188330,  2.191650/
      DATA  (BM2JI( 2, 8,IBETA), IBETA = 1,10) /
     &  2.144871,  2.150990,  2.163748,  2.177731,  2.190364,
     &  2.200712,  2.208687,  2.214563,  2.218716,  2.221502/
      DATA  (BM2JI( 2, 9,IBETA), IBETA = 1,10) /
     &  2.189223,  2.192595,  2.199540,  2.207033,  2.213706,
     &  2.219125,  2.223297,  2.226403,  2.228660,  2.230265/
      DATA  (BM2JI( 2,10,IBETA), IBETA = 1,10) /
     &  2.212595,  2.214342,  2.217912,  2.221723,  2.225082,
     &  2.227791,  2.229869,  2.231417,  2.232551,  2.233372/
      DATA  (BM2JI( 3, 1,IBETA), IBETA = 1,10) /
     &  0.837870,  0.824476,  0.793119,  0.750739,  0.700950,
     &  0.646691,  0.590508,  0.534354,  0.479532,  0.426856/
      DATA  (BM2JI( 3, 2,IBETA), IBETA = 1,10) /
     &  0.896771,  0.885847,  0.859327,  0.821694,  0.775312,
     &  0.722402,  0.665196,  0.605731,  0.545742,  0.486687/
      DATA  (BM2JI( 3, 3,IBETA), IBETA = 1,10) /
     &  1.076089,  1.071727,  1.058845,  1.036171,  1.002539,
     &  0.957521,  0.901640,  0.836481,  0.764597,  0.689151/
      DATA  (BM2JI( 3, 4,IBETA), IBETA = 1,10) /
     &  1.409571,  1.415168,  1.425346,  1.432021,  1.428632,
     &  1.409696,  1.371485,  1.312958,  1.236092,  1.145293/
      DATA  (BM2JI( 3, 5,IBETA), IBETA = 1,10) /
     &  1.862757,  1.880031,  1.918394,  1.963456,  2.004070,
     &  2.030730,  2.036144,  2.016159,  1.970059,  1.900079/
      DATA  (BM2JI( 3, 6,IBETA), IBETA = 1,10) /
     &  2.289741,  2.313465,  2.366789,  2.431612,  2.495597,
     &  2.549838,  2.588523,  2.608665,  2.609488,  2.591662/
      DATA  (BM2JI( 3, 7,IBETA), IBETA = 1,10) /
     &  2.597157,  2.618731,  2.666255,  2.722597,  2.777531,
     &  2.825187,  2.862794,  2.889648,  2.906199,  2.913380/
      DATA  (BM2JI( 3, 8,IBETA), IBETA = 1,10) /
     &  2.797975,  2.813116,  2.845666,  2.882976,  2.918289,
     &  2.948461,  2.972524,  2.990687,  3.003664,  3.012284/
      DATA  (BM2JI( 3, 9,IBETA), IBETA = 1,10) /
     &  2.920832,  2.929843,  2.948848,  2.970057,  2.989632,
     &  3.006057,  3.019067,  3.028979,  3.036307,  3.041574/
      DATA  (BM2JI( 3,10,IBETA), IBETA = 1,10) /
     &  2.989627,  2.994491,  3.004620,  3.015720,  3.025789,
     &  3.034121,  3.040664,  3.045641,  3.049347,  3.052066/
      DATA  (BM2JI( 4, 1,IBETA), IBETA = 1,10) /
     &  0.893179,  0.870897,  0.820996,  0.759486,  0.695488,
     &  0.634582,  0.579818,  0.532143,  0.490927,  0.454618/
      DATA  (BM2JI( 4, 2,IBETA), IBETA = 1,10) /
     &  0.948355,  0.927427,  0.880215,  0.821146,  0.758524,
     &  0.697680,  0.641689,  0.591605,  0.546919,  0.506208/
      DATA  (BM2JI( 4, 3,IBETA), IBETA = 1,10) /
     &  1.109562,  1.093648,  1.056438,  1.007310,  0.951960,
     &  0.894453,  0.837364,  0.781742,  0.727415,  0.673614/
      DATA  (BM2JI( 4, 4,IBETA), IBETA = 1,10) /
     &  1.423321,  1.417557,  1.402442,  1.379079,  1.347687,
     &  1.308075,  1.259703,  1.201983,  1.134778,  1.058878/
      DATA  (BM2JI( 4, 5,IBETA), IBETA = 1,10) /
     &  1.933434,  1.944347,  1.968765,  1.997653,  2.023054,
     &  2.036554,  2.029949,  1.996982,  1.934982,  1.845473/
      DATA  (BM2JI( 4, 6,IBETA), IBETA = 1,10) /
     &  2.547772,  2.577105,  2.645918,  2.735407,  2.830691,
     &  2.917268,  2.981724,  3.013684,  3.007302,  2.961560/
      DATA  (BM2JI( 4, 7,IBETA), IBETA = 1,10) /
     &  3.101817,  3.139271,  3.225851,  3.336402,  3.453409,
     &  3.563116,  3.655406,  3.724014,  3.766113,  3.781394/
      DATA  (BM2JI( 4, 8,IBETA), IBETA = 1,10) /
     &  3.540920,  3.573780,  3.647439,  3.737365,  3.828468,
     &  3.911436,  3.981317,  4.036345,  4.076749,  4.103751/
      DATA  (BM2JI( 4, 9,IBETA), IBETA = 1,10) /
     &  3.856771,  3.879363,  3.928579,  3.986207,  4.042173,
     &  4.091411,  4.132041,  4.164052,  4.188343,  4.206118/
      DATA  (BM2JI( 4,10,IBETA), IBETA = 1,10) /
     &  4.053923,  4.067191,  4.095509,  4.127698,  4.158037,
     &  4.184055,  4.205135,  4.221592,  4.234115,  4.243463/
      DATA  (BM2JI( 5, 1,IBETA), IBETA = 1,10) /
     &  0.935846,  0.906814,  0.843358,  0.768710,  0.695885,
     &  0.631742,  0.579166,  0.538471,  0.508410,  0.486863/
      DATA  (BM2JI( 5, 2,IBETA), IBETA = 1,10) /
     &  0.988308,  0.959524,  0.896482,  0.821986,  0.748887,
     &  0.684168,  0.630908,  0.589516,  0.558676,  0.536056/
      DATA  (BM2JI( 5, 3,IBETA), IBETA = 1,10) /
     &  1.133795,  1.107139,  1.048168,  0.977258,  0.906341,
     &  0.842477,  0.789093,  0.746731,  0.713822,  0.687495/
      DATA  (BM2JI( 5, 4,IBETA), IBETA = 1,10) /
     &  1.405692,  1.385781,  1.340706,  1.284776,  1.227085,
     &  1.173532,  1.127008,  1.087509,  1.052712,  1.018960/
      DATA  (BM2JI( 5, 5,IBETA), IBETA = 1,10) /
     &  1.884992,  1.879859,  1.868463,  1.854995,  1.841946,
     &  1.829867,  1.816972,  1.799319,  1.771754,  1.729406/
      DATA  (BM2JI( 5, 6,IBETA), IBETA = 1,10) /
     &  2.592275,  2.612268,  2.661698,  2.731803,  2.815139,
     &  2.901659,  2.978389,  3.031259,  3.048045,  3.021122/
      DATA  (BM2JI( 5, 7,IBETA), IBETA = 1,10) /
     &  3.390321,  3.435519,  3.545615,  3.698419,  3.876958,
     &  4.062790,  4.236125,  4.378488,  4.475619,  4.519170/
      DATA  (BM2JI( 5, 8,IBETA), IBETA = 1,10) /
     &  4.161376,  4.216558,  4.346896,  4.519451,  4.711107,
     &  4.902416,  5.077701,  5.226048,  5.341423,  5.421764/
      DATA  (BM2JI( 5, 9,IBETA), IBETA = 1,10) /
     &  4.843961,  4.892035,  5.001492,  5.138515,  5.281684,
     &  5.416805,  5.535493,  5.634050,  5.712063,  5.770996/
      DATA  (BM2JI( 5,10,IBETA), IBETA = 1,10) /
     &  5.352093,  5.385119,  5.458056,  5.545311,  5.632162,
     &  5.710566,  5.777005,  5.830863,  5.873123,  5.905442/
      DATA  (BM2JI( 6, 1,IBETA), IBETA = 1,10) /
     &  0.964038,  0.930794,  0.859433,  0.777776,  0.700566,
     &  0.634671,  0.582396,  0.543656,  0.517284,  0.501694/
      DATA  (BM2JI( 6, 2,IBETA), IBETA = 1,10) /
     &  1.013416,  0.979685,  0.907197,  0.824135,  0.745552,
     &  0.678616,  0.625870,  0.587348,  0.561864,  0.547674/
      DATA  (BM2JI( 6, 3,IBETA), IBETA = 1,10) /
     &  1.145452,  1.111457,  1.038152,  0.953750,  0.873724,
     &  0.805955,  0.753621,  0.717052,  0.694920,  0.684910/
      DATA  (BM2JI( 6, 4,IBETA), IBETA = 1,10) /
     &  1.376547,  1.345004,  1.276415,  1.196704,  1.121091,
     &  1.058249,  1.012197,  0.983522,  0.970323,  0.968933/
      DATA  (BM2JI( 6, 5,IBETA), IBETA = 1,10) /
     &  1.778801,  1.755897,  1.706074,  1.649008,  1.597602,
     &  1.560087,  1.540365,  1.538205,  1.549738,  1.568333/
      DATA  (BM2JI( 6, 6,IBETA), IBETA = 1,10) /
     &  2.447603,  2.445172,  2.443762,  2.451842,  2.475877,
     &  2.519039,  2.580118,  2.653004,  2.727234,  2.789738/
      DATA  (BM2JI( 6, 7,IBETA), IBETA = 1,10) /
     &  3.368490,  3.399821,  3.481357,  3.606716,  3.772101,
     &  3.969416,  4.184167,  4.396163,  4.582502,  4.721838/
      DATA  (BM2JI( 6, 8,IBETA), IBETA = 1,10) /
     &  4.426458,  4.489861,  4.648250,  4.877510,  5.160698,
     &  5.477495,  5.803123,  6.111250,  6.378153,  6.586050/
      DATA  (BM2JI( 6, 9,IBETA), IBETA = 1,10) /
     &  5.568061,  5.644988,  5.829837,  6.081532,  6.371214,
     &  6.672902,  6.963737,  7.226172,  7.449199,  7.627886/
      DATA  (BM2JI( 6,10,IBETA), IBETA = 1,10) /
     &  6.639152,  6.707020,  6.863974,  7.065285,  7.281744,
     &  7.492437,  7.683587,  7.847917,  7.983296,  8.090977/
      DATA  (BM2JI( 7, 1,IBETA), IBETA = 1,10) /
     &  0.980853,  0.945724,  0.871244,  0.787311,  0.708818,
     &  0.641987,  0.588462,  0.547823,  0.518976,  0.500801/
      DATA  (BM2JI( 7, 2,IBETA), IBETA = 1,10) /
     &  1.026738,  0.990726,  0.914306,  0.828140,  0.747637,
     &  0.679351,  0.625127,  0.584662,  0.556910,  0.540749/
      DATA  (BM2JI( 7, 3,IBETA), IBETA = 1,10) /
     &  1.146496,  1.108808,  1.028695,  0.938291,  0.854101,
     &  0.783521,  0.728985,  0.690539,  0.667272,  0.657977/
      DATA  (BM2JI( 7, 4,IBETA), IBETA = 1,10) /
     &  1.344846,  1.306434,  1.224543,  1.132031,  1.046571,
     &  0.976882,  0.926488,  0.896067,  0.884808,  0.891027/
      DATA  (BM2JI( 7, 5,IBETA), IBETA = 1,10) /
     &  1.670227,  1.634583,  1.558421,  1.472939,  1.396496,
     &  1.339523,  1.307151,  1.300882,  1.319622,  1.360166/
      DATA  (BM2JI( 7, 6,IBETA), IBETA = 1,10) /
     &  2.224548,  2.199698,  2.148284,  2.095736,  2.059319,
     &  2.050496,  2.075654,  2.136382,  2.229641,  2.347958/
      DATA  (BM2JI( 7, 7,IBETA), IBETA = 1,10) /
     &  3.104483,  3.105947,  3.118398,  3.155809,  3.230427,
     &  3.350585,  3.519071,  3.731744,  3.976847,  4.235616/
      DATA  (BM2JI( 7, 8,IBETA), IBETA = 1,10) /
     &  4.288426,  4.331456,  4.447024,  4.633023,  4.891991,
     &  5.221458,  5.610060,  6.036467,  6.471113,  6.880462/
      DATA  (BM2JI( 7, 9,IBETA), IBETA = 1,10) /
     &  5.753934,  5.837061,  6.048530,  6.363800,  6.768061,
     &  7.241280,  7.755346,  8.276666,  8.771411,  9.210826/
      DATA  (BM2JI( 7,10,IBETA), IBETA = 1,10) /
     &  7.466219,  7.568810,  7.819032,  8.168340,  8.582973,
     &  9.030174,  9.478159,  9.899834, 10.275940, 10.595910/
      DATA  (BM2JI( 8, 1,IBETA), IBETA = 1,10) /
     &  0.990036,  0.954782,  0.880531,  0.797334,  0.719410,
     &  0.652220,  0.596923,  0.552910,  0.519101,  0.494529/
      DATA  (BM2JI( 8, 2,IBETA), IBETA = 1,10) /
     &  1.032428,  0.996125,  0.919613,  0.833853,  0.753611,
     &  0.684644,  0.628260,  0.583924,  0.550611,  0.527407/
      DATA  (BM2JI( 8, 3,IBETA), IBETA = 1,10) /
     &  1.141145,  1.102521,  1.021017,  0.929667,  0.844515,
     &  0.772075,  0.714086,  0.670280,  0.639824,  0.621970/
      DATA  (BM2JI( 8, 4,IBETA), IBETA = 1,10) /
     &  1.314164,  1.273087,  1.186318,  1.089208,  0.999476,
     &  0.924856,  0.867948,  0.829085,  0.807854,  0.803759/
      DATA  (BM2JI( 8, 5,IBETA), IBETA = 1,10) /
     &  1.580611,  1.538518,  1.449529,  1.350459,  1.260910,
     &  1.190526,  1.143502,  1.121328,  1.124274,  1.151974/
      DATA  (BM2JI( 8, 6,IBETA), IBETA = 1,10) /
     &  2.016773,  1.977721,  1.895727,  1.806974,  1.732891,
     &  1.685937,  1.673026,  1.697656,  1.761039,  1.862391/
      DATA  (BM2JI( 8, 7,IBETA), IBETA = 1,10) /
     &  2.750093,  2.723940,  2.672854,  2.628264,  2.612250,
     &  2.640406,  2.723211,  2.866599,  3.071893,  3.335217/
      DATA  (BM2JI( 8, 8,IBETA), IBETA = 1,10) /
     &  3.881905,  3.887143,  3.913667,  3.981912,  4.111099,
     &  4.316575,  4.608146,  4.988157,  5.449592,  5.974848/
      DATA  (BM2JI( 8, 9,IBETA), IBETA = 1,10) /
     &  5.438870,  5.492742,  5.640910,  5.886999,  6.241641,
     &  6.710609,  7.289480,  7.960725,  8.693495,  9.446644/
      DATA  (BM2JI( 8,10,IBETA), IBETA = 1,10) /
     &  7.521152,  7.624621,  7.892039,  8.300444,  8.839787,
     &  9.493227, 10.231770, 11.015642, 11.799990, 12.542260/
      DATA  (BM2JI( 9, 1,IBETA), IBETA = 1,10) /
     &  0.994285,  0.960012,  0.887939,  0.807040,  0.730578,
     &  0.663410,  0.606466,  0.559137,  0.520426,  0.489429/
      DATA  (BM2JI( 9, 2,IBETA), IBETA = 1,10) /
     &  1.033505,  0.998153,  0.923772,  0.840261,  0.761383,
     &  0.692242,  0.633873,  0.585709,  0.546777,  0.516215/
      DATA  (BM2JI( 9, 3,IBETA), IBETA = 1,10) /
     &  1.132774,  1.094907,  1.015161,  0.925627,  0.841293,
     &  0.767888,  0.706741,  0.657439,  0.619135,  0.591119/
      DATA  (BM2JI( 9, 4,IBETA), IBETA = 1,10) /
     &  1.286308,  1.245273,  1.158809,  1.061889,  0.971208,
     &  0.893476,  0.830599,  0.782561,  0.748870,  0.729198/
      DATA  (BM2JI( 9, 5,IBETA), IBETA = 1,10) /
     &  1.511105,  1.467141,  1.374520,  1.271162,  1.175871,
     &  1.096887,  1.037243,  0.997820,  0.978924,  0.980962/
      DATA  (BM2JI( 9, 6,IBETA), IBETA = 1,10) /
     &  1.857468,  1.812177,  1.717002,  1.612197,  1.519171,
     &  1.448660,  1.405871,  1.393541,  1.413549,  1.467532/
      DATA  (BM2JI( 9, 7,IBETA), IBETA = 1,10) /
     &  2.430619,  2.388452,  2.301326,  2.210241,  2.139724,
     &  2.104571,  2.114085,  2.174696,  2.291294,  2.467500/
      DATA  (BM2JI( 9, 8,IBETA), IBETA = 1,10) /
     &  3.385332,  3.357690,  3.306611,  3.269804,  3.274462,
     &  3.340862,  3.484609,  3.717740,  4.048748,  4.481588/
      DATA  (BM2JI( 9, 9,IBETA), IBETA = 1,10) /
     &  4.850497,  4.858280,  4.896008,  4.991467,  5.171511,
     &  5.459421,  5.873700,  6.426128,  7.119061,  7.942603/
      DATA  (BM2JI( 9,10,IBETA), IBETA = 1,10) /
     &  6.957098,  7.020164,  7.197272,  7.499331,  7.946554,
     &  8.555048,  9.330503, 10.263610, 11.327454, 12.478332/
      DATA  (BM2JI(10, 1,IBETA), IBETA = 1,10) /
     &  0.994567,  0.961842,  0.892854,  0.814874,  0.740198,
     &  0.673303,  0.615105,  0.565139,  0.522558,  0.486556/
      DATA  (BM2JI(10, 2,IBETA), IBETA = 1,10) /
     &  1.031058,  0.997292,  0.926082,  0.845571,  0.768501,
     &  0.699549,  0.639710,  0.588538,  0.545197,  0.508894/
      DATA  (BM2JI(10, 3,IBETA), IBETA = 1,10) /
     &  1.122535,  1.086287,  1.009790,  0.923292,  0.840626,
     &  0.766982,  0.703562,  0.650004,  0.605525,  0.569411/
      DATA  (BM2JI(10, 4,IBETA), IBETA = 1,10) /
     &  1.261142,  1.221555,  1.137979,  1.043576,  0.953745,
     &  0.874456,  0.807292,  0.752109,  0.708326,  0.675477/
      DATA  (BM2JI(10, 5,IBETA), IBETA = 1,10) /
     &  1.456711,  1.413432,  1.322096,  1.219264,  1.122319,
     &  1.038381,  0.969743,  0.916811,  0.879544,  0.858099/
      DATA  (BM2JI(10, 6,IBETA), IBETA = 1,10) /
     &  1.741792,  1.695157,  1.596897,  1.487124,  1.385734,
     &  1.301670,  1.238638,  1.198284,  1.181809,  1.190689/
      DATA  (BM2JI(10, 7,IBETA), IBETA = 1,10) /
     &  2.190197,  2.141721,  2.040226,  1.929245,  1.832051,
     &  1.760702,  1.721723,  1.719436,  1.757705,  1.840677/
      DATA  (BM2JI(10, 8,IBETA), IBETA = 1,10) /
     &  2.940764,  2.895085,  2.801873,  2.707112,  2.638603,
     &  2.613764,  2.644686,  2.741255,  2.912790,  3.168519/
      DATA  (BM2JI(10, 9,IBETA), IBETA = 1,10) /
     &  4.186191,  4.155844,  4.101953,  4.069102,  4.089886,
     &  4.189530,  4.389145,  4.707528,  5.161567,  5.765283/
      DATA  (BM2JI(10,10,IBETA), IBETA = 1,10) /
     &  6.119526,  6.127611,  6.171174,  6.286528,  6.508738,
     &  6.869521,  7.396912,  8.113749,  9.034683, 10.162190/
        
C *** end of data statements.       


C *** START CALCULATIONS:

      CONSTII = ABS( HALF * ( TWO ) ** TWO3RDS - ONE )
      SQRTTWO = SQRT(TWO)      
      DLGSQT2 = ONE / LOG( SQRTTWO )

         ESAT01   = EXP( 0.125D0 * XXLSGAT * XXLSGAT )
         ESAC01   = EXP( 0.125D0 * XXLSGAC * XXLSGAC )

         ESAT04  = ESAT01 ** 4
         ESAC04  = ESAC01 ** 4

         ESAT05  = ESAT04 * ESAT01
         ESAC05  = ESAC04 * ESAC01
         
         ESAT08  = ESAT04 * ESAT04
         ESAC08  = ESAC04 * ESAC04
         
         ESAT09  = ESAT08 * ESAT01
         ESAC09  = ESAC08 * ESAC01

         ESAT16  = ESAT08 * ESAT08
         ESAC16  = ESAC08 * ESAC08
         
         ESAT20  = ESAT16 * ESAT04
         ESAC20  = ESAC16 * ESAC04

         ESAT24  = ESAT20 * ESAT04
         ESAC24  = ESAC20 * ESAC04
         
         ESAT25  = ESAT20 * ESAT05
         ESAC25  = ESAC20 * ESAC05
                  
         ESAT36  = ESAT20 * ESAT16
         ESAC36  = ESAC20 * ESAC16
         
         ESAT49  = ESAT24 * ESAT25
         
         ESAT64  = ESAT20 * ESAT20 * ESAT24
         ESAC64  = ESAC20 * ESAC20 * ESAC24
         
         ESAT100 = ESAT64 * ESAT36
         
         DGAT2   = DGATK * DGATK
         DGAT3   = DGATK * DGATK * DGATK
         DGAC2   = DGACC * DGACC
         DGAC3   = DGACC * DGACC * DGACC
         
         SQDGAT  = SQRT( DGATK )
         SQDGAC  = SQRT( DGACC )
         SQDGAT5 = DGAT2 * SQDGAT
         SQDGAC5 = DGAC2 * SQDGAC
         SQDGAT7 = DGAT3 * SQDGAT

         XM2AT = DGAT2 * ESAT16
         XM3AT = DGAT3 * ESAT36
         
         XM2AC = DGAC2 * ESAC16
         XM3AC = DGAC3 * ESAC36
         
C *** For the free molecular regime:  Page H.3 of Whitby et al. (1991)
        
         R       = SQDGAC / SQDGAT
         R2      = R * R
         R3      = R2 * R
         R4      = R2 * R2
         R5      = R3 * R2
         R6      = R3 * R3
         R8      = R4 * R4
         RI1     = ONE / R
         RI2     = ONE / R2
         RI3     = ONE / R3
         RI4     = RI2 * RI2
         KNGAT   = TWO * LAMDA / DGATK
         KNGAC   = TWO * LAMDA / DGACC
         

C *** Calculate ratio of geometric mean diameters
         RAT = DGACC / DGATK
C *** Trap subscripts for BM0 and BM0I, between 1 and 10            
c     See page H.5 of Whitby et al. (1991)

      N2N = MAX( 1, MIN( 10, 
     &      NINT( 4.0 * ( SGATK - 0.75D0 ) ) ) )
            
      N2A = MAX( 1, MIN( 10, 
     &      NINT( 4.0 * ( SGACC - 0.75D0 ) ) ) )
     
      N1  = MAX( 1, MIN( 10,
     &       1 + NINT( DLGSQT2 * LOG( RAT ) ) ) )

C *** INTERMODAL COAGULATION
       
    
C *** SET UP FOR ZEROETH MOMENT

C *** NEAR-CONTINUUM FORM:  Equation H.10a of Whitby et al. (1991)

         COAGNC0 = KNC * (         
     &    TWO + A * ( KNGAT * ( ESAT04 + R2 * ESAT16 * ESAC04 )
     &              + KNGAC * ( ESAC04 + RI2 * ESAC16 * ESAT04 ) )
     &              + ( R2 + RI2 ) * ESAT04 * ESAC04  ) 

     
C *** FREE-MOLECULAR FORM:  Equation H.7a of Whitby et al. (1991)
        
         COAGFM0 = KFMATAC * SQDGAT * BM0IJ(N1,N2N,N2A) * ( 
     &             ESAT01 + R * ESAC01 + TWO * R2 * ESAT01 * ESAC04 
     &           + R4 * ESAT09 * ESAC16 + RI3 * ESAT16 * ESAC09 
     &           + TWO * RI1 * ESAT04 + ESAC01  )  


C *** LOSS TO ACCUMULATION MODE

C *** HARMONIC MEAN

      COAGATAC0 = COAGNC0 * COAGFM0 / ( COAGNC0 + COAGFM0 )
      
      QN12 = COAGATAC0
      

C *** SET UP FOR SECOND MOMENT
C      The second moment equations are new and begin with equations A1
c     through A4 of Binkowski and Shankar (1995). After some algebraic
c     rearrangement and application of the extended mean value theorem
c     of integral calculus, equations are obtained that can be solved
c     analytically with correction factors as has been done by
c     Whitby et al. (1991)

C *** The term ( dp1 + dp2 ) ** (2/3) in Equations A3 and A4 of
c     Binkowski and Shankar (1995) is approximated by
c     (DGAT ** 3 + DGAC **3 ) ** 2/3 

C *** NEAR-CONTINUUM FORM
              
      I1NC = KNC * DGAT2 * (
     &       TWO * ESAT16
     &     + R2 * ESAT04 * ESAC04
     &     + RI2 * ESAT36 * ESAC04
     &     + A * KNGAT * (
     &           ESAT04
     &     +     RI2 * ESAT16 * ESAC04
     &     +     RI4 * ESAT36 * ESAC16
     &     +     R2 * ESAC04 )  )
      
     


C *** FREE-MOLECULAR FORM
       
       I1FM =  KFMATAC * SQDGAT5 * BM2IJ(N1,N2N,N2A) * (
     &         ESAT25
     &      +  TWO * R2 * ESAT09 * ESAC04
     &      +  R4 * ESAT01 * ESAC16
     &      +  RI3 * ESAT64 * ESAC09
     &      +  TWO * RI1 * ESAT36 * ESAC01
     &      +  R * ESAT16 * ESAC01  )
      
     
     
C *** LOSS TO ACCUMULATION MODE

C *** HARMONIC MEAN
 
      I1 = ( I1FM * I1NC ) / ( I1FM + I1NC )

      COAGATAC2 = I1 
      
      QS12 = COAGATAC2 
      

C *** GAIN BY ACCUMULATION MODE      
            
      COAGACAT2 = ( ( ONE + R6 ) ** TWO3RDS - R4 ) * I1 
      
      QS21 = COAGACAT2 * BM2JI(N1,N2N,N2A)
           
C *** SET UP FOR THIRD MOMENT
     
C *** NEAR-CONTINUUM FORM: Equation H.10b of Whitby et al. (1991)

      COAGNC3 = KNC * DGAT3 * ( 
     &          TWO * ESAT36       
     &        + A * KNGAT * ( ESAT16 + R2 * ESAT04 * ESAC04 )                           
     &        + A * KNGAC * ( ESAT36 * ESAC04 + RI2 * ESAT64 * ESAC16 )
     &        + R2 * ESAT16 * ESAC04 + RI2 * ESAT64 * ESAC04 )

           
C *** FREE_MOLECULAR FORM: Equation H.7b of Whitby et al. (1991)

      COAGFM3 = KFMATAC * SQDGAT7 * BM3I( N1, N2N, N2A ) * ( 
     &         ESAT49 
     &        +  R * ESAT36  * ESAC01 
     &        + TWO * R2 * ESAT25  * ESAC04
     &        + R4 * ESAT09  * ESAC16
     &        + RI3 * ESAT100 * ESAC09
     &        + TWO * RI1 * ESAT64  * ESAC01 )   

C *** GAIN BY ACCUMULATION MODE = LOSS FROM AITKEN MODE

C *** HARMONIC MEAN 
       
      COAGATAC3 = COAGNC3 * COAGFM3 / ( COAGNC3 + COAGFM3 )
      
      QV12 = COAGATAC3         

C *** INTRAMODAL COAGULATION

C *** ZEROETH MOMENT

C *** AITKEN MODE

C *** NEAR-CONTINUUM FORM: Equation H.12a of Whitby et al. (1991)

      COAGNC_AT = KNC * (ONE + ESAT08 + A * KNGAT * (ESAT20 + ESAT04)) 

C *** FREE-MOLECULAR FORM: Equation H.11a of Whitby et al. (1991)
      
      COAGFM_AT = KFMAT * SQDGAT * BM0(N2N) * 
     &           ( ESAT01 + ESAT25 + TWO * ESAT05 )
      

C *** HARMONIC MEAN 

      COAGATAT0 = COAGFM_AT * COAGNC_AT / ( COAGFM_AT + COAGNC_AT )
      
      QN11 = COAGATAT0 
     
      
C *** ACCUMULATION MODE 

C *** NEAR-CONTINUUM FORM: Equation H.12a of Whitby et al. (1991)
     
      COAGNC_AC = KNC * (ONE + ESAC08 + A * KNGAC * (ESAC20 + ESAC04))

C *** FREE-MOLECULAR FORM: Equation H.11a of Whitby et al. (1991)

      COAGFM_AC = KFMAC * SQDGAC * BM0(N2A) * 
     &             ( ESAC01 + ESAC25 + TWO * ESAC05 ) 
       
C *** HARMONIC MEAN 
            
      COAGACAC0 = COAGFM_AC * COAGNC_AC / ( COAGFM_AC + COAGNC_AC )
      
      QN22 = COAGACAC0
      

C *** SET UP FOR SECOND MOMENT
C      The second moment equations are new and begin with 3.11a on Page
c     45 of Whitby et al. (1991). After some algebraic rearrangement and
c     application of the extended mean value theorem of integral calculus
c     equations are obtained that can be solved analytically with 
c     correction factors as has been done by Whitby et al. (1991)
           
C *** AITKEN MODE

C *** NEAR-CONTINUUM

      I1NC_AT = KNC * DGAT2 * (
     &       TWO * ESAT16
     &     + ESAT04 * ESAT04
     &     + ESAT36 * ESAT04
     &     + A * KNGAT * (
     &          TWO * ESAT04
     &     +     ESAT16 * ESAT04
     &     +     ESAT36 * ESAT16 )  )
     
C *** FREE- MOLECULAR FORM

       I1FM_AT =  KFMAT * SQDGAT5 * BM2II(N2N) * (
     &         ESAT25
     &      +  TWO * ESAT09 * ESAT04
     &      +  ESAT01 * ESAT16
     &      +  ESAT64 * ESAT09
     &      +  TWO * ESAT36 * ESAT01
     &      +  ESAT16 * ESAT01  ) 
     
      I1_AT = ( I1NC_AT * I1FM_AT ) / ( I1NC_AT + I1FM_AT  )
      
      COAGATAT2 = CONSTII * I1_AT
      
      QS11 = COAGATAT2 * BM2IITT(N2N)

C *** ACCUMULATION MODE

C *** NEAR-CONTINUUM

      I1NC_AC = KNC * DGAC2 * (
     &       TWO * ESAC16
     &     + ESAC04 * ESAC04
     &     + ESAC36 * ESAC04
     &     + A * KNGAC * (
     &          TWO * ESAC04
     &     +     ESAC16 * ESAC04
     &     +     ESAC36 * ESAC16 )  )

C *** FREE- MOLECULAR FORM
     
       I1FM_AC =  KFMAC * SQDGAC5 * BM2II(N2A) * (
     &         ESAC25
     &      +  TWO * ESAC09 * ESAC04
     &      +  ESAC01 * ESAC16
     &      +  ESAC64 * ESAC09
     &      +  TWO * ESAC36 * ESAC01
     &      +  ESAC16 * ESAC01  )
          
      I1_AC = ( I1NC_AC * I1FM_AC ) / ( I1NC_AC + I1FM_AC  )
     
      COAGACAC2 = CONSTII * I1_AC
      
      QS22 = COAGACAC2 * BM2IITT(N2A)

     
      RETURN

      END  SUBROUTINE GETCOAGS

c /////////////////////////////////////////////////////////////////////
         
      END  MODULE AERO_INFO
      
