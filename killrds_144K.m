%    Lowpass filter generator for RDS elimination
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

function [Hd, name, Fs, pbfs, sbfs] = killrds_144K

Fs = 144000;

N     = 12;
Fpass = 15000;
Fstop = 55350;
F     = [0 Fpass Fstop Fs/2];
A     = [1 1 0 0];
W     = [1 1];
CEMs  = {'c', 'w'};
dens  = 20;

b  = fircband(N, F/(Fs/2), A, W, CEMs, {dens});
b  = b / 1.001098632812500000;

% non-decimator FIR filters must have even number of taps in q15
if ~mod(N, 2)
  b(end + 1) = 0;
end

Hd = dfilt.dffir(b);

name = sprintf("RDS blocker for %.3f Ksps", Fs/1000);
pbfs = [0 Fpass];
sbfs = [Fstop Fs/2];

% [EOF]
