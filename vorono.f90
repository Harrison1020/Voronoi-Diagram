SUBROUTINE VORONO(N,NN,NE,NL,INDEXP,X,Y,NP,LID,LPF,LES,LEE,LELS,LERS)

  PARAMETER (LLEN=300)
  LOGICAL SAME
  INTEGER NB1,J1,I1
  REAL*8 X,Y,YMIN,YMAX,XSW,YSW,XNW,YNW
  DIMENSION INDEXP(-1:LLEN),X(0:LLEN),Y(0:LLEN),NP(-LLEN:LLEN),LID(7*LLEN),&
       LPF(7*LLEN),LES(3*LLEN),LEE(3*LLEN),LELS(3*LLEN),LERS(3*LLEN),&
       LPFD(3*LLEN),ID(LLEN),IFLAG(LLEN)

  ! INITIALIZE SOME VARIABLES
  NB1=2
  J1=0
  I1=0

  NN=0  
  DO 5 I=1,N
     NN=MAX(NN,INDEXP(I))
5    CONTINUE

  ! INITIALIZE VARIABLES
  NL=9
  NE=3
  INDEXP(0)=0
  INDEXP(-1)=-1
  NP(-1)=7
  NP(0)=9
  NP(INDEXP(1))=1
  NP(INDEXP(2))=3
  NP(INDEXP(3))=5
  LES(1)=INDEXP(2)
  LES(2)=INDEXP(3)
  LES(3)=INDEXP(3)
  LEE(1)=INDEXP(1)
  LEE(2)=INDEXP(2)
  LEE(2)=INDEXP(1)
  LELS(1)=INDEXP(3)
  LELS(2)=INDEXP(1)
  LELS(3)=0
  LERS(1)=0
  LERS(2)=0
  LERS(3)=INDEXP(2)
  LID(1)=3
  LID(2)=1
  LID(3)=2
  LID(4)=1
  LID(5)=3
  LID(6)=2
  LID(7)=2
  LID(8)=1
  LID(9)=3
  LPF(1)=2
  LPF(2)=0
  LPF(3)=4
  LPF(4)=0
  LPF(5)=6
  LPF(6)=0
  LPF(7)=8
  LPF(8)=0
  LPF(9)=0
  IF(Y(INDEXP(2)).LE.Y(INDEXP(1))+(Y(INDEXP(3))-Y(INDEXP(1)))*&
       (X(INDEXP(2))-X(INDEXP(1)))/(X(INDEXP(3))-X(INDEXP(1)))) THEN

     DO 10 I=1,3
        L=LELS(I)
        LELS(I)=LERS(I)
        LERS(I)=L
10      CONTINUE

     NP(-1)=9
     NP(0)=7
  END IF
  IF(N.NE.3) THEN
     YMIN=Y(INDEXP(1))
     YMAX=YMIN
  END IF
  DO 20 I=2,N
     YMIN=MIN(YMIN,Y(INDEXP(I)))
     YMAX=MAX(YMAX,Y(INDEXP(I)))
20   CONTINUE

  XSW=X(INDEXP(1))
  YSW=Y(INDEXP(1))-YMAX+YMIN
  XNW=X(INDEXP(1))
  YNW=Y(INDEXP(1))+YMAX-YMIN

  ! MAIN LOOP
  DO 55 II=4,N
     I=INDEXP(II)
     NPFD=0
     NP(I)=0

     ! FIRST EDGE TO JOIN INDEXP(II) AND INDEXP(II-1)
     NE=NE+1
     NER=NE
     LES(NE)=I
     LEE(NE)=INDEXP(II-1)
     LELS(NE)=0
     LERS(NE)=0

     ! AUGMENT SPOKE LIST BY ADDING EDGE NE
     CALL AUGMEN(II,NL,NB1,INDEXP,NP,LID,LPF,I,NE,J1)
     CALL AUGMEN(II,NL,NB1,INDEXP,NP,LID,LPF,INDEXP(II-1),NE,J1)

     ! ADD EDGE FROM INDEXP(II) TO OTHERE VISIBLE POINTS
     J=NP(-1)
