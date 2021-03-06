 IDENTIFICATION DIVISION.
 PROGRAM-ID. PROG14.
 ENVIRONMENT DIVISION.
 INPUT-OUTPUT SECTION.
 FILE-CONTROL.
     SELECT EMP-FILE-IN   ASSIGN TO 'EMPFILE.DAT'.
     SELECT WORK-FILE     ASSIGN TO 'WORKFILE.DAT'.
     SELECT EMPLOYEE-FILE ASSIGN TO 'TEMPFILE.DAT'
        ORGANIZATION IS SEQUENTIAL
        ACCESS MODE  IS SEQUENTIAL
        FILE STATUS  IS WS-EMP-STAT.
     SELECT REPORT-FILE ASSIGN TO 'REPFILE.REP'
        ORGANIZATION IS SEQUENTIAL
        ACCESS MODE  IS SEQUENTIAL
        FILE STATUS  IS WS-REP-STAT.
 DATA DIVISION.
 FILE SECTION.
 FD  EMP-FILE-IN
     RECORD CONTAINS 50 CHARACTERS
     RECORDING MODE IS F.
 01  EMP-RECORD          PIC X(50).
 SD  WORK-FILE.
 01  WORK-RECORD.
     03  FILLER          PIC X(20).
     03  W-EMP-LOC       PIC X(03).
     03  FILLER          PIC X(08).
     03  W-EMP-TECH      PIC X(05).
     03  FILLER          PIC X(14).
 FD  EMPLOYEE-FILE
     RECORD CONTAINS 50 CHARACTERS
     RECORDING MODE IS F.
 01  EMPLOYEE-RECORD.              
     03  EMP-ID       PIC X(05).   
     03  EMP-NAME     PIC X(15).   
     03  EMP-LOC      PIC X(03).   
     03  EMP-DOB      PIC X(08).   
     03  EMP-TECH     PIC X(05).   
     03  EMP-EARN     PIC 9(05)V99.
     03  EMP-DEDN     PIC 9(05)V99.     
 FD  REPORT-FILE
     RECORD CONTAINS 80 CHARACTERS
     RECORDING MODE IS F.
 01  REPORT-RECORD PIC X(80).
 WORKING-STORAGE SECTION.
 01  HEADING-LINE1.
     03  FILLER           PIC X(06) VALUE 'DATE:'.
     03  P-DATE           PIC X(10) VALUE SPACES.
     03  FILLER           PIC X(50) VALUE SPACES.
     03  FILLER           PIC X(06) VALUE 'TIME:'.
     03  P-TIME.
         05  WS-TIME-HH   PIC 9(02) VALUE ZERO.
         05  FILLER       PIC X(01) VALUE ':'.
         05  WS-TIME-MM   PIC 9(02) VALUE ZERO.
         05  FILLER       PIC X(01) VALUE ':'.
         05  WS-TIME-SS   PIC 9(02) VALUE ZERO.
 01  HEADING-LINE2.
     03  FILLER           PIC X(20)
                          VALUE 'LISTING OF EMPLOYEES'.
     03  FILLER           PIC X(46) VALUE SPACES.
     03  FILLER           PIC X(06) VALUE 'PAGE:'.
     03  P-PAGE           PIC Z9    VALUE ZERO.
 01  HEADING-LINE3.
     03  FILLER           PIC X(05) VALUE 'LOC:'.
     03  P-LOC            PIC X(05) VALUE SPACES.
     03  FILLER           PIC X(06) VALUE 'TECH:'.
     03  P-TECH           PIC X(05) VALUE SPACES.
 01  HEADING-LINE4.
     03  FILLER           PIC X(06) VALUE 'ID'.
     03  FILLER           PIC X(16) VALUE 'NAME'.
     03  FILLER           PIC X(04) VALUE SPACES.
     03  FILLER           PIC X(11) VALUE 'BIRTH DATE'.
     03  FILLER           PIC X(06) VALUE SPACES.
     03  FILLER           PIC X(11) VALUE '  EARNINGS '.
     03  FILLER           PIC X(11) VALUE 'DEDUCTIONS '.
     03  FILLER           PIC X(10) VALUE ' TOTAL SAL'.
 01  DETAIL-LINE.
     03  P-DESCRIPTION.
         05  P-ID         PIC X(05) VALUE SPACES.
         05  FILLER       PIC X(01) VALUE SPACES.
         05  P-NAME       PIC X(15) VALUE SPACES.
         05  FILLER       PIC X(01) VALUE SPACES.
     03  FILLER           PIC X(03) VALUE SPACES.
     03  FILLER           PIC X(01) VALUE SPACES.
     03  P-DOB            PIC X(10) VALUE SPACES.
     03  FILLER  REDEFINES  P-DOB.
         05  P-EMP        PIC ZZ9.   
         05  FILLER       PIC X(07).
     03  FILLER           PIC X(01) VALUE SPACES.
     03  FILLER           PIC X(05) VALUE SPACES.
     03  FILLER           PIC X(01) VALUE SPACES.
     03  P-EARN           PIC ZZZ,ZZ9.99 VALUE ZERO.
     03  FILLER           PIC X(01) VALUE SPACES.
     03  P-DEDN           PIC ZZZ,ZZ9.99 VALUE ZERO.
     03  FILLER           PIC X(01) VALUE SPACES.
     03  P-SAL            PIC ZZZ,ZZ9.99 VALUE ZERO.
 01  WS-DATE-TIME-FIELDS.                      
     03  WS-DATE          PIC 9(08) VALUE ZERO.
     03  WS-TIME                    VALUE ZERO.
         05  WS-TIME-HH   PIC 9(02).           
         05  WS-TIME-MM   PIC 9(02).           
         05  WS-TIME-SS   PIC 9(02).           
         05  WS-TIME-FS   PIC 9(02).                
 01  WS-VARIABLES.
     03  PAGE-COUNT       PIC 9(02) VALUE ZERO.
     03  LINE-COUNT       PIC 9(01) VALUE 4.
     03  WS-SAL           PIC 9(06)V99 VALUE ZERO.
     03  WS-TOT-EMP       PIC 9(06)V99 VALUE ZERO.
     03  WS-FILE-FLAG     PIC X(01) VALUE 'N'.
         88  END-OF-FILE            VALUE 'Y'.
     03  WS-EMP-STAT      PIC X(02) VALUE SPACES.
     03  WS-REP-STAT      PIC X(02) VALUE SPACES.
     03  TEMP-LOC         PIC X(03) VALUE SPACES.
     03  TEMP-TECH        PIC X(05) VALUE SPACES.
 01  WS-COUNTERS                    VALUE ZERO.
     03  TOTAL-CTRS           OCCURS 3 TIMES.
         05  TOTAL-EMP     PIC 9(02).
         05  TOTAL-EARN    PIC 9(06)V99.
         05  TOTAL-DEDN    PIC 9(06)V99.
