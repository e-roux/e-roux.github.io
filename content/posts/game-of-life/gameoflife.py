#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
# File:
#
# @author      : Emmanuel Roux ()
# @file        : game-of-life.py
# @created     : Mer 15 déc 22:19:14 2021
# @description :
#
# @Copyright © 2021 Emmanuel Roux
#
# Distributed under terms of the LICENSE license.

"""
 Description 
"""

import logging
from dataclasses import dataclass, field
from itertools import product

# Seed :
from random import choice
from typing import Mapping, Tuple

logging.basicConfig(level=logging.INFO)


class NbAliveNeighbors:
    def __get__(self, obj, objtype=None):
        # logging.info('First')
        logging.info(
            f'Cell at pos {obj.pos_x}/{obj.pos_y} is {"alive" if obj.alive else "dead"} {obj.parent}'
        )
        return obj.alive


class Cell:
    pos_x: int
    pos_y: int
    alive: bool

    def __init__(self, pos_x, pos_y) -> None:
        self.pos_x = pos_x
        self.pos_y = pos_y
        self.alive = choice((True, False))
        logging.info(f"Cell {pos_x}/{pos_y} is {self.alive}")

    # def __set_name__(self, owner, name):
    #     self._name = name

    @property
    def nb_alive_neighbors(self) -> int:
        return 1

    def __get__(self, obj, objtype=None):
        logging.info(f"Retrieved by {obj} of type {objtype}")
        try:
            return obj._value
        except AttributeError:
            # self.parent = obj
            return self

    # def __set__(self, obj, value):
    #     logging.info("Setting")
    #     obj._value = value

    def __repr__(self) -> None:
        return f"<Cell[{self.pos_x},{self.pos_y}] · {self.alive}"


class Parent:
    val_1: int = 10
    cell_1 = Cell(1, 2)
    cell_2 = Cell(2, 2)


@dataclass
class CellGrid:  # (Mapping[Tuple(int, int), Cell]):
    size_x: int
    size_y: int
    grid: Mapping[Tuple[int, int], Cell] = field(init=False)

    def __post_init__(self):
        self.grid = {
            (i, j): Cell(i, j)
            for (i, j) in product(range(self.size_x), range(self.size_y))
        }

    def __getitem__(self, key):
        x, y = key
        logging.info(f"Accessing {x}/{y}: {self.grid[key]}")
        return self.grid[key]


# 2 dims prob
# Grid -> (X;Y)
# - Array
# - Compute neighbors number for each cell
# - Keep cell alive or register them as dead
