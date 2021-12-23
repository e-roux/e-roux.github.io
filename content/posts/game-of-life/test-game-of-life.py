#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
# File:
#
# @author      : Emmanuel Roux ()
# @file        : test-game-of-life.py
# @created     : Mer 15 déc 22:35:13 2021
# @description :
#
# @Copyright © 2021 Emmanuel Roux
#
# Distributed under terms of the LICENSE license.

"""

"""
from unittest import TestCase

from .gameoflife import Cell, CellGrid, Parent


class TestCell(TestCase):
    def test_cellgrid(self):
        parent = Parent()

        # self.assertEqual(parent.cell_1.parent, parent)

        self.assertFalse(parent.cell_1.nb_alive_neighbors)

        # cg = CellGrid(4, 5)
        # cell = cg[3,3]
        # cell.nb_alive_neighbors
        # self.assertEqual(cg.grid, 10)


def test_cell():
    assert False