*     03  TECH-CTRS                  VALUE ZERO.
*         05  TECH-EMP     PIC 9(02).
*         05  TECH-EARN    PIC 9(06)V99.
*         05  TECH-DEDN    PIC 9(06)V99.
*     03  LOC-CTRS                   VALUE ZERO.
*         05  LOC-EMP      PIC 9(02).
*         05  LOC-EARN     PIC 9(06)V99.
*         05  LOC-DEDN     PIC 9(06)V99.
*     03  COMP-CTRS                  VALUE ZERO.
*         05  COMP-EMP     PIC 9(02).
*         05  COMP-EARN    PIC 9(06)V99.
*         05  COMP-DEDN    PIC 9(06)V99.
 PROCEDURE DIVISION.
 0000-MAIN-PARA.
     PERFORM 1000-INIT-PARA.
     PERFORM 2000-PROCESS-PARA  UNTIL  END-OF-FILE
     PERFORM 9000-END-PARA
     STOP RUN.
 1000-INIT-PARA.
     PERFORM 1111-SORT-PARA
     OPEN INPUT EMPLOYEE-FILE
     DISPLAY 'EMP OPEN FS ', WS-EMP-STAT
     OPEN OUTPUT REPORT-FILE.
     DISPLAY 'REP OPEN FS ', WS-REP-STAT
     PERFORM 1200-DATE-TIME-PARA.
     PERFORM 1500-READ-PARA.
     MOVE EMP-LOC  TO TEMP-LOC, P-LOC.
     MOVE EMP-TECH TO TEMP-TECH, P-TECH.
 1111-SORT-PARA.
     SORT WORK-FILE
        ON ASCENDING KEY W-EMP-LOC
           ASCENDING KEY W-EMP-TECH
           USING EMP-FILE-IN
           GIVING EMPLOYEE-FILE.
 1200-DATE-TIME-PARA.                     
     ACCEPT WS-DATE FROM DATE   
     ACCEPT WS-TIME FROM TIME             
     MOVE    20        TO P-DATE(7:2)
     MOVE WS-DATE(3:2) TO P-DATE(9:2)     
     MOVE WS-DATE(5:2) TO P-DATE(4:2)     
     MOVE WS-DATE(7:2) TO P-DATE(1:2)     
     MOVE '/'  TO P-DATE(3:1) P-DATE(6:1).
     MOVE CORRESPONDING WS-TIME TO P-TIME.
 1500-READ-PARA.
     READ EMPLOYEE-FILE
        AT END
           MOVE 'Y' TO WS-FILE-FLAG
     END-READ.
