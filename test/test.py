# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    """Cocotb test for Tiny Tapeout 8-bit turbo encoder"""

    dut._log.info("Starting Cocotb test...")

    # Setup clock: 10us period = 100 kHz
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Apply reset
    dut.rst.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 5)
    dut.rst.value = 0
    await ClockCycles(dut.clk, 2)

    # === Test case 1 ===
    # Input: 0b10101010 → Expected output: 0x99
    dut.ui_in.value = 0b10101010
    dut.uio_in.value = 0b00000001  # start = 1
    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000  # clear start
    await ClockCycles(dut.clk, 5)

    expected = 0x99  # Based on manual parity calc
    actual = dut.uo_out.value.integer
    dut._log.info(f"Got encoded output: 0x{actual:02X}, expected: 0x{expected:02X}")
    assert actual == expected, f"Test failed: got 0x{actual:02X}, expected 0x{expected:02X}"

    dut._log.info("Test passed.")
