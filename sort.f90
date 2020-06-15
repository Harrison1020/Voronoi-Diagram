SUBROUTINE SORT(N,INDEXP,X)
  ! SORTS ARRAY INDEX, INDEXP, OF LENGTH N, SO THAT ITS ELEMENTS
  ! REFER TO POINTS WITH INCREASING X-COORDINATES

  PARAMETER (LLEN=300)
  REAL*8 X,XX
  DIMENSION INDEXP(-1:LLEN),X(0:LLEN)
  X(0)=-9.D8

  DO J=2,N
     I=J-1
     II=INDEXP(J)
     XX=X(II)
1    IF(XX.LT.X(INDEXP(I))) THEN
        INDEXP(I+1)=INDEXP(I)
        I=I-1
        GOTO 1
     END IF
     INDEXP(I+1)=II
  END DO
  RETURN
END SUBROUTINE SORT
