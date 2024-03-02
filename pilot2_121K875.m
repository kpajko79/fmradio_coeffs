%    19 kHz pilot extractor filter generator
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

function [Hd, name, Fs, pbfs, sbfs] = pilot2_121K875

Fs  = 121875;
Fct = -19000;

N     = 36;
Fpass = 200;
Fstop = 4000;
A     = [0 0 1 1 0 0];
W     = [1 1 1];
debug = 'off';
dens  = 20;

F     = [-Fs/2 Fct-Fstop Fct-Fpass Fct+Fpass Fct+Fstop Fs/2];

b  = cfirpm(N, F/(Fs/2), {'multiband', A}, W, {dens}, debug);
b  = b / 0.957987524540577229;
Hd = dfilt.dffir(b);

name = sprintf("FM 19 kHz pilot extractor for %.3f Ksps", Fs/1000);
pbfs = [Fct-Fpass, Fct+Fpass];
sbfs = [-Fs/2, Fct-Fstop, Fct+Fstop, Fs/2];

% [EOF]