*     DISPLAY 'EMP READ FS ', WS-EMP-STAT.
 2000-PROCESS-PARA.
     IF EMP-LOC = TEMP-LOC
        IF EMP-TECH = TEMP-TECH
           NEXT SENTENCE
        ELSE
           PERFORM 4000-TECH-CHANGE-PARA
        END-IF
     ELSE
        PERFORM 4000-TECH-CHANGE-PARA
        PERFORM 5000-LOC-CHANGE-PARA
     END-IF.
     PERFORM 3000-PRINT-PARA
     IF LINE-COUNT > 3
        PERFORM 2500-HEADING-PARA
     END-IF
     WRITE REPORT-RECORD FROM DETAIL-LINE
*     DISPLAY 'REP WRITE FS ', WS-REP-STAT.
     ADD 1 TO LINE-COUNT
     PERFORM 1500-READ-PARA.
 2500-HEADING-PARA.
     ADD 1 TO PAGE-COUNT
     MOVE PAGE-COUNT TO P-PAGE
     WRITE REPORT-RECORD FROM HEADING-LINE1 AFTER PAGE.
     WRITE REPORT-RECORD FROM HEADING-LINE2.
     IF NOT END-OF-FILE
        WRITE REPORT-RECORD FROM HEADING-LINE3 
        WRITE REPORT-RECORD FROM HEADING-LINE4 AFTER 2
     END-IF.
     MOVE ZERO TO LINE-COUNT.
 3000-PRINT-PARA.
     MOVE EMP-ID  TO P-ID.
     MOVE EMP-NAME TO P-NAME.
     MOVE EMP-EARN TO P-EARN.
     MOVE EMP-DEDN TO P-DEDN.
     MOVE EMP-DOB(1:4) TO P-DOB(7:4)
     MOVE EMP-DOB(5:2) TO P-DOB(4:2)
     MOVE EMP-DOB(7:2) TO P-DOB(1:2)
     MOVE '/'  TO P-DOB(3:1) P-DOB(6:1).
     COMPUTE WS-SAL = EMP-EARN - EMP-DEDN
     MOVE WS-SAL  TO P-SAL.
     ADD   1      TO TOTAL-EMP(1)
     ADD EMP-EARN TO TOTAL-EARN(1)
     ADD EMP-DEDN TO TOTAL-DEDN(1).
