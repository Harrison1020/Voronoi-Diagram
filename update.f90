SUBROUTINE UPDATE(LID,LPF,LES,LEE,LELS,LERS,IND,NP,K,L,M)

  ! IDENTIFIES THE EDGE IN THE SPOKE LIST AND UPDATES THE EDGE LIST

  PARAMETER (LLEN=300)
  DIMENSION LID(7*LLEN),LPF(7*LLEN),LES(3*LLEN),LEE(3*LLEN),LELS(3*LLEN),&
       LERS(3*LLEN)

  J=NP
  !PRINT *, K
1 IF(LES(LID(J)).NE.K.AND.LEE(LID(J)).NE.K) THEN
     !PRINT *, 'J:',J,'LPF(J):',LPF(J)
     J=LPF(J)
     GOTO 1
  END IF
  IND=LID(J)
  IF(LERS(IND).EQ.L) THEN
     LERS(IND)=M
  ELSE
     LELS(IND)=M
  END IF
  RETURN
END SUBROUTINE UPDATE