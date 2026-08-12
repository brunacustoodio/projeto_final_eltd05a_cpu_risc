# RISC — CPU em pipeline (Trabalho II, Grupo 2)

Implementação de uma CPU RISC de 5 estágios em pipeline, em Verilog, para FPGA da família
**Cyclone IV GX**. O enunciado completo do trabalho está em [`docs/RISC.pdf`](docs/RISC.pdf).

## Parâmetros do grupo

Este grupo é o **Grupo 2**, com as constantes:

- `CteMemProg(h) = 130h`
- `CteMemDados(h) = 240h`

O que dá, para a decodificação de endereços (já implementada em `ADDRDecoding_Prog.v` e
`ADDRDecoding.v`):

| Memória | Base = Grupo × Cte | Limite (base + 1kWord − 1) |
|---|---|---|
| Programa (`ADDRDecoding_Prog`) | 2 × 130h = **260h** | **65Fh** |
| Dados (`ADDRDecoding`) | 2 × 240h = **480h** | **87Fh** |

E, para os opcodes das instruções (já implementados em `control.v`):

| Instrução | Opcode = Grupo + base | Valor (Grupo=2) |
|---|---|---|
| LW | Grupo+32 | 34 |
| SW | Grupo+33 | 35 |
| BNE | Grupo+34 | 36 |
| ADDI | Grupo+35 | 37 |
| ORI | Grupo+36 | 38 |
| ADD / SUB / MUL / AND / OR (tipo R) | Grupo+10 | 12 |
| JMP | fixo | 2 |

O campo `calc`/`FUNCT` (6 bits) das instruções tipo R não depende do grupo: `ADD=32`, `SUB=34`,
`MUL=50`, `AND=36`, `OR=37`.

## Arquitetura

- Word de 32 bits, **Big Endian**.
- Pipeline completo: Instruction Fetch, Instruction Decode, Execute, Memory, Write Back.
- Todas as instruções têm 4 bytes.
- 32 registradores (`r0`–`r31`); `r0` é *hard-wired* em 0.
- Memória de programa e memória de dados: 1 kWord cada (ver tabela de endereços acima).
- A cada *Reset*, o Program Counter aponta para o endereço inicial do grupo (`260h`).
- As memórias BRAM nas FPGAs Altera são síncronas tanto para leitura quanto para escrita, então o
  pipeline real tem menos registradores de estágio explícitos do que o pipeline MIPS "clássico" de
  5 estágios — parte desse registro já existe internamente nas BRAMs.
- Sinais `branchFlag`, `branchOffset`, `jmpFlag`, `jmpAddress` e `zeroFlag` controlam desvio de
  fluxo (BNE e JMP).

## ISA

Formato I: 6 bits opcode, 5 bits `rs`, 5 bits `rt`, 16 bits `offset`.
Formato R: 6 bits opcode, 5 bits `rs`, 5 bits `rt`, 5 bits `rd`, 5 bits (não usado), 6 bits `calc`.
Formato J: 6 bits opcode, 26 bits `JumpADDR`.

| Instrução | Mnemônico | Formato | Operação |
|---|---|---|---|
| Load Word | LW | I | `R[rt] = M[R[rs] + SignExtImm]` |
| Store Word | SW | I | `M[R[rs] + SignExtImm] = R[rt]` |
| Branch on Not Equal | BNE | I | `if (R[rs] != R[rt]) PC = PC + 4 + offset` |
| Add Immediate | ADDI | I | `R[rt] = R[rs] + SignExtImm` |
| Or Immediate | ORI | I | `R[rt] = R[rs] \| SignExtImm` |
| Add | ADD | R | `R[rd] = R[rs] + R[rt]` |
| Subtract | SUB | R | `R[rd] = R[rs] - R[rt]` |
| Multiplication | MUL | R | `R[rd] = lowerHW_R[rs] * lowerHW_R[rt]` |
| And | AND | R | `R[rd] = R[rs] & R[rt]` |
| Or | OR | R | `R[rd] = R[rs] \| R[rt]` |
| Jump | JMP | J | `PC = JumpADDR` |

## Multiplicador (16 bits)

- A instrução `MUL` opera sobre os 16 bits menos significativos de `rs` e `rt`; o resultado (32
  bits) é armazenado em `rd`.
