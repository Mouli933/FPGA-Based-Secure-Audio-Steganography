# 🎧 FPGA Based Secure Audio Steganography System

<p align="center">
  <img src="IMAGES/BLOCKDIAGRAM.png" width="800">
</p>

---

# 🚀 Project Overview

This project presents a **real-time FPGA-based Audio Steganography System** using the **EDGE Z7 (Zynq FPGA)** platform.

The system securely embeds two audio streams into a single stego audio signal using an **interleaving technique** and reconstructs different outputs based on a **secret key** entered through FPGA switches.

The project combines:

- 🎵 Digital Audio Processing
- 🔐 Secure Audio Extraction
- ⚡ FPGA Real-Time Hardware Implementation
- 🧠 MATLAB + Verilog Integration
- 🎛 PWM Audio Generation
- 💾 BRAM-Based Audio Storage

---

# 🔥 Key Features

✅ Key-based secure audio playback  
✅ FPGA real-time audio reconstruction  
✅ PWM audio output through audio jack  
✅ BRAM memory storage using COE files  
✅ MATLAB preprocessing + FPGA hardware implementation  
✅ Real-time address decoding logic  
✅ Secret audio extraction using interleaved indexing  

---

# 🧠 Working Principle

The project stores:

- 🎵 Cover Tune
- 🔐 Secret Audio

inside a single **stego audio stream**.

The audio samples are interleaved as:

| Index Type | Stored Audio |
|---|---|
| Odd Index | Cover Tune |
| Even Index | Secret Audio |

The FPGA checks the entered key:

- ✅ Correct Key → Secret Audio
- ❌ Wrong Key → Cover Tune

---

# ⚙️ Complete System Flow

<p align="center">
  <img src="IMAGES/system_flow.png" width="850">
</p>

```text
MATLAB Audio Processing
        ↓
Interleaving Based Embedding
        ↓
COE File Generation
        ↓
BRAM Storage in FPGA
        ↓
Address Decoder Logic
        ↓
Key-Based Audio Selection
        ↓
PWM Audio Generation
        ↓
Audio Jack Output
```

---

# 🏗 Hardware Used

| Component | Description |
|---|---|
| FPGA Board | EDGE Z7 Zynq FPGA |
| FPGA Device | Zynq-7010 / Zynq-7020 |
| Audio Output | 3.5 mm Audio Jack |
| Clock | 50 MHz |
| Input | Slide Switches |
| Software | Vivado 2019.1 |
| Audio Processing | MATLAB |

---

# 💻 Software Tools

| Tool | Purpose |
|---|---|
| MATLAB | Audio preprocessing & COE generation |
| Vivado 2019.1 | FPGA synthesis & implementation |
| Verilog HDL | Hardware design |
| Xilinx IP Catalog | Clock & BRAM IP generation |

---

# 🧩 Xilinx IPs Used

## 1️⃣ Clock Wizard IP
Used to generate stable internal FPGA system clock.

```text
clk_wiz_0
```

---

## 2️⃣ Block Memory Generator IP
Used to store audio samples inside FPGA BRAM.

```text
blk_mem_gen_0
```

---

## 3️⃣ ODDR2 Primitive
Used for high-speed PWM audio generation.

---

# 📂 Project Structure

```text
Audio-Steganography-FPGA/
│
├── MATLAB/
│   ├── coe_generation.m
│   ├── key_based_extraction.m
│
├── Verilog/
│   ├── top_audio_pwm.v
│   ├── pwm_b.v
│   ├── tb.v
│
├── IP/
│   ├── clk_wiz_0.xci
│   ├── blk_mem_gen_0.xci
│
├── CONSTRAINTS/
│   ├── hw.xdc
│
├── COE/
│   ├── output.coe
│
├── IMAGES/
│   ├── block_diagram.png
│   ├── waveform.png
│   ├── edge_z7_board.png
│
└── README.md
```

---

# 🎵 MATLAB Processing

## Step 1 — Audio Interleaving

Two audio signals are merged:

```matlab
stego(1:2:end) = tune;
stego(2:2:end) = secret;
```

---

## Step 2 — COE File Generation

Audio samples converted into:

```text
0 → 255
```

format for FPGA BRAM storage.

---

# 🔐 Key Based Extraction Logic

| Key Condition | Output |
|---|---|
| Correct Key | Secret Audio |
| Wrong Key | Cover Tune |

---

# 🖥 FPGA Decoder Logic

The FPGA checks:

```verilog
key == 4'b1010
```

and selects:

- Even indexed samples
- Odd indexed samples

accordingly.

---

# 🎚 PWM Audio Generation

The selected audio samples are converted into PWM signals using:

```verilog
pwm_out_ddr
```

module and transmitted through:

- AUDIO_OUT_L
- AUDIO_OUT_R

pins.

---

# 📊 Simulation Results

<p align="center">
  <img src="IMAGES/waveform.png" width="900">
</p>

The waveform verifies:

✅ Correct address indexing  
✅ Key-based sample selection  
✅ Real-time PWM output generation  

---

# 🎯 Hardware Demonstration

<p align="center">
  <img src="IMAGES/edge_z7_board.png" width="700">
</p>

### FPGA Verification:
- Slide switches used as secret key input
- Audio output verified through earphones/speaker
- Secret audio extracted only for correct key

---

# 🛡 Applications

- Military Communication
- Secure Audio Broadcasting
- Authentication Systems
- Embedded Security
- Audio Watermarking
- Covert Communication

---

# 🔮 Future Scope

✅ Audio Encryption Integration  
✅ Wireless Secure Communication  
✅ Real-Time Dynamic Key Generation  
✅ Multi-Level Audio Security  
✅ AI-Based Steganography Detection  

---

# 👨‍💻 Author

## Thota Mouli Krishna Sai

B.Tech — Electronics and Communication Engineering (ECE)

SRM University AP

---

# ⭐ If you like this project

Give this repository a ⭐ on GitHub!

---
