SUBROUTINE DATIN(N,INDEXP,X,Y)
  
  PARAMETER (LLEN=300)
  REAL*8 X,Y,XX,YY
  DIMENSION INDEXP(-1:LLEN),X(0:LLEN),Y(0:LLEN)

  ! READS THE INPUT FILE
  READ(21,*,ERR=2,END=2) N
  IF(N.GE.4.AND.N.LE.LLEN) THEN
     DO I=1,N
        READ(21,*,ERR=2,END=2) INDEX,XX,YY
	! PRINT *, INDEX
        IF(INDEX.LT.1.OR.INDEX.GT.LLEN) GOTO 2
        INDEXP(I)=INDEX
        X(INDEX)=XX
        Y(INDEX)=YY
     END DO

     RETURN
  ELSE
     WRITE(6,109)
     STOP
  END IF

  ! FATAL ERROR MESSAGE
2 WRITE(6,110)
  STOP
109 FORMAT('EITHER TOO FEW OR TOO MANY DATA POINTS (DATIN)')
110 FORMAT('DATA INPUT ERROR (DATIN)')
END SUBROUTINE DATIN