*     ADD   1      TO TECH-EMP
*     ADD EMP-EARN TO TECH-EARN
*     ADD EMP-DEDN TO TECH-DEDN.
 4000-TECH-CHANGE-PARA.    
     INITIALIZE DETAIL-LINE.
     MOVE 'TECHNOLOGY TOTALS =>' TO P-DESCRIPTION 
     MOVE TOTAL-EMP(1)  TO P-EMP
     MOVE TOTAL-EARN(1) TO P-EARN
     MOVE TOTAL-DEDN(1) TO P-DEDN
     COMPUTE WS-SAL = TOTAL-EARN(1) - TOTAL-DEDN(1)
*     MOVE TECH-EMP   TO P-EMP
*     MOVE TECH-EARN  TO P-EARN
*     MOVE TECH-DEDN  TO P-DEDN
*    COMPUTE WS-SAL = TECH-EARN - TECH-DEDN
     MOVE WS-SAL     TO P-SAL.
     WRITE REPORT-RECORD FROM DETAIL-LINE 
     ADD TOTAL-EMP(1)  TO TOTAL-EMP(2)
     ADD TOTAL-EARN(1) TO TOTAL-EARN(2)
     ADD TOTAL-DEDN(1) TO TOTAL-DEDN(2)
     MOVE ZERO         TO TOTAL-CTRS(1)
*     ADD TECH-EMP    TO LOC-EMP
*     ADD TECH-EARN   TO LOC-EARN
*     ADD TECH-DEDN   TO LOC-DEDN
*     MOVE ZERO       TO TECH-CTRS
     MOVE EMP-TECH   TO TEMP-TECH, P-TECH
     MOVE 6          TO LINE-COUNT.
 5000-LOC-CHANGE-PARA.    
     INITIALIZE DETAIL-LINE.
     MOVE 'LOCATION TOTALS =>' TO P-DESCRIPTION
     MOVE TOTAL-EMP(2)  TO P-EMP
     MOVE TOTAL-EARN(2) TO P-EARN
     MOVE TOTAL-DEDN(2) TO P-DEDN
     COMPUTE WS-SAL = TOTAL-EARN(2) - TOTAL-DEDN(2)
*     MOVE LOC-EMP    TO P-EMP
*     MOVE LOC-EARN   TO P-EARN
*     MOVE LOC-DEDN   TO P-DEDN
*     COMPUTE WS-SAL = LOC-EARN - LOC-DEDN
     MOVE WS-SAL     TO P-SAL.
     WRITE REPORT-RECORD FROM DETAIL-LINE 
     ADD TOTAL-EMP(2)  TO TOTAL-EMP(3)
     ADD TOTAL-EARN(2) TO TOTAL-EARN(3)
     ADD TOTAL-DEDN(2) TO TOTAL-DEDN(3)
     MOVE ZERO         TO TOTAL-CTRS(2)
*     ADD LOC-EMP     TO COMP-EMP
*     ADD LOC-EARN    TO COMP-EARN
*     ADD LOC-DEDN    TO COMP-DEDN
*     MOVE ZERO       TO LOC-CTRS.
     MOVE EMP-LOC    TO TEMP-LOC, P-LOC.
 6000-TOTALS-PARA.
     PERFORM 2500-HEADING-PARA.
     INITIALIZE DETAIL-LINE.
     MOVE 'COMPANY TOTALS =>' TO P-DESCRIPTION
     MOVE TOTAL-EMP(3)  TO P-EMP
     MOVE TOTAL-EARN(3) TO P-EARN
     MOVE TOTAL-DEDN(3) TO P-DEDN
     COMPUTE WS-SAL = TOTAL-EARN(3) - TOTAL-DEDN(3)
*     MOVE COMP-EMP    TO P-EMP
*     MOVE COMP-EARN   TO P-EARN
*     MOVE COMP-DEDN   TO P-DEDN
*     COMPUTE WS-SAL = COMP-EARN - COMP-DEDN
     MOVE WS-SAL     TO P-SAL.
     WRITE REPORT-RECORD FROM DETAIL-LINE AFTER 2 LINES. 
 9000-END-PARA.
     PERFORM 4000-TECH-CHANGE-PARA
     PERFORM 5000-LOC-CHANGE-PARA
     PERFORM 6000-TOTALS-PARA.
     CLOSE EMPLOYEE-FILE, REPORT-FILE.
