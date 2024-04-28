.globl main

main:
    addi $s0, $zero, 0
    addi $s3, $zero, 0
    addi $s4, $zero, 0
    addi $s5, $zero, 0
    addi $s6, $zero, 0

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_enter_multiplicador
    syscall

    lw   $v0, sys_leer_entero
    syscall
    add  $s1, $zero, $v0

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_enter_multiplicando
    syscall

    lw   $v0, sys_leer_entero
    syscall
    add  $s2, $zero, $v0

imprimir_step:
    beq  $s0, 33, exit

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_loop_counter
    syscall

    lw   $v0, sys_imprimir_int
    add  $a0, $zero, $s0
    syscall
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_tab
    syscall

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_n
    syscall

    lw   $v0, sys_imprimir_int
    add  $a0, $zero, $s6
    syscall
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_tab
    syscall

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_p
    syscall

    lw   $v0, sys_imprimir_binario
    add  $a0, $zero, $s3
    syscall
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_tab
    syscall

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_m
    syscall

    lw   $v0, sys_imprimir_binario
    add  $a0, $zero, $s4
    syscall
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_tab
    syscall

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_x
    syscall

    lw   $v0, sys_imprimir_binario
    add  $a0, $zero, $s1
    syscall
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_tab
    syscall

    lw   $v0, sys_imprimir_cadena
    la   $a0, str_x_1
    syscall

    lw   $v0, sys_imprimir_int
    add  $a0, $zero, $s5
    syscall
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_tab
    syscall

    andi $t0, $s1, 1
    beq  $t0, $zero, x_lsb_0
    j    x_lsb_1

x_lsb_0:
    beq  $s5, $zero, caso_00
    j    caso_01

x_lsb_1:
    beq  $s5, $zero, caso_10
    j    caso_11

caso_00:
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_imprimir_00_info
    syscall

    andi $t0, $s3, 1
    bne  $t0, $zero, A
    srl  $s4, $s4, 1
    j    corrimiento

caso_01:
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_imprimir_01_info
    syscall

    beq  $s2, -2147483648, suma_bits

    add  $s3, $s3, $s2
    andi $s5, $s5, 0
    andi $t0, $s3, 1
    bne  $t0, $zero, A
    srl  $s4, $s4, 1
    j    corrimiento

caso_10:
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_imprimir_10_info
    syscall
    
    beq  $s2, -2147483648, resta_bits

    sub  $s3, $s3, $s2
    ori  $s5, $s5, 1
    andi $t0, $s3, 1
    bne  $t0, $zero, A
    srl  $s4, $s4, 1
    j    corrimiento

caso_11:
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_imprimir_11_info
    syscall

    andi $t0, $s3, 1
    bne  $t0, $zero, A
    srl  $s4, $s4, 1
    j    corrimiento

A:
    andi $t0, $s4, 0x80000000
    bne  $t0, $zero, A_msb_1
    srl  $s4, $s4, 1
    ori  $s4, $s4, 0x80000000
    j    corrimiento

A_msb_1:
    srl  $s4, $s4, 1
    ori  $s4, $s4, 0x80000000
    j    corrimiento

corrimiento:
    sra  $s3, $s3, 1
    ror  $s1, $s1, 1
    addi $s0, $s0, 1
    beq  $s0, 32, save
    j    imprimir_step

save:
    add  $t1, $zero, $s3
    add  $t2, $zero, $s4
    j    imprimir_step

resta_bits:
    subu $s3, $s3, $s2
    andi $s6, $s6, 0
    ori  $s5, $s5, 1
    andi $t0, $s3, 1
    bne  $t0, $zero, A
    srl  $s4, $s4, 1
    j    corrimiento_especial

suma_bits:
    addu $s3, $s3, $s2
    ori  $s6, $s6, 1
    andi $s5, $s5, 0
    andi $t0, $s3, 1
    bne  $t0, $zero, A
    srl  $s4, $s4, 1
    j    corrimiento_especial

corrimiento_especial:
    beq  $s6, $zero, n_0
    sra  $s3, $s3, 1
    ror  $s1, $s1, 1
    addi $s0, $s0, 1
    beq  $s0, 32, save
    j    imprimir_step

n_0:
    srl  $s3, $s3, 1
    ror  $s1, $s1, 1
    addi $s0, $s0, 1
    beq  $s0, 32, save
    j    imprimir_step

exit:
    lw   $v0, sys_imprimir_cadena
    la   $a0, str_imprimir_result
    syscall
    
    lw   $v0, sys_imprimir_binario
    add  $a0, $zero, $t1
    syscall

    lw   $v0, sys_imprimir_binario
    add  $a0, $zero, $t2
    syscall

    lw   $v0, sys_salir
    syscall
    
    .data
    
str_enter_multiplicando:   .asciiz "\nPor favor ingrese el multiplicando: "
str_enter_multiplicador:   .asciiz "\nPor favor ingrese el multiplicador: "
str_imprimir_00_info:     .asciiz "00, no realizar el cambio"
str_imprimir_01_info:     .asciiz "01, agregar cambio"
str_imprimir_10_info:     .asciiz "10, restar cambio"
str_imprimir_11_info:     .asciiz "11, no realizar cambio"
str_imprimir_result:      .asciiz "\n\nResultado -> (EN 64 BITS): "
str_loop_counter:      .asciiz "\nPaso="
str_tab:           .asciiz "\t"
str_n:             .asciiz "N="
str_p:             .asciiz "P="
str_m:             .asciiz "A="
str_x:             .asciiz "Q="
str_y:             .asciiz "Y="
str_x_1:           .asciiz "Q-1="

sys_imprimir_int:      .word 1
sys_imprimir_binario:    .word 35
sys_imprimir_cadena:   .word 4
sys_leer_entero:   .word 5
sys_salir:        .word 10

.text