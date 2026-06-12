.intel_syntax noprefix
.global _start

# [X] V0.1 Lee el contenido de un directorio e imprime los nombres (Un mini ls)
# [ ]v1: Lee el contenido del directorio actual e imprime la cantidad de archivos por extension
# [ ]v2: Crea subdirectorios por extension (uno para los que no tienen) y mete los archivos en su respectivo directorio

_start:
push r12
push r13
# Reserve space in stack
push rbp
mov rbp, rsp
sub rsp, 512

mov byte ptr [rsp], '.'
mov byte ptr [rsp+1], 0


# First open directory
mov eax, 257              # sys_openat
mov edi, -100             # AT_FDCWD
mov rsi, rsp              # Path
mov rdx, 0x10000          # Flags (0 = O_RDONLY | 0x1000= O_DIRECTORY)
syscall
cmp rax, 0
jle error

# Get dir entries
mov r12, rax              # Dir FD
mov rax, 217              # sys_getdents64
mov rdi, r12
mov rsi, rsp
mov rdx, 512
syscall
cmp rax, 0
jle error

# Read data
mov r13, rsp
add r13, rax              # End of struct
mov rbx, rsp              # Start of the struct
sub rsp, 1
mov byte ptr [rsp], 0x0A
readloop:
# Add entry end validation here
cmp rbx, r13
jae endreadloop
xor r8d, r8d
mov r8w, word ptr [rbx+16]    # Length of entry
# Nameloop start
xor r9d, r9d              # Name chars
mov r10, rbx
add r10, 19               # First char
nameloop:
cmp r9, r8
ja endnameloop
cmp byte ptr [r10], 0
je endnameloop
add r9, 1
add r10, 1
jmp nameloop
endnameloop:
mov eax, 1
mov edi, 1
mov rsi, rbx
add rsi, 19
mov rdx, r9
syscall                   # Write
mov eax, 1
mov edi, 1
mov rsi, rsp
mov rdx, 1
syscall
add rbx, r8
jmp readloop

endreadloop:
mov eax, 3
mov edi, r12d
syscall                   # Close

mov rsp, rbp
pop rbp
pop r13
pop r12
mov eax, 60
xor edi, edi
syscall                   # Exit

error:
mov rsp, rbp
pop rbp
pop r13
pop r12
mov eax, 60
mov edi, -15
syscall
