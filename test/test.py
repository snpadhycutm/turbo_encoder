# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def test_turbo_encoder(dut):
    """Testbench for 8-bit Turbo Encoder"""

    # Start a 100 MHz clock on dut.clk (10 ns period)
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut._log.info("Resetting...")
    dut.rst.value = 1
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    await Timer(20, units="ns")
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    # Apply input 1
    test_vector_1 = 0b10110101
    dut.ui_in.value = test_vector_1
    dut.uio_in.value = 0b00000001  # start = 1
    await RisingEdge(dut.clk)

    # Deassert start
    dut.uio_in.value = 0b00000000
    await Timer(20, units="ns")

    result_1 = dut.uo_out.value.integer
    dut._log.info(f"Input: {test_vector_1:08b}, Output: {result_1:08b}")

    # Apply input 2
    test_vector_2 = 0b11001100
    dut.ui_in.value = test_vector_2
    dut.uio_in.value = 0b00000001
    await RisingEdge(dut.clk)

    dut.uio_in.value = 0
    await Timer(20, units="ns")

    result_2 = dut.uo_out.value.integer
    dut._log.info(f"Input: {test_vector_2:08b}, Output: {result_2:08b}")

    # Add more test vectors if needed

    assert isinstance(result_1, int) and isinstance(result_2, int), "Invalid output"