- Hardware: o multiplicador sequencial do Laboratório 4 (ACC + Adder + Counter + CONTROL),
  adaptado para operandos de 16 bits.
- Funciona num clock próprio (`CLK_MUL`), diferente do clock do sistema (`CLK_SYS`) — mesmo assim o
  sistema mantém *throughput* de 1 instrução/clock.
- `CLK_SYS` e `CLK_MUL` são gerados pelo IP `ALTPLL` (pasta `PLL/`).
- Latência do multiplicador: `2N + 2` ciclos de `CLK_MUL` (N=16), pela máquina de estados do Lab04.

## Estrutura da pasta

```
RISC/
├─ risc.v              — topo (descrição estrutural, liga todos os módulos)
├─ risc_TB.v            — testbench estrutural (instancia risc como DUT)
├─ datamemory.v / datamemory_TB.v
├─ Data.hex             — conteúdo inicial da memória de dados
├─ InstMem.v / InstMem_TB.v
├─ Code.hex             — programa codificado (memória de instruções)
├─ mux.v / mux_TB.v
├─ pc.v / pc_TB.v
├─ alu.v / alu_TB.v
├─ Multiplicador/       — arquivos direto na pasta (sem subpastas por módulo)
│  ├─ Multiplicador.v / Multiplicador_TB.v
│  ├─ Adder.v / Adder_TB.v
│  ├─ CONTROL.v / CONTROL_TB.v
│  ├─ Counter.v / Counter_TB.v
│  └─ ACC.v / ACC_TB.v
├─ control.v / control_TB.v
├─ registerfile.v / registerfile_TB.v
├─ extend.v / extend_TB.v
├─ register.v / register_TB.v
├─ ADDRDecoding.v / ADDRDecoding_TB.v         — decodificação de endereço (memória de dados)
├─ ADDRDecoding_Prog.v / ADDRDecoding_Prog_TB.v — decodificação de endereço (memória de programa)
└─ PLL/                 — arquivos gerados pelo IP ALTPLL (CLK_SYS e CLK_MUL)
```

`Code.hex` e `Data.hex` já sobem sintetizados com o conteúdo codificado — o testbench não faz
*boot* das memórias, elas já sobem inicializadas.

## Testes

- Programa de teste gerado com o assembler disponível em
  [odutra00/assemblerRISC](https://github.com/odutra00/assemblerRISC).
- `risc_TB` expõe entradas/saídas e sinais internos com os nomes indicados no diagrama do enunciado
  (usando `$init_signal_spy` e `(*keep=1*)` para preservar nomes de sinais internos também na
  simulação Gate Level).
- Simulação final obrigatoriamente em **Gate Level** — considera os atrasos dos gates e se
  aproxima da realidade; a simulação RTL não vale como validação final.
- O clock aplicado no testbench para a PLL deve ser igual ao definido como entrada da PLL no IP
  Catalog, e a frequência de simulação deve respeitar a máxima frequência de operação encontrada no
  TimeQuest.

## Avaliação (responder como comentário no início de `risc.v`)

1. Qual a latência do sistema?
2. Qual o *throughput* do sistema?
3. Qual a máxima frequência operacional (TimeQuest) para o multiplicador e para o sistema?
   (indicar a FPGA usada)
4. Qual a máxima frequência de operação do sistema? (indicar a FPGA usada)
5. Há problemas de metaestabilidade entre os dois domínios de clock? Por quê?
6. O multiplicador utilizado é eficiente em velocidade para este sistema? Por quê?
7. Que modificações tornariam o sistema mais rápido? Qual a nova latência/throughput para cada
   modificação sugerida?

## Notas

- Esta pasta corresponde à estrutura de entrega exigida no enunciado: `risc.v`/`risc_TB.v` como
  topo/testbench e os módulos do multiplicador soltos dentro de `Multiplicador/` (sem subpastas por
  módulo).
- Arquivos de projeto Quartus (`.qpf`/`.qsf`/`.qws`) e artefatos de build/simulação (`db/`,
  `incremental_db/`, `output_files/`, `simulation/`) não fazem parte da entrega e não ficam nesta
  pasta — são recriados localmente ao abrir/compilar o projeto no Quartus.