25   IF(.NOT.SAME(X,Y,I,LES(LID(J)),LEE(LID(J)),XSW,YSW)) THEN
        NE=NE+1
        LES(NE)=I
        LEE(NE)=LEE(LID(J))
        LERS(NE)=0
        LERS(NE-1)=LEE(NE)
        LERS(LID(J))=I

        ! AUGMENT SPOKE LIST FOR INDEXP(II) AND LEE(NE)
        CALL AUGMEN(II,NL,NB1,INDEXP,NP,LID,LPF,I,NE,J)
        CALL AUGMEN(II,NL,NB1,INDEXP,NP,LID,LPF,LEE(NE),NE,J)

        ! ADD EDGE LID(J) TO THE PDF LIST
        IF(NPFD.EQ.3*LLEN) GOTO 99
        NPFD=NPFD+1
        LPFD(NPFD)=LID(J)

        ! PUT POINTER ON THE NEXT EDGE
        J=LPF(J)
        IF(J.NE.0) GOTO 25
     END IF

     ! MODIFY UPPER HULL LIST AND SET NEW POINTER
     NL=NL+1
     IF(NL.EQ.7*LLEN+1) CALL GARBAG(II,NL,NB1,INDEXP,NP,LID,LPF,J)
     LID(NL)=NE
     LPF(NL)=J
     NP(-1)=NL

     ! MOVE TO LOWER HULL. ADD EDGES FROM INDEXP(II) TO VISIBLE POINTS
     J=NP(0)
35   IF(.NOT.SAME(X,Y,I,LES(LID(J)),LEE(LID(J)),XNW,YNW)) THEN
        IF(J.NE.NP(0)) NER=NE

        ! ADD AN EDGE TO THE NEXT POINT
        NE=NE+1
        LES(NE)=I
        LEE(NE)=LEE(LID(J))
        LELS(NE)=0
        LERS(NE)=LES(LID(J))
        LELS(NER)=LEE(NE)
        LELS(LID(J))=I

        ! AUGMENT SPOKE LIST FOR INDEXP(II) AND LEE(NE) BY ADDING EDGE NE
        CALL AUGMEN(II,NL,NB1,INDEXP,NP,LID,LPF,I,NE,J)
        CALL AUGMEN(II,NL,NB1,INDEXP,NP,LID,LPF,LEE(NE),NE,J)

        ! ADD EDGE LID(J) TO THE PFD LIST
        IF(NPFD.EQ.3*LLEN) GOTO 99
        NPFD=NPFD+1
        LPFD(NPFD)=LID(J)

        ! PUT THE POINTER ON THE NEXT EDGE
        J=LPF(J)
        IF(J.NE.0) GOTO 35
     END IF

     ! MODIFY HULL LIST AND SET NEW POINTER
     NL=NL+1
     IF(NL.EQ.7*LLEN+1) CALL GARBAG(II,NL,NB1,INDEXP,NP,LID,LPF,J)
     IF(J.EQ.NP(0)) THEN
        LID(NL)=NER
     ELSE
        LID(NL)=NE
     END IF
     LPF(NL)=J
     NP(0)=NL

     ! ADD TEST EDGES IN PFD LIST
     CALL TESTPF(N,NL,NB1,INDEXP,X,Y,NP,LID,LPF,LES,LEE,LELS,LERS,NPFD,&
          LPFD,IFLAG)
55   CONTINUE
  
  ! AMALGAMATE UPPER AND LOWER HULLS
  CALL DECODE(LID,LPF,NP(-1),ID,K)

  DO 65 I=1,K
     CALL AUGMEN(N,NL,NB1,INDEXP,NP,LID,LPF,I1,ID(I),J1)
65   CONTINUE

  NB1=1
  CALL GARBAG(N,NL,NB1,INDEXP,NP,LID,LPF,J1)
  NL=NL-1
  RETURN

  ! FATAL ERROR MESSAGE
99  WRITE(6,100)
  STOP
100 FORMAT('ARRAY OVERFLOW FOR PFD LIST (VORONO)')
END SUBROUTINE VORONO

