#!/usr/bin/python
# -*- coding: utf-8 -*-
# Copyright (c) 2014 Mikkel Schubert <MSchubert@snm.ku.dk>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import sys
import argparse

import pysam


def parse_args(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument("infile")
    parser.add_argument("outfile")
    parser.add_argument("--left", default=0, type=int,
            help="Number of bases to trim from 5' termini [Default: %(default)s]")
    parser.add_argument("--right", default=0, type=int,
            help="Number of bases to trim from 3' termini [Default: %(default)s]")

    return parser.parse_args(argv)


def update_cigar(cigar, nbases, cache={}):
    key = (cigar, nbases)
    if key in cache:
        return cache[key]

    to_trim = nbases
    cigar = list(cigar)
    event = num = -1
    while cigar and to_trim:
        event, num = cigar[0]

        if event in (1, 4): # I, S
            # Remove both from cigar and sequence
            nbases += num
            cigar = cigar[1:]
        elif event in (0, 2, 3, 7, 8): # M, D, N, =, X
            if event in (2, 3): # D, N
                # Bases are already missing
                nbases -= min(num, to_trim)

            if num <= to_trim:
                to_trim -= num
                cigar = cigar[1:]
            else:
                cigar[0] = (event, num - to_trim)
                break
        else:
            assert False, (event, num)

    cigar = tuple(cigar)
    cache[key] = (cigar, nbases)
    return cigar, nbases


def cigar_nbases(cigar, cache={}):
    if cigar in cache:
        return cache[cigar]

    nbases = 0
    for (op, num) in cigar:
        if op in (0, 1, 4, 7, 8):
            nbases += num

    cache[cigar] = nbases
    return nbases


def trim_record(record, args):
    cigar = tuple(record.cigar)
    left, right = args.left, args.right
    if record.is_reverse:
        left, right = right, left

    cigar, left = update_cigar(cigar, left)
    cigar, right = update_cigar(cigar[::-1], right)
    cigar = tuple(cigar[::-1])
    if not cigar:
        return False

    # Qualities must be copied, as setting .seq sets .qual to None
    qualities = record.qual
    if right:
        record.seq = record.seq[left:-right]
        record.qual = qualities[left:-right]
    else:
        # right == 0 yields undesired results
        record.seq = record.seq[left:]
        record.qual = qualities[left:]

    assert len(record.seq) == cigar_nbases(cigar), record.qname

    record.cigar = cigar

    new_position = record.pos + (args.right if record.is_reverse else args.left)
    # Set .pos TWICE; this is a workaround for a bug in some versions of
    # of pysam, in which the bin in the record is re-calculated BEFORE
    # the new position value is set, using the old pos value.
    record.pos = new_position
    record.pos = new_position

    return True


def main(argv):
    args = parse_args(argv)
    with pysam.Samfile(args.infile) as in_handle:
        with pysam.Samfile(args.outfile, "wb", template=in_handle) as out_handle:
            for record in in_handle:
                if trim_record(record, args):
                    out_handle.write(record)

    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))

