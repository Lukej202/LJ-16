; Count R1 down from 5 to zero. Demonstrates constants, branches, and flags.
; The instruction ROM is WORD addressed (PC increments by one).
LDCL 5
LDCH 0
MOV R1, CR

; Keep the loop address in R7 since we will reuse CR.
LDCL LOOP
LDCH LOOP
MOV R7, CR

LDCL 1
LDCH 0
LOOP:
    SUB R1, R1, CR    ; R1 = R1 - 1; sets Z when result is zero
    BNE R7             ; jump back while Z=0
HALT
