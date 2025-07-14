# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles

@cocotb.test()
async def test_project(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut.rst.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await ClockCycles(dut.clk, 2)

    # Input = 0b10101010
    # Interleaved (bit‑reversed): 0b01010101
    # Compute parity manually or via script to match design
    dut.ui_in.value = 0b10101010
    dut.uio_in.value = 1
    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)

    actual = dut.uo_out.value.integer
    # Use your own script or manual calc to set expected here:
    expected = ...  # ⟵ compute based on new parity logic
    dut._log.info(f"Got 0x{actual:02X}, expected 0x{expected:02X}")
    assert actual == expected


