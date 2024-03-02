%    Lowpass filter generator for RDS resampling
%    Copyright (C) 2024  Patrik Kluba <kpajko79@gmail.com>
%
%    Permission is hereby granted, free of charge, to any person obtaining a copy
%    of this software and associated documentation files (the "Software"), to deal
%    in the Software without restriction, including without limitation the rights
%    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
%    copies of the Software, and to permit persons to whom the Software is
%    furnished to do so, subject to the following conditions:
%
%    The above copyright notice and this permission notice shall be included in all
%    copies or substantial portions of the Software.
%
%    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%    SOFTWARE.
%
%    SPDX-License-Identifier: MIT

function [Hd, name, Fs, pbfs, sbfs] = rdsresample_24K

Fs    = 24000;
Fsout = 19000; % Fs*19/24

N     = 6 * 19;
debug = 'off';
dens  = 20;

Fs = Fs * 19;
[F, A, W] = genaa(Fs, Fsout, 1650);

b  = cfirpm(N, F/(Fs/2), {'multiband', A}, W, {dens}, debug);
Hd = dfilt.dffir(b);

name = sprintf("Antialias filter for %.3f -> %.3f Ksps interpolation for RDS resampling", Fs/1000, Fsout/1000);
[pbfs, sbfs] = genbandranges(F, A);

% [EOF]
