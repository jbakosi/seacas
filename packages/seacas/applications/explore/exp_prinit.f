C    Copyright(C) 2008-2017 National Technology & Engineering Solutions of
C    Sandia, LLC (NTESS).  Under the terms of Contract DE-NA0003525 with
C    NTESS, the U.S. Government retains certain rights in this software.
C
C    Redistribution and use in source and binary forms, with or without
C    modification, are permitted provided that the following conditions are
C    met:
C
C    * Redistributions of source code must retain the above copyright
C       notice, this list of conditions and the following disclaimer.
C
C    * Redistributions in binary form must reproduce the above
C      copyright notice, this list of conditions and the following
C      disclaimer in the documentation and/or other materials provided
C      with the distribution.
C
C    * Neither the name of NTESS nor the names of its
C      contributors may be used to endorse or promote products derived
C      from this software without specific prior written permission.
C
C    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
C    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
C    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
C    A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
C    OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
C    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
C    LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
C    DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
C    THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
C    (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
C    OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
C
C=======================================================================
      SUBROUTINE PRINIT (OPTION, NOUT, DBNAME, TITLE,
     &   NDIM, NUMNP, NUMEL, NELBLK,
     &   NUMNPS, LNPSNL, lnpsdf, NUMESS, LESSEL, LESSNL, LESSDF,
     &   NVARGL, NVARNP, NVAREL, NVARNS, NVARSS)
C=======================================================================

C   --*** PRINIT *** (EXPLORE) Display database initial variables
C   --
C   --PRINIT displays the database initial variables.
C   --
C   --Parameters:
C   --   OPTION - IN - '*' to print all, else print options:
C   --      'N' to print database name
C   --      'T' to print title
C   --      'I' to print number of nodes, etc.
C   --      'S' to print nodal point and element side set information
C   --      'V' to print number of variables
C   --      'C' to print number of coordinate frames

C   --   NOUT - IN - the output file, <=0 for standard
C   --   DBNAME - IN - the database name
C   --   TITLE - IN - the database title
C   --   NUMNP - IN - the number of nodes
C   --   NDIM - IN - the number of coordinates per node
C   --   NUMEL - IN - the number of elements
C   --   NELBLK - IN - the number of element blocks
C   --   NUMNPS - IN - the number of nodal points sets
C   --   LNPSNL - IN - the length of the nodal point sets node list
C   --   NUMESS - IN - the number of side sets
C   --   LESSEL - IN - the length of the element side sets element list
C   --   LESSNL - IN - the length of the element side sets node list
C   --   LESSDF - IN - the length of the side sets distribution list
C   --   NVARGL - IN - the number of global variables (if OPTION)
C   --   NVARNP - IN - the number of nodal variables (if OPTION)
C   --   NVAREL - IN - the number of element variables (if OPTION)
C   --   NVARNS - IN - the number of nodeset variables (if OPTION)
C   --   NVARSS - IN - the number of sideset variables (if OPTION)

      include 'exp_dbase.blk'
      include 'exodusII.inc'

      CHARACTER*(*) OPTION
      CHARACTER*(*) DBNAME
      CHARACTER*80 TITLE
      CHARACTER*15 SCRSTR(10)

      IF ((OPTION .EQ. '*') .OR. (INDEX (OPTION, 'I') .GT. 0)) THEN
         IF (NOUT .GT. 0) WRITE (NOUT, 10000)
      END IF

      IF ((OPTION .EQ. '*') .OR. (INDEX (OPTION, 'N') .GT. 0)) THEN
         IF (NOUT .GT. 0) THEN
            WRITE (NOUT, 10010) DBNAME(:LENSTR(DBNAME))
         ELSE
            WRITE (*, 10010) DBNAME(:LENSTR(DBNAME))
         END IF
      END IF

      IF ((OPTION .EQ. '*') .OR. (INDEX (OPTION, 'T') .GT. 0)) THEN
         IF (NOUT .GT. 0) THEN
            WRITE (NOUT, 10020) TITLE(1:LENSTR(TITLE))
         ELSE
            WRITE (*, 10020) TITLE(1:LENSTR(TITLE))
         END IF
      END IF

      IF ((OPTION .EQ. '*') .OR. (INDEX (OPTION, 'I') .GT. 0)) THEN
         call convert(scrstr(1), numnp,  l1)
         call convert(scrstr(2), numel,  l2)
         call convert(scrstr(3), nelblk, l3)
         IF (NOUT .GT. 0) THEN
            WRITE (NOUT, 10030, IOSTAT=IDUM)
     &         NDIM, scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3)
         ELSE
            WRITE (*, 10030, IOSTAT=IDUM)
     &         NDIM, scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3)
         END IF
      END IF

      IF ((OPTION .EQ. '*') .OR. (INDEX (OPTION, 'S') .GT. 0)) THEN
         call convert(scrstr(1), numnps,  l1)
         call convert(scrstr(2), lnpsnl,  l2)
         call convert(scrstr(3), lnpsdf, l3)
         IF (NUMNPS .LE. 0) THEN
            IF (NOUT .GT. 0) THEN
               WRITE (NOUT, 10040, IOSTAT=IDUM) scrstr(1)(:l1)
            ELSE
               WRITE (*, 10040, IOSTAT=IDUM) scrstr(1)(:l1)
            END IF
         ELSE
            IF (NOUT .GT. 0) THEN
               WRITE (NOUT, 10040, IOSTAT=IDUM)
     $              scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3)
            ELSE
               WRITE (*, 10040, IOSTAT=IDUM)
     $              scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3)
            END IF
         END IF
         call convert(scrstr(1), numness,  l1)
         call convert(scrstr(2), lessel,  l2)
         call convert(scrstr(3), lessnl, l3)
         call convert(scrstr(4), lessdf, l4)
         IF (NUMESS .LE. 0) THEN
            IF (NOUT .GT. 0) THEN
               WRITE (NOUT, 10050, IOSTAT=IDUM)
     $              scrstr(1)(:l1)
            ELSE
               WRITE (*, 10050, IOSTAT=IDUM)
     $              scrstr(1)(:l1)
            END IF
         ELSE
            IF (NOUT .GT. 0) THEN
               WRITE (NOUT, 10050, IOSTAT=IDUM) 
     $              scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3),
     $              scrstr(4)(:l4)
            ELSE
               WRITE (*, 10050, IOSTAT=IDUM) 
     $              scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3),
     $              scrstr(4)(:l4)
            END IF
         END IF
      END IF

      IF ((OPTION .EQ. '*') .OR. (INDEX (OPTION, 'C') .GT. 0)) THEN
        call exinq(ndb, EXNCF, ncf, rdum, cdum, ierr)
        if (INDEX (OPTION, 'C') .GT. 0 .or. ncf .gt. 0) then
          IF (NOUT .GT. 0) THEN
            WRITE (NOUT, 10055, IOSTAT=IDUM) NCF
          ELSE
            WRITE (*, 10055, IOSTAT=IDUM) NCF
          END IF
        END IF
      END IF

      IF ((OPTION .EQ. '*') .OR. (INDEX (OPTION, 'V') .GT. 0)) THEN
         call convert(scrstr(1), nvargl, l1)
         call convert(scrstr(2), nvarnp, l2)
         call convert(scrstr(3), nvarel, l3)
         call convert(scrstr(4), nvarns, l4)
         call convert(scrstr(5), nvarss, l5)
         IF (NOUT .GT. 0) THEN
            WRITE (NOUT, 10060, IOSTAT=IDUM)
     $              scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3),
     $              scrstr(4)(:l4), scrstr(5)(:l5)
         ELSE
            WRITE (*, 10060, IOSTAT=IDUM)
     $              scrstr(1)(:l1), scrstr(2)(:l2), scrstr(3)(:l3),
     $              scrstr(4)(:l4), scrstr(5)(:l5)
         END IF
      END IF

      RETURN

10000  FORMAT (/, 1X, 'DATABASE INITIAL VARIABLES')
10010  FORMAT (/, 1X, 'Database:  ', A)
10020  FORMAT (/, 1X, A)
10030  FORMAT (
     &   /, 1X, 'Number of coordinates per node       =', I15
     &   /, 1X, 'Number of nodes                      =', A15
     &   /, 1X, 'Number of elements                   =', A15
     &   /, 1X, 'Number of element blocks             =', A15
     &   )
10040  FORMAT (
     &   /, 1X, 'Number of nodal point sets           =', A15, :
     &   /, 1X, '   Length of node list               =', A15
     &   /, 1X, '   Length of distribution list       =', A15
     &   )
10050  FORMAT
     &   (  1X, 'Number of element side sets          =', A15, :
     &   /, 1X, '   Length of element list            =', A15
     &   /, 1X, '   Length of node list               =', A15
     &   /, 1X, '   Length of distribution list       =', A15
     &   )
10055  FORMAT (
     &   /, 1X, 'Number of coordinate frames          =', I15
     &   )

10060  FORMAT (
     &   /, 1X, 'Number of global variables           =', A15
     &   /, 1X, 'Number of variables at each node     =', A15
     &   /, 1X, 'Number of variables at each element  =', A15
     &   /, 1X, 'Number of variables at each nodeset  =', A15
     &   /, 1X, 'Number of variables at each sideset  =', A15
     &   )
      END
